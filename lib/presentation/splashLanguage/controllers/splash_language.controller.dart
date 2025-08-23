import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';

import '../../../infrastructure/navigation/routes.dart';

class SplashLanguageController extends GetxController {
  //TODO: Implement SplashLanguageController

  final count = 0.obs;

  // Observable variable to store the selected language
  var selectedLanguage = Rx<String?>('English'); // Default value set to 'English'

  // Method to update the selected language
  void updateSelectedLanguage(String? language) {
    selectedLanguage.value = language;
  }

  void saveLanguageAndNavigate() {
    final localizationController = Get.find<LocalizationController>();
    final selected = selectedLanguage.value;
    if (selected != null) {
      for (var language in AppConstants.languages) {
        if (language.languageName == selected) {
          localizationController
              .setLanguage(Locale(language.languageCode, language.countryCode));
          break;
        }
      }
    }
    Get.toNamed(Routes.LOG_IN);
  }

  void increment() => count.value++;
}