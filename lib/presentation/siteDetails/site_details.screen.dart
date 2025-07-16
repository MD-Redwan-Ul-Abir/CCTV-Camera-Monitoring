import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/customCarocelSlider/customCaroselSlider.dart';
import 'controllers/site_details.controller.dart';

class SiteDetailsScreen extends GetView<SiteDetailsController> {
  const SiteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryDark,

      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Site Details",
          style: AppTextStyles.headLine6.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.primaryLight,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                AppImages.backIcon,
                color: AppColors.primaryLight,
                  height: 24.h,
                  width: 24.w
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auto Carousel Slider
              //AutoCarouselSlider(),
              AutoCarouselSlider(
                images: [
                  AppImages.sitePic, // Replace with actual site images
                  AppImages.chatPerson, // Replace with actual site images
                  AppImages.sitePic, // Replace with actual site images
                  AppImages.chatPerson,
                ],
                height: 230.h,
                autoPlayInterval: Duration(seconds: 5),
                activeIndicatorColor: AppColors.primaryDark,
                inactiveIndicatorColor: AppColors.grayDarker,
                borderRadius: BorderRadius.circular(4),
                onPageChanged: (index) {
                  //print('Page changed to $index');
                },
              ),

              SizedBox(height: 20.h),

              // Site Information
              Text(
                "Site A, Bashundhara",
                style: AppTextStyles.button.copyWith(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                "23 - 30 May (40 Hours)",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                ),
              ),

              SizedBox(height: 38.h),

              // Assign Manager Section
              Text(
                "Assign manager",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                  fontSize: 13.sp,
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayDarker, width: 1.5),
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundImage: AssetImage(AppImages.chatPerson),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Henrik",
                      style: AppTextStyles.caption1.copyWith(
                        color: AppColors.secondaryLightActive,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Type Section
              Text(
                "Type",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                  fontSize: 13.sp,
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayDarker, width: 1.5),
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    "Construction Site",
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.secondaryLightActive,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 50.h),

              // Live View Site Button
              PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  Get.toNamed(Routes.LIVE_VIEW);
                },
                text: 'Live View Site',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
