import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:neumorphic_player_concept/model.dart';
import 'package:provider/provider.dart';

class PlayerButton extends StatefulWidget {
  PlayerButton(
      {this.radius,
      this.iconPri,
      this.iconAlt = const Icon(Icons.queue_music),
      this.isInnerColorFill = false,
      this.musicNo = 0});
  final double radius;
  final Icon iconPri;
  final Icon iconAlt;
  final bool isInnerColorFill;
  final int musicNo;
  @override
  _PlayerButtonState createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  Color iconColor = Color(0xFF76B54A4);
  List<Color> gradientColors = [Color(0xFFe5ecf5), Color(0xFFc1c7ce)];
  double angle = -105 * Math.pi / 180;

  @override
  Widget build(BuildContext context) {
    PlayerModel model = Provider.of<PlayerModel>(context);
    double radius = widget.radius;
    int musicNo = widget.musicNo;
    Icon iconPri = widget.iconPri;
    Icon iconAlt = widget.iconAlt;
    bool isInnerColorFill = widget.isInnerColorFill;
    double x = Math.cos(angle);
    double y = Math.sin(angle);
    bool musicStatus = model.musicList[musicNo].isPlaying;
    return Container(
      alignment: Alignment.center,
      width: 2 * radius + 10,
      height: 2 * radius + 10,
      decoration: BoxDecoration(
        color: iconColor,
        border: Border.fromBorderSide(
          BorderSide(
              color: !isInnerColorFill ? Colors.grey : Color(0xFFaeb4ba),
              width: 0.5),
        ),
        shape: BoxShape.circle,
        gradient: !isInnerColorFill
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                    0.33,
                    0.66,
                    1
                  ],
                colors: [
                    Color(0xFFaeb4ba),
                    Color(0xffD6DDE5),
                    Color(0xFFfefefe),
                  ])
            : null,
      ),
      child: Container(
        height: 2 * radius,
        width: 2 * radius,
        child: Icon(
          musicStatus ? iconAlt.icon : iconPri.icon,
          color: iconColor,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment(x, y),
                end: Alignment(-x, -y),
                colors: musicStatus
                    ? gradientColors.reversed.toList()
                    : gradientColors),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(-5 * x, -5 * y),
                  color: Color(0xFFb6bcc3)),
              BoxShadow(
                  blurRadius: 10,
                  offset: Offset(5 * x, 5 * y),
                  color: Color(0xFFf6feff))
            ]),
      ),
    );
  }
}