import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skt_sikring/presentation/languageChanging/localizationController.dart';
import 'package:skt_sikring/presentation/languageChanging/appConst.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/networkStatus/globalNetworkService.dart';
import '../../shared/widgets/networkStatus/network.dart';

class SplashScreenController extends GetxController {
  final count = 0.obs;
  RxBool isConnected = false.obs;
  final NetworkConnectivity connectivity = NetworkConnectivity();


  final GlobalNetworkService _networkService = Get.find<GlobalNetworkService>();

  Future<void> checkInitialConnectivity() async {

    final bool connected = await _networkService.checkInitialConnectivity();
    isConnected.value = connected;
  }

  // Initialize language using the existing LocalizationController
  Future<void> initializeLanguage() async {
    try {
      final LocalizationController localizationController = Get.find<LocalizationController>();
      localizationController.loadCurrentLanguage();

      print("Language initialized with locale: ${localizationController.locale}");

    } catch (e) {
      print("Error initializing language: $e");
      // The LocalizationController should handle fallback to default language
    }
  }

  void startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () async {
      // Initialize language first
      await initializeLanguage();
      
      if (isConnected.value == true) {
        var storedData = await getStoredUserData();
        String? language = await SecureStorageHelper.getNullableString(AppConstants.LANGUAGE_CODE);

        if (storedData['accessToken'] != null && storedData['accessToken'] != '') {
          // User is logged in, go to main screen
          _networkService.startGlobalMonitoring();
          Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
        }
        else if (language != null && language.isNotEmpty) {
          // Language is selected but not logged in, go to login
          _networkService.startGlobalMonitoring();
          Get.offAllNamed(Routes.LOG_IN);
        }
        else {
          // No language selected, go to language selection screen
          _networkService.startGlobalMonitoring();
          Get.offAllNamed(Routes.SPLASH_LANGUAGE);
        }
      } else {
        Get.toNamed(Routes.NO_INTERNET);
      }
    });
  }

  Future<Map<String, dynamic>> getStoredUserData() async {
    try {
      return {
        'accessToken': await SecureStorageHelper.getString("accessToken"),
      };
    } catch (e) {
      print("Error retrieving stored user data: $e");
      return {'accessToken': ''};
    }
  }

  void increment() => count.value++;
}