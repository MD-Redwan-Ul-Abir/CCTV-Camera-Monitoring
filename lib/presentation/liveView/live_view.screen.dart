import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';

import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/live_view.controller.dart';

class LiveViewScreen extends GetView<LiveViewController> {
  const LiveViewScreen({super.key});

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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Container
              // VlcPlayer(
              //  // placeholder: Center(child: CircularProgressIndicator( color: AppColors.primaryDark,),),
              //   controller: VlcPlayerController.network(
              //       "rtsp://rtspuser:liVEtv4me@62.79.144.146/Streaming/Channels/102",
              //       autoPlay: true,
              //       options: VlcPlayerOptions(
              //         rtp: VlcRtpOptions([
              //           VlcRtpOptions.rtpOverRtsp(true),
              //           ":rtsp-tcp",
              //         ]),
              //       )
              //   ), aspectRatio: 16/9,
              // ),

              Obx(() =>
                  Container(
                    height: 340.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: controller.selectedCameraUrl.value.isEmpty
                          ? AppColors.primaryDark
                          : Colors.transparent,

                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Stack(
                      children: [
                        // Video Player Placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Center(
                            child:
                               VlcPlayer(
                                //placeholder: Center(child: CircularProgressIndicator( color: AppColors.primaryDark,),),
                                controller: VlcPlayerController.network(
                                    controller.selectedCameraUrl.value,
                                    autoPlay: true,
                                    options: VlcPlayerOptions(
                                      rtp: VlcRtpOptions([
                                        VlcRtpOptions.rtpOverRtsp(true),
                                        ":rtsp-tcp",
                                      ]),
                                    )
                                ), aspectRatio: 16 / 9,
                              )

                          ),
                        ),

                        // LIVE indicator (top right)
                        if (controller.hasCameraSelected)
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black38,
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
                        if (controller.hasCameraSelected)
                          Positioned(
                            bottom: 12.h,
                            right: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Obx(() =>
                                  Text(
                                    controller.currentTime.value,
                                    style: AppTextStyles.button.copyWith(
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )),
                            ),
                          ),
                      ],
                    ),
                  )),
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
                  color: AppColors.primaryLightActive,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 15.h),

              // Available Cameras Section
              Text(
                "Available cameras",
                style: AppTextStyles.headLine6.copyWith(
                  color: AppColors.secondaryLight,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Choose a camera to view live feed",
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.secondaryLightActive,
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 19.h),

              // Camera List - FIXED with proper Obx wrapping
              Obx(() =>
              controller.cameraList.isEmpty
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.videocam_off,
                        size: 50.sp,
                        color: AppColors.secondaryLightActive,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No cameras available",
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.secondaryLightActive,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.cameraList.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    bool isSelected = controller.selectedCameraIndex.value ==
                        index;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: GestureDetector(
                        onTap: () {
                          controller.selectCamera(index);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.grayDarker,
                              width: 1.w,
                            ),
                            color: AppColors.secondaryDark,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18.r,
                                backgroundColor: isSelected ? AppColors
                                    .primaryDark : AppColors.grayDarker,
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.cameraList[index]['camera']!,
                                      style: AppTextStyles.button.copyWith(
                                        color: isSelected ? AppColors
                                            .primaryLight : AppColors
                                            .secondaryLightActive,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}