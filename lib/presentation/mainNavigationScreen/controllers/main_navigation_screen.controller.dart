import 'package:get/get.dart';

class MainNavigationScreenController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }




  // void increment() => count.value++;
}
