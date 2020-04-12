import 'package:flutter/material.dart';
import 'package:neumorphic_player_concept/home.dart';
import 'package:neumorphic_player_concept/painter.dart';
import 'package:neumorphic_player_concept/pppp.dart';
import 'package:neumorphic_player_concept/wave_painter.dart';
import 'dart:math' as Math;

void main() {
  runApp(MaterialApp(
    home: PlayerApp(),    debugShowCheckedModeBanner: false,

  ));
}

class PlayerApp extends StatefulWidget {
  @override
  _PlayerAppState createState() => _PlayerAppState();
}

class _PlayerAppState extends State<PlayerApp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _waveAnim;
  Animation<double> _waveConstAmpAnim;
  Animation<double> _coverAnim;
  Animation<Duration> _timeCounter;

  bool isWaveTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(minutes: 1, seconds: 32))
      ..addListener(() => setState(() {}));
    _waveAnim = Tween<double>(begin: 1, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _waveConstAmpAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _coverAnim = Tween<double>(begin: 0, end: 2 * Math.pi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
    _timeCounter = Tween<Duration>(
            begin: Duration(seconds: 0), end: Duration(minutes: 3, seconds: 32))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

//40,110,145,356,565
//bg d4e3f2
// 9fb7cf
//bg item 9881cf
//bg item selected 876bc7
//bg item selected 9273dc
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              decoration: BoxDecoration(color: Color(0xffd4e3f2)),
            ),
          ),
          //  widgetMusicList(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text('Runnin\' Outta Luck', style: TextStyle(fontSize: 22)),
                SizedBox(
                  height: 15,
                ),
                Text('Alex Cameron', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 75,
                ),
                FlatButton(
                  child: Text('Play music'),
                  onPressed: () {
                    _controller.forward();
                  },
                ),
                buildRecordPlayer(),
                SizedBox(
                  height: 1,
                ),
                Container(width: width, height: 40, color: Colors.grey),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: <Widget>[
                    // Text(_timeCounter.value.toString().substring(3, 7),
                    //     style: TextStyle(
                    //         color: Colors.grey,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w700)),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: 400.0 - 116,
                      height: 40,
                      child: ClipRect(
                        clipper: WaveClipper(
                            _waveConstAmpAnim.value * (400 - 116)),
                        child: CustomPaint(
                          painter: WavePainter(_waveAnim),
                       ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('3:32',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text('ALL TRACKS'),
                SizedBox(
                  height: 25,
                ),
                Text(
                  '-',
                  style: TextStyle(fontSize: 27),
                )
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Spacer(),
                Icon(Icons.search),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecordPlayer() {
    double x = Math.cos(_coverAnim.value);
    double y = Math.sin(_coverAnim.value);

    return Container(
      height: 290,
      width: 290,
      alignment: Alignment.center,
      child: ClipOval(
        child: Image.asset('images/cover.png',
            height: 190, width: 190, fit: BoxFit.fitHeight),
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-x, -y),
              end: Alignment(x, y),
              colors: [
                Color(0xFFfdeff9),
                Color(0xFFec38bc),
                Color(0xFF7303c0),
                Color(0xFF03001e),
              ]),
          shape: BoxShape.circle),
    );
  }

  Widget buildButton({bool tapped, Icon icon, double radius}) {
    return Container(
      child: icon,
      decoration: BoxDecoration(shape: BoxShape.circle),
    );
  }
}
