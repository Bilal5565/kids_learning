// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:edu_app/constant/strings.dart';
import 'package:edu_app/constant/voices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:math';

import 'package:vibration/vibration.dart';

import '../../constant/colors.dart';
import '../../constant/constant.dart';

class ColorMatch extends StatefulWidget {
  _ColorMatchState createState() => _ColorMatchState();
}

class _ColorMatchState extends State<ColorMatch> {
  final player = AudioPlayer();
  final Map<String, bool> score = {};
  final Map choices = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange
  };

  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sage,
      appBar: AppBar(
          foregroundColor: AppColors.black,
          actions: [
            FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.sage,
              mini: true,
              child: Icon(Icons.refresh, color: AppColors.black),
              onPressed: () {
                setState(() {
                  score.clear();
                  seed++;
                });
              },
            ),
          ],
          centerTitle: true,
          title: PrimaryText(
            text: '${AppString.score} ${score.length} / 6',
            size: 25,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          elevation: 0,
          backgroundColor: AppColors.sage),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                choices.keys.map((emoji) => _buildDragTarget(emoji)).toList()
                  ..shuffle(Random(seed)),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((emoji) {
                return Draggable<String>(
                  data: emoji,
                  child: Emoji(emoji: score[emoji] == true ? '✅' : emoji),
                  feedback: Emoji(emoji: emoji),
                  childWhenDragging: Emoji(emoji: '🌱'),
                );
              }).toList())
        ],
      ),
    );
  }

  Widget _buildDragTarget(emoji) {
    return DragTarget<String>(
        builder: (BuildContext context, List<String?> incoming, List rejected) {
          if (score[emoji] == true) {
            return Container(
              child: PrimaryText(
                  text: AppString.great, fontWeight: FontWeight.w800, size: 25),
              alignment: Alignment.center,
              height: 80.h,
              width: 200.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 2,
                    )
                  ]),
            );
          } else {
            return Container(
              height: 80.h,
              width: 200.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: choices[emoji],
                  boxShadow: [
                    BoxShadow(
                      color: choices[emoji],
                      blurRadius: 2,
                    )
                  ]),
            );
          }
        },
        onWillAccept: (data) => data == emoji,
        onAccept: (data) {
          setState(
            () {
              score[emoji] = true;
              player.play(AssetSource(AppVoices.correct,),);
              if (score.length == 6) {
                player.play(AssetSource(AppVoices.winner,),);
                Future.delayed(
                  Duration(seconds: 4),
                  () {
                    setState(() => score.clear());
                    setState(() => seed++);
                  },
                );
              }
            },
          );
        },
        onLeave: (data) {
          Vibration.vibrate(duration: 500);
        });
  }
}

class Emoji extends StatelessWidget {
  final String emoji;
  Emoji({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 80,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: AppColors.black, fontSize: 50),
        ),
      ),
    );
  }
}
