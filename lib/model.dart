import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:neumorphic_player_concept/musicdata.dart';

class PlayerModel extends ChangeNotifier {
  List<Music> musicList = [];
  bool _resetPlayer = false;
  int _currentTrack = 0;

  resetList() {
    musicList.forEach((music) {
      music.isPlaying = false;
    });
    notifyListeners();
  }

  int get currentTrack => _currentTrack;

  set currentTrack(int currentTrack) {
    _currentTrack = currentTrack;
    notifyListeners();
  }

  bool get resetPlayer => _resetPlayer;

  set resetPlayer(bool resetPlayer) {
    _resetPlayer = resetPlayer;
    notifyListeners();
  }

  PlayerModel() {
    for (int i = 0; i < Data.nameList.length; i++) {
      musicList
          .add(Music(artistName: Data.artistList[i], name: Data.nameList[i]));
    }

    musicList.removeWhere(
        (musicItem) => musicItem.name == null || musicItem.artistName == null);

    musicList.forEach((musicItem) {
      musicItem.duration = Duration(
        minutes: Random().nextInt(5).clamp(1, 5),
        seconds: Random().nextInt(59),
      );

      musicList.forEach((music) => print(music.name));
    });
  }
}

class Music {
  String name;
  Duration duration;
  String artistName;
  bool isPlaying = false;

  Music({this.artistName, this.duration, this.name});
}
