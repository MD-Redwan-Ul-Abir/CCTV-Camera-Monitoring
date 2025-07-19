import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus {
  connected,
  disconnected,
  unknown,
}

class NetworkConnectivity {
  static final NetworkConnectivity _instance = NetworkConnectivity._internal();
  factory NetworkConnectivity() => _instance;
  NetworkConnectivity._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final StreamController<NetworkStatus> _networkStatusController =
  StreamController<NetworkStatus>.broadcast();

  // Stream to listen to network status changes
  Stream<NetworkStatus> get onNetworkChanged => _networkStatusController.stream;

  /// Check if internet is available
  Future<bool> isInternetAvailable() async {
    try {
      final List<ConnectivityResult> connectivityResult =
      await _connectivity.checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      // Additional check with actual internet connectivity
      return await _hasInternetConnection();
    } catch (e) {
      return false;
    }
  }

  /// Get current network status
  Future<NetworkStatus> getNetworkStatus() async {
    try {
      final bool hasInternet = await isInternetAvailable();
      return hasInternet ? NetworkStatus.connected : NetworkStatus.disconnected;
    } catch (e) {
      return NetworkStatus.unknown;
    }
  }

  /// Get connectivity result details
  Future<List<ConnectivityResult>> getConnectivityResult() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return [ConnectivityResult.none];
    }
  }

  /// Get human-readable connectivity status
  Future<String> getConnectivityStatus() async {
    final List<ConnectivityResult> result = await getConnectivityResult();

    if (result.contains(ConnectivityResult.wifi)) {
      return 'WiFi Connected';
    } else if (result.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data Connected';
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet Connected';
    } else if (result.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth Connected';
    } else if (result.contains(ConnectivityResult.vpn)) {
      return 'VPN Connected';
    } else {
      return 'No Connection';
    }
  }

  /// Start monitoring network connectivity
  void startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> result) async {
        final NetworkStatus status = await getNetworkStatus();
        _networkStatusController.add(status);
      },
    );
  }

  /// Stop monitoring network connectivity
  void stopMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Actually test internet connection by making a request
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _networkStatusController.close();
  }
}

// Usage Example Class
class NetworkConnectivityExample {
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity();
  StreamSubscription<NetworkStatus>? _statusSubscription;

  void initializeNetworkMonitoring() {
    // Start monitoring
    _networkConnectivity.startMonitoring();

    // Listen to network status changes
    _statusSubscription = _networkConnectivity.onNetworkChanged.listen(
          (NetworkStatus status) {
        switch (status) {
          case NetworkStatus.connected:
            print('✅ Internet Connected');
            // Handle connected state
            break;
          case NetworkStatus.disconnected:
            print('❌ No Internet Connection');
            // Handle disconnected state
            break;
          case NetworkStatus.unknown:
            print('❓ Network Status Unknown');
            // Handle unknown state
            break;
        }
      },
    );
  }

  Future<void> checkConnectivityExample() async {
    // Check if internet is available
    final bool isConnected = await _networkConnectivity.isInternetAvailable();
    print('Is Connected: $isConnected');

    // Get network status
    final NetworkStatus status = await _networkConnectivity.getNetworkStatus();
    print('Network Status: $status');

    // Get connectivity details
    final List<ConnectivityResult> result =
    await _networkConnectivity.getConnectivityResult();
    print('Connectivity Result: $result');

    // Get human-readable status
    final String statusString = await _networkConnectivity.getConnectivityStatus();
    print('Connection Type: $statusString');
  }

  void dispose() {
    _statusSubscription?.cancel();
    _networkConnectivity.dispose();
  }
}