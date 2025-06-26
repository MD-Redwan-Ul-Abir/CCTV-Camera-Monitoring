import 'package:get/get.dart';

import '../../../../presentation/createReport/controllers/create_report.controller.dart';
import '../../../../presentation/shared/widgets/imagePicker/imagePickerController.dart';

class CreateReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateReportController>(
      () => CreateReportController(),
    );
    Get.lazyPut<imagePickerController>(
      () => imagePickerController(),
    );
  }
}
