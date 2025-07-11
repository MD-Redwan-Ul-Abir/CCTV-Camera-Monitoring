import 'package:get/get.dart';

import '../../../../presentation/mainNavigationScreen/controllers/main_navigation_screen.controller.dart';
import '../../../../presentation/reportScreen/controllers/report_screen.controller.dart';
import '../../../../presentation/shared/widgets/imagePicker/imagePickerController.dart';

class MainNavigationScreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationScreenController>(
      () => MainNavigationScreenController(),
    );
    Get.lazyPut<imagePickerController>(
          () => imagePickerController(),
    );
    Get.lazyPut<ReportScreenController>(
          () => ReportScreenController(),
    );
  }
}
