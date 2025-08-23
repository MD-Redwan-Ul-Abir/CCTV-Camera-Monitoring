import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/shared/widgets/custom_button.dart';
import '../../languageChanging/appString.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/theme/app_colors.dart';
import '../../../infrastructure/theme/text_styles.dart';
import '../../../infrastructure/utils/app_images.dart';
import '../../shared/widgets/buttons/primary_buttons.dart';
import '../../shared/widgets/custom_text_form_field.dart';
import 'controllers/log_in.controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> with TickerProviderStateMixin {
  final LogInController loginController = Get.find<LogInController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   TabController? tabController;
  final tabIndex = 0.obs;
  final role = 'user'.obs;

  @override
  void initState() {
    super.initState();
    // Initialize TabController and add null check
    try {
      tabController = TabController(length: 2, vsync: this);
      tabController?.addListener(() {
        if (!tabController!.indexIsChanging) {
          tabIndex.value = tabController!.index;
          role.value = tabIndex.value == 0 ? 'user' : 'customer';

        }
      });
    } catch (e) {
      print('Error initializing TabController: $e');
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController!.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    // Remove this line - use controller directly since you extend GetView

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
                    AppStrings.loginTitle.tr,
                    style: AppTextStyles.headLine6.copyWith(
                        color: Color(0xFFFFFFFF)),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppStrings.loginSubtitle.tr,
                    style: AppTextStyles.button,
                  ),
                  SizedBox(height: 30.h),

                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.grayDarker,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: GetBuilder<LogInController>(
                      builder: (controller) {
                        // Add null check for tabController
                        if (tabController == null) {
                          return SizedBox.shrink(); // or a loading widget
                        }

                        return TabBar(
                          controller: tabController,
                          onTap: changeTab,
                          labelPadding: EdgeInsets.zero,
                          indicatorColor: Colors.transparent,
                          indicatorWeight: 0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
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
                                child: Text(AppStrings.userTab.tr, style: AppTextStyles.button),
                              ),
                            ),
                            Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(AppStrings.customerTab.tr, style: AppTextStyles.button),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30.h),
                  CustomTextFormField(
                    validator: (value) => (value?.trim().isEmpty ?? true) ? AppStrings.enterEmailAddressValidation.tr : null,
                    controller: loginController.emailController,
                    hintText: AppStrings.emailHint.tr,
                    keyboardType: 'email',
                    prefixSvg: AppImages.emailIcon,
                  ),
                  SizedBox(height: 17.h),
                  CustomTextFormField(
                    validator: (value) => (value?.trim().isEmpty ?? true) ? AppStrings.enterPasswordValidation.tr : null,
                    controller: loginController.passwordController,
                    hintText: AppStrings.passwordHint.tr,
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
                          AppStrings.forgetPasswordButton.tr,
                          style: AppTextStyles.textCaption1.copyWith(
                            color: AppColors.primaryNormal,
                          ),
                        ),
                      ),
                    ),
                  ),

                 // Obx((){
                 //   return CustomButton(
                 //     loading: loginController.isLoading.value,
                 //     width: double.infinity,
                 //     onTap: () async {
                 //       // Add null check for form validation
                 //       if (_formKey.currentState?.validate() ?? false) {
                 //       await loginController.login();
                 //       }
                 //     },
                 //     text: "Log in",
                 //   );
                 // })
                  GetBuilder<LogInController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryLight,
                          ),
                        );
                      }
                      return PrimaryButton(
                        width: double.infinity,
                        onPressed: () async {
                          // Add null check for form validation
                          if (_formKey.currentState?.validate() ?? false) {
                           await controller.login();
                          }
                        },
                        text: AppStrings.loginButton.tr,
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
  @override
  void dispose() {
    tabController!.dispose();
    loginController.emailController.dispose();
    loginController.passwordController.dispose();
    super.dispose();
  }

}