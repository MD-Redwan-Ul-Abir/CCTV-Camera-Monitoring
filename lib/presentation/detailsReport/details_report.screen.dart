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
        toolbarHeight: 70.h,
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
                height: 24.h,
                width: 24.w,
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
              AutoCarouselSlider(
                images: [
                  AppImages.sitePic, // Replace with actual site images
                  AppImages.chatPerson, // Replace with actual site images
                  AppImages.sitePic, // Replace with actual site images
                  AppImages.chatPerson,
                ],
                height: 220.h,
                autoPlayInterval: Duration(seconds: 5),
                activeIndicatorColor: AppColors.primaryDark,
                inactiveIndicatorColor: AppColors.grayDarker,
                borderRadius: BorderRadius.circular(4.r),
                onPageChanged: (index) {
                  //print('Page changed to $index');
                },
              ),

              SizedBox(height: 20.h),

              // Site Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Broken Fence Detected – Northeast Side",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.paragraph3.copyWith(
                        color: AppColors.primaryLight,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w), // Add some spacing
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightActive,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8,
                      ),
                      child: Text(
                        'under Review',
                        style: AppTextStyles.caption1,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 38.h),

              // Location and Date Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.location2),
                            SizedBox(width: 8.w),
                            Text(
                              'Location',
                              style: AppTextStyles.caption1.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Site A– Mirpur',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.secondaryLightActive,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.date),
                            SizedBox(width: 8.w),
                            Text(
                              'Date',
                              style: AppTextStyles.caption1.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'May 21, 2025 – 07:42 AM',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.secondaryLightActive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Description Section
              Text(
                'Description :',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                ),
              ),

              SizedBox(height: 12.h),

              // Description Content Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.grayDarker,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'A broken section of the perimeter fence was found on the northeast side of the site during the early morning patrol. The breach appears to be recent. There were no signs of unauthorized entry, but the area has been temporarily secured.',
                  style: AppTextStyles.caption1.copyWith(
                    color: AppColors.secondaryLightActive,
                    letterSpacing: 0.18,
                    height: 1.6,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Security Supervisor Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.grayDarker,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Profile Avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            width: 26.r,
                            height: 26.r,

                            color: AppColors.grayDarker,
                            child: Image.asset(
                              AppImages.person,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Name and Title
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sachin',
                              style: AppTextStyles.caption1.copyWith(
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Security Superviser',
                              style: AppTextStyles.button.copyWith(
                                color: Color(0xFFFFFFFF),
                                //fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
