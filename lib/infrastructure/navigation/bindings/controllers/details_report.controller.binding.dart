import 'package:get/get.dart';

import '../../../../presentation/detailsReport/controllers/details_report.controller.dart';

class DetailsReportControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsReportController>(
      () => DetailsReportController(),
    );
  }
}
