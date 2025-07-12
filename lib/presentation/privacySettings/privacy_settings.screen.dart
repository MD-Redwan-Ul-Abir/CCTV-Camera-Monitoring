import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import '../shared/widgets/customRatings/customRatings.dart';
import '../shared/widgets/custom_text_form_field.dart';
import 'controllers/privacy_settings.controller.dart';

class PrivacySettingsScreen extends GetView<PrivacySettingsController> {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacySettingsController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          "Privacy Setting",
          style: AppTextStyles.paragraph3.copyWith(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            privacySettings(
              Name: 'Terms of Services',
              onTap: () {
                Get.toNamed(
                  Routes.CUSTOM_PRIVACY_POLICY,
                  arguments: {
                    'title': 'Terms of Services ',
                    'customWidget': Column(
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu. \n\nLorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu.',
                          style: AppTextStyles.button.copyWith(
                            height: 1.6,
                            color: AppColors.secondaryLightActive,
                          ),
                        ),
                      ],
                    ),
                  },
                );
              },
            ),
            SizedBox(height: 17.h),
            privacySettings(
              Name: 'Privacy Policy',
              onTap: () {
                Get.toNamed(
                  Routes.CUSTOM_PRIVACY_POLICY,
                  arguments: {
                    'title': 'Privacy Policy',
                    'customWidget': Column(
                      children: [
                        Text(
                          'Lorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu. \n\nLorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu.',
                          style: AppTextStyles.button.copyWith(
                            height: 1.6,

                            color: AppColors.secondaryLightActive,
                          ),
                        ),
                      ],
                    ),
                  },
                );
              },
            ),
            SizedBox(height: 17.h),
            privacySettings(
              Name: 'About us',
              onTap: () {
                Get.toNamed(
                  Routes.CUSTOM_PRIVACY_POLICY,
                  arguments: {
                    'title': 'About us',
                    'customWidget': Column(
                      children: [
                        Image.asset(
                          AppImages.appLogo2,
                          height: 53.h,
                          width: 132.w,
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          'Lorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu. \n\nLorem ipsum dolor sit amet consectetur. Enim sagittis mattis sed risus nunc. Non ac vel viverra ut facilisis ultricies leo. Vel nunc eget tellus duis mollis sollicitudin. Eget aliquam leo sed arcu. Dignissim enim dolor rhoncus nam nisi ullamcorper sed suscipit pellentesque. Volutpat magna imperdiet cum adipiscing quam curabitur consectetur. At tortor consectetur ut ut scelerisque nec elementum tellus. Consectetur quis amet duis quisque suspendisse. Pellentesque scelerisque venenatis blandit velit ac eu.',
                          style: AppTextStyles.button.copyWith(
                            height: 1.6,

                            color: AppColors.secondaryLightActive,
                          ),
                        ),
                      ],
                    ),
                  },
                );
              },
            ),
            SizedBox(height: 17.h),
            privacySettings(
              Name: 'Contact us',
              onTap: () {
                Get.toNamed(
                  Routes.CUSTOM_PRIVACY_POLICY,
                  arguments: {
                    'title': 'Contact us',
                    'customWidget': Column(
                      children: [
                        SizedBox(height: 22.h),
                        Image.asset(
                          AppImages.appLogo2,
                          height: 53.h,
                          width: 132.w,
                        ),
                        SizedBox(height: 22.h),
                        Container(
                          height: 240.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: AppColors.grayDarker,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SGT Sikring",
                                  style: AppTextStyles.textButton.copyWith(
                                    color: AppColors.primaryLight,
                                    fontSize: 21.5.sp,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(AppImages.phone2),
                                    SizedBox(width: 12.w),
                                    Text(
                                      ' +45 12 34 56 78',
                                      style: AppTextStyles.textButton.copyWith(
                                        fontSize: 15.5.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(AppImages.email2,color: AppColors.secondaryLightActive,),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'support@sktsikring.dk',
                                      style: AppTextStyles.textButton.copyWith(
                                        fontSize: 15.5.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(AppImages.location2,color: AppColors.secondaryLightActive,),
                                    SizedBox(width: 12.w),
                                    Flexible(
                                      child: Text(
                                        'Nordre Ringvej 14,2600 Glostrup, Denmark',
                                        style: AppTextStyles.textButton.copyWith(
                                          fontSize: 15.5.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(AppImages.timer),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Mon–Fri, 08:00–17:00',
                                      style: AppTextStyles.textButton.copyWith(
                                        fontSize: 15.5.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class privacySettings extends StatelessWidget {
  final String Name;
  final VoidCallback onTap;

  const privacySettings({super.key, required this.Name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 54.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grayDarker,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Name,
                style: AppTextStyles.button.copyWith(color: Color(0xFFFFFFFF)),
              ),
              SvgPicture.asset(
                AppImages.forwardIcon,
                height: 24.h,
                width: 24.w,
                color: AppColors.primaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
