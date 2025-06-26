import 'package:get/get.dart';

import '../../../infrastructure/utils/app_images.dart';

class SiteDetailsController extends GetxController {
  //TODO: Implement SiteDetailsController

  final count = 0.obs;
  final List<String> _images = [
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
    AppImages.chatPerson, // Replace with actual site images
  ];

  void increment() => count.value++;
}
