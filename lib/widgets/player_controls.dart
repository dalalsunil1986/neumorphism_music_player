import 'package:flutter/material.dart';
import '../model.dart';
import 'button.dart';

Row buildControlsRow(PlayerModel model) {
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