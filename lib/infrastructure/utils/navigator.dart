import 'package:get/get.dart';

class MasterNavigator {
  /// Navigates to the specified route after a delay, removing all previous routes
  /// from the navigation stack.
  ///
  /// [delayInSeconds] - Time to wait before navigation (in seconds)
  /// [routeName] - Name of the route to navigate to (must be registered in Get)
  /// [arguments] - Optional arguments to pass to the route
  ///
  /// Throws an error if the route name is not registered
  static void navigateAfterDelay({
    required int delayInSeconds,
    required String routeName,
    dynamic arguments,
  }) {
    Future.delayed(
      Duration(seconds: delayInSeconds),
      () => Get.offAllNamed(routeName, arguments: arguments),
    );
  }

  static void navigate({required String routeName, dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  static void navigateAndRemove({
    required String routeName,
    dynamic arguments,
  }) {
    Get.offAllNamed(routeName, arguments: arguments);
  }
}
