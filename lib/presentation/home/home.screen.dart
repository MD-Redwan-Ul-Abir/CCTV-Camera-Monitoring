import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> cardColors = [
      AppColors.greenLight,
      AppColors.yellowLightActive,
      Color(0xFFC7ECFF), // Light Mint
    ];

    List<Map<String, String>> siteData = [
      {'name': 'Site A, Bashundhara', 'date': '23 - 30 May'},
      {'name': 'Site C, Mirpur', 'date': '15 - 22 June'},
      {'name': 'Site D, Gulshan', 'date': '01 - 08 July'},
    ];

    List<Map<String, String>> reportData = [
      {
        'title': 'Incident Report',
        'description':
            'Found broken fence on the northeast side of the site. Found broken fence on the northeast side of the site. Found broken fence on the northeast side of the site.',
      },
      {
        'title': 'Safety Check',
        'description': 'Found broken fence on the northeast side of the site.',
      },
      {
        'title': 'Safety Check',
        'description': 'Found broken fence on the northeast side of the site.',
      },
      {
        'title': 'Safety Check',
        'description': 'Found broken fence on the northeast side of the site.',
      },
      {
        'title': 'Safety Check',
        'description': 'Found broken fence on the northeast side of the site.',
      },
      {
        'title': 'Maintenance',
        'description': 'Found broken fence on the northeast side of the site.',
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.secondaryDark,
            automaticallyImplyLeading: false,
            expandedHeight: 160.h,
            collapsedHeight: kToolbarHeight + 10.h,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final statusBarHeight = MediaQuery.of(context).padding.top;
                final maxHeight = 130.h + statusBarHeight;
                final minHeight = kToolbarHeight + 10.h + statusBarHeight;
                final shrinkRatio =
                    (constraints.maxHeight - minHeight) /
                    (maxHeight - minHeight);
                final isCollapsed = shrinkRatio <= 0.2;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: AppColors.secondaryDark,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Expanded content
                      if (!isCollapsed)
                        Positioned(
                          top: statusBarHeight + 10.h,
                          left: 16.w,
                          right: 16.w,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: isCollapsed ? 0.0 : 1.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo
                                SizedBox(height: 20.h),
                                Image.asset(
                                  AppImages.appLogo2,
                                  height: 52.h,
                                  width: 156.w,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 20.h),
                                // Profile section
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        AppImages.profilePic,
                                        height: 48.h,
                                        width: 48.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome, John jack',
                                          style: AppTextStyles.textButton
                                              .copyWith(
                                                color: AppColors.secondaryLight,
                                              ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          'Customer',
                                          style: AppTextStyles.textCaption1
                                              .copyWith(
                                                color: AppColors.secondaryLight,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Collapsed content
                      if (isCollapsed)
                        Positioned(
                          left: 16.w,
                          right: 16.w,
                          bottom: 8.h,
                          height: 40.h,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  AppImages.profilePic,
                                  height: 32.h,
                                  width: 32.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'John jack',
                                  style: AppTextStyles.textButton.copyWith(
                                    color: AppColors.secondaryLight,
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Image.asset(
                                AppImages.appLogo2,
                                height: 28.h,
                                width: 84.w,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your sites',
                      style: AppTextStyles.headLine6.copyWith(height: 1.5),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: siteData.length,
                    itemBuilder: (context, index) {
                      final color = cardColors[index % cardColors.length];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SITE_DETAILS);
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
                                  siteData[index]['name']!,
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
                                  siteData[index]['date']!,
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
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Today's Report",
                      style: AppTextStyles.headLine6.copyWith(
                        color: AppColors.primaryLight,
                        height: 1.5,
                      ),
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio:
                              1.3, // Increased from 1.2 to give more height
                        ),
                    itemCount: reportData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(
                          14.w,
                        ), // Reduced padding from 16.w to 14.w
                        decoration: BoxDecoration(
                          color: AppColors.grayDarker,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween, // Changed from center to spaceBetween
                          mainAxisSize: MainAxisSize.min, // Keep this as min
                          children: [
                            // Top section with title and description
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    reportData[index]['title']!,
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Flexible(
                                    child: Text(
                                      reportData[index]['description']!,
                                      maxLines:
                                          3, // Reduced from 3 to 2 for better fit
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption1.copyWith(
                                        color: AppColors.grayNormal,
                                        fontSize: 13.sp,
                                        height:
                                            1.4.h, // Reduced line height from 1.4 to 1.3
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bottom section with View Reports button
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.DETAILS_REPORT);
                                },
                                child: Text(
                                  'View Reports',
                                  style: AppTextStyles.caption1.copyWith(
                                    color: AppColors.primaryNormal,
                                    height:
                                        1.3, // Reduced line height from 1.4 to 1.3
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),
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
        ],
      ),
    );
  }
}
