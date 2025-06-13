import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/live_view.controller.dart';

class LiveViewScreen extends GetView<LiveViewController> {
  const LiveViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> cameraList = [
      {
        'camera': 'camera 01',
        'url':
            'https://vg-republictvlive.akamaized.net/v1/manifest/611d79b11b77e2f571934fd80ca1413453772ac7/vglive-sk-456368/71dd8ad8-6b5e-4c8a-b708-4832dbcbecc8/1.m3u8?ads.partner=republicweb&sessionId=76fdaed3-abfd-4b64-8317-133644eadf4b',
      },
      {
        'camera': 'camera 02',
        'url':
            'https://vg-republictvlive.akamaized.net/v1/manifest/611d79b11b77e2f571934fd80ca1413453772ac7/vglive-sk-456368/71dd8ad8-6b5e-4c8a-b708-4832dbcbecc8/1.m3u8?ads.partner=republicweb&sessionId=76fdaed3-abfd-4b64-8317-133644eadf4b',
      },
      {
        'camera': 'camera 03',
        'url':
            'https://vg-republictvlive.akamaized.net/v1/manifest/611d79b11b77e2f571934fd80ca1413453772ac7/vglive-sk-456368/71dd8ad8-6b5e-4c8a-b708-4832dbcbecc8/1.m3u8?ads.partner=republicweb&sessionId=76fdaed3-abfd-4b64-8317-133644eadf4b',
      },
    ];

    // Auto-select first camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cameraList.isNotEmpty && controller.selectedCameraIndex == -1) {
        controller.selectCamera(0, cameraList[0]['url']!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Live view",
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
              // Video Player Container
              GetBuilder<LiveViewController>(
                builder: (controller) {
                  return Container(
                    height: 350.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Stack(
                      children: [
                        // Video Player
                        controller.videoPlayerController != null &&
                                controller
                                    .videoPlayerController!
                                    .value
                                    .isInitialized
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width:
                                        controller
                                            .videoPlayerController!
                                            .value
                                            .size
                                            .width,
                                    height:
                                        controller
                                            .videoPlayerController!
                                            .value
                                            .size
                                            .height,
                                    child: VideoPlayer(
                                      controller.videoPlayerController!,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : Center(
                              child:
                                  controller.isLoading
                                      ? CircularProgressIndicator(
                                        color: AppColors.primaryLight,
                                      )
                                      : Text(
                                        'Loading camera feed...',
                                        style: AppTextStyles.button.copyWith(
                                          color: AppColors.primaryLight,
                                        ),
                                      ),
                            ),

                        // LIVE indicator (top right)
                        if (controller.videoPlayerController != null &&
                            controller
                                .videoPlayerController!
                                .value
                                .isInitialized)
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.redNormal,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Live',
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Current time (bottom right)
                        if (controller.videoPlayerController != null &&
                            controller
                                .videoPlayerController!
                                .value
                                .isInitialized)
                          Positioned(
                            bottom: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                controller.currentTime,
                                style: AppTextStyles.button.copyWith(
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
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
                "23 - 30 May",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 35.h),

              // Site Information
              Text(
                "Available cameras",
                style: AppTextStyles.headLine6.copyWith(
                  color: AppColors.primaryLight,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Choose a camera to view live feed",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 25.h),

              // Camera List
              GetBuilder<LiveViewController>(
                builder: (controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cameraList.length,
                    itemBuilder: (context, index) {
                      bool isSelected = controller.selectedCameraIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.selectCamera(
                              index,
                              cameraList[index]['url']!,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.primaryDark
                                        : AppColors.grayDarker,
                                width: 1.5,
                              ),
                              color: AppColors.secondaryDark,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor:
                                      isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.grayDarker,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppImages.camera2,
                                      height: 19.h,
                                      width: 19.w,
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  cameraList[index]['camera']!,
                                  style: AppTextStyles.button.copyWith(
                                    color:
                                        isSelected
                                            ? AppColors.primaryLight
                                            : AppColors.secondaryLightActive,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
