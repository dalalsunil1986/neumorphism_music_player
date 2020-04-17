import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_player_concept/painter.dart';
import 'package:neumorphic_player_concept/clipper.dart';
import 'package:neumorphic_player_concept/wave_painter.dart';
import 'package:provider/provider.dart';
import 'distorted_wave.dart';
import 'dart:math' as Math;

import 'clipper.dart';
import 'newmodel.dart';

void main() {
  runApp(MaterialApp(
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
  Animation<double> _musicSelectedColorAnim;
  Animation<Duration> _timeCounter;

  bool isWaveTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(minutes: 1, seconds: 9))
      ..addListener(() => setState(() {}));
    _perspectiveController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {});
    _perspectiveAnim = Tween<double>(begin: 0, end: Math.pi / 6).animate(
        CurvedAnimation(curve: Curves.easeOut, parent: _perspectiveController));
    _waveAnim = Tween<double>(begin: 1, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _musicSelectedColorAnim = Tween<double>(begin: 1, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _waveConstAmpAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(curve: Curves.easeInSine, parent: _controller));
    _coverAnim = Tween<double>(begin: 0, end: 300 * Math.pi).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
  }

  double time;
  bool isListVisible = false;
  PlayerModel model;
  bool isPressed = false;

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
      if (status == AnimationStatus.completed)
        model.musicList[model.currentTrack].isPlaying = false;
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
            // duration: Duration(seconds: 4),
            top: 210,
            width: width,
            height: height,
            child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(3.14 / 6 - _perspectiveAnim.value),
                child: buildMusicList()),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 2),
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
                        height: 90,
                      ),
                      Text(model.musicList[model.currentTrack].name,
                          style: TextStyle(fontSize: 22)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(model.musicList[model.currentTrack].artistName,
                          style: TextStyle(fontSize: 16)),
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
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
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
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildControlsRow(),
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
          Positioned(
            top: 40,
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
          Positioned(
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
          duration: Duration(milliseconds: 500),
          color: isIndexCurrentTrack ? Color(0xff6A52A4) : Color(0xFF7A5EBB),
          // clipper: WaveClipper((1-_waveConstAmpAnim.value) * 360),

          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              model.resetList();
              if (index != model.currentTrack) _controller.reset();
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

  Row buildControlsRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Spacer(),
        SizedBox(
          width: 35,
        ),
        PlayerButton(
            radius: 20,
            iconPri: Icon(Icons.skip_previous),
            iconAlt: Icon(Icons.skip_next),
            musicNo: model.currentTrack + 1),
        SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: () {
            model.currentTrack = model.currentTrack;
            model.musicList[model.currentTrack].isPlaying =
                !model.musicList[model.currentTrack].isPlaying;
            print('big tap');
          },
          child: PlayerButton(
            radius: 35,
            iconPri: Icon(Icons.play_arrow),
            iconAlt: Icon(Icons.pause),
            musicNo: model.currentTrack,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        PlayerButton(
          radius: 20,
          iconPri: Icon(Icons.skip_next),
          iconAlt: Icon(Icons.skip_next),
          musicNo: model.currentTrack + 1,
        ),
        SizedBox(
          width: 35,
        ),
        Spacer(),
      ],
    );
  }

  Container buildWave(double width) {
    return Container(
      width: 262 * _waveAnim.value,
      height: 40,
      child: CustomPaint(
        painter: TrialPainter(),
        child: ClipRect(
          clipper: WaveClipper(_waveConstAmpAnim.value * width),
          child: CustomPaint(
            painter: TrialPainter(),
            foregroundPainter: WavePainter(_waveAnim),
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
