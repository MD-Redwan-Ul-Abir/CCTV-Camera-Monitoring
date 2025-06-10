import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/message/message_screen.screen.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
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
      name: Routes.SIGN_UP_PAGE,
      page: () => const SignUpPageScreen(),
      binding: SignUpPageControllerBinding(),
    ),
    GetPage(
      name: Routes.CUSTOM_SUCCESS_MASSEGE,
      page: () => const CustomSuccessMassegeScreen(),
      binding: CustomSuccessMassegeControllerBinding(),
    ),
    GetPage(
      name: Routes.DETAILS_REPORT,
      page: () => const DetailsReportScreen(),
      binding: DetailsReportControllerBinding(),
    ),
    GetPage(
      name: Routes.MAIN_NAVIGATION_SCREEN,
      page: () => const MainNavigationScreenScreen(),
      binding: MainNavigationScreenControllerBinding(),
    ),
    GetPage(
      name: Routes.MESSAGE_SCREEN,
      page: () => const MessageScreen(),
      binding: MessageScreenControllerBinding(),
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
  ];
}
