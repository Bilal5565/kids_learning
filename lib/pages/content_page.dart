import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_app/constant/constant.dart';
import 'package:edu_app/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/colors.dart';
import '../model/content_model.dart';

class ContentPage extends StatefulWidget {
  final String collectionName;

  ContentPage({required this.collectionName});

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage>
    with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  late Stream<QuerySnapshot> _contentStream;
  bool _isContentLoaded = false;

  @override
  void initState() {
    super.initState();
    _contentStream = FirebaseFirestore.instance
        .collection(widget.collectionName)
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    if (_isContentLoaded) {
      Music.volDown();
      await _flutterTts.setLanguage(
        widget.collectionName == AppString.letters
            ? AppString.urdu
            : AppString.english,
      );

      await _flutterTts.setPitch(1);
      await _flutterTts.speak(text);
      await Future.delayed(Duration(milliseconds: 650));
      Music.volUp();
    }
  }

  void _onTap(AnimationController controller, String text) async {
    await controller.forward();
    await _speak(text);
    await controller.reverse();
  }

  AnimationController _createAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: Shimmer.fromColors(
          baseColor: AppColors.secondary,
          highlightColor: AppColors.backGround,
          child: PrimaryText(
            text: widget.collectionName.toUpperCase(),
            size: 22.0.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _contentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingBar(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                AppString.errorLoading,
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                AppString.noContent,
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          _isContentLoaded = true;
          List<Content> contentList = snapshot.data!.docs
              .map((doc) => Content.fromDocument(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          return GridView.builder(
            itemCount: contentList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final content = contentList[index];
              final AnimationController controller =
                  _createAnimationController();

              final Animation<double> scaleAnimation =
                  Tween<double>(begin: 1, end: 1.1).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOut,
                ),
              );

              final Animation<double> rotationAnimation =
                  Tween<double>(begin: 0, end: 0.1).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOut,
                ),
              );

              final Animation<double> opacityAnimation =
                  Tween<double>(begin: 1, end: 0.7).animate(
                CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOut,
                ),
              );

              return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnimation.value,
                    child: Transform.rotate(
                      angle: rotationAnimation.value,
                      child: Opacity(
                        opacity: opacityAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: InkWell(
                  onTap: () => _onTap(controller, content.title),
                  child: CachedNetworkImage(
                    imageUrl: content.imageUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.all(8.h),
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                        color: AppColors.backGround,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: PrimaryText(
                              text: content.title.toLowerCase(),
                              size: 18.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Spacer(),
                          Image(
                            image: imageProvider,
                            height: 85.h,
                            width: 85.w,
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: PrimaryText(
                              text: content.description?.toLowerCase() ?? '',
                              size: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tale,
                            ),
                          ),
                        ],
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.white,
                      highlightColor: AppColors.gray.shade300,
                      child: Container(
                        margin: EdgeInsets.all(8.h),
                        padding: EdgeInsets.all(8.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
