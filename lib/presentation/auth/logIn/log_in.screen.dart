import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../shared/widgets/buttons/primary_buttons.dart';
import '../../shared/widgets/custom_text_form_field.dart';

import 'controllers/log_in.controller.dart';

class LogInScreen extends GetView<LogInController> {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LogInController logInController = Get.find<LogInController>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                height: 30.h,
                width: 30.w,
              ),
              onPressed: () {
                Get.offAllNamed(Routes.SPLASH_LANGUAGE);
              },
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 95.h,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login or create \nAccount",
                    style: AppTextStyles.headLine6.copyWith(
                        color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Enter Your Email to enjoy the best security \nmanagement",
                    style: AppTextStyles.button,
                  ),
                  SizedBox(height: 30.h),
              
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.grayDarker,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: TabBar(
                      controller: controller.tabController,
                      onTap: controller.changeTab,
                      labelPadding: EdgeInsets.zero,
                      indicatorColor: Colors.transparent,
                      // This removes the default indicator
                      indicatorWeight: 0,
                      // Add this to remove indicator weight
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      // Add this to remove the divider line
                      indicator: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      labelColor: AppColors.grayDark,
                      unselectedLabelColor: AppColors.grayDark,
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("user", style: AppTextStyles.button),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Customer", style: AppTextStyles
                                .button), // Capitalized to match your second image
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: 30.h),
                   CustomTextFormField(
                     validator: (value) => (value?.trim().isEmpty ?? true) ? 'Enter your Email address' : null,
                      controller: logInController.emailController,
                      hintText: "Email",
                      keyboardType: 'email',
                      prefixSvg: AppImages.emailIcon,
                    ),
                  SizedBox(height: 17.h),
                  CustomTextFormField(
                    validator: (value) => (value?.trim().isEmpty ?? true) ? 'Enter your Password' : null,
                    controller: logInController.passwordController,
                    hintText: "Password",
                    keyboardType: 'visiblePassword',
                    prefixSvg: AppImages.password,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.FORGET_PASSWORD);
                        },
                        child: Text(
                          "Forget Password?",
                          style: AppTextStyles.textCaption1.copyWith(
                            color: AppColors.primaryNormal,
                          ),
                        ),
                      ),
                    ),
                  ),
                 
                  GetBuilder<LogInController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator(color: AppColors.primaryLight,));
                      }
                      return PrimaryButton(
                        width: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                           logInController.login();
                          }

                        },
                        text: "Log in",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
