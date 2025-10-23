import 'package:get/get.dart';

import '../../../../presentation/createReport/controllers/create_report.controller.dart';
import '../../../../presentation/detailsReport/controllers/details_report.controller.dart';
import '../../../../presentation/shared/widgets/imagePicker/imagePickerController.dart';

class DetailsReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsReportController>(
      () => DetailsReportController(),
    );
    Get.lazyPut<CreateReportController>(
          () => CreateReportController(),
    );
    Get.lazyPut<imagePickerController>(
          () => imagePickerController(),
    );
  }
}
