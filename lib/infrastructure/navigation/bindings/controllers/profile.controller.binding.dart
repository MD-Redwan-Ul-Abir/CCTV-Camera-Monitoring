import 'package:get/get.dart';

import '../../../../presentation/profile/controllers/profile.controller.dart';
import '../../../../presentation/shared/widgets/imagePicker/imagePickerController.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<imagePickerController>(
          () => imagePickerController(),
    );
  }
}
