import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_player_concept/wave_base_painter.dart';
import 'package:neumorphic_player_concept/clipper.dart';
import 'package:neumorphic_player_concept/wave_color_painter.dart';
import 'package:provider/provider.dart';
import 'distorted_wave.dart';
import 'widgets/button.dart';
import 'dart:math' as Math;

import 'clipper.dart';
import 'model.dart';
import 'widgets/player_controls.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: TextTheme(body1: TextStyle(color: Color(0xFF75889B))),
      iconTheme: IconThemeData(color: Color(0xFF6B54A4)),
    ),
    home: ChangeNotifierProvider<PlayerModel>(
        create: (context) => PlayerModel(), child: PlayerApp()),
    debugShowCheckedModeBanner: false,
  ));
}

class PlayerApp extends StatefulWidget {
  @override
  _PlayerAppState createState() => _PlayerAppState();
}

class _PlayerAppState extends State<PlayerApp> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _perspectiveController;

  Animation<double> _waveAnim;
  Animation<double> _perspectiveAnim;
  Animation<double> _waveConstAmpAnim;
  Animation<double> _coverAnim;
  Animation<Duration> _timeCounter;
  bool isListVisible = false;
  PlayerModel model;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(minutes: 1, ))
      ..addListener(() => setState(() {}));
    _perspectiveController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() => setState(() {}));
    _perspectiveAnim = Tween<double>(begin: 0, end: Math.pi / 6).animate(
        CurvedAnimation(curve: Curves.easeOut, parent: _perspectiveController));
    _waveAnim = Tween<double>(begin: 1, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _waveConstAmpAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _coverAnim =
        Tween<double>(begin: 0, end: 200 * Math.pi).animate(CurvedAnimation(
      curve: Curves.easeInOutCirc,
      parent: _controller,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _perspectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    model = Provider.of<PlayerModel>(context);

    if (model.currentTrack == 0)
      _controller.duration = model.musicList[model.currentTrack].duration;

    if (model.musicList[model.currentTrack].isPlaying == true) {
      _controller.duration = model.musicList[model.currentTrack].duration;

      _controller.forward();
    } else {
      _controller.stop();
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        model.musicList[model.currentTrack].isPlaying = false;
        _controller.reset();
      }
    });
    _timeCounter =
        Tween<Duration>(begin: Duration(seconds: 0), end: _controller.duration)
            .animate(_controller);

    return Scaffold(
      backgroundColor: Color(0xFf7A5EBB),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 210,
            width: width,
            height: height,
            child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(Math.pi / 6 - _perspectiveAnim.value),
                child: buildMusicList()),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            width: width,
            bottom: isListVisible ? height - 210 : 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_perspectiveController.isAnimating
                    ? -_perspectiveAnim.value
                    : 0),
              child: Material(
                elevation: 16,
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffD6DDE5),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Text(model.musicList[model.currentTrack].name,
                          style: TextStyle(
                              fontSize: 34,
                              color: Colors.black,
                              fontFamily: 'Rochester')),
                      SizedBox(
                        height: 15,
                      ),
                      Text(model.musicList[model.currentTrack].artistName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 75,
                      ),
                      DistortedCircle(
                        child: buildRecordPlayer(),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: <Widget>[
                          Text(_timeCounter.value.toString().substring(3, 7),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                          SizedBox(
                            width: 8,
                          ),
                          buildWave(
                            width,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(_controller.duration.toString().substring(3, 7),
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildControlsRow(model),
                      SizedBox(
                        height: 30,
                      ),
                      Text('ALL TRACKS'),
                      SizedBox(
                        height: 25,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                        ),
                        onPressed: () {
                          setState(() {
                            if (!isListVisible)
                              _perspectiveController.forward();
                            else
                              _perspectiveController.reverse();
                            isListVisible = !isListVisible;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            top: isListVisible ? 15 : 40,
            left: 30,
            right: 30,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 30,
                ),
                Spacer(),
                Icon(
                  Icons.playlist_play,
                  size: 33,
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            top: isListVisible ? 90 : 643,
            left: 30,
            right: 30,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.repeat,
                  size: 25,
                ),
                Spacer(),
                Icon(
                  Icons.add,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView buildMusicList() {
    return ListView.separated(
      separatorBuilder: (_, __) => Divider(
        thickness: 1,
        height: 0,
        color: Color(0xff9780CD),
      ),
      itemCount: model.musicList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        bool isIndexCurrentTrack = false;
        if (index == model.currentTrack) isIndexCurrentTrack = true;

        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: isIndexCurrentTrack ? Color(0xff6A52A4) : Color(0xFF7A5EBB),

          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!isIndexCurrentTrack) {
                model.resetList();
                _controller.reset();
              }
              model.currentTrack = index;
              model.musicList[model.currentTrack].isPlaying =
                  !model.musicList[model.currentTrack].isPlaying;
              print(model.musicList[model.currentTrack].isPlaying.toString() +
                  '$index');
            },
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              leading: PlayerButton(
                iconPri: Icon(Icons.play_arrow),
                iconAlt: Icon(Icons.pause),
                radius: 18,
                isInnerColorFill: true,
                musicNo: index,
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  model.musicList[index].name,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Text(model.musicList[index].artistName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  )),
              trailing: Text(
                  model.musicList[index].duration.toString().substring(3, 7),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  )),
            ),
          ),
        );
      },
    );
  }

  Container buildWave(double width) {
    return Container(
      width: 262 * _waveAnim.value,
      height: 40,
      child: CustomPaint(
        painter: WaveBasePainter(),
        child: ClipRect(
          clipper: WaveClipper(_waveConstAmpAnim.value * width),
          child: CustomPaint(
            painter: WaveBasePainter(),
            foregroundPainter: WaveColorPainter(_waveAnim),
          ),
        ),
      ),
    );
  }

  Widget buildRecordPlayer() {
    return Transform.rotate(
      angle: _coverAnim.value,
      child: Container(
        height: 290,
        width: 290,
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -_coverAnim.value,
          child: ClipOval(
            child: Image.asset(
              'images/cover.png',
              height: 150,
              width: 150,
              fit: BoxFit.fill,
            ),
          ),
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/vinyl.png',
              ),
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.color),
            ),
            shape: BoxShape.circle),
      ),
    );
  }
}
