import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';
import 'package:skt_sikring/infrastructure/utils/api_content.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    if(homeController.fatchedData==false){
      WidgetsBinding.instance.addPostFrameCallback((__) async {
        await homeController.getProfile();
        await homeController.getAllYourSites();
        await homeController.getAllTodaysReportByDate();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    List<Color> cardColors = [
      AppColors.greenLight,
      AppColors.yellowLightActive,
      Color(0xFFC7ECFF), // Light Mint
    ];



    return Scaffold(
      body: Obx(() {
        if (homeController.isLoading.value == true) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryNormal),
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryNormal,
          backgroundColor: AppColors.primaryLighthover,
          onRefresh: () async {
            await homeController.getProfile();
            await homeController.getAllYourSites();
            await homeController.getAllTodaysReportByDate();
          },
          child: CustomScrollView(
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
                    final statusBarHeight = MediaQuery
                        .of(context)
                        .padding
                        .top;
                    final maxHeight = 130.h + statusBarHeight;
                    final minHeight = kToolbarHeight + 10.h + statusBarHeight;
                    final shrinkRatio = (constraints.maxHeight - minHeight) /
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
                                      AppImages.appLogo,
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
                                          child: Obx(() {
                                            // Safe check for profile image
                                            final imageUrl = homeController
                                                .profileImageUrl.value;
                                            if (imageUrl.isNotEmpty) {
                                              return Image.network(
                                                imageUrl,
                                                height: 48.h,
                                                width: 48.w,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    height: 48.h,
                                                    width: 48.w,
                                                    color: Colors.grey[300],
                                                    child: Icon(Icons.person,
                                                        color: Colors.grey[600]),
                                                  );
                                                },
                                              );
                                            } else {
                                              return Container(
                                                height: 48.h,
                                                width: 48.w,
                                                color: Colors.grey[300],
                                                child: Icon(Icons.person,
                                                    color: Colors.grey[600]),
                                              );
                                            }
                                          }),
                                        ),
                                        SizedBox(width: 12.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Obx(() {
                                              // Safe null check for profile details
                                              final profileData = homeController
                                                  .profileDetails.value;
                                              final userName = profileData?.data
                                                  ?.attributes?.name ?? 'User';

                                              return Text(
                                                'Welcome, $userName',
                                                style: AppTextStyles.textButton
                                                    .copyWith(
                                                  color: AppColors.secondaryLight,
                                                ),
                                              );
                                            }),
                                            SizedBox(height: 6.h),
                                            Obx(() {
                                              return Text(
                                                homeController.role.value.isEmpty
                                                    ? 'Role'
                                                    : homeController.role.value,
                                                style: AppTextStyles.textCaption1
                                                    .copyWith(
                                                  color: AppColors.secondaryLight,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            }),
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
                                    child: Obx(() {
                                      final imageUrl = homeController
                                          .profileImageUrl.value;
                                      if (imageUrl.isNotEmpty) {
                                        return Image.network(
                                          imageUrl,
                                          height: 32.h,
                                          width: 32.w,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Container(
                                              height: 32.h,
                                              width: 32.w,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.person,
                                                  color: Colors.grey[600],
                                                  size: 16),
                                            );
                                          },
                                        );
                                      } else {
                                        return Container(
                                          height: 32.h,
                                          width: 32.w,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.person,
                                              color: Colors.grey[600], size: 16),
                                        );
                                      }
                                    }),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Obx(() {
                                      final profileData = homeController
                                          .profileDetails.value;
                                      final userName = profileData?.data
                                          ?.attributes?.name ?? 'No User Found';

                                      return Text(
                                        userName,
                                        style: AppTextStyles.textButton.copyWith(
                                          color: AppColors.secondaryLight,
                                          fontSize: 14.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                                  ),
                                  Image.asset(
                                    AppImages.appLogo,
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your sites',
                          style: AppTextStyles.headLine6.copyWith(height: 0,
                              color: AppColors.secondaryLight),
                        ),
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Obx(() {
                        final siteData = homeController.getallSiteBySiteID.value;
                        if (siteData?.data?.attributes?.results == null ||
                            siteData!.data!.attributes!.results!.isEmpty) {
                          return Center(
                            child: Text(
                              'No sites available',
                              style: AppTextStyles.caption1.copyWith(
                                color: AppColors.grayNormal,
                              ),
                            ),
                          );
                        }

                        final results = siteData.data!.attributes!.results!;
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final color = cardColors[index % cardColors.length];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SITE_DETAILS,arguments: results[index].siteId?.siteId);
                              },
                              child: Card(
                                color: color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 6.w),
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Text(
                                      results[index].siteId?.name ??
                                          'No site found',
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.secondaryDarker,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: Text(
                                      results[index].siteId?.createdAt
                                          .toString()
                                          .substring(0, 10) ?? '',
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
                            );
                          },
                        );
                      }),
                      SizedBox(height: 11.h),
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
                      SizedBox(
                        height: 12.h,
                      ),
                      Obx(() {
                        final todaysReport = homeController.getAllReportByDate.value;
                        if (todaysReport?.data?.attributes?.results == null ||
                            todaysReport!.data!.attributes!.results!.isEmpty) {
                          return Center(
                            child: Text(
                              'Nothing Reported Today',
                              style: AppTextStyles.caption1.copyWith(
                                color: AppColors.grayNormal,
                              ),
                            ),
                          );
                        }
                        final reportData = todaysReport.data!.attributes!.results!;
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1.3,
                          ),
                          itemCount: reportData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: AppColors.grayDarker,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Top section with title and description

                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: double.infinity,),
                                        Text(
                                          reportData[index].reportId!.title!,
                                          style: AppTextStyles.button.copyWith(
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6.h),
                                        Flexible(
                                          child: Text(
                                            reportData[index].reportId!.description!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.caption1
                                                .copyWith(
                                              color: AppColors.grayNormal,
                                              fontSize: 13.sp,
                                              height: 1.4.h,
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
                                        Get.toNamed(Routes.DETAILS_REPORT,arguments:reportData[index].reportId!.reportId);
                                      },
                                      child: Text(
                                        'View Reports',
                                        style: AppTextStyles.caption1.copyWith(
                                          color: AppColors.primaryNormal,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },

                        );
                      }),
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
      }),
    );
  }
}