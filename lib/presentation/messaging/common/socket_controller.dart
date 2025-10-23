import 'dart:async';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:skt_sikring/infrastructure/utils/api_content.dart';
import 'package:skt_sikring/infrastructure/utils/log_helper.dart';
import 'package:skt_sikring/infrastructure/utils/secure_storage_helper.dart';

class SocketController extends GetxController {
  static SocketController get instance => Get.put(SocketController(), permanent: false);

  IO.Socket? _socket;
  IO.Socket? get socket => _socket;

  final RxBool isSocketConnected = false.obs;
  final RxString socketStatus = 'disconnected'.obs;
  final RxBool isConnecting = false.obs;


  String token = '' ;
  String userId = '' ;

  String _currentScreen = '';
  bool _isInMessagingFlow = false;


  Future<void> initializeUserData() async {
    if(token ==''|| userId ==''){
      try {
        token  = await SecureStorageHelper.getString('accessToken');
        userId  = await SecureStorageHelper.getString('id');
        LoggerHelper.warn('socket is trying to connect');
         connectSocket();
        LoggerHelper.warn('socket is connected');
        print("token for socket connection ===================>$token" );
        print("User ID for socket connection ===================>$userId");
      } catch (e) {
        LoggerHelper.error('Error initializing user data: $e');
      }
    }
  }

  // Connect to socket
  Future<void> connectSocket() async {
      if (isConnecting.value || isSocketConnected.value) return;

    isConnecting.value = true;
    socketStatus.value = 'connecting';

    try {
      // Ensure we have token and userId
      if (token .isEmpty || userId .isEmpty) {
        await initializeUserData();
      }

      if (token .isEmpty) {
        LoggerHelper.error('No token available for socket connection');
        isConnecting.value = false;
        socketStatus.value = 'error';
        return;
      }

      // Configure socket with proper timeout and connection options
      _socket = IO.io(ApiConstants.socketUrl, <String, dynamic>{
        'transports': ['websocket'], // Prioritize websocket transport
        'autoConnect': false,
        'forceNew': true,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 2000,
        'timeout': 20000, // 20 seconds timeout
        'extraHeaders': {'token': token},
        'query': 'token=$token' // Also send token as query parameter
      });

      // Setup event listeners
      _setupSocketListeners();

      // Connect to the socket
      // Connect to the socket with timeout handling
      _connectWithTimeout();

    } catch (e) {
      LoggerHelper.error('Error connecting to socket: $e');
      isSocketConnected.value = false;
      socketStatus.value = 'error';
      isConnecting.value = false;
    }

  }

  // Connect with timeout handling
  void _connectWithTimeout() {
    final timeoutDuration = Duration(seconds: 20); // 20 seconds timeout
    Timer? timeoutTimer;

    bool hasCompleted = false;

    void completeConnection() {
      if (!hasCompleted) {
        hasCompleted = true;
        timeoutTimer?.cancel();
      }
    }

    // Set up timeout
    timeoutTimer = Timer(timeoutDuration, () {
      if (!hasCompleted) {
        LoggerHelper.error('Socket connection timeout after ${timeoutDuration.inSeconds} seconds');
        disconnectSocket();
        isSocketConnected.value = false;
        socketStatus.value = 'error';
        isConnecting.value = false;
      }
    });

    // Connect to socket
    _socket?.connect();

    // After connecting, clear the timeout
    _socket?.onConnect((_) {
      completeConnection();
    });

    _socket?.onConnectError((error) {
      completeConnection();
    });
  }

  void _setupSocketListeners() {

    _socket?.onConnect((_) {
      LoggerHelper.info('==== Connected to server ====');
      isSocketConnected.value = true;
      socketStatus.value = 'connected';
      isConnecting.value = false;
    });

    _socket?.onDisconnect((_) {
      LoggerHelper.info('==== Disconnected from server ====');
      isSocketConnected.value = false;
      socketStatus.value = 'disconnected';
      isConnecting.value = false;
    });

    _socket?.onConnectError((error) {
      LoggerHelper.error('Socket connection error: $error');
      isSocketConnected.value = false;
      socketStatus.value = 'error';
      isConnecting.value = false;
    });

    _socket?.onError((error) {
      LoggerHelper.error('Socket error: $error');
      isSocketConnected.value = false;
      socketStatus.value = 'error';
      isConnecting.value = false;
    });
  }

  // Disconnect socket
  void disconnectSocket() {
    if (_socket != null) {

      _socket?.disconnect();

      _socket?.clearListeners();
      _socket?.dispose();
      _socket = null;
      isSocketConnected.value = false;
      socketStatus.value = 'disconnected';
      isConnecting.value = false;
    }
  }

  // Clear all user-specific data (call on logout)
  void clearUserData() {
    disconnectSocket();
    token  = '';
    userId  = '';
    _currentScreen = '';
    _isInMessagingFlow = false;
  }

  // Reset controller state completely
  void resetController() {
    clearUserData();
    isSocketConnected.value = false;
    socketStatus.value = 'disconnected';
    isConnecting.value = false;
  }

  // Complete logout cleanup - resets everything
  void performLogoutCleanup() {
    LoggerHelper.info('Performing complete socket logout cleanup');

    if (_socket != null) {

      _socket?.clearListeners();
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
    }
    

    token  = '';
    userId  = '';
    isSocketConnected.value = false;
    socketStatus.value = 'disconnected';
    isConnecting.value = false;
    _currentScreen = '';
    _isInMessagingFlow = false;
    
    LoggerHelper.info('Socket logout cleanup completed');
  }

  // Enter messaging flow (from message screen)
  void enterMessagingFlow(String screenName) {
    _currentScreen = screenName;
    _isInMessagingFlow = true;

    if (!isSocketConnected.value && !isConnecting.value) {
      LoggerHelper.warn('Socket not connected in messaging flow, attempting to reconnect');
      connectSocket();
    }
  }

  // Leave messaging flow
  void leaveMessagingFlow(String fromScreen, {String? toScreen}) {
    _currentScreen = toScreen ?? '';

    if (fromScreen == 'MessageScreen' && toScreen == 'ConversationPage') {
      LoggerHelper.info('Staying in messaging flow: MessageScreen -> ConversationPage');
      return;
    }

    if (fromScreen == 'ConversationPage' && toScreen == 'MessageScreen') {
      LoggerHelper.info('Staying in messaging flow: ConversationPage -> MessageScreen');
      return;
    }


    if (fromScreen == 'MessageScreen' || fromScreen == 'ConversationPage') {
      LoggerHelper.info('Leaving messaging flow from $fromScreen to $toScreen');
      _isInMessagingFlow = false;
     // disconnectSocket();
    }
  }


  bool get isInMessagingFlow => _isInMessagingFlow;


  String get currentScreen => _currentScreen;


  void emitWithAck(String event, dynamic data, {Function(dynamic)? ack}) {
    if (_socket != null && isSocketConnected.value) {
      _socket!.emitWithAck(event, data, ack: ack);
    } else {
      LoggerHelper.error('Socket not connected. Cannot emit event: $event');

      if (_isInMessagingFlow) {
        connectSocket().then((_) {
          if (isSocketConnected.value) {
            _socket!.emitWithAck(event, data, ack: ack);
          }
        });
      }
    }
  }

  // Listen to events
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  // Remove listener
  void off(String event) {
    _socket?.off(event);
  }

  // Retry connection
  void retryConnection() {
    if (!isSocketConnected.value && !isConnecting.value && _isInMessagingFlow) {
      connectSocket();
    }
  }

  @override
  void onClose() {
    disconnectSocket();
    performLogoutCleanup();
    super.onClose();
  }
}