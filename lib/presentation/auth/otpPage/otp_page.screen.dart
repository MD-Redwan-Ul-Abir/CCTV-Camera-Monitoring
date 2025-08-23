import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../languageChanging/appString.dart';
import '../../shared/widgets/buttons/primary_buttons.dart';
import 'controllers/otp_page.controller.dart';

class OtpPageScreen extends StatefulWidget {
  const OtpPageScreen({super.key});

  @override
  State<OtpPageScreen> createState() => _OtpPageScreenState();
}

class _OtpPageScreenState extends State<OtpPageScreen> {
  final OtpPageController controller = Get.find<OtpPageController>();

  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will rebuild the widget when the locale changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryDark,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                AppImages.backIcon,
                color: AppColors.primaryLight,
                height: 24.h,
                width: 24.w,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.LOG_IN);
              },
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 95.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text(AppStrings.otpTitle.tr,
                  style: AppTextStyles.headLine6
                      .copyWith(color: Color(0xFFFFFFFF))),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppStrings.otpSubtitle.tr,
                style: AppTextStyles.button,
              ),
            ),
            SizedBox(height: 40.h),
            PinCodeTextField(
              appContext: context,
              length: 6,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                activeBorderWidth: 1.r,
                borderRadius: BorderRadius.circular(8.r),
                fieldHeight: 57.h,
                fieldWidth: 44.w,
                activeFillColor: AppColors.grayDarker,
                inactiveFillColor: AppColors.grayDarker,
                selectedFillColor: AppColors.grayDarker,
                activeColor: AppColors.primaryDark,
                inactiveColor: Colors.transparent,
                selectedColor: Colors.transparent,
              ),
              cursorColor: AppColors.primaryDark,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: controller.otpTextEditingController,
              keyboardType: TextInputType.number,
              textStyle: AppTextStyles.button.copyWith(
                fontSize: 14.sp,
                color: AppColors.primaryDark,
              ),
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                ),
              ],
              onChanged: (value) {
                controller.isPinComplete.value = value.length == 6;
              },
              onCompleted: (v) {
                debugPrint("Completed");
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                return true;
              },
            ),
            SizedBox(height: 20.h),
//             Obx(
//                   () => PrimaryButton(
//                 isActive: controller.isPinComplete.value,
//                 width: double.infinity,
//                 onPressed:
//                 controller.isPinComplete.value
//                     ? () {
// // otpPageController.showPin();
//                 otpPageController.verifyOtp();
//                  // Get.toNamed(Routes.RESET_PASSWORD);
//                 }
//                     : null,
//                 text: "Verify Email",
//               ),
//             ),
            GetBuilder<OtpPageController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppColors.primaryLight,
                  ));
                }
                return PrimaryButton(
                  width: double.infinity,
                  onPressed: () async {
                    // if (_formKey.currentState!.validate()) {
                    //   forgetPasswordController.sendOTP();
                    //   //  var x =logInController.getStoredUserData();
                    //   //  print("------------------------------------------------------------------");
                    //   // print(x);
                    // }
                    controller.verifyOtp();
                  },
                  text: AppStrings.sendOTP.tr,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}