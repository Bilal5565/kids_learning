import 'package:edu_app/constant/colors.dart';
import 'package:edu_app/constant/images.dart';
import 'package:edu_app/constant/strings.dart';
import 'package:edu_app/constant/voices.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import '../../constant/constant.dart';
import '../../main.dart';

class Memory extends StatefulWidget {
  @override
  MemoryState createState() => MemoryState();
}

class MemoryState extends State<Memory> {
  final player = AudioPlayer();
  GameLogic _gameLogic = GameLogic();
  int tries = 15; // Set the initial number of tries
  int score = 0;

  @override
  void initState() {
    super.initState();
    _gameLogic.initGame();
  }

  void restartGame() {
    setState(() {
      _gameLogic.initGame();
      tries = 15; // Reset tries to initial value
      score = 0;
    });
  }

  void _handleCardTap(int index) {
    if (_gameLogic.gameImg[index] != _gameLogic.hiddenCardPath ||
        _gameLogic.matchCheck.length == 2) {
      return;
    }

    setState(() {
      tries--; // Decrease tries by one
      _gameLogic.gameImg[index] = _gameLogic.cardsList[index];
      _gameLogic.matchCheck.add({index: _gameLogic.cardsList[index]});
    });

    if (_gameLogic.matchCheck.length == 2) {
      if (_gameLogic.matchCheck[0].values.first ==
              _gameLogic.matchCheck[1].values.first &&
          _gameLogic.matchCheck[0].keys.first !=
              _gameLogic.matchCheck[1].keys.first) {
        score += 100;
        player.play(AssetSource(AppVoices.correct));
        _gameLogic.matchCheck.clear();
      } else {
        player.play(AssetSource(AppVoices.wrong));

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _gameLogic.gameImg[_gameLogic.matchCheck[0].keys.first] =
                _gameLogic.hiddenCardPath;
            _gameLogic.gameImg[_gameLogic.matchCheck[1].keys.first] =
                _gameLogic.hiddenCardPath;
            _gameLogic.matchCheck.clear();
            Vibration.vibrate(duration: 300);
          });
        });
      }

      if (!_gameLogic.gameImg.contains(AppImage.memo) &&
          score >= 400) {
        player.play(
          AssetSource(AppVoices.winner),
        );
        Future.delayed(
          Duration(seconds: 4),
          () {
            restartGame();
          },
        );
      }
    }

    if (tries <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppString.gameOver,),
            content: Text(AppString.reach,),
            actions: [
              TextButton(
                child: Text(AppString.restart),
                onPressed: () {
                  restartGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Lpink,
      appBar: AppBar(
        foregroundColor: AppColors.black,
        actions: [
          FloatingActionButton(
            elevation: 0,
            backgroundColor: AppColors.Lpink,
            mini: true,
            child: Icon(Icons.refresh, color: AppColors.black),
            onPressed: restartGame,
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.Lpink,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              scoreBoard(AppString.tries, "$tries"),
              scoreBoard(AppString.score, "$score"),
            ],
          ),
          SizedBox(
            height: height * 0.6,
            width: width,
            child: GridView.builder(
              itemCount: _gameLogic.gameImg.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              padding: EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.crimson,
                      image: DecorationImage(
                        image: AssetImage(_gameLogic.gameImg[index]),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.crimson,
                          blurRadius: 2,
                        )
                      ],
                    ),
                  ),
                  onTap: () => _handleCardTap(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget scoreBoard(String title, String info) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(25.0),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryText(text: title, fontWeight: FontWeight.w800, size: 22),
          SizedBox(height: 10),
          PrimaryText(text: info, fontWeight: FontWeight.w800, size: 22),
        ],
      ),
    ),
  );
}

class GameLogic {
  final String hiddenCardPath = AppImage.memo;
  late List<String> gameImg;
  final cardCount = 8;

  
  List<String> cardsList = [];

  List<String> cardList1 = [
    "assets/memo/circle.png",
    "assets/memo/triangle.png",
    "assets/memo/heart.png",
    "assets/memo/star.png",
  ];

  List<String> cardList2 = [
    "assets/memo/circle.png",
    "assets/memo/triangle.png",
    "assets/memo/heart.png",
    "assets/memo/star.png",
  ];

  List<Map<int, String>> matchCheck = [];

  void fillList() {
    cardsList = [];
    cardsList += shuffle(cardList1) + shuffle(cardList2);
  }

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardPath);
    fillList();
  }
}

List<String> shuffle(List<String> items) {
  var random = new Random();

  for (var i = items.length - 1; i >= 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}
