import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/ride_screens/ride_request_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';

class SocketManager {
  // Singleton instance
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  SocketManager._internal();

  Future<void> _requestBatteryOptimizations() async {
    try {
      print('🔋 Requesting to ignore battery optimizations...');
      final status = await Permission.ignoreBatteryOptimizations.request();
      if (status.isGranted) {
        print('✅ Battery optimizations ignored - App should stay alive');
      } else {
        print(
          '⚠️ Battery optimizations NOT ignored - App might be killed in background',
        );
      }
    } catch (e) {
      print('❌ Error requesting battery permission: $e');
    }
  }

  // Platform channel for native service
  static const MethodChannel _platform = MethodChannel(
    'com.nzcu_driver/background_service',
  );

  Future<void> _startNativeService() async {
    try {
      await _platform.invokeMethod('startService');
      print('🚀 Native Foreground Service Started');
    } catch (e) {
      print("❌ Failed to start native service: $e");
    }
  }

  Future<void> _stopNativeService() async {
    try {
      await _platform.invokeMethod('stopService');
      print('🛑 Native Foreground Service Stopped');
    } catch (e) {
      print("❌ Failed to stop native service: $e");
    }
  }

  Future<void> _updateNativeNotification(String title, String body) async {
    try {
      await _platform.invokeMethod('updateNotification', {
        'title': title,
        'body': body,
      });
    } catch (e) {
      print("❌ Failed to update native notification: $e");
    }
  }

  Future<void> _setNativeAppState(String state) async {
    try {
      await _platform.invokeMethod('setAppState', {'state': state});
    } catch (e) {
      print("❌ Failed to update native app state: $e");
    }
  }

  /// Check for a pending ride request from the native Kotlin service.
  /// Called when the app cold-starts from a killed state after a ride notification.
  /// The Kotlin SocketForegroundService sets `pending_ride_from_killed=true`
  /// and stores the ride JSON in `last_ride_request`.
  Future<void> checkPendingRideFromKilledState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasPending =
          prefs.getBool("pending_ride_from_killed") ?? false;

      if (!hasPending) return;

      final String? rideJson = prefs.getString("last_ride_request");
      if (rideJson == null || rideJson.isEmpty) {
        await prefs.setBool("pending_ride_from_killed", false);
        return;
      }

      print('🚕 [SocketManager] Pending ride from killed state detected!');

      // Clear flag immediately
      await prefs.setBool("pending_ride_from_killed", false);

      // Parse and MAP ride data (same normalization as live socket - required for Accept/Cancel)
      final Map<String, dynamic> rideDataRaw = json.decode(rideJson);
      final Map<String, dynamic> rideDataMapped = _mapRideData(rideDataRaw);
      _lastRideData = rideDataMapped;

      print(
        '🚕 [SocketManager] Navigating to RideRequestScreen (orderId=${rideDataMapped['orderId']})...',
      );

