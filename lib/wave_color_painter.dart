import 'package:flutter/material.dart';
import 'dart:math';

class WaveColorPainter extends CustomPainter {
  WaveColorPainter(this.animation, {this.tapped = false})
      : super(repaint: animation);
  Animation<double> animation;
  bool tapped;
  List<Color> colors;
  Paint _paint;
  double waveAmplitude;
  @override
  void paint(Canvas canvas, Size size) {
    colors = List.from(Colors.accents);

    colors.removeRange(6, 13);

    List<Color> gradColors = colors
        .map(
            (color) => color.withOpacity(Random().nextDouble().clamp(0.5, 0.9)))
        .toList();
    final Gradient gradient = LinearGradient(colors: gradColors);

    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = gradient.createShader(Rect.fromLTWH(0, 20, size.width, 40));


    canvas.translate(0, size.height / 2);
    canvas.scale(1, -1);

    for (double i = animation.value; i < size.width.toInt(); i++) {
      waveAmplitude = cos(i / 20) * 20;
      var r = 2 * sin(i) - 2 * cos(4 * i) + sin(2 * i - pi * 24);
      r = r * 5;
      if (tapped)
        canvas.drawLine(Offset(i, waveAmplitude), Offset(i, -waveAmplitude),
            _paint);

      canvas.drawLine(Offset(i, r), Offset(i, -r), _paint);
    }
  }

  @override
  bool shouldRepaint(WaveColorPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}