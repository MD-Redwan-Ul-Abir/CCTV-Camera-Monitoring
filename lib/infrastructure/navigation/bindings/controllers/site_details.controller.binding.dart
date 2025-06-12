import 'package:get/get.dart';

import '../../../../presentation/siteDetails/controllers/site_details.controller.dart';

class SiteDetailsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteDetailsController>(
      () => SiteDetailsController(),
    );
  }
}