      // Navigate to ride request screen strictly after rendering frame (stops GetX from swallowing the intent)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // High delay to ensure the splash screen is completely done transitioning
        // to HomeScreen before projecting the RideRequest view onto the stack.
        Future.delayed(const Duration(milliseconds: 1500), () {
          Get.to(() => RideRequestScreen(rideData: rideDataMapped));
        });
      });

      // Also trigger the callback if registered
      onNewRide?.call(rideDataMapped);
    } catch (e) {
      print('❌ [SocketManager] Error checking pending ride: $e');
      // Clear bad data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("pending_ride_from_killed", false);
    }
  }

  // Socket instance
  IO.Socket? _socket;

  // ✅ Static flag to track restoration - only restore once per app session
  static bool _hasAttemptedRestoration = false;
  bool isRestorationInProgress = false;

  // Configuration
  // static const String SOCKET_URL = 'https://api.corezap.framekarts.com';

  // static const String SOCKET_URL = 'https://corezap.smarttechbros.com';

  // static const String SOCKET_URL = 'https://nzcu.smarttechbros.com';

  static const String SOCKET_URL = '${ApiPath.SOCKET_URL}';

  // static const String SOCKET_URL = "https://api.nzcu.framekarts.com";

  // static const String SOCKET_URL = 'https://api.syrus.framekarts.com';

  // https://api.syrus.framekarts.com/

  //nzcu url
  // static const String SOCKET_URL = 'https://api.nzcu.framekarts.com';

  static const int MAX_RECONNECT_ATTEMPTS = 5;
  static const int CONNECTION_TIMEOUT = 10000;
  static const int LOCATION_UPDATE_INTERVAL = 3000;
  static const double LOCATION_CHANGE_THRESHOLD = 0.0001;

  // Driver data
  String? _driverId;
  String? _driverName;
  String? _driverPhone;
  String? _driverImage;
  String? _vehicleType;
  String? _vehicleType2;
  String? _vehicleNumber;
  String? _vehicleImage;
  String? _fleetId;
  String? _token;

  // Status
  bool _isSocketConnected = false;
  bool isOnDuty = false;
  bool _isProcessingOnline = false;
  bool _isRideInProgress = false;
  Map<String, dynamic>?
  _lastRideData; // Store latest ride request for notification actions
  bool _isAppReady = false;
  bool _permissionCheckInProgress = false;
  String _socketStatus = 'Not Connected';
  String? _socketId;

  // Location
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  DateTime? _lastLocationUpdate;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;
  Timer? _reconnectTimer;

  // Ride tracking
  String? _activeRideId;
  Map<String, dynamic>? _currentRide;
  DateTime? _rideStartTime;

  // Callbacks
  Function(Map<String, dynamic>)? onNewRide;
  Function(Map<String, dynamic>)? onRideConfirmed;
  Function(Map<String, dynamic>)? onRideStatusUpdate;
  Function(Map<String, dynamic>)? onRideCancelled;
  Function(Map<String, dynamic>)? onRideLocationUpdate;
  Function(Map<String, dynamic>)? onRideReconnected;
  Function(Map<String, dynamic>)? onChatMessage;
  Function(Map<String, dynamic>)? onChatTyping;
  Function(Map<String, dynamic>)? onChatMessageSent;
  Function(Map<String, dynamic>)? onChatJoin;
  Function(Map<String, dynamic>)? onChatError;
  Function(bool)? onConnectionStatusChange;
  Function(bool)? onDriverStatusChange;
  Function(Map<String, dynamic>)? onSocketError;

  // Stream for chat messages to allow multiple listeners
  final StreamController<Map<String, dynamic>> _chatMessageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get chatMessageStream =>
      _chatMessageStreamController.stream;

  // Listeners
  final Map<String, List<Function(dynamic)>> _socketListeners = {};

  // Debug mode
  bool _debug = true;

  // ==================== INITIALIZATION ====================
  Future<void> initialize() async {
    print('🔄 Initializing SocketManager...');
    await _loadDriverData();

    // Inform native foreground service that Flutter app is now in foreground.
    await _setNativeAppState('Foreground');

    // Request Battery Optimizations to prevent background kill
    await _requestBatteryOptimizations();

    await _getInitialLocation();

    // Initialize Advanced Geolocation
    // await _initAdvancedGeolocation();

    await connectSocket();
    // Restore online status from SharedPreferences
    await _restoreOnlineStatus();

    // Process any pending accept/decline actions coming from native notification
    await _processPendingNativeNotificationActions();
  }

  Future<void> _processPendingNativeNotificationActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingAcceptOrderId =
          prefs.getString('pending_accept_order_id') ?? '';
      final pendingDeclineOrderId =
          prefs.getString('pending_decline_order_id') ?? '';

      if (pendingAcceptOrderId.isNotEmpty) {
        print(
          '🚕 [SocketManager] Processing pending native ACCEPT for $pendingAcceptOrderId',
        );
        await prefs.remove('pending_accept_order_id');

        if (!_isSocketConnected) {
          await connectSocket();
        }

        await acceptRideFromNotification(pendingAcceptOrderId);
      } else if (pendingDeclineOrderId.isNotEmpty) {
        print(
          '🚕 [SocketManager] Processing pending native DECLINE for $pendingDeclineOrderId',
        );
        await prefs.remove('pending_decline_order_id');

        if (!_isSocketConnected) {
          await connectSocket();
        }

        final success = declineRide(
          pendingDeclineOrderId,
          reason: 'Declined from native notification',
        );
        if (!success) {
          print(
            '❌ [SocketManager] Failed to decline pending native ride action',
          );
        }
      }
    } catch (e) {
      print('❌ [SocketManager] Error processing pending native actions: $e');
    }
  }

  // Future<void> _initAdvancedGeolocation() async {
  //   print('🛰️ [SocketManager] Initializing Advanced Geolocation...');

  //   bg.BackgroundGeolocation.onLocation((bg.Location location) {
  //     print(
  //       '[Advanced Geolocation] Location changed: ${location.coords.latitude}, ${location.coords.longitude}',
  //     );
  //     _currentLatitude = location.coords.latitude;
  //     _currentLongitude = location.coords.longitude;

  //     // If we are online, emit update immediately via socket
  //     if (isOnDuty && _socket != null && _isSocketConnected) {
  //       _sendLocationUpdate();
  //     }
  //   });

  //   await bg.BackgroundGeolocation.ready(
  //     bg.Config(
  //       desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
  //       distanceFilter: 10.0,
  //       stopOnTerminate: false,
  //       startOnBoot: true,
  //       debug: false,
  //       logLevel: bg.Config.LOG_LEVEL_OFF,
  //       notification: bg.Notification(
  //         title: "NZCU Driver Tracking",
  //         text: "Online and ready for rides",
  //       ),
  //     ),
  //   );
  // }

  // ✅ NEW: Mark app as ready for location requests
  void setAppReady(bool ready) {
    _isAppReady = ready;
    print(
      _isAppReady ? '✅ App ready for location requests' : '⏳ App not ready',
    );
  }

  // ==================== DRIVER DATA ====================
  Future<void> _loadDriverData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("auth_token");
      _driverId = prefs.getString("driver_userid");

      // Load vehicle data from SharedPreferences FIRST
      _vehicleType = prefs.getString("vehicle_type_id");
      _vehicleType2 = prefs.getString("vehicle_SubType");
      _vehicleNumber = prefs.getString("vehicle_id");

      print('✅ Vehicle Type ID loaded from prefs: $_vehicleType');
      print('✅ Vehicle SubType loaded from prefs: $_vehicleType2');
      print('✅ Vehicle ID loaded from prefs: $_vehicleNumber');

      // Load driver basic info from prefs
      _driverName = prefs.getString("driver_name");
      _driverPhone = prefs.getString("driver_mobile");
      // _driverImage = prefs.getString("driver_image");

      // _driverImage = prefs.getString("driver_image");
      _driverImage = prefs.getString("driver_image");

      // Also try to load from stored driverData JSON
      final storedDriverData = prefs.getString('driverData');

      if (storedDriverData != null) {
        final driverData = json.decode(storedDriverData);

        // Use data from JSON if not already loaded from prefs
        _driverName ??= driverData['name'] ?? driverData['driverName'];
        _driverPhone ??= driverData['phone'] ?? driverData['phoneNumber'];
        _driverImage ??= driverData['profileImage'] ?? driverData['image'];

        // Only use vehicle data from JSON if not already loaded from prefs
        if (_vehicleType == null) {
          _vehicleType = driverData['vehicleType'];
        }
        if (_vehicleNumber == null) {
          _vehicleNumber =
              driverData['vehicleNumber'] ?? driverData['vehicleNo'];
        }

        _vehicleImage = driverData['vehicleImage'];
        _fleetId = driverData['fleetId'];

        print('✅ Additional driver data loaded from JSON');
      }

      print('👤 Driver loaded: $_driverName');
      print('📱 Phone: $_driverPhone');
      print('🚗 Vehicle Type ID: $_vehicleType');
      print('🚗 Vehicle ID: $_vehicleNumber');
    } catch (error) {
      print('❌ Error loading driver data: $error');
    }
  }

  // ==================== VEHICLE DATA MANAGEMENT ====================
  void updateVehicleData(
    String vehicleId,
    String vehicleTypeId,
    String vehicleSubType,
  ) {
    _vehicleType = vehicleTypeId;
    _vehicleNumber = vehicleId;
    _vehicleType2 = vehicleSubType;

    print('🚗 Vehicle data updated:');
    print('   - Type ID: $vehicleTypeId');
    print('   - SubType: $vehicleSubType');
    print('   - Vehicle ID: $vehicleId');

    // Save to SharedPreferences for persistence
    _saveVehicleDataToPrefs(vehicleId, vehicleTypeId, vehicleSubType);
  }

  Future<void> _saveVehicleDataToPrefs(
    String vehicleId,
    String vehicleTypeId,
    String vehicleSubType,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("vehicle_id", vehicleId);
      await prefs.setString("vehicle_type_id", vehicleTypeId);
      await prefs.setString("vehicle_SubType", vehicleSubType);
      print('💾 Vehicle and SubType data saved to SharedPreferences');
    } catch (error) {
      print('❌ Error saving vehicle data to prefs: $error');
    }
  }

  Future<void> refreshVehicleData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Reload vehicle data from SharedPreferences
      _vehicleType = prefs.getString("vehicle_type_id");
      _vehicleType2 = prefs.getString("vehicle_SubType");

      _vehicleNumber = prefs.getString("vehicle_id");

      // Also load other vehicle info if you need it
      final vehicleName = prefs.getString("vehicle_name");
      final vehicleNumberPlate = prefs.getString("vehicle_number");

      print('🔄 Vehicle data refreshed:');
      print('   - Type ID: $_vehicleType');

      print("vehicallltype_camee>>> ${_vehicleType2}");
      print('   - Vehicle ID: $_vehicleNumber');
      print('   - Name: $vehicleName');
      print('   - Number Plate: $vehicleNumberPlate');
    } catch (error) {
      print('❌ Error refreshing vehicle data: $error');
    }
  }

  // ==================== ONLINE STATUS PERSISTENCE ====================
  Future<void> _saveOnlineStatusToPrefs(bool isOnline) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("driver_is_online", isOnline);
      print('💾 Online status saved to SharedPreferences: $isOnline');
    } catch (error) {
      print('❌ Error saving online status to prefs: $error');
    }
  }

  Future<void> _saveRideStateToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_ride_in_progress", _isRideInProgress);
      await prefs.setString("active_ride_id", _activeRideId ?? "");
      print(
        '💾 [SocketManager] Saved ride state to prefs: isRideInProgress=$_isRideInProgress, activeRideId=$_activeRideId',
      );
    } catch (e) {
      print('❌ [SocketManager] Error saving ride state: $e');
    }
  }

  Future<void> _restoreOnlineStatus() async {
    try {
      // Only attempt restoration once per app session
      if (_hasAttemptedRestoration) {
        print('✅ Restoration already attempted this session, skipping...');
        return;
      }

      _hasAttemptedRestoration = true;
      isRestorationInProgress = true;

      final prefs = await SharedPreferences.getInstance();

      // ✅ Restore ride state FIRST
      _isRideInProgress = prefs.getBool("is_ride_in_progress") ?? false;
      _activeRideId = prefs.getString("active_ride_id");
      if (_isRideInProgress) {
        print('🔄 Restoring active ride state: ID=$_activeRideId');
      }

      final wasOnline = prefs.getBool("driver_is_online") ?? false;

      if (wasOnline) {
        print('🔄 Restoring online status from prefs...');
        // Wait for socket to be ready before going online
        int retries = 0;
        while (!_isSocketConnected && retries < 10) {
          await Future.delayed(const Duration(milliseconds: 200));
          retries++;
        }

        if (_isSocketConnected) {
          print('✅ Socket connected, restoring online status...');
          await goOnline();
        } else {
          print(
            '⚠️ Socket not connected, but user was online - marking as ready',
          );
          isOnDuty = true;
        }
      } else {
        // Ensure service is stopped if we are offline
        print(
          '✅ [SocketManager] Driver is offline, ensuring service is stopped',
        );
        await _stopNativeService();
      }

      isRestorationInProgress = false;
    } catch (error) {
      print('❌ Error restoring online status: $error');
      isRestorationInProgress = false;
    }
  }

  // ==================== LOCATION ====================
  Future<void> _getInitialLocation() async {
    try {
      // Check if app is ready for location requests
      if (!_isAppReady) {
        print('⏳ App not ready yet, using cached location if available');
        if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 3),
      );

      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
      _lastLocationUpdate = DateTime.now();

      print('✅ Initial location: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      print('⚠️ Quick location failed: $e');
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _currentLatitude = lastPosition.latitude;
          _currentLongitude = lastPosition.longitude;
          print(
            '📍 Using last known location: $_currentLatitude, $_currentLongitude',
          );
        } else {
          _currentLatitude = 23.2508131;
          _currentLongitude = 77.4647936;
          print(
            '📍 Using default location: $_currentLatitude, $_currentLongitude',
          );
        }
      } catch (e) {
        _currentLatitude = 23.2508131;
        _currentLongitude = 77.4647936;
      }
    }
  }

  void startLocationWatch() {
    if (_positionStreamSubscription != null) {
      print('ℹ️ Location watch already active');
      return;
    }

    print('📍 Starting continuous location watch');

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5,
          ),
        ).listen(
          (position) {
            _currentLatitude = position.latitude;
            _currentLongitude = position.longitude;
            _lastLocationUpdate = DateTime.now();

            // Send location update if on duty (REMOVED: Now handled exclusively by periodic timer)
            // if (isOnDuty && _socket != null && _isSocketConnected) {
            //   _sendLocationUpdate();
            // }

            // print('📍 Location updated: $_currentLatitude, $_currentLongitude');
          },
          onError: (error) {
            print('⚠️ Location watch error: $error');
          },
        );
  }

  void stopLocationWatch() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
      print('⏹️ Stopped location watch');
    }
  }

  // ==================== SOCKET CONNECTION ====================
  Future<bool> connectSocket() async {
    print("🔄 Connecting socket...");

    try {
      if (_socket != null && _isSocketConnected) {
        print('✅ Socket already connected');
        return true;
      }

      // Disconnect existing
      _disconnectSocket();

      print('🔌 Creating socket connection...');

      // Create socket connection
      _socket = IO.io(
        SOCKET_URL,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(CONNECTION_TIMEOUT)
            .setAuth({'token': _token})
            .setQuery({
              'userRole': 'Driver',
              'platform': 'flutter',
              'driverId': _driverId,
            })
            .build(),
      );

      // Setup event listeners
      _setupSocketEventListeners();

      // Connect
      _socket!.connect();

      // Wait for connection
      return await _waitForConnection();
    } catch (error) {
      print('❌ Socket connection error: $error');
      return false;
    }
  }

  Future<bool> _waitForConnection() async {
    final completer = Completer<bool>();

    final timeout = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        print('❌ Connection timeout');
        completer.complete(false);
      }
    });

    _socket!.once('connect', (_) {
      timeout.cancel();
      if (!completer.isCompleted) {
        print('✅ Socket connected!');
        completer.complete(true);
      }
    });

    _socket!.once('connect_error', (error) {
      timeout.cancel();
      if (!completer.isCompleted) {
        print('❌ Connection error: $error');
      }
    });

    return completer.future;
  }

  // ==================== EVENT LISTENERS ====================
  void _setupSocketEventListeners() {
    if (_socket == null) return;

    // Debug all events
    _socket!.onAny((event, data) {
      if (_debug) {
        print(
          '[SOCKET RECEIVED] $event: ${data != null ? jsonEncode(data).substring(0, data.toString().length > 100 ? 100 : data.toString().length) : "No data"}',
        );
      }
    });

    // CONNECTION EVENTS
    _socket!.onConnect((_) {
      print('✅ Driver socket connected: ${_socket!.id}');
      _isSocketConnected = true;
      _socketId = _socket!.id;
      _socketStatus = 'Connected';

      onConnectionStatusChange?.call(true);

      // Auto go online if driver was on duty
      if (isOnDuty) {
        Timer(const Duration(seconds: 1), () {
          goOnline();
        });
      }
    });

    _socket!.onDisconnect((_) {
      print('❌ Driver socket disconnected');
      _isSocketConnected = false;
      _socketStatus = 'Disconnected';

      // Only stop location updates if driver went offline intentionally.
      // If still on duty, keep GPS alive so we can resume on reconnect.
      if (!isOnDuty) {
        _stopLocationUpdates();
      }

      onConnectionStatusChange?.call(false);

      // Auto-reconnect if driver is still on duty (background disconnect)
      if (isOnDuty) {
        _scheduleReconnect();
      }
    });

    _socket!.onConnectError((data) {
      print('❌ Socket connection error: $data');
      onSocketError?.call({'error': data.toString(), 'type': 'connect_error'});
    });

    _socket!.onReconnect((data) {
      print('🔄 Socket reconnected after $data attempts');
      _isSocketConnected = true;
      _socketStatus = 'Connected';
      _cancelReconnect();
      onConnectionStatusChange?.call(true);

      // Re-emit online status and restart location after reconnect
      if (isOnDuty) {
        print('🔄 [Reconnect] Driver is on duty — re-emitting user:online');
        goOnline();
      }
    });

    // DRIVER STATUS EVENTS
    _socket!.on('driver:online_success', (data) {
      print('✅ Driver online confirmed: $data');
      _handleOnlineSuccess(data);
    });

    _socket!.on('driver:online_failed', (data) {
      print('❌ Driver online failed: $data');
      _handleOnlineFailure(data);
    });

    // RIDE REQUEST EVENTS
    _socket!.on('ride:newRide', (data) {
      final rideData = _mapRideData(data);

      // Pretty print the full ride request data
      print('🚕 NEW RIDE REQUEST RECEIVED:');
      print('╔═══════════════════════════════════════════════════════════');
      print('║ RIDE DETAILS:');
      print('╠═══════════════════════════════════════════════════════════');

      // Convert rideData to JSON with pretty formatting
      final prettyJson = JsonEncoder.withIndent('  ').convert(rideData);
      prettyJson.split('\n').forEach((line) {
        print('║ $line');
      });

      print('╠═══════════════════════════════════════════════════════════');
      print(
        '║ Raw data preview: ${jsonEncode(data).substring(0, min(200, jsonEncode(data).length))}...',
      );
      print('╚═══════════════════════════════════════════════════════════');

      if (!isOnDuty) {
        print('⚠️ Received ride request but driver is offline');
        return;
      }

      _lastRideData = rideData;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_ride_request', jsonEncode(data));
      });

      // Run navigation on main/UI isolate so screen always shows (avoids "only notification" in foreground)
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXx');
      //   if (!isOnDuty) return;
      //   Get.to(() => RideRequestScreen(rideData: rideData));
      // });

      // Trigger heads-up notification for background/lock screen
      NotificationService.instance.showRideRequestNotification(rideData);

      onNewRide?.call(rideData);
    });

    _socket!.on('ride:orderCancelled', (data) {
      print('userrrr_side____Canceeledddd>>>>>>>>>>>>>>>>: ${data}');

      // Handle order cancelled notification
    });

    _socket!.on('ride:confirmed', (data) async {
      print(">>>>>>>>> [SOCKET] Ride Confirmed");

      // Convert incoming data to Map
      final rideData = Map<String, dynamic>.from(data);

      final orderId = rideData['orderId'] ?? rideData['_id'];

      final prefs = await SharedPreferences.getInstance();

      // ✅ 1. Store FULL ride data
      await prefs.setString('active_ride_full_data', jsonEncode(rideData));

      // ✅ 2. Store profile image (from rider object)
      final profileImage = rideData['rider']?['profileImage'] ?? '';
      await prefs.setString('active_ride_profile_image', profileImage);

      // ✅ 3. Store order id
      await prefs.setString('active_order_id', orderId.toString());

      print("✅ Ride Data Stored Successfully");

      // =====================================================
      // 🔄 READ AGAIN FROM SHARED PREFERENCES (Verification)
      // =====================================================

      final storedRideString = prefs.getString('active_ride_full_data');

      print("📦 Stored Ride Data From Prefs: $storedRideString");

      if (storedRideString != null) {
        final storedRideMap =
            jsonDecode(storedRideString) as Map<String, dynamic>;

        print("🚗 Stored Order ID: ${storedRideMap['orderId']}");
        print(
          "👤 Stored Profile Image: ${storedRideMap['rider']?['profileImage']}",
        );
        print("💰 Stored Fare: ${storedRideMap['fare']}");
      }

      // =====================================================
      // 🧠 Update App Memory State
      // =====================================================

      _currentRide = rideData;
      _activeRideId = orderId.toString();
      _isRideInProgress = true;
      _rideStartTime = DateTime.now();

      _saveRideStateToPrefs();

      // Join ride room
      _joinRideRoom(orderId.toString());

      // Notify listeners
      onRideConfirmed?.call(_currentRide!);
      _updateNativeNotification(
        'NZCU Driver — Ride in Progress',
        'Ride #${orderId.toString().substring(orderId.toString().length > 6 ? orderId.toString().length - 6 : 0)} is active.',
      );
    });

    _socket!.on('ride:status', (data) {
      print('📊 Ride status update: $data');

      final orderId = data['orderId'] ?? data['rideId'];
      if (orderId != null) {
        if (_currentRide != null && _currentRide!['orderId'] == orderId) {
          _currentRide!['status'] = data['status'];
        }

        // Mark ride as complete if status indicates it ended
        final status = data['status']?.toString().toLowerCase();
        if (status == 'completed' ||
            status == 'finished' ||
            status == 'ended' ||
            status == 'cancelled') {
          print('✅ Ride end status received: $status');
          _completeRide(orderId);
        }
      }

      onRideStatusUpdate?.call(data);
    });

    _socket!.on('ride:orderCancelled', (data) {
      print("myyyy_cancelledddddd2>>>>>");

      print("my_cancelledddd_full_datatattt ${data}");
      print('❌ Ride cancelled: $data');

      // Ensure any looping background ringtone shuts off if driver hasn't touched the screen
      NotificationService.instance.cancelRideNotification();

      // FIX: Use rideId instead of orderId
      final rideId = data['rideId'] ?? data['orderId'];

      if (rideId != null && rideId is String) {
        _completeRide(rideId);
        _currentRide = null;
        onRideCancelled?.call(data);

        Get.offAll(BottomnavmainScreen(isOnDuty: true));

        // Get.back();
      } else {
        print('⚠️ No valid rideId found in cancellation data');
      }
    });

    _socket!.on('ride:location', (data) {
      // print('📍 Rider location during ride: $data');
      onRideLocationUpdate?.call(data);
    });

    _socket!.on('ride:reconnected', (data) async {
      print('>>>>>>>>>>> Reconnected to active ride: $data');

      final fullRideData = Map<String, dynamic>.from(data);
      final orderId = fullRideData['orderId']?.toString();
      final orderStatus = fullRideData['orderStatus']?.toString() ?? '';

      // ✅ Store FULL ride data (not just orderId and status)
      _currentRide = fullRideData;
      _activeRideId = orderId;
      _isRideInProgress = true;
      _rideStartTime = DateTime.now();
      _saveRideStateToPrefs(); // Call to save ride state

      // ✅ Save full backend data to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'active_ride_full_data',
          jsonEncode(fullRideData),
        );
        await prefs.setString('active_order_id', orderId.toString());
        print('💾 Reconnected ride data saved to SharedPreferences');
      } catch (e) {
        print('⚠️ Error saving reconnected ride data: $e');
      }

      onRideReconnected?.call(fullRideData);

      // Handle reconnection navigation and step setup
      _handleRideReconnection(fullRideData, orderStatus);
    });

    // _socket!.on('chat:history', (data) {
    //   print('>>>>>>>>>>> Chat history: $data');

    //   // _currentRide = {
    //   //   'orderId': data['orderId'],
    //   //   'status': data['orderStatus'] ?? data['status'],
    //   // };

    //   // onRideReconnected?.call(data);
    // });

    // CHAT EVENTS
    _socket!.on('chat:join_success', (data) {
      print('✅ Joined chat room: $data');
      onChatJoin?.call({'success': true, 'data': data});
    });

    _socket!.on('chat:join_error', (data) {
      print('❌ Chat join error: $data');
      onChatError?.call(data);
    });

    // Listen to both possible event names for maximum compatibility
    _socket!.on('chat:receiveMessage', (data) {
      print('💬 New chat message received (chat:receiveMessage): $data');
      onChatMessage?.call(data);
      _chatMessageStreamController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('chat:message', (data) {
      print('💬 New chat message received (chat:message): $data');
      onChatMessage?.call(data);
      _chatMessageStreamController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('chat:message_sent', (data) {
      print('✅ Message sent successfully: $data');
      onChatMessageSent?.call(data);
    });

    _socket!.on('chat:typing', (data) {
      print('✍️ User is typing: $data');
      onChatTyping?.call(data);
    });

    _socket!.on('chat:error', (data) {
      print('❌ Chat error: $data');
      onChatError?.call(data);
    });
  }

  Map<String, dynamic> _mapRideData(dynamic data) {
    final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

    // Extract pickup coordinates
    Map<String, dynamic>? pickupCoords;
    if (rideData['pickup'] != null) {
      final pickup = Map<String, dynamic>.from(rideData['pickup']);
      if (pickup['latitude'] != null && pickup['longitude'] != null) {
        pickupCoords = {
          'latitude': double.parse(pickup['latitude'].toString()),
          'longitude': double.parse(pickup['longitude'].toString()),
        };
      }
    }

    // Extract dropoff coordinates
    Map<String, dynamic>? dropoffCoords;
    if (rideData['destination'] != null) {
      final destination = Map<String, dynamic>.from(rideData['destination']);
      if (destination['latitude'] != null && destination['longitude'] != null) {
        dropoffCoords = {
          'latitude': double.parse(destination['latitude'].toString()),
          'longitude': double.parse(destination['longitude'].toString()),
        };
      }
    }

    // Robust extraction for pickup address
    String pickupAddress = 'Pickup Location';
    final rawStart =
        rideData['startLocation'] ?? rideData['pickup'] ?? rideData['source'];
    if (rawStart is Map) {
      pickupAddress =
          rawStart['address']?.toString() ??
          rawStart['name']?.toString() ??
          'Pickup Location';
    } else if (rawStart is String) {
      pickupAddress = rawStart;
    } else if (rideData['pickupAddress'] != null) {
      pickupAddress = rideData['pickupAddress'].toString();
    }

    // Robust extraction for dropoff address
    String dropAddress = 'Drop Location';
    final rawEnd =
        rideData['endLocation'] ??
        rideData['destination'] ??
        rideData['dropoff'];
    if (rawEnd is Map) {
      dropAddress =
          rawEnd['address']?.toString() ??
          rawEnd['name']?.toString() ??
          'Drop Location';
    } else if (rawEnd is String) {
      dropAddress = rawEnd;
    } else if (rideData['dropoffAddress'] != null) {
      dropAddress = rideData['dropoffAddress'].toString();
    }

    // Robust extraction for rider name
    String riderName = 'Customer';
    if (rideData['riderName'] != null) {
      riderName = rideData['riderName'].toString();
    } else {
      final rawUser =
          rideData['userId'] ?? rideData['rider'] ?? rideData['user'];
      if (rawUser is Map) {
        riderName =
            rawUser['name']?.toString() ??
            rawUser['firstName']?.toString() ??
            'Customer';
      }
    }

    // Build mapped data
    return {
      ...rideData,
      'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
      'pickup': pickupCoords,
      'destination': dropoffCoords,
      'startLocation': {'address': pickupAddress, 'coordinates': pickupCoords},
      'endLocation': {'address': dropAddress, 'coordinates': dropoffCoords},
      'riderId':
          rideData['riderId'] ??
          rideData['userId']?['_id'] ??
          rideData['userId'],
      'riderName': riderName,
      'riderNumber':
          (rideData['riderNumber'] ?? rideData['userId']?['phone'] ?? '')
              .toString(),
      'totalFare':
          (rideData['totalFare'] ??
                  rideData['fare']?['total'] ??
                  rideData['fare'] ??
                  '0')
              .toString(),
      'distance': (rideData['distance'] ?? '0').toString(),
      'estimatedTime': (rideData['estimatedTime'] ?? '15').toString(),
      'vehicleType': rideData['vehicleType'] ?? 'sedan',
      'otp': rideData['otp'],
    };
  }

  // ==================== DRIVER ONLINE/OFFLINE ====================
  Future<void> goOnline() async {
    print('🟢 GOING ONLINE...');

    if (_isProcessingOnline) {
      print('⏳ Already processing...');
      return;
    }

    _isProcessingOnline = true;

    // Notify UI to show loading state
    onDriverStatusChange?.call(isOnDuty);

    try {
      // If socket is not connected, try to reconnect first
      if (_socket == null || !_isSocketConnected) {
        print('⚠️ Socket not connected, attempting to reconnect...');

        final reconnected = await connectSocket();

        if (!reconnected) {
          print('❌ Failed to reconnect socket');
          _handleOnlineFailure(
            'Failed to connect to server. Please check your internet connection.',
          );
          return;
        }

        print('✅ Socket reconnected successfully');

        // Wait a bit for socket to stabilize
        await Future.delayed(const Duration(milliseconds: 500));
      }

      print('📍 Using current location: $_currentLatitude, $_currentLongitude');

      // Debug print to show what vehicle data we have
      print('🚗 Vehicle Type ID: $_vehicleType');
      print('🚗 Vehicle ID: $_vehicleNumber');

      // Check if we have required vehicle data (vehicleSubType is optional)
      if (_vehicleType == null || _vehicleNumber == null) {
        print('⚠️ Missing vehicle data! Trying to load from prefs...');
        await refreshVehicleData();

        if (_vehicleType == null || _vehicleNumber == null) {
          print('⚠️ Still missing data. Attempting to fetch from API...');
          try {
            await HomeApiServices.get_driverid_data();
            await refreshVehicleData();

            if (_vehicleType == null || _vehicleNumber == null) {
              print(
                '❌ Still missing vehicle data after API fetch. Cannot go online.',
              );
              _handleOnlineFailure(
                'Vehicle data not found. Please complete your vehicle registration.',
              );
              return;
            }
          } catch (e) {
            print("❌ Error fetching driver data during online attempt: $e");
            _handleOnlineFailure('Failed to fetch vehicle details.');
            return;
          }
        }
      }

      // Log if vehicleSubType is missing (non-blocking)
      if (_vehicleType2 == null) {
        print('⚠️ vehicleSubType is null - proceeding without it');
      }

      final payload = {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
        'vehicleType': _vehicleType,
        'vehicleSubType': _vehicleType2,
        'vehicleId': _vehicleNumber,
        'vehicleImage': _vehicleImage,
        'fleetId': _fleetId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      print("vehical_type_coming>>>  ${_vehicleType}");
      print("vehical_subtyp[e_coming>>>  ${_vehicleType2}");
      print('>>>>>>   Emitting user:online: $payload');
      _socket!.emit('user:online', payload);

      // Start location updates
      _startLocationUpdates();
      startLocationWatch();

      // START NATIVE FOREGROUND SERVICE (keeps app alive in background)
      print('🚀 [SocketManager] Starting Native Foreground Service...');
      await _startNativeService();

      // Native SocketForegroundService handles killed-state socket via Kotlin

      // START APP KEEP-ALIVE (isolated try-catch)
      // try {
      //   print('🚀 [SocketManager] Enabling FlutterBackground keep-alive...');
      //   bool hasPermissions = await bg_lib.FlutterBackground.hasPermissions;

      //   if (!hasPermissions) {
      //     print(
      //       '⚠️ [SocketManager] FlutterBackground missing permissions - attempting to initialize...',
      //     );
      //     const androidConfig = bg_lib.FlutterBackgroundAndroidConfig(
      //       notificationTitle: "NZCU Driver",
      //       notificationText: "App is running in the background",
      //       notificationImportance: bg_lib.AndroidNotificationImportance.high,
      //       notificationIcon: bg_lib.AndroidResource(
      //         name: 'ic_launcher',
      //         defType: 'mipmap',
      //       ),
      //     );
      //     await bg_lib.FlutterBackground.initialize(
      //       androidConfig: androidConfig,
      //     );
      //     hasPermissions = await bg_lib.FlutterBackground.hasPermissions;
      //   }

      //   if (hasPermissions) {
      //     bool enabled =
      //         await bg_lib.FlutterBackground.enableBackgroundExecution();
      //     print(
      //       '✅ [SocketManager] FlutterBackground execution enabled: $enabled',
      //     );
      //   } else {
      //     print(
      //       '❌ [SocketManager] FlutterBackground permissions still missing after init attempt',
      //     );
      //   }
      // } catch (bgKeepAliveError) {
      //   print(
      //     '⚠️ [SocketManager] FlutterBackground keep-alive failed (non-fatal): $bgKeepAliveError',
      //   );
      // }

      // START ADVANCED GEOLOCATION TRACKING
      try {
        print('🚀 [SocketManager] Starting Native Geolocation Tracking...');
        // await bg.BackgroundGeolocation.start();
        print('✅ [SocketManager] Native Geolocation Tracking started');
      } catch (geoError) {
        print(
          '⚠️ [SocketManager] Geolocation start failed (non-fatal): $geoError',
        );
      }

      print('🟢 [SocketManager] Driver online request sent successfully');
    } catch (error) {
      print('❌ Error going online: $error');
      _handleOnlineFailure('Error: $error');
    }
  }

  Future<void> goOffline() async {
    print('🔴 GOING OFFLINE...');

    // Stop any looping ride request sounds
    NotificationService.instance.cancelRideNotification();

    print("hellooooo222 ${_isProcessingOnline}");
    if (_isProcessingOnline) return;
    print("hellooooo3333 ${_isProcessingOnline}");
    // _isProcessingOnline = true;
    print("hellooooo4444 ${_isProcessingOnline}");

    // Notify UI to show loading state
    onDriverStatusChange?.call(isOnDuty);

    try {
      // Emit offline event before disconnecting
      if (_socket != null && _isSocketConnected) {
        print('🔴 Emitting offline status...');

        final payload = {
          'driverId': _driverId,
          'timestamp': DateTime.now().toIso8601String(),
        };
        _socket!.emit('driver:offline', payload);
        print('📡 Emitted driver:offline event: $payload');

        // Wait a bit for the event to be sent before disconnecting
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Update driver status
      isOnDuty = false;
      _isProcessingOnline = false;
      _isRideInProgress = false;
      _activeRideId = null;
      _currentRide = null;
      _cancelReconnect();
      print("hellooooo5555");

      // Save offline status to SharedPreferences
      await _saveOnlineStatusToPrefs(false);

      onDriverStatusChange?.call(false);
      print("hellooooo6666");

      // Disconnect socket (this will also stop location updates)
      _disconnectSocket();
      print("hellooooo7777");

      print("hellooooo7777");

      // Native SocketForegroundService is stopped via _stopNativeService() below

      // STOP FOREGROUND SERVICE
      print('🛑 Stopping Native Foreground Service...');
      await _stopNativeService();

      // STOP APP KEEP-ALIVE
      print('🛑 [SocketManager] Disabling FlutterBackground keep-alive...');
      try {
        // await bg_lib.FlutterBackground.disableBackgroundExecution();
      } catch (e) {
        print('⚠️ Error disabling background execution: $e');
      }

      // STOP ADVANCED GEOLOCATION TRACKING
      print('🛑 [SocketManager] Stopping Native Geolocation Tracking...');
      // await bg.BackgroundGeolocation.stop();

      print('✅ Driver is now offline and socket disconnected');
    } catch (error) {
      print('❌ Error going offline: $error');
      _isProcessingOnline = false;
      // Notify UI to hide loading state
      onDriverStatusChange?.call(isOnDuty);
    }
  }

  void _handleOnlineSuccess(dynamic data) {
    if (!_isProcessingOnline) return;

    print('✅ DRIVER ONLINE SUCCESS');
    isOnDuty = true;
    _isProcessingOnline = false;

    // Save online status to SharedPreferences
    _saveOnlineStatusToPrefs(true);

    onDriverStatusChange?.call(true);
  }

  void _handleOnlineFailure(dynamic data) {
    if (!_isProcessingOnline) return;

    print('❌ DRIVER ONLINE FAILED');
    isOnDuty = false;
    _isProcessingOnline = false;

    // Stop foreground service if online attempt failed
    _stopNativeService();

    onDriverStatusChange?.call(false);
  }

  // ==================== LOCATION UPDATES ====================
  void _sendLocationUpdate() {
    if (_socket == null || !_isSocketConnected) return;

    final rideId =
        _activeRideId ?? _currentRide?['orderId'] ?? _currentRide?['rideId'];
    final bool isRideActive =
        _isRideInProgress &&
        rideId != null &&
        rideId.toString().trim().isNotEmpty;

    if (isRideActive) {
      // 1. Specific ride location update
      final ridePayload = {
        'rideId': rideId,
        'location': {
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
          'lat': _currentLatitude,
          'lng': _currentLongitude,
          'timestamp': DateTime.now().toIso8601String(),
          'accuracy': 0.0,
          'speed': 0.0,
        },
      };

      print("📍 [RIDE-MODE] my_ride_location_payload>>> $ridePayload");
      _socket!.emit('ride:location:update', ridePayload);
    } else {
      // 2. ONLY send general status if NO ride is in progress
      if (!_isRideInProgress) {
        final driverPayload = {
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
          'role': 'Driver',
          'vehicleType': _vehicleType,
          'vehicleImage': _vehicleImage,
          'fleetId': _fleetId,
          'timestamp': DateTime.now().toIso8601String(),
        };

        print(
          '📍 [DRIVER-MODE] Sending general driver location update: $_currentLatitude, $_currentLongitude',
        );
        _socket!.emit('driver:location:update', driverPayload);
      } else {
        // Extra safety: we are in a ride, but rideId was missing/empty
        print(
          '⚠️ [SAFETY-BLOCK] Suppressing driver:location:update - Ride is in progress but ID is invalid: "$rideId"',
        );
      }
    }
  }

  void _startLocationUpdates() {
    _stopLocationUpdates();

    print('🔄 Starting location update broadcasts every 3 seconds');

    _locationUpdateTimer = Timer.periodic(
      const Duration(milliseconds: LOCATION_UPDATE_INTERVAL),
      (_) {
        if (_socket != null && _isSocketConnected && isOnDuty) {
          if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
            _sendLocationUpdate();
          }
        }
      },
    );
  }

  void _stopLocationUpdates() {
    if (_locationUpdateTimer != null) {
      _locationUpdateTimer!.cancel();
      _locationUpdateTimer = null;
      print('⏹️ Stopped location update broadcasts');
    }
  }

  // ==================== AUTO-RECONNECT ====================

  /// Schedules exponential-backoff reconnect attempts while driver is on duty.
  void _scheduleReconnect() {
    _cancelReconnect();

    const initialDelay = Duration(seconds: 5);
    int attempt = 0;

    void tryReconnect() {
      if (!isOnDuty || _isSocketConnected) {
        _cancelReconnect();
        return;
      }

      attempt++;
      // Exponential backoff: 5s, 10s, 20s, 40s … capped at 60s
      final delay = Duration(
        seconds: (initialDelay.inSeconds * (1 << (attempt - 1))).clamp(5, 60),
      );
      print('🔄 [AutoReconnect] Attempt #$attempt in ${delay.inSeconds}s');

      _reconnectTimer = Timer(delay, () async {
        if (!isOnDuty || _isSocketConnected) return;

        print('🔌 [AutoReconnect] Trying to reconnect...');
        final connected = await connectSocket();
        if (connected && isOnDuty) {
          print('✅ [AutoReconnect] Reconnected — re-emitting user:online');
          await goOnline();
        } else if (isOnDuty) {
          // Retry again
          tryReconnect();
        }
      });
    }

    tryReconnect();
  }

  /// Cancels any pending reconnect timer.
  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // ==================== RIDE METHODS ====================
  Future<void> acceptRideFromNotification(String orderId) async {
    if (_lastRideData != null && _lastRideData!['orderId'] == orderId) {
      print('🚀 [SocketManager] Accepting ride from memory: $orderId');
      acceptRide(_lastRideData!);
    } else {
      print(
        '🔍 [SocketManager] Memory check failed for $orderId, checking SharedPreferences...',
      );
      try {
        final prefs = await SharedPreferences.getInstance();
        final lastRideJson = prefs.getString('last_ride_request');
        if (lastRideJson != null) {
          final rideDataRaw = jsonDecode(lastRideJson);
          final rideDataMapped = _mapRideData(rideDataRaw);

          if (rideDataMapped['orderId'] == orderId) {
            print(
              '🚀 [SocketManager] Accepting ride from SharedPreferences: $orderId',
            );
            _lastRideData = rideDataMapped;

            // ✅ Wait for socket to be connected before emitting accept
            if (!_isSocketConnected) {
              print(
                '⏳ Socket not connected, waiting for connection before accepting ride...',
              );
              int retries = 0;
              while (!_isSocketConnected && retries < 15) {
                await Future.delayed(const Duration(milliseconds: 500));
                retries++;
              }
            }

            if (_isSocketConnected) {
              acceptRide(rideDataMapped);
            } else {
              print(
                '❌ [SocketManager] Failed to connect socket within timeout. Cannot accept ride.',
              );
              Get.snackbar(
                'Error',
                'Connection failed. Please accept the ride manually.',
              );
            }
            return;
          }
        }
      } catch (e) {
        print(
          '❌ [SocketManager] Error reading last ride request from prefs: $e',
        );
      }
      print(
        '⚠️ [SocketManager] Could not find ride data for $orderId. Cannot accept from notification.',
      );
    }
  }

  bool acceptRide(Map<String, dynamic> rideData) {
    if (_socket == null || !_isSocketConnected) {
      print('❌ Cannot accept ride - socket not connected');
      return false;
    }

    final orderId =
        rideData['orderId'] ??
        rideData['_id'] ??
        rideData['id'] ??
        rideData['rideId'];

    if (orderId == null) {
      print('❌ No order ID found in ride data');
      return false;
    }

    // ✅ CRITICAL: Mark ride as in progress BEFORE emitting to prevent disconnection
    _activeRideId = orderId;
    _rideStartTime = DateTime.now();
    _isRideInProgress = true;

    _currentRide = {
      'orderId': orderId,
      'status': 'accepting',
      'data': rideData,
    };

    final payload = {
      'orderId': orderId,
      'driverId': _driverId,
      'driverName': _driverName,
      'driverPhone': _driverPhone,
      'driverImage': _driverImage,
      'acceptedAt': DateTime.now().toIso8601String(),
      'location': {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
      },
      'vehicleType': _vehicleType,
      'vehicleNumber': _vehicleNumber,
      'vehicleImage': _vehicleImage,
    };

    print('✅ Ride marked as IN PROGRESS (ID: $orderId)');
    _saveRideStateToPrefs(); // Persistence for background isolate synchronization
    print('✅ Emitting ride:accept: $payload');
    _socket!.emit('ride:accept', payload);

    // Keep driver online but mark
    //as busy
    isOnDuty = true; // Keep online to receive updates

    return true;
  }

  bool declineRide(String rideId, {String reason = ''}) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    final payload = {
      'orderId': rideId,
      'driverId': _driverId,
      'reason': reason,
      'declinedAt': DateTime.now().toIso8601String(),
    };

    print('❌ Declining ride: $payload');
    _socket!.emit('ride:decline', payload);

    // Ensure we return to general location updates
    _isRideInProgress = false;
    _activeRideId = null;
    _currentRide = null;
    _saveRideStateToPrefs(); // Reset state for background isolate

    return true;
  }

  void _completeRide(String? rideId) {
    if (rideId != null && rideId.isNotEmpty) {
      if (_activeRideId == rideId) {
        print('✅ Ride completed (ID: $rideId)');
        _activeRideId = null;
        _rideStartTime = null;
        _isRideInProgress = false;
        _currentRide = null;
        _saveRideStateToPrefs(); // Reset state for background isolate

        // Reset foreground notification back to online status
        // Reset foreground notification back to online status
        _updateNativeNotification(
          'NZCU Driver — Online',
          'You are online and ready for ride requests.',
        );

        // Clear persisted ride data
        _clearPersistedRide();
      }
    } else {
      print('⚠️ Invalid rideId provided to _completeRide');
    }
  }

  // ==================== RIDE RECONNECTION ====================
  void _handleRideReconnection(
    Map<String, dynamic> rideData,
    String orderStatus,
  ) {
    try {
      print('🔄 Handling ride reconnection with status: $orderStatus');

      // Determine the step based on order status
      final step = _getStepFromOrderStatus(orderStatus);
      print('📍 Setting active step to: $step for status: $orderStatus');

      // Update the stepper controller with the correct step
      final stepperController = Get.find<StepperController>();
      stepperController.reachStep(step);

      // Navigate to ArrivingClient screen with full ride data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(
          () => ArrivingClient(rideData: rideData, typeCheck: false),
          arguments: rideData,
        );
      });

      print('✅ Navigated to ArrivingClient screen');
    } catch (e) {
      print('❌ Error handling ride reconnection: $e');
    }
  }

  /// Maps order status to stepper step
  /// Returns 0 for "Accepted", 1 for "Arriving", 2 for "Progress"
  int _getStepFromOrderStatus(String orderStatus) {
    final normalizedStatus = orderStatus.toLowerCase().trim();

    switch (normalizedStatus) {
      case 'accepted':
        return 0; // "I've Arrived" button
      case 'arriving':
        return 1; // "Start Trip" button
      case 'progress':
      case 'in progress':
        return 2; // "Complete" button
      default:
        print('⚠️ Unknown order status: $orderStatus, defaulting to step 0');
        return 0;
    }
  }

  // ==================== CHAT FUNCTIONALITY ====================
  bool joinChatRoom(String orderId, {String userRole = 'driver'}) {
    if (_socket == null || !_isSocketConnected) {
      print('❌ Cannot join chat - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      'userRole': userRole,
      'userId': _driverId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('💬 Joining chat room: $payload');
    _socket!.emit('chat:join', payload);
    return true;
  }

  bool sendChatMessage(
    String orderId,
    String message, {
    String? receiverId,
    String? chatId,
  }) {
    if (_socket == null || !_isSocketConnected) {
      print('❌ Cannot send message - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      if (chatId != null) 'chatId': chatId,
      'message': message.trim(),
      'senderId': _driverId,
      'senderType': 'Driver',
      'senderRole': 'driver',
      if (receiverId != null) 'receiverId': receiverId,
      'receiverRole': 'user',
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('💬 Sending message: $payload');

    // Emit to both known events for compatibility
    _socket!.emit('chat:sendMessage', payload);
    _socket!.emit('sendChatMessage', payload);

    return true;
  }

  bool sendTypingIndicator(
    String orderId,
    bool isTyping, {
    String userRole = 'driver',
  }) {
    if (_socket != null && _isSocketConnected) {
      return false;
    }

    final payload = {
      'orderId': orderId,
      'userRole': userRole,
      'isTyping': isTyping,
    };

    _socket!.emit('chat:typing', payload);
    return true;
  }

  bool getChatHistory(String orderId) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    print('💬 Requesting chat history for: $orderId');
    _socket!.emit('chat:getHistory', {'orderId': orderId});
    return true;
  }

  bool leaveChatRoom(String orderId) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    print('💬 Leaving chat room: $orderId');
    _socket!.emit('chat:leave', {'orderId': orderId});
    return true;
  }

  void _joinRideRoom(String rideId) {
    if (_socket != null && _isSocketConnected) {
      final roomName = 'ride:$rideId';
      _socket!.emit('join:room', {'roomName': roomName});
      print('✅ Joined ride room: $roomName');
    }
  }

  // ==================== PERSISTENCE METHODS ====================
  Future<bool> saveActiveRide(Map<String, dynamic> rideData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Extract coordinates properly
      LatLng? pickupCoords;
      if (rideData['pickupCoordinates'] != null) {
        pickupCoords = rideData['pickupCoordinates'];
      } else if (rideData['pickup'] != null) {
        final pickup = rideData['pickup'];
        if (pickup is Map && pickup['latitude'] != null) {
          pickupCoords = LatLng(
            pickup['latitude'].toDouble(),
            pickup['longitude'].toDouble(),
          );
        }
      }

      LatLng? dropoffCoords;
      if (rideData['dropoffCoordinates'] != null) {
        dropoffCoords = rideData['dropoffCoordinates'];
      } else if (rideData['destination'] != null) {
        final dest = rideData['destination'];
        if (dest is Map && dest['latitude'] != null) {
          dropoffCoords = LatLng(
            dest['latitude'].toDouble(),
            dest['longitude'].toDouble(),
          );
        }
      }

      final activeRide = {
        'orderId': rideData['orderId']?.toString() ?? '',
        'rideId':
            rideData['rideId']?.toString() ??
            rideData['orderId']?.toString() ??
            '',
        'riderId': rideData['riderId']?.toString() ?? '',
        'riderName': rideData['riderName']?.toString() ?? 'Rider',
        'riderPhone': rideData['riderPhone']?.toString() ?? '',
        'riderImage': rideData['riderImage']?.toString() ?? '',
        'pickupAddress':
            rideData['pickupLocation']?.toString() ?? 'Pickup Location',
        'dropoffAddress':
            rideData['dropLocation']?.toString() ?? 'Drop Location',
        'pickupLat': pickupCoords?.latitude ?? 0.0,
        'pickupLng': pickupCoords?.longitude ?? 0.0,
        'dropoffLat': dropoffCoords?.latitude ?? 0.0,
        'dropoffLng': dropoffCoords?.longitude ?? 0.0,
        'totalFare': rideData['totalFare']?.toString() ?? '0',
        'vehicleType': rideData['vehicleType']?.toString() ?? 'sedan',
        'orderStatus': rideData['orderStatus']?.toString() ?? 'accepted',
        'rideOtp': rideData['rideOtp']?.toString() ?? '',
        'savedAt': DateTime.now().toIso8601String(),
        'screenToRestore':
            rideData['screenToRestore']?.toString() ?? 'Arriving',
      };

      await prefs.setString('activeRide', jsonEncode(activeRide));
      print('💾 Active ride saved to storage: ${activeRide['orderId']}');
      return true;
    } catch (error) {
      print('❌ Failed to save active ride: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getPersistedRide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? activeRideJson = prefs.getString('activeRide');

      if (activeRideJson != null) {
        final activeRide = jsonDecode(activeRideJson) as Map<String, dynamic>;
        print('📂 Found persisted ride: ${activeRide['orderId']}');

        // Check if ride data is not too old (max 4 hours)
        final savedAt = DateTime.parse(activeRide['savedAt']);
        final now = DateTime.now();
        final hoursDiff = now.difference(savedAt).inHours;

        if (hoursDiff > 4) {
          print('⚠️ Persisted ride is too old, clearing');
          await _clearPersistedRide();
          return null;
        }

        return activeRide;
      }

      return null;
    } catch (error) {
      print('❌ Failed to get persisted ride: $error');
      return null;
    }
  }

  Future<bool> _clearPersistedRide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('activeRide');
      print('🗑️ Cleared persisted ride data');
      return true;
    } catch (error) {
      print('❌ Failed to clear persisted ride: $error');
      return false;
    }
  }

  Future<void> updatePersistedRideScreen(String screen) async {
    try {
      final activeRide = await getPersistedRide();
      if (activeRide != null) {
        activeRide['screenToRestore'] = screen;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('activeRide', jsonEncode(activeRide));
        print('📝 Updated persisted ride screen to: $screen');
      }
    } catch (error) {
      print('❌ Failed to update persisted ride screen: $error');
    }
  }

  // ==================== LISTENER MANAGEMENT ====================
  void addEventListener(String event, Function(dynamic) callback) {
    if (!_socketListeners.containsKey(event)) {
      _socketListeners[event] = [];
    }
    _socketListeners[event]!.add(callback);
    print('✅ Added listener for: $event');
  }

  void removeEventListener(String event, Function(dynamic) callback) {
    if (_socketListeners.containsKey(event)) {
      final callbacks = _socketListeners[event]!;
      final index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.removeAt(index);
        print('❌ Removed listener for: $event');
      }
    }
  }

  void _notifyListeners(String event, dynamic data) {
    if (_socketListeners.containsKey(event)) {
      final callbacks = _socketListeners[event]!;
      for (final callback in callbacks) {
        try {
          callback(data);
        } catch (error) {
          print('❌ Error in $event listener: $error');
        }
      }
    }
  }

  // ==================== UTILITY METHODS ====================
  void _disconnectSocket() {
    // Don't disconnect if ride is in progress
    if (_isRideInProgress && _activeRideId != null) {
      print(
        '⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.',
      );
      return;
    }

    stopLocationWatch();
    _stopLocationUpdates();

    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    _isSocketConnected = false;
    _socketId = null;
    isOnDuty = false;

    onConnectionStatusChange?.call(false);
    onDriverStatusChange?.call(false);

    print('🔌 Driver socket disconnected');
  }

  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isSocketConnected,
      'socketId': _socketId,
      'driverId': _driverId,
      'isOnDuty': isOnDuty,
      'currentRide': _currentRide,
      'location': {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
      },
      'rideInProgress': _isRideInProgress,
      'activeRideId': _activeRideId,
      'socketStatus': _socketStatus,
    };
  }

  Map<String, dynamic> getRideStatus() {
    return {
      'activeRideId': _activeRideId,
      'isRideInProgress': _isRideInProgress,
      'rideStartTime': _rideStartTime?.toIso8601String(),
      'duration': _rideStartTime != null
          ? DateTime.now().difference(_rideStartTime!).inSeconds
          : 0,
    };
  }

  // Update location
  void updateLocation(double latitude, double longitude) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _lastLocationUpdate = DateTime.now();
  }

  // Debug function
  void debugSocket() {
    print('🔍 === DRIVER SOCKET DEBUG ===');
    print('Connected: $_isSocketConnected');
    print('Socket ID: $_socketId');
    print('Driver ID: $_driverId');
    print('On Duty: $isOnDuty');
    print('Current Ride: $_currentRide');
    print('Ride In Progress: $_isRideInProgress');
    print('Active Ride ID: $_activeRideId');
    print('Location: $_currentLatitude, $_currentLongitude');
    print('Vehicle Type: $_vehicleType');
    print('Vehicle ID: $_vehicleNumber');
    print('==============================');
  }

  // Cleanup - Only call this on actual logout/app termination, NOT on screen navigation
  void dispose() {
    print('🔌 Disposing SocketManager (full cleanup)');
    _disconnectSocket();
    _stopLocationUpdates();
    stopLocationWatch();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    }
  }

  // ==================== LOGOUT ====================
  Future<void> logout() async {
    try {
      print('🚪 Logging out driver...');

      // Go offline first
      await goOffline();

      // Clear all SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("driver_is_online");
      await prefs.remove("auth_token");
      await prefs.remove("driver_userid");
      await prefs.remove("vehicle_type_id");
      await prefs.remove("vehicle_id");
      await prefs.remove("driver_name");
      await prefs.remove("driver_mobile");
      await prefs.remove("driver_image");

      // Reset internal state
      isOnDuty = false;
      _activeRideId = null;
      _currentRide = null;
      _isRideInProgress = false;

      print('✅ All data cleared on logout');
    } catch (error) {
      print('❌ Error during logout: $error');
    }
  }

  // ==================== GETTERS ====================
  bool get isSocketConnected => _isSocketConnected;
  bool get isOnDutyy => isOnDuty;
  bool get isProcessingOnline => _isProcessingOnline;
  bool get isRideInProgress => _isRideInProgress;
  String get socketStatus => _socketStatus;
  String? get socketId => _socketId;
  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;
  Map<String, dynamic>? get currentRide => _currentRide;
  String? get activeRideId => _activeRideId;
  DateTime? get lastLocationUpdate => _lastLocationUpdate;
  String? get vehicleType => _vehicleType;
  String? get vehicleId => _vehicleNumber;
}

// For LatLng class (if not imported)
class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);

  Map<String, double> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
