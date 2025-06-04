import 'package:get/get.dart';

class SplashLanguageController extends GetxController {
  //TODO: Implement SplashLanguageController

  final count = 0.obs;

  // Observable variable to store the selected language
  var selectedLanguage = Rx<String?>('English');  // Default value set to 'English'

  // Method to update the selected language
  void updateSelectedLanguage(String? language) {
    selectedLanguage.value = language;
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
