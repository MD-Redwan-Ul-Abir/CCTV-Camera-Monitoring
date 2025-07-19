import 'package:get/get.dart';
import 'dart:async';

import '../../../../infrastructure/navigation/routes.dart';
import 'network.dart';


class GlobalNetworkService extends GetxService {
  static GlobalNetworkService get to => Get.find();

  final NetworkConnectivity _connectivity = NetworkConnectivity();
  StreamSubscription<NetworkStatus>? _statusSubscription;

  final RxBool isConnected = true.obs;
  final RxBool isMonitoring = false.obs;

  // List of routes where we should NOT show no internet screen
  final List<String> _excludedRoutes = [
    Routes.NO_INTERNET,
    Routes.SPLASH_SCREEN, // Don't interfere with splash screen logic
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeNetworkMonitoring();
  }

  void _initializeNetworkMonitoring() {
    // Start monitoring network changes
    _connectivity.startMonitoring();

    // Listen to network status changes
    _statusSubscription = _connectivity.onNetworkChanged.listen(
          (NetworkStatus status) {
        _handleNetworkStatusChange(status);
      },
    );
  }

  void _handleNetworkStatusChange(NetworkStatus status) {
    final wasConnected = isConnected.value;
    final nowConnected = status == NetworkStatus.connected;

    isConnected.value = nowConnected;

    print('Network status changed: wasConnected=$wasConnected, nowConnected=$nowConnected, currentRoute=${Get.currentRoute}');

    // If we lost connection and we're not already on excluded routes
    if (wasConnected && !nowConnected && _shouldShowNoInternet()) {
      print('Navigating to no internet screen');
      Get.toNamed(Routes.NO_INTERNET);
    }

    // If we regained connection and we're on the no internet screen
    if (!wasConnected && nowConnected && Get.currentRoute == Routes.NO_INTERNET) {
      print('Internet restored, going back');
      Get.back();
    }
  }

  bool _shouldShowNoInternet() {
    final currentRoute = Get.currentRoute;
    return !_excludedRoutes.contains(currentRoute) && isMonitoring.value;
  }

  // Call this after splash screen completes
  void startGlobalMonitoring() {
    print('Starting global network monitoring');
    isMonitoring.value = true;
  }

  // Call this when you want to stop monitoring (e.g., on logout)
  void stopGlobalMonitoring() {
    print('Stopping global network monitoring');
    isMonitoring.value = false;
  }

  // Check initial connectivity (for splash screen)
  Future<bool> checkInitialConnectivity() async {
    final connected = await _connectivity.isInternetAvailable();
    isConnected.value = connected;
    print('Initial connectivity check: $connected');
    return connected;
  }

  // Method to manually check connectivity (for try again functionality)
  Future<bool> recheckConnectivity() async {
    final connected = await _connectivity.isInternetAvailable();
    isConnected.value = connected;
    return connected;
  }

  @override
  void onClose() {
    _statusSubscription?.cancel();
    _connectivity.dispose();
    super.onClose();
  }
}