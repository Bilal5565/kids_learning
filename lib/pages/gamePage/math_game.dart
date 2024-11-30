

import 'dart:math';
import 'package:edu_app/constant/button.dart';
import 'package:edu_app/constant/strings.dart';
import 'package:edu_app/constant/voices.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/colors.dart';
import '../../constant/constant.dart';

class MathGame extends StatefulWidget {
  const MathGame({Key? key}) : super(key: key);

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  // Number A, number B
  int numberA = 1;
  int numberB = 1;

  // User answer
  String userAnswer = '';

  // Audio player instance
  AudioPlayer audioPlayer = AudioPlayer();

  // Counter for correct answers
  int correctAnswers = 0;

  // Difficulty level
  int difficultyLevel = 5;

  // User tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // Calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // Clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // Delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // Maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  // Check if user is correct or not
  void checkResult() async {
    if (numberA + numberB == int.parse(userAnswer)) {
      await audioPlayer.play(
        AssetSource(
          AppVoices.winner,
        ),
      );
      correctAnswers++;
      if (correctAnswers % 5 == 0) {
        difficultyLevel += 5; // Increase difficulty by 5
        showDialog(
          context: context,
          barrierDismissible:
              false, // Prevents dismissing the dialog by tapping outside
          builder: (context) {
            return AlertDialog(
              title: Text(AppString.congratulations),
              content: Text(
                  'You have answered $correctAnswers questions correctly. The game will now be a bit harder!'),
              actions: [
                TextButton(
                  onPressed: () {
                    goToNextQuestion();
                    correctAnswers = 0;
                    // This will now only close the dialog
                  },
                  child: Text(AppString.ok),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return ResultMessage(
              message: AppString.correct,
              onTap: goToNextQuestion,
              icon: Icons.arrow_forward,
            );
          },
        );
      }
    } else {
      await audioPlayer.play(
        AssetSource(
          AppVoices.wrong,
        ),
      );
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: AppString.sorry,
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  // Create random numbers
  var randomNumber = Random();

  // Go to next question
  void goToNextQuestion() {
    // Dismiss alert dialog
    Navigator.of(context).pop();

    // Reset values
    setState(() {
      userAnswer = '';
    });

    // Create a new question
    numberA = randomNumber.nextInt(difficultyLevel);
    numberB = randomNumber.nextInt(difficultyLevel);
  }

  // Go back to question
  void goBackToQuestion() {
    setState(() {
      userAnswer = '';
    });
    // Dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Lpink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Correct answers and difficulty level display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${AppString.correctAnswer} $correctAnswers',
                  style: whiteTextStyle.copyWith(fontSize: 24.sp),
                ),
                Text(
                  '${AppString.level} $difficultyLevel',
                  style: whiteTextStyle.copyWith(fontSize: 24.sp),
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Question
                    Text(
                      '$numberA + $numberB = ',
                      style: whiteTextStyle,
                    ),

                    // Answer box
                    Container(
                      height: 50.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Number pad
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: AppString.numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: AppString.numberPad[index],
                    onTap: () => buttonTapped(AppString.numberPad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
