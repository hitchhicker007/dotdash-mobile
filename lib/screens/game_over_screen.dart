import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quicktap_duel/constants/game_constants.dart';
import 'game_screen.dart';
import 'home_screen.dart';
import '../utils/score_storage.dart';

class GameOverScreen extends StatefulWidget {
  final int score;

  const GameOverScreen({required this.score, super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late ConfettiController _confettiController;
  int maxScore = 0;
  BannerAd? _bannerAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isAdReady = false;


  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {}),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  void _loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: rewardedAdId,
      request: AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedInterstitialAd = ad;
            _isAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('RewardedInterstitialAd failed to load: $error');
          _isAdReady = false;
        },
      ),
    );
  }




  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _confettiController.play();
    _loadBannerAd();
    _loadRewardedInterstitialAd();

    saveScoreAndLoadMax();
  }

  Future<void> saveScoreAndLoadMax() async {
    await ScoreStorage.saveScore(widget.score);
    final score = await ScoreStorage.getMaxScore();
    setState(() => maxScore = score);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 30,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("🎉 Game Over 🎉", style: TextStyle(fontSize: 32, color: Colors.redAccent)),
                  SizedBox(height: 16),
                  Text("Your Score: ${widget.score}", style: TextStyle(fontSize: 24, color: Colors.white)),
                  SizedBox(height: 8),
                  Text("Max Score: $maxScore", style: TextStyle(fontSize: 20, color: Colors.greenAccent)),
                  SizedBox(height: 36),
                  ElevatedButton(
                    // onPressed: () {
                    //
                    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GameScreen()));
                    // },
                    onPressed: () {
                      if (_isAdReady && _rewardedInterstitialAd != null) {
                        _rewardedInterstitialAd!.show(
                          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => GameScreen()),
                            );
                          },
                        );

                        _rewardedInterstitialAd!.fullScreenContentCallback =
                            FullScreenContentCallback(
                              onAdDismissedFullScreenContent: (ad) {
                                ad.dispose();
                                _loadRewardedInterstitialAd(); // Load next ad
                              },
                              onAdFailedToShowFullScreenContent: (ad, error) {
                                ad.dispose();
                                _loadRewardedInterstitialAd();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => GameScreen()),
                                );
                              },
                            );
                      } else {
                        // Fallback if ad not ready
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => GameScreen()),
                        );
                      }
                    },

                    child: Text("Play Again"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    child: Text("Home", style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),

          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }


}
