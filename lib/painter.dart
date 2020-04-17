import 'package:flutter/material.dart';
import 'dart:math';

class TrialPainter extends CustomPainter {
  Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.grey.withOpacity(0.25);

    canvas.translate(0, size.height / 2);
    canvas.scale(1, -1);

    for (int i = 0; i < size.width.toInt(); i++) {
      double x = i.toDouble();
      // double waveAmplitude = Random().nextDouble() * 20;
      double r = 2 * sin(i) - 2 * cos(4 * i) + sin(2 * i - pi * 24);
      r = r * 5;
      canvas.drawLine(
          Offset(x, r), Offset(x, -r), _paint);
    }
  }

  @override
  bool shouldRepaint(TrialPainter oldDelegate) {
    return false;
  }
}
