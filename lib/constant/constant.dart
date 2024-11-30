import 'package:audioplayers/audioplayers.dart';
import 'package:edu_app/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/content_page.dart';

Widget loadingBar() {
  return CircularProgressIndicator(
    color: AppColors.secondary,
  );
}

class Music {
  static final AudioPlayer player = AudioPlayer();

  static Future<void> play() async {
    try {
      await player.setVolume(0.30);
      await player.setReleaseMode(ReleaseMode.loop); // Loop the audio
      await player.play(
        AssetSource('voices/music.mp3'),
      );
    } catch (e) {
      print('Error playing music: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await player.stop();
    } catch (e) {
      print('Error stopping music: $e');
    }
  }

  static Future<void> volDown() async {
    try {
      await player.setVolume(0.10);
    } catch (e) {
      print('Error setting volume down: $e');
    }
  }

  static Future<void> volUp() async {
    try {
      await player.setVolume(0.30);
    } catch (e) {
      print('Error setting volume up: $e');
    }
  }
}

class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;
  final TextOverflow? overflow;
  final int? line;

  const PrimaryText({
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.black,
    this.size = 20,
    this.height = 1.2,
    this.overflow,
    this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: line,
      overflow: overflow,
      style: GoogleFonts.happyMonkey(
        height: height,
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class ScreenSize {
  BuildContext context;

  ScreenSize(this.context) : assert(true);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

var whiteTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 30.sp,
  color: Colors.white,
);

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final String collectionName;
  final String image;

  CategoryTile({
    required this.categoryName,
    required this.collectionName,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentPage(collectionName: collectionName),
          ),
        );
      },
      hoverColor: AppColors.Lpink,
      splashColor: AppColors.backGround,
      child: Container(
        margin: EdgeInsets.all(8.h),
        padding: EdgeInsets.all(6.h),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 100.h,
              width: 100.w,
            ),
            SizedBox(
              height: 20.h,
            ),
            PrimaryText(
              text: categoryName,
              fontWeight: FontWeight.w800,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class ResultMessage extends StatelessWidget {
  final String message;
  final VoidCallback onTap;
  final icon;

  const ResultMessage({
    Key? key,
    required this.message,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backGround,
      content: Container(
        height: 150.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // the result
            Text(
              message,
              style: whiteTextStyle,
            ),

            // button to go to next question
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
