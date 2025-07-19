import 'package:get/get.dart';
import 'package:gif/gif.dart';
import 'package:skt_sikring/infrastructure/theme/app_colors.dart';

import '../../shared/widgets/customSnakBar.dart';
import '../../shared/widgets/networkStatus/globalNetworkService.dart';
import '../../shared/widgets/networkStatus/network.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../infrastructure/utils/secure_storage_helper.dart';

class NoInternetController extends GetxController with GetTickerProviderStateMixin  {
  late GifController gifController;

  final count = 0.obs;
  RxBool isConnected = false.obs;
  final NetworkConnectivity _connectivity = NetworkConnectivity();

  // Get the global network service
  final GlobalNetworkService _networkService = Get.find<GlobalNetworkService>();

  @override
  void onInit() {
    super.onInit();

    gifController = GifController(vsync: this);
    checkInitialConnectivity();
  }

  Future<void> checkInitialConnectivity() async {
    // Use the global service for consistency
    final bool connected = await _networkService.recheckConnectivity();
    isConnected.value = connected;
  }

  // Updated try again method
  Future<void> tryAgain() async {
    await checkInitialConnectivity();

    if (isConnected.value == true) {
      // Internet is back, navigate properly
      var storedData = await getStoredUserData();

      // Start global monitoring
      _networkService.startGlobalMonitoring();

      if (storedData['accessToken'] != '') {
        Get.offAllNamed(Routes.MAIN_NAVIGATION_SCREEN);
      } else {
        Get.offAllNamed(Routes.SPLASH_LANGUAGE);
      }
    } else {
      // Still no internet
      CustomSnackbar.show(
        title: "No Internet",
        message: "Try again later",
      );
    }
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

  @override
  void onClose() {
    // Dispose the GifController to prevent memory leaks
    gifController.dispose();
    super.onClose();
  }
}