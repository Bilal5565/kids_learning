import 'package:edu_app/constant/images.dart';
import 'package:edu_app/constant/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/colors.dart';
import '../constant/constant.dart';
import '../main.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int selectedCard = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppColors.backGround),
        ),
        title:
            Image.asset(AppImage.logo, width: 100.w, height: 100.h),
      ),
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildCards(context),
            Image.asset(AppImage.gameFooter)
          ],
        ),
      ),
    );
  }

  Widget cardsStyle(String imagePath, String name, int index) {
    return InkWell(
      onTap: () => {
        setState(
          () {
            selectedCard = index;
            Navigator.pushNamed(
                context,AppString. gamesRoutes[index]['routePath'].toString());
          },
        ),
      },
      child: Container(
        height: 100.h,
        width: width * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: selectedCard == index ? AppColors.crimson : AppColors.yellow,
            boxShadow: [
              BoxShadow(
                color: AppColors.crimson,
                blurRadius: 2,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.transparent,
              height: 150.h,
              width: 90.w,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            PrimaryText(text: name, fontWeight: FontWeight.w800, size: 25),
          ],
        ),
      ),
    );
  }

  SizedBox buildCards(BuildContext context) {
    return SizedBox(
      height: ScreenSize(context).height / 1.3,
      child: ListView.builder(
        itemCount: AppString.GamesList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return cardsStyle(AppString.GamesList[index]['imagePath'].toString(),
              AppString.GamesList[index]['GameName'].toString(), index);
        },
      ),
    );
  }
}
