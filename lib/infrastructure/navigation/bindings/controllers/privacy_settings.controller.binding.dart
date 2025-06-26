import 'package:get/get.dart';

import '../../../../presentation/privacySettings/controllers/privacy_settings.controller.dart';

class PrivacySettingsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacySettingsController>(
      () => PrivacySettingsController(),
    );
  }
}
