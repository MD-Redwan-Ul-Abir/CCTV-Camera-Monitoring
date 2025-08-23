import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/infrastructure/theme/text_styles.dart';
import 'package:skt_sikring/presentation/shared/widgets/buttons/primary_buttons.dart';
import 'package:skt_sikring/presentation/shared/widgets/custom_text_form_field.dart';
import '../languageChanging/appString.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/utils/app_images.dart';
import 'controllers/splash_language.controller.dart';

class SplashLanguageScreen extends GetView<SplashLanguageController> {
  const SplashLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 50.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo image
            Image.asset(
              AppImages.appLogo,
              height: 92.h,
              width: 233.w,
            ),
            SizedBox(
              height: 100.h,
            ),
            Text(
              AppStrings.languageText.tr,
              style: AppTextStyles.paragraph2,
            ),
            SizedBox(
              height: 16.h,
            ),
            // Custom dropdown field
            Obx(
              () {
                return CustomTextFormField(
                  dropDownItems: [
                    DropdownMenuItem(
                      value: 'English',
                      child: Text(
                        AppStrings.english.tr,
                        style: AppTextStyles.button,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Danish',
                      child: Text(
                        AppStrings.danish.tr,
                        style: AppTextStyles.button,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Swedish',
                      child: Text(
                        AppStrings.swedish.tr,
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                  selectedValue: controller.selectedLanguage.value,
                  onChanged: (String? newValue) {
                    controller.updateSelectedLanguage(newValue);
                  },
                  hintText: AppStrings.selectOptionHint.tr,
                  //suffixSvg: AppImages.backIcon,
                );
              },
            ),

            SizedBox(
              height: 26.h,
            ),
            PrimaryButton(
                width: double.infinity,
                onPressed: () {
                  controller.saveLanguageAndNavigate();
                },
                text: AppStrings.startButton.tr),

            SizedBox(
              height: 150.h,
            )
          ],
        ),
      ),
    );
  }
}