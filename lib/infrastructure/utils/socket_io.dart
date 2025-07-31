import 'dart:async';
import 'dart:io';
import 'package:skt_sikring/infrastructure/utils/api_content.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SocketStatus { disconnected, connecting, connected, reconnecting, error }

/// Merged SocketApi combining simplicity with robustness
class SocketApi {
  // Singleton pattern - Factory constructor
  factory SocketApi() => _socketApi;

  // Private constructor
  SocketApi._internal();

  static final SocketApi _socketApi = SocketApi._internal();

  // Core socket instance
  static IO.Socket? _socket;

  // State management
  static SocketStatus _status = SocketStatus.disconnected;
  static Timer? _heartbeatTimer;
  static Timer? _reconnectTimer;
  static int _reconnectAttempts = 0;
  static String _currentEvent = '';

  // Configuration
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 3);
  static const Duration heartbeatInterval = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);

  // Event handlers storage
  static final Map<String, Function(dynamic)> _eventHandlers = {};
  static final Map<String, StreamController<dynamic>> _eventStreams = {};

  // Getters for status monitoring
  static SocketStatus get status => _status;
  static bool get isConnected => _socket?.connected ?? false;
  static String get currentEvent => _currentEvent;
  static int get reconnectAttempts => _reconnectAttempts;

  /// Initialize socket with enhanced configuration
  // Add these fixes to your socket_io.dart file

  /// Enhanced initialization with better error handling
  static Future<bool> init({
    String? serverUrl,
    String? token,
    String? eventName,
    Map<String, dynamic>? query,
  }) async {
    try {
      debugPrint('=============> Socket initialization started');

      // Validate required parameters
      if (token == null || token.isEmpty) {
        debugPrint('=============> Error: Token is required for socket connection');
        return false;
      }

      final url = serverUrl ?? ApiConstants.socketUrl;
      if (url.isEmpty) {
        debugPrint('=============> Error: Socket URL is required');
        return false;
      }

      debugPrint('=============> Connecting to: $url');
      debugPrint('=============> Token provided: ${token.substring(0, 20)}...');

      _status = SocketStatus.connecting;
      _currentEvent = eventName ?? '';

      // Create socket if not exists or if URL changed
      if (_socket == null || serverUrl != null) {
        await _createSocket(
          serverUrl: url,
          token: token,
          query: query,
        );
      }

      if (!_socket!.connected) {
        return await _connectWithTimeout();
      } else {
        debugPrint('Socket instance already connected');
        _status = SocketStatus.connected;
        return true;
      }
    } catch (e) {
      debugPrint('Socket initialization error: $e');
      _status = SocketStatus.error;
      return false;
    }
  }

  /// Enhanced socket creation with better configuration
  /// Enhanced socket creation with token in headers
  static Future<void> _createSocket({
    required String serverUrl,
    String? token,
    Map<String, dynamic>? query,
  }) async {
    // Cleanup existing socket
    await _cleanup(disposeSocket: true);

    // Prepare query parameters (without token)
    final queryParams = <String, dynamic>{};
    if (query != null) queryParams.addAll(query);

    // Prepare headers with token
    final headers = <String, dynamic>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
      // Or use custom header:
      // headers['x-auth-token'] = token;
    }

    debugPrint('=============> Creating socket with headers: ${headers.keys}');
    debugPrint('=============> Query params: $queryParams');

    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .setTimeout(15000)
          .setReconnectionDelay(3000)
          .setReconnectionDelayMax(10000)
          .setReconnectionDelayMax(3)
          .enableForceNew()
          .setQuery(queryParams)           // Query without token
          .setExtraHeaders(headers)        // Token in headers
          .build(),
    );

    _setupSocketListeners();
  }
  /// Setup core socket event listeners
  static void _setupSocketListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      debugPrint('===============> Socket Connected');
      _status = SocketStatus.connected;
      _reconnectAttempts = 0;
      _startHeartbeat();
    });

    _socket!.onDisconnect((_) {
      debugPrint('===============> Socket Disconnected');
      _status = SocketStatus.disconnected;
      _stopHeartbeat();

      // Auto-reconnect if not manually disconnected
      if (_currentEvent.isNotEmpty && _reconnectAttempts < maxReconnectAttempts) {
        _scheduleReconnect();
      }
    });

    _socket!.onConnectError((error) {
      debugPrint('===============> Socket Connection Error: $error');
      _status = SocketStatus.error;
      if (_reconnectAttempts < maxReconnectAttempts) {
        _scheduleReconnect();
      }
    });

    _socket!.onError((error) {
      debugPrint('===============> Socket Error: $error');
    });

    // Handle reconnection events
    _socket!.onReconnect((_) {
      debugPrint('===============> Socket Reconnected');
      _status = SocketStatus.connected;
      _reconnectAttempts = 0;
    });
  }
  /// Enhanced connection with better timeout handling
  static Future<bool> _connectWithTimeout() async {
    final completer = Completer<bool>();
    Timer? timeoutTimer;
    bool hasCompleted = false;

    void complete(bool result) {
      if (!hasCompleted) {
        hasCompleted = true;
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      }
    }

    void onConnected() {
      debugPrint('===============> Socket Connected Successfully');
      complete(true);
    }

    void onError(dynamic error) {
      debugPrint('===============> Socket Connection Error: $error');
      complete(false);
    }

    void onTimeout() {
      debugPrint('===============> Socket Connection Timeout (15s)');
      complete(false);
    }

    // Setup one-time listeners
    _socket!.onConnect((_) => onConnected());
    _socket!.onConnectError((error) => onError(error));
    _socket!.onError((error) => onError(error));

    // Set timeout (15 seconds)
    timeoutTimer = Timer(const Duration(seconds: 15), onTimeout);

    try {
      // Attempt connection
      debugPrint('===============> Attempting socket connection...');
      _socket!.connect();
    } catch (e) {
      debugPrint('===============> Socket connect() error: $e');
      complete(false);
    }

    return await completer.future;
  }

  /// Add network connectivity check
  static Future<bool> checkNetworkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Enhanced initialization with network check
  static Future<bool> initWithNetworkCheck({
    String? serverUrl,
    String? token,
    String? eventName,
    Map<String, dynamic>? query,
  }) async {
    // Check network connectivity first
    bool hasNetwork = await checkNetworkConnectivity();
    if (!hasNetwork) {
      debugPrint('=============> No network connectivity detected');
      _status = SocketStatus.error;
      return false;
    }

    return await init(
      serverUrl: serverUrl,
      token: token,
      eventName: eventName,
      query: query,
    );
  }

  /// Add method to get detailed connection status
  static Map<String, dynamic> getDetailedStatus() {
    return {
      'status': _status.toString(),
      'isConnected': isConnected,
      'socketConnected': _socket?.connected ?? false,
      'socketId': _socket?.id,
      'currentEvent': _currentEvent,
      'reconnectAttempts': _reconnectAttempts,
      'maxReconnectAttempts': maxReconnectAttempts,
      'activeHandlers': _eventHandlers.keys.toList(),
      'hasSocket': _socket != null,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  /// Smart reconnection with exponential backoff
  static void _scheduleReconnect() {
    if (_reconnectTimer?.isActive == true) return;

    _status = SocketStatus.reconnecting;
    _reconnectAttempts++;

    final delay = Duration(
      seconds: reconnectDelay.inSeconds * _reconnectAttempts,
    );

    debugPrint('===============> Scheduling reconnect attempt $_reconnectAttempts/$maxReconnectAttempts in ${delay.inSeconds}s');

    _reconnectTimer = Timer(delay, () async {
      if (_currentEvent.isNotEmpty) {
        final success = await init(eventName: _currentEvent);
        if (!success && _reconnectAttempts < maxReconnectAttempts) {
          _scheduleReconnect();
        }
      }
    });
  }

  /// Start heartbeat to maintain connection
  static void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (timer) {
      if (_socket?.connected == true) {
        _socket!.emit('ping');
      } else {
        timer.cancel();
      }
    });
  }

  /// Stop heartbeat timer
  static void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  ///<------------------------- Enhanced Emit With Ack ---------------->
  static Future<dynamic> emitWithAck(
      String event,
      dynamic body, {
        Duration timeout = const Duration(seconds: 10),
      }) async {
    if (!isConnected) {
      debugPrint('===========> Cannot emit: Socket not connected');
      throw SocketException('Socket not connected');
    }

    try {
      final completer = Completer<dynamic>();
      Timer? timeoutTimer;

      // Set timeout
      timeoutTimer = Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('Emit acknowledgment timeout', timeout));
        }
      });

      _socket!.emitWithAck(event, body, ack: (data) {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          debugPrint('===========> Emit With Ack Response: $data');
          completer.complete(data ?? 'ack_received');
        }
      });

      return await completer.future;
    } catch (e) {
      debugPrint('===========> Emit With Ack Error: $e');
      rethrow;
    }
  }

  ///<------------------------- Enhanced Emit ---------------->
  static bool emit(String event, dynamic body) {
    if (!isConnected) {
      debugPrint('===========> Cannot emit: Socket not connected');
      return false;
    }

    try {
      _socket!.emit(event, body);
      debugPrint('===========> Emit Success: $event');
      return true;
    } catch (e) {
      debugPrint('===========> Emit Error: $e');
      return false;
    }
  }

  ///<------------------------- Enhanced Event Listening ---------------->
  static void onEvent(String eventName, Function(dynamic) callback) {
    if (_socket == null) {
      debugPrint('===========> Cannot listen: Socket not initialized');
      return;
    }

    // Store handler for cleanup
    _eventHandlers[eventName] = callback;

    _socket!.on(eventName, (data) {
      try {
        debugPrint('===========> Event Received: $eventName');
        callback(data);
      } catch (e) {
        debugPrint('===========> Event Handler Error: $e');
      }
    });
  }

  /// Remove specific event listener
  static void offEvent(String eventName) {
    _socket?.off(eventName);
    _eventHandlers.remove(eventName);
    debugPrint('===========> Event Listener Removed: $eventName');
  }

  /// Get reactive stream for an event (GetX integration)
  static Stream<dynamic> getEventStream(String eventName) {
    if (!_eventStreams.containsKey(eventName)) {
      _eventStreams[eventName] = StreamController<dynamic>.broadcast();

      onEvent(eventName, (data) {
        if (!_eventStreams[eventName]!.isClosed) {
          _eventStreams[eventName]!.add(data);
        }
      });
    }

    return _eventStreams[eventName]!.stream;
  }

  ///<------------------------- Connection Management ---------------->
  /// Force reconnect
  static Future<bool> forceReconnect() async {
    debugPrint('===============> Force Reconnecting...');
    final currentEventBackup = _currentEvent;

    await disconnect();

    if (currentEventBackup.isNotEmpty) {
      return await init(eventName: currentEventBackup);
    }
    return await init();
  }

  /// Disconnect socket
  static Future<void> disconnect() async {
    debugPrint('===============> Socket Disconnecting...');
    _status = SocketStatus.disconnected;
    _currentEvent = '';

    await _cleanup(disposeSocket: false);

    if (_socket?.connected == true) {
      _socket!.disconnect();
    }

    debugPrint('===============> Socket Disconnected');
  }

  /// Dispose socket completely
  static Future<void> dispose() async {
    debugPrint('===============> Socket Disposing...');
    await _cleanup(disposeSocket: true);
    debugPrint('===============> Socket Disposed');
  }

  /// Internal cleanup method
  static Future<void> _cleanup({required bool disposeSocket}) async {
    // Cancel timers
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    // Clear handlers
    _eventHandlers.clear();

    // Close streams
    for (final stream in _eventStreams.values) {
      if (!stream.isClosed) {
        await stream.close();
      }
    }
    _eventStreams.clear();

    // Reset counters
    _reconnectAttempts = 0;

    if (disposeSocket && _socket != null) {
      try {
        _socket!.clearListeners();
        _socket!.dispose();
      } catch (e) {
        debugPrint('Socket disposal error: $e');
      } finally {
        _socket = null;
      }
    }
  }

  ///<------------------------- Utility Methods ---------------->
  /// Get connection information
  static Map<String, dynamic> getConnectionInfo() {
    return {
      'status': _status.toString(),
      'isConnected': isConnected,
      'currentEvent': _currentEvent,
      'reconnectAttempts': _reconnectAttempts,
      'activeHandlers': _eventHandlers.keys.toList(),
      'socketId': _socket?.id,
    };
  }

  /// Check if specific event has listeners
  static bool hasEventListener(String eventName) {
    return _eventHandlers.containsKey(eventName);
  }

  /// Get all active event listeners
  static List<String> getActiveEvents() {
    return _eventHandlers.keys.toList();
  }
}