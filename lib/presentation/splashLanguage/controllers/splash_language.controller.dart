import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../languageChanging/appString.dart';

class SplashLanguageController extends GetxController {
  final count = 0.obs;

  // Observable variable to store the selected language
  var selectedLanguage = Rx<String?>(AppStrings.english); // Default value set to 'english'

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }


  Future<void> loadSavedLanguage() async {
    try {
      final localizationController = Get.find<LocalizationController>();

      // The LocalizationController already loads the saved language in its loadCurrentLanguage method
      // We just need to get the current locale and find the corresponding language name
      final currentLocale = localizationController.locale;

      for (var language in AppConstants.languages) {
        if (language.languageCode == currentLocale.languageCode &&
            language.countryCode == currentLocale.countryCode) {
          selectedLanguage.value = language.languageName;
          break;
        }
      }
    } catch (e) {
      print("Error loading saved language: $e");
      // Keep default English if error occurs
      selectedLanguage.value = AppConstants.languages[0].languageName;
    }
  }

  // Method to update the selected language
  void updateSelectedLanguage(String? language) {
    selectedLanguage.value = language;
  }

  Future<void> saveLanguageAndNavigate() async {
    final localizationController = Get.find<LocalizationController>();
    final selected = selectedLanguage.value;

    if (selected != null) {
      // Find and set the locale
      for (int index = 0; index < AppConstants.languages.length; index++) {
        var language = AppConstants.languages[index];
        if (language.languageName == selected) {
          // Use the LocalizationController's setLanguage method which handles saving
          localizationController.setLanguage(
              Locale(language.languageCode, language.countryCode)
          );
          // Also update the selected index
          localizationController.setSelectIndex(index);
          break;
        }
      }
    }

    // Navigate to login screen and clear the splash language route from stack
    Get.offAllNamed(Routes.LOG_IN);
  }

  void increment() => count.value++;
}