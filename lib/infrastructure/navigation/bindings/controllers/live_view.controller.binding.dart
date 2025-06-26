import 'package:get/get.dart';

import '../../../../presentation/liveView/controllers/live_view.controller.dart';

class LiveViewControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveViewController>(
      () => LiveViewController(),
    );
  }
}
