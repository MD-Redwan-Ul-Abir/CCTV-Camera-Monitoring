import 'package:get/get.dart';
import 'package:skt_sikring/presentation/home/controllers/home.controller.dart';

import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';
import '../../shared/widgets/networkStatus/globalNetworkService.dart';
import '../../shared/widgets/networkStatus/network.dart';


class SplashScreenController extends GetxController {


  final count = 0.obs;
  RxBool isConnected = false.obs;
  final NetworkConnectivity connectivity = NetworkConnectivity();

  // Get the global network service
  final GlobalNetworkService _networkService = Get.find<GlobalNetworkService>();

  Future<void> checkInitialConnectivity() async {
    // Use the global service for consistency
    final bool connected = await _networkService.checkInitialConnectivity();
    isConnected.value = connected;
  }

  void startSplashTimer() {
    Future.delayed(Duration(seconds: 3), () async {
      // Navigate to next page, replace '/next' with your route
      // var token = await SecureStorageHelper.getString("accessToken");
      //final HomeController homeController = Get.find<HomeController>();
      if(isConnected.value==true){
        var storedData = await getStoredUserData();

        if(storedData['accessToken']!=''){
          // Start global monitoring before navigating to main app
          _networkService.startGlobalMonitoring();
          Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
        }else{
          // Start global monitoring before navigating to language selection
          _networkService.startGlobalMonitoring();
          Get.offNamed(Routes.SPLASH_LANGUAGE);
        }
      }else{
        Get.toNamed(Routes.NO_INTERNET);
      }
    });
  }

  Future<Map<String, dynamic>> getStoredUserData() async {
    try {
      return {
        'accessToken': await SecureStorageHelper.getString("accessToken") ?? '',
      };
    } catch (e) {
      print("Error retrieving stored user data: $e");
      return {'accessToken': ''};
    }
  }

  void increment() => count.value++;
}