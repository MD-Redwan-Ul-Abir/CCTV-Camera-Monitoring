// nav_controller.dart
import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
