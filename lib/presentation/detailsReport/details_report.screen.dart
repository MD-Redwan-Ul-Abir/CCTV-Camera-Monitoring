import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import '../shared/widgets/customCarocelSlider/customCaroselSlider.dart';
import 'controllers/details_report.controller.dart';

class DetailsReportScreen extends GetView<DetailsReportController> {
  const DetailsReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Details reports",
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
                height: 30.h,
                width: 30.w,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

              SizedBox(height: 8.h),

              Text(
                "23 - 30 May (40 Hours)",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                ),
              ),

              SizedBox(height: 38.h),
            ],
          ),
        ),
      ),
    );
  }
}
