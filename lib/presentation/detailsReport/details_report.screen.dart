import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/createReport/controllers/create_report.controller.dart';

import '../../app/routes/app_routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_contents.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import '../shared/widgets/customCarocelSlider/customCaroselSlider.dart';
import 'controllers/details_report.controller.dart';

// SCREEN UI - Updated to work with single object response
class DetailsReportScreen extends StatefulWidget {
  const DetailsReportScreen({super.key});

  @override
  State<DetailsReportScreen> createState() => _DetailsReportScreenState();
}

class _DetailsReportScreenState extends State<DetailsReportScreen> {
  final DetailsReportController detailsReportController = Get.find<DetailsReportController>();
  final CreateReportController createReportController = Get.find<CreateReportController>();

  @override
  void initState() {
    super.initState();
    detailsReportController.getReportDetails();
  }

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
          padding: EdgeInsets.only(left: 8.0.w),
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Obx(() {
          // Loading state
          if (detailsReportController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryNormal),
            );
          }

          // No data state
          if (detailsReportController.reportDetails.value == null) {
            return Center(
              child: Text(
                'No report details available',
                style: AppTextStyles.paragraph3.copyWith(
                  color: AppColors.secondaryLightActive,
                ),
              ),
            );
          }

          // Data loaded successfully
          final report = detailsReportController.reportDetails.value!;
          final attributes = report.data.attributes;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auto Carousel Slider
                AutoCarouselSlider(
                  images: attributes.attachments.isNotEmpty
                      ? attributes.attachments
                      .map((attachment) => attachment.attachment)
                      .where((url) => url.isNotEmpty)
                      .toList()
                      : [],
                  height: 220.h,
                  autoPlayInterval: Duration(seconds: 5),
                  activeIndicatorColor: AppColors.primaryDark,
                  inactiveIndicatorColor: AppColors.grayDarker,
                  borderRadius: BorderRadius.circular(4.r),
                  defaultAssetImage: AppImages.noImage,
                  onPageChanged: (index) {
                    print('Page changed to $index');
                  },
                ),

                SizedBox(height: 20.h),

                // Site Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        attributes.siteId.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.paragraph3.copyWith(
                          color: AppColors.primaryLight,
                          fontSize: 16.sp,
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
                            attributes.siteId.address,
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.secondaryLightActive,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w),

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
                            attributes.createdAt != null
                                ? attributes.createdAt!.toString().substring(0, 10)
                                : 'N/A',
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
                    attributes.description,
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
                            borderRadius: BorderRadius.circular(100.r),
                            child: Container(
                              width: 34.r,
                              height: 34.r,
                              color: AppColors.grayDarker,
                              child: detailsReportController.profileImageUrl.value.isNotEmpty
                                  ? Image.network(
                                detailsReportController.profileImageUrl.value,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    AppImages.noImage,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                                  : Image.asset(
                                AppImages.noImage,
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
                                attributes.creatorId.name,
                                style: AppTextStyles.caption1.copyWith(
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                attributes.creatorId.role,
                                style: AppTextStyles.button.copyWith(
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 36.h),

                // Conditional button based on role
                if (attributes.creatorId.role != AppContents.userRole)
                  PrimaryButton(
                    onPressed: () {
                      Get.toNamed(Routes.CREATE_REPORT);
                    },
                    text: "Create Response Report",
                    width: double.infinity,
                  ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}