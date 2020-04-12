import 'package:flutter/material.dart';
import 'dart:math';

class WavePainter extends CustomPainter {
  WavePainter(this.animation, {this.tapped=false}):super(repaint:animation);
  Animation<double> animation;
  bool tapped;
  List<Color> colors ;
  Paint _paint ;
  Paint _paintBlank ;
  double waveAmplitude;
  @override
  void paint(Canvas canvas, Size size) {
  colors=List.from( Colors.accents);

    colors.removeRange(6, 12);

    List<Color> gradColors = colors
        .map((color) =>
            color.withOpacity(Random().nextDouble().clamp(0.05, 0.4)))
        .toList();
    final Gradient gradient = LinearGradient(colors: gradColors);

     _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = gradient.createShader(Rect.fromLTWH(0, 20, size.width, 40));
     _paintBlank = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5..color=Colors.grey;

    canvas.translate(0, size.height / 2);
    canvas.scale(1, -1);
      print(size.width*animation.value);

    for (double i = animation.value; i < size.width.toInt(); i++) {
      waveAmplitude = Random().nextDouble() * 20;

      
      canvas.drawLine(
          Offset(i, waveAmplitude), Offset(i, -waveAmplitude), _paint);
      if(tapped)
      canvas.drawLine(
          Offset(i, waveAmplitude), Offset(i, -waveAmplitude), _paintBlank);

    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate)  {
return oldDelegate.colors!=colors;
}

}
