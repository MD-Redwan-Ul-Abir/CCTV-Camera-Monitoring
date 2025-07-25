
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

class SiteDetailsScreen extends StatefulWidget {
  const SiteDetailsScreen({super.key});

  @override
  State<SiteDetailsScreen> createState() => _SiteDetailsScreenState();
}

class _SiteDetailsScreenState extends State<SiteDetailsScreen> {
  final SiteDetailsController siteDetailsController = Get.find<
      SiteDetailsController>();


  @override
  void initState() {
    super.initState();
    siteDetailsController.getSiteDetails();
  }




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
          padding: EdgeInsets.only(left: 8.0.w),
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
        child: Obx(() {
          if(siteDetailsController.isLoading.value== true){
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryNormal),
            );
          }


          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AutoCarouselSlider(

                  images: siteDetailsController.getCarouselImages(),
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
                  siteDetailsController.siteDetails.value?.data?.attributes?.results?.first.siteId?.name  ??'',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  siteDetailsController.siteDetails.value?.data?.attributes?.results?.first.siteId?.createdAt .toString()
                      .substring(0, 10)   ??'',
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
                        backgroundImage: NetworkImage(siteDetailsController.profileImageUrl.value),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        siteDetailsController.siteDetails.value?.data?.attributes?.userInfo?.first.personId!.name ??"",
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
                    padding:  EdgeInsets.symmetric(vertical: 5.0.h),
                    child: Text(
                      siteDetailsController.siteDetails.value?.data?.attributes?.results?.first.siteId?.type ??"",
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
                    final siteData = siteDetailsController.siteDetails.value?.data?.attributes?.results?.first;
//     siteDetailsController.siteDetails.value?.data?.attributes?.results?.first.siteId?.name
                    Get.toNamed(Routes.LIVE_VIEW, arguments: {
                      'siteId': siteData?.siteId?.siteId,
                      'siteName': siteData?.siteId?.name, // assuming siteName property exists
                      'date': DateTime.now().toString(), // or whatever date you want to pass

                    });
                  },
                  text: 'Live View Site',
                ),
              ],
            ),

          );
        }),
      ),
    );
  }
}
