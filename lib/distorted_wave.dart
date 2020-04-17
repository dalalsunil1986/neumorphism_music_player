import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'newmodel.dart';

class DistortedCircle extends StatefulWidget {
  DistortedCircle({this.child});
  final Widget child;
  @override
  _DistortedCircleState createState() => _DistortedCircleState();
}

class _DistortedCircleState extends State<DistortedCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _distortAnim;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _controller.repeat();
            // if (status == AnimationStatus.dismissed) _controller.forward();
          });

    _distortAnim = Tween<double>(begin: pi / 2, end: pi * 2).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: _controller));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PlayerModel model = Provider.of<PlayerModel>(context);
    if (model.musicList[model.currentTrack].isPlaying &&
        _controller.status != AnimationStatus.completed)
      _controller.forward();
    else
      _controller.stop();
    // if (status == AnimationStatus.dismissed) _controller.forward();

    Widget child = widget.child;

    return Transform.rotate(
      angle: _distortAnim.value,
      child: CustomPaint(
        painter: DistortPainter(),
        child: Transform.rotate(
          angle: -_distortAnim.value,
          child: child,
        ),
      ),
    );
  }
}

class DistortPainter extends CustomPainter {
  Paint tpaint = Paint()
    ..color = Color(0xffFFFF8D)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1, -1);

    for (int i = 0; i < 36; i++)
      paintZigZag(
          canvas,
          tpaint,
          Offset(
              cos(i * 10 * 3.14 / 180) * 180, sin(i * 10 * 3.14 / 180) * 180),
          Offset(
              cos(i * 20 * 3.14 / 180) * 180, sin(i * 20 * 3.14 / 180) * 180),
          Random().nextInt(50) + 1,
          15);
  }

  @override
  bool shouldRepaint(DistortPainter oldDelegate) => false;
}
