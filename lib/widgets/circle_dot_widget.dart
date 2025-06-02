import 'package:flutter/material.dart';
import '../models/circle_dot.dart';

class CircleDotWidget extends StatelessWidget {
  final CircleDot dot;
  final Function() onTap;

  const CircleDotWidget({required this.dot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: dot.position.dx,
      top: dot.position.dy,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '+${dot.points}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
