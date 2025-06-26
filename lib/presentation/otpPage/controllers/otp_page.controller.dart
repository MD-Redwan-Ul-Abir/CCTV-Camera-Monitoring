import 'package:get/get.dart';

class OtpPageController extends GetxController {
  //TODO: Implement OtpPageController
  RxList<int?> pinValues = List<int?>.filled(6, null).obs;
  RxInt currentPinIndex = 0.obs;
  RxBool isPinComplete = false.obs;

  void addDigit(int digit) {
    if (currentPinIndex.value < pinValues.length) {
      pinValues[currentPinIndex.value] = digit;
      currentPinIndex.value++;

      isPinComplete.value = currentPinIndex.value == pinValues.length;
    }
  }

  void removeDigit() {
    if (currentPinIndex.value > 0) {
      currentPinIndex.value--;
      pinValues[currentPinIndex.value] = null;
      isPinComplete.value = false;
    }
  }




}
