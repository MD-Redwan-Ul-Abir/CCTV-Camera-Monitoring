import 'package:get/get.dart';

class PrivacySettingsController extends GetxController {
  //TODO: Implement PrivacySettingsController

  final count = 0.obs;
  RxDouble rating = 0.0.obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
