import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:skt_sikring/presentation/reportScreen/model/reportModel.dart';

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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h),
        child: AppBar(
          backgroundColor: AppColors.secondaryDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            "Reports",
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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Filter buttons section
              Obx(() => _buildFilterButtons(controller.availableCategories)),

              SizedBox(height: 16.h),

              // Reports list section
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primaryNormal),
                  );
                }
                return _buildReportsList(
                    controller.allSelectedReport, cardColors, controller);
              }),

              SizedBox(height: 20.h),

              // Pagination section
              Obx(() => _buildPagination()),

              SizedBox(height: 20.h),

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

  Widget _buildFilterButtons(List<String> categories) {
    return Wrap(
      spacing: 18.w,
      runSpacing: 12.h,
      children: categories.map((category) {
        bool isSelected = controller.selectedCategory.value == category;
        return GestureDetector(
          onTap: () {
            controller.setSelectedCategory(category);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryNormal
                  : AppColors.primaryLight.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              category,
              style: AppTextStyles.button.copyWith(
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.primaryLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReportsList(
    List<Result> reports,
    List<Color> cardColors,
    ReportScreenController controller,
  ) {
    if (reports.isEmpty) {
      return Container(
        height: 200.h,
        child: Center(
          child: Text(
            'No reports found',
            style: AppTextStyles.paragraph.copyWith(
              color: AppColors.primaryLight.withOpacity(0.7),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final color = cardColors[index % cardColors.length];

        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.DETAILS_REPORT, arguments: report.reportId?.reportId! );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Card(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    report.reportId!.title!,
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.secondaryDarker,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  child: Text(
                    report.createdAt!.toLocal().toString(),
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
    );
  }

  Widget _buildPagination() {
    if (controller.totalPages.value <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        GestureDetector(
          onTap: controller.currentPage.value > 1
              ? () => controller.goToPreviousPage()
              : null,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: controller.currentPage.value > 1
                  ? AppColors.primaryLight.withOpacity(0.3)
                  : AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.chevron_left,
              color: controller.currentPage.value > 1
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
        ),

        SizedBox(width: 16.w),

        // Page numbers
        ...List.generate(controller.totalPages.value, (index) {
          int pageNumber = index + 1;
          bool isCurrentPage = pageNumber == controller.currentPage.value;

          return GestureDetector(
            onTap: () => controller.goToPage(pageNumber),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: isCurrentPage
                    ? AppColors.primaryNormal
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  pageNumber.toString(),
                  style: AppTextStyles.button.copyWith(
                    color: isCurrentPage
                        ? AppColors.primaryLight
                        : Color(0xFFFFFFFF).withOpacity(0.6),
                    fontWeight:
                        isCurrentPage ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),

        SizedBox(width: 16.w),

        // Next button
        GestureDetector(
          onTap: controller.currentPage.value < controller.totalPages.value
              ? () => controller.goToNextPage()
              : null,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: controller.currentPage.value < controller.totalPages.value
                  ? AppColors.primaryLight.withOpacity(0.3)
                  : AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.chevron_right,
              color: controller.currentPage.value < controller.totalPages.value
                  ? AppColors.primaryLight
                  : AppColors.primaryLight.withOpacity(0.5),
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
