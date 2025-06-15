import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/report_screen.controller.dart';

class ReportScreen extends GetView<ReportScreenController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> cardColors = [
      AppColors.greenLight,
      AppColors.yellowLightActive,
      Color(0xFFC7ECFF), // Light Mint
    ];

    // Restructured data to support multiple categories
    List<Map<String, dynamic>> categorizedData = [
      {
        'categoryTitle': 'Alarm report',
        'sites': [
          {'name': 'Site A, Bashundhara', 'date': '23 - 30 May'},
          {'name': 'Site C, Mirpur', 'date': '15 - 22 June'},
          {'name': 'Site D, Gulshan', 'date': '01 - 08 July'},
        ]
      },
      {
        'categoryTitle': 'Irregularity reports',
        'sites': [
          {'name': 'Site B, Dhanmondi', 'date': '10 - 17 April'},
          {'name': 'Site E, Uttara', 'date': '25 May - 01 June'},
        ]
      },
      {
        'categoryTitle': 'Service Reports',
        'sites': [
          {'name': 'Site G, Banani', 'date': '15 - 22 August'},
          {'name': 'Site H, Motijheel', 'date': '01 - 08 September'},
        ]
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Profile & Settings",
            style: AppTextStyles.headLine6.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.primaryLight,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Outer ListView.builder for categories
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categorizedData.length,
                itemBuilder: (context, categoryIndex) {
                  final category = categorizedData[categoryIndex];
                  final sites = category['sites'] as List<Map<String, String>>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category title
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          category['categoryTitle'],
                          style: AppTextStyles.headLine6.copyWith(height: 1.5),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Inner ListView.builder for sites in this category
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sites.length,
                        itemBuilder: (context, siteIndex) {
                          final color = cardColors[siteIndex % cardColors.length];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.DETAILS_REPORT);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Card(
                                color: color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      sites[siteIndex]['name']!,
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.secondaryDarker,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      sites[siteIndex]['date']!,
                                      style: AppTextStyles.caption1.copyWith(
                                        color: AppColors.secondaryDark,
                                      ),
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    height: 32.h,
                                    width: 32.w,
                                    child: SvgPicture.asset(
                                      AppImages.forwardIcon,
                                      color: AppColors.primaryDark,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Add spacing between categories
                      SizedBox(height: 20.h),
                    ],
                  );
                },
              ),


              PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  Get.toNamed(Routes.CREATE_REPORT);
                },
                text: 'Create Report',
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}