import 'package:get/get.dart';

import '../../../../presentation/reportScreen/controllers/report_screen.controller.dart';

class ReportScreenControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportScreenController>(
      () => ReportScreenController(),
    );
  }
}
