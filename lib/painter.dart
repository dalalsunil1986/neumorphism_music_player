import 'package:flutter/material.dart';
import 'dart:math';

class TrialPainter extends CustomPainter {
  Paint _paint;
 
  @override
  void paint(Canvas canvas, Size size) {


    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.orange;

    canvas.translate(0, size.height / 2);
    canvas.scale(1, -1);

    for (int i = 0; i < size.width.toInt(); i++) {
      double x = i.toDouble();
  double waveAmplitude = Random().nextDouble() * 20;

      canvas.drawLine(
          Offset(x, waveAmplitude), Offset(x, -waveAmplitude), _paint);
    }
  }

  @override
  bool shouldRepaint(TrialPainter oldDelegate) {
return false;



  }
}
