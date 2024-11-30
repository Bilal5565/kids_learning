import 'package:edu_app/constant/colors.dart';
import 'package:edu_app/constant/constant.dart';
import 'package:edu_app/constant/images.dart';
import 'package:flutter/material.dart';
import 'dart:async';




class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/Home');
    });

    return new Scaffold(
      backgroundColor: AppColors.black,
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              AppImage.logo,
              width: ScreenSize(context).width * 0.6,
              height: ScreenSize(context).height * 0.75,
            ),
            loadingBar(),
          ],
        ),
      ),
    );
  }
}
