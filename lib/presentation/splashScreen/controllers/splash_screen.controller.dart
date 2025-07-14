import 'package:get/get.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  final count = 0.obs;

  void startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () async {
      // Navigate to next page, replace '/next' with your route
      // var token = await SecureStorageHelper.getString("accessToken");
      //final HomeController homeController = Get.find<HomeController>();
      var storedData = await getStoredUserData();

      if(storedData['accessToken']!=''){

        await Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
      }else{
        await Get.offNamed(Routes.SPLASH_LANGUAGE);
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
      return {};
    }
  }


  void increment() => count.value++;
}
