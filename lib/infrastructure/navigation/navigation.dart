import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/auth/customSuccessMassege/custom_success_massege.screen.dart';
import '../../presentation/languageChanging/language_screen.dart';

import '../../presentation/messaging/message/message_screen.screen.dart';
import '../../presentation/screens.dart';
import '../../presentation/shared/widgets/imagePicker/imagePickerController.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  const EnvironmentsBadge({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASH_LANGUAGE,
      page: () => const SplashLanguageScreen(),
      //page: () => const LanguageScreen(),

      binding: SplashLanguageControllerBinding(),
    ),
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => const SplashScreenScreen(),
      binding: SplashScreenControllerBinding(),
    ),
    GetPage(
      name: Routes.LOG_IN,
      page: () => const LogInScreen(),
      binding: LogInControllerBinding(),
    ),
    GetPage(
      name: Routes.OTP_PAGE,
      page: () => const OtpPageScreen(),
      binding: OtpPageControllerBinding(),
    ),
    GetPage(
      name: Routes.FORGET_PASSWORD,
      page: () => const ForgetPasswordScreen(),
      binding: ForgetPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordControllerBinding(),
    ),
    GetPage(
      name: Routes.CUSTOM_SUCCESS_MASSEGE,
      page: () => const CustomSuccessMassegeScreen(),
      binding: CustomSuccessMassegeControllerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.DETAILS_REPORT,
      page: () => const DetailsReportScreen(),
      binding: DetailsReportControllerBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION_SCREEN,
      page: () => const MainNavigationScreenScreen(),
      //binding: MainNavigationScreenControllerBinding(),
      bindings: [
        MainNavigationScreenControllerBinding(),
        BindingsBuilder(() {
          Get.lazyPut<imagePickerController>(() => imagePickerController());
        }),
      ],
    ),
    GetPage(
      name: Routes.MESSAGE_SCREEN,
      page: () => const MessageScreen(),
      binding: MessageScreenControllerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.REPORT_SCREEN,
      page: () => const ReportScreen(),
      binding: ReportScreenControllerBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileControllerBinding(),
    ),
    GetPage(
      name: Routes.CONVERSATION_PAGE,
      page: () => const ConversationPageScreen(),
      binding: ConversationPageControllerBinding(),
    ),
    GetPage(
      name: Routes.SITE_DETAILS,
      page: () => const SiteDetailsScreen(),
      binding: SiteDetailsControllerBinding(),
    ),
    GetPage(
      name: Routes.LIVE_VIEW,
      page: () => const LiveViewScreen(),
      binding: LiveViewControllerBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordControllerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.PRIVACY_SETTINGS,
      page: () => const PrivacySettingsScreen(),
      binding: PrivacySettingsControllerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.CUSTOM_PRIVACY_POLICY,
      page: () => const CustomPrivacyPolicyScreen(),
      binding: CustomPrivacyPolicyControllerBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.CREATE_REPORT,
      page: () => const CreateReportScreen(),
      binding: CreateReportControllerBinding(),
    ),
    GetPage(
      name: Routes.ERROR_PAGE,
      page: () => const ErrorPageScreen(),
      binding: ErrorPageControllerBinding(),
    ),
    GetPage(
      name: Routes.NO_INTERNET,
      page: () => const NoInternetScreen(),
      binding: NoInternetControllerBinding(),
    ),
  ];
}
