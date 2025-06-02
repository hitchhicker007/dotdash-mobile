import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';
import '../models/circle_dot.dart';

Offset generateNonOverlappingOffset(Size screenSize, List<CircleDot> existingDots) {
  final random = Random();
  const int maxAttempts = 20;

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    double x = random.nextDouble() * (screenSize.width - dotSize);
    double y = random.nextDouble() * (screenSize.height - 200); // Leave UI space

    final newOffset = Offset(x, y);

    bool overlaps = existingDots.any((dot) {
      final dx = (dot.position.dx - newOffset.dx).abs();
      final dy = (dot.position.dy - newOffset.dy).abs();
      return dx < dotSize && dy < dotSize;
    });

    if (!overlaps) return newOffset;
  }

  // If no non-overlapping position found, return a random one anyway
  return Offset(
    random.nextDouble() * (screenSize.width - dotSize),
    random.nextDouble() * (screenSize.height - 200),
  );
}


int getRandomPoints() {
  final points = [1, 2, 5, 10];
  return points[Random().nextInt(points.length)];
}
