import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:html/parser.dart';

import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/app_colors.dart';
import '../../infrastructure/theme/text_styles.dart';
import '../../infrastructure/utils/app_images.dart';
import '../shared/widgets/buttons/primary_buttons.dart';
import '../shared/widgets/customRatings/customRatings.dart';
import '../shared/widgets/custom_text_form_field.dart';
import '../languageChanging/appString.dart';
import 'controllers/privacy_settings.controller.dart';
import 'model/privacyModel.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});


  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  final PrivacySettingsController privacySettingsController = Get.find<
      PrivacySettingsController>();

  @override
  void initState() {
    privacySettingsController.getPrivacyData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        title: Text(
          AppStrings.privacySettingsTitle.tr,
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
        child: Obx(() {
          if(privacySettingsController.isLoading.value==true){
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryNormal,
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              privacySettings(
                Name: AppStrings.termsOfServicesMenuItem.tr,
                onTap: () {
                  Attribute? termsAttr = privacySettingsController
                      .getAttributeByType('termsAndConditions'); // Use actual type from API

                  Get.toNamed(
                    Routes.CUSTOM_PRIVACY_POLICY,
                    arguments: {
                      'title': AppStrings.termsOfServicesMenuItem.tr,
                      'customWidget': Column(

                        children: [

                          Text(
                            parse( termsAttr?.details  ?? AppStrings.noPrivacyPolicyAvailable.tr).body?.text ?? '',
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
                Name: AppStrings.privacyPolicyMenuItem.tr,
                onTap: () {
                  Attribute? privacyPolicy = privacySettingsController
                      .getAttributeByType('privacyPolicy');
                  Get.toNamed(
                    Routes.CUSTOM_PRIVACY_POLICY,
                    arguments: {
                      'title': AppStrings.privacyPolicyMenuItem.tr,
                      'customWidget': Column(
                        children: [

                          Text(
                            parse(privacyPolicy?.details ?? AppStrings.noPrivacyPolicyAvailable.tr).body?.text ?? '',
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
                Name: AppStrings.aboutUsMenuItem.tr,
                onTap: () {
                  Attribute? aboutUs = privacySettingsController
                      .getAttributeByType('aboutUs');
                  Get.toNamed(
                    Routes.CUSTOM_PRIVACY_POLICY,
                    arguments: {
                      'title': AppStrings.aboutUsMenuItem.tr,
                      'customWidget': Column(
                        children: [
                          Image.asset(
                            AppImages.appLogo2,
                            height: 53.h,
                            width: 132.w,
                          ),
                          SizedBox(height: 22.h),

                          Text(
                            parse( aboutUs?.details   ?? AppStrings.noPrivacyPolicyAvailable.tr).body?.text ?? '',
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
                Name: AppStrings.contactUsMenuItem.tr,
                onTap: () {
                  // Get the attribute first, then access its contactUs property
                  Attribute? contactAttr = privacySettingsController
                      .getAttributeByType('contactUs');
                  ContactUs? contactUS = contactAttr?.contactUs; // Access the contactUs property

                  Get.toNamed(
                    Routes.CUSTOM_PRIVACY_POLICY,
                    arguments: {
                      'title': AppStrings.contactUsMenuItem.tr,
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
                                    AppStrings.sgtSikringTitle.tr,
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
                                        contactUS?.phone ?? AppStrings.defaultPhone.tr, // Use contactUS.phone
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
                                      SvgPicture.asset(AppImages.email2,
                                        color: AppColors.secondaryLightActive,),
                                      SizedBox(width: 12.w),
                                      Text(
                                        contactUS?.email ?? AppStrings.defaultEmail.tr, // Use contactUS.email
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
                                      SvgPicture.asset(AppImages.location2,
                                        color: AppColors.secondaryLightActive,),
                                      SizedBox(width: 12.w),
                                      Flexible(
                                        child: Text(
                                          contactUS?.address ?? AppStrings.defaultAddress.tr, // Use contactUS.address
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
                                        contactUS?.availableTime ?? AppStrings.defaultHours.tr, // Use contactUS.availableTime
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
          );
        }),
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
