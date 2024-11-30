// ignore_for_file: deprecated_member_use

import 'package:edu_app/constant/images.dart';
import 'package:edu_app/constant/strings.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/colors.dart';
import '../constant/constant.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back navigation logic here (e.g., show confirmation dialog)
        final confirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              AppString.exitText,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  AppString.cancel,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  AppString.exit,
                ),
              ),
            ],
          ),
        );

        // If user confirmed, exit the app
        if (confirmed ?? false) {
          SystemNavigator.pop(); // Exit the app
        }

        // Return false to prevent default back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.h),
                height: 0.35.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  color: AppColors.backGround,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AppImage.logo,
                    ),
                  ),
                ),
              ),
              CategoryList(),
             SizedBox(height:20.h),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/Games');
                },
                child: Container(
                  padding: EdgeInsets.all(15.h),
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  height: 0.2.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 80.h,
                        width: 80.w,
                        child: Image.asset(
                          AppImage.gameImage,
                        ),
                      ),
                      PrimaryText(
                        text: AppString.fun,
                        fontWeight: FontWeight.w700,
                        size: 26.sp,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 120.h,
                width: 1.sw,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    AppImage.footer,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.5.sh,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemCount: AppString.categoryNameAndCollectionNameList.length,
          itemBuilder: (context, index) {
            return CategoryTile(
              categoryName: AppString.categoryNameAndCollectionNameList[index]
                  ['categoryName']!,
              collectionName: AppString.categoryNameAndCollectionNameList[index]
                  ['collectionName']!,
              image: AppString.categoryNameAndCollectionNameList[index]
                  ['categoryImage']!,
            );
          }),
    );
  }
}
