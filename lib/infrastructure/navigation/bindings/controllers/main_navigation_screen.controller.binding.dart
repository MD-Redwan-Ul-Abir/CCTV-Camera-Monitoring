import 'package:get/get.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';

import '../../../../presentation/mainNavigationScreen/controllers/main_navigation_screen.controller.dart';
import '../../../../presentation/profile/controllers/profile.controller.dart';
import '../../../../presentation/reportScreen/controllers/report_screen.controller.dart';
import '../../../../presentation/shared/widgets/imagePicker/imagePickerController.dart';
import '../../../utils/api_client.dart';

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
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
    Get.lazyPut<ApiClient>(
          () => ApiClient(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}
