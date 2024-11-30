

import 'package:edu_app/constant/constant.dart';
import 'package:edu_app/pages/home_page.dart';
import 'package:edu_app/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'pages/gamePage/color_match.dart';
import 'pages/gamePage/math_game.dart';
import 'pages/gamePage/memory.dart';
import 'pages/game_page.dart';
import'package:cloud_firestore/cloud_firestore.dart';



late double height, width;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  //WidgetsBinding.instance.addObserver(MusicHandler());
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.immersive,
  // );

   //Music.play();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,],

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    height = ScreenSize(context).height;
    width = ScreenSize(context).width;

    return ScreenUtilInit(
       designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        
        builder: (_, child) {
          return MaterialApp(
            title: 'Junior Genius',
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => SplashPage(),
              '/Home': (context) => HomePage(),
              '/Games': (context) => GamePage(),
              '/Color': (context) => ColorMatch(),
              '/Memory': (context) => Memory(),
              '/Math': (context) => MathGame(),
            },
          );
        });
  }
}

class MusicHandler extends WidgetsBindingObserver {
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      Music.player.pause();
    } else if (state == AppLifecycleState.resumed) {
      Music.player.resume();
    }
  }
}
