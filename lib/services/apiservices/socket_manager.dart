import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/controllers/home_controllers/ride_request_queue_controller.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/ride_screens/ride_request_queue_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class SocketManager {
  // Singleton instance
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;
  SocketManager._internal();

  Future<void> _requestBatteryOptimizations() async {
    try {
      AppLogger.d('🔋 Requesting to ignore battery optimizations...');
      final status = await Permission.ignoreBatteryOptimizations.request();
      if (status.isGranted) {
        AppLogger.d('✅ Battery optimizations ignored - App should stay alive');
      } else {
        AppLogger.d(
          '⚠️ Battery optimizations NOT ignored - App might be killed in background',
        );
      }
    } catch (e) {
      AppLogger.d('❌ Error requesting battery permission: $e');
    }
  }

  // Platform channel for native service
  static const MethodChannel _platform = MethodChannel(
    'com.nzcu_driver/background_service',
  );

  Future<void> _startNativeService() async {
    try {
      await _platform.invokeMethod('startService');
      AppLogger.d('🚀 Native Foreground Service Started');
    } catch (e) {
      AppLogger.d("❌ Failed to start native service: $e");
    }
  }

  Future<void> _stopNativeService() async {
    try {
      await _platform.invokeMethod('stopService');
      AppLogger.d('🛑 Native Foreground Service Stopped');
    } catch (e) {
      AppLogger.d("❌ Failed to stop native service: $e");
    }
  }

  Future<void> _updateNativeNotification(String title, String body) async {
    try {
      await _platform.invokeMethod('updateNotification', {
        'title': title,
        'body': body,
      });
    } catch (e) {
      AppLogger.d("❌ Failed to update native notification: $e");
    }
  }

  Future<void> _setNativeAppState(String state) async {
    try {
      await _platform.invokeMethod('setAppState', {'state': state});
    } catch (e) {
      AppLogger.d("❌ Failed to update native app state: $e");
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

      // Clear flag immediately so this block cannot fire twice per session.
      await prefs.setBool("pending_ride_from_killed", false);

      // ── Staleness guard ─────────────────────────────────────────────────
      // If the ride request is older than 30 seconds the window to accept it
      // has probably expired — discard silently to avoid a ghost screen.
      final pendingTs = prefs.getInt('last_ride_request_ts') ?? 0;
      if (pendingTs > 0) {
        final ageMs = DateTime.now().millisecondsSinceEpoch - pendingTs;
        if (ageMs > 60000) {
          AppLogger.d(
            '⏰ [SocketManager] Pending ride is ${ageMs ~/ 1000}s old — discarding (too stale)',
          );
          return;
        }
      }

      // ── Accept-already-tapped guard ──────────────────────────────────────
      // If the driver tapped "Accept" from the notification before the app
      // opened, pending_accept_order_id is already set. In that case
      // _processPendingNativeNotificationActions() (called from initialize())
      // will emit ride:accept and navigate to AcceptedScreen — don't also
      // push RideRequestScreen on top of it.
      final pendingAcceptId = prefs.getString('pending_accept_order_id') ?? '';
      if (pendingAcceptId.isNotEmpty) {
        AppLogger.d(
          '🚕 [SocketManager] Accept already tapped — skipping RideRequestScreen '
          '(pending_accept_order_id=$pendingAcceptId)',
        );
        return;
      }

      AppLogger.d(
        '🚕 [SocketManager] Pending ride from killed state detected!',
      );

      // Parse and MAP ride data (same normalization as live socket - required for Accept/Cancel)
      final Map<String, dynamic> rideDataRaw = json.decode(rideJson);
      final Map<String, dynamic> rideDataMapped = _mapRideData(rideDataRaw);
      _lastRideData = rideDataMapped;

      // Mark that a pending ride request is active so the ride:newRide guard
      // doesn't block the eventual Accept/Decline from this screen.
      _hasPendingRideRequest = true;
      // Also ensure isOnDuty is true — driver must have been online when killed.
      isOnDuty = true;

      AppLogger.d(
        '🧾 [RideQueue] Pending ride from killed-state (orderId=${rideDataMapped['orderId']})',
      );

      // Enqueue and navigate to queue screen strictly after first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // High delay to ensure the splash screen is completely done transitioning
        // to HomeScreen before projecting the RideRequest view onto the stack.
        Future.delayed(const Duration(milliseconds: 1500), () {
          // Double-check that accept was not tapped during the delay.
          if (!_hasPendingRideRequest) {
            AppLogger.d(
              '🚕 [SocketManager] Ride cancelled or accepted during delay — skipping navigation',
            );
            return;
          }

          final queue = Get.isRegistered<RideRequestQueueController>()
              ? Get.find<RideRequestQueueController>()
              : Get.put(RideRequestQueueController(), permanent: true);

          queue.addOrUpdateRide(rideDataMapped);

          if (!queue.isQueueScreenOpen.value) {
            AppLogger.d('🧾 [RideQueue] Opening RideRequestQueueScreen (killed-state)');
            Get.to(() => const RideRequestQueueScreen());
          }
        });
      });

      // Also trigger the callback if registered
      onNewRide?.call(rideDataMapped);
    } catch (e) {
      AppLogger.d('❌ [SocketManager] Error checking pending ride: $e');
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

  /// Guards against stale navigation after a ride is cancelled
  bool _hasPendingRideRequest = false;
  Map<String, dynamic>?
  _lastRideData; // Store latest ride request for notification actions
  bool _isAppReady = false;
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
    AppLogger.d('🔄 Initializing SocketManager...');
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
        AppLogger.d(
          '🚕 [SocketManager] Processing pending native ACCEPT for $pendingAcceptOrderId',
        );
        await prefs.remove('pending_accept_order_id');

        if (!_isSocketConnected) {
          await connectSocket();
        }

        await acceptRideFromNotification(pendingAcceptOrderId);
      } else if (pendingDeclineOrderId.isNotEmpty) {
        AppLogger.d(
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
          AppLogger.d(
            '❌ [SocketManager] Failed to decline pending native ride action',
          );
        }
      }
    } catch (e) {
      AppLogger.d(
        '❌ [SocketManager] Error processing pending native actions: $e',
      );
    }
  }

  // Future<void> _initAdvancedGeolocation() async {
  //   AppLogger.d('🛰️ [SocketManager] Initializing Advanced Geolocation...');

  //   bg.BackgroundGeolocation.onLocation((bg.Location location) {
  //     AppLogger.d(
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
    AppLogger.d(
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

      AppLogger.d('✅ Vehicle Type ID loaded from prefs: $_vehicleType');
      AppLogger.d('✅ Vehicle SubType loaded from prefs: $_vehicleType2');
      AppLogger.d('✅ Vehicle ID loaded from prefs: $_vehicleNumber');

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

        AppLogger.d('✅ Additional driver data loaded from JSON');
      }

      AppLogger.d('👤 Driver loaded: $_driverName');
      AppLogger.d('📱 Phone: $_driverPhone');
      AppLogger.d('🚗 Vehicle Type ID: $_vehicleType');
      AppLogger.d('🚗 Vehicle ID: $_vehicleNumber');
    } catch (error) {
      AppLogger.d('❌ Error loading driver data: $error');
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

    AppLogger.d('🚗 Vehicle data updated:');
    AppLogger.d('   - Type ID: $vehicleTypeId');
    AppLogger.d('   - SubType: $vehicleSubType');
    AppLogger.d('   - Vehicle ID: $vehicleId');

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
      AppLogger.d('💾 Vehicle and SubType data saved to SharedPreferences');
    } catch (error) {
      AppLogger.d('❌ Error saving vehicle data to prefs: $error');
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

      AppLogger.d('🔄 Vehicle data refreshed:');
      AppLogger.d('   - Type ID: $_vehicleType');

      AppLogger.d("vehicallltype_camee>>> ${_vehicleType2}");
      AppLogger.d('   - Vehicle ID: $_vehicleNumber');
      AppLogger.d('   - Name: $vehicleName');
      AppLogger.d('   - Number Plate: $vehicleNumberPlate');
    } catch (error) {
      AppLogger.d('❌ Error refreshing vehicle data: $error');
    }
  }

  // ==================== ONLINE STATUS PERSISTENCE ====================
  Future<void> _saveOnlineStatusToPrefs(bool isOnline) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("driver_is_online", isOnline);
      AppLogger.d('💾 Online status saved to SharedPreferences: $isOnline');
    } catch (error) {
      AppLogger.d('❌ Error saving online status to prefs: $error');
    }
  }

  Future<void> _saveRideStateToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("is_ride_in_progress", _isRideInProgress);
      await prefs.setString("active_ride_id", _activeRideId ?? "");
      AppLogger.d(
        '💾 [SocketManager] Saved ride state to prefs: isRideInProgress=$_isRideInProgress, activeRideId=$_activeRideId',
      );
    } catch (e) {
      AppLogger.d('❌ [SocketManager] Error saving ride state: $e');
    }
  }

  Future<void> _restoreOnlineStatus() async {
    try {
      // Only attempt restoration once per app session
      if (_hasAttemptedRestoration) {
        AppLogger.d(
          '✅ Restoration already attempted this session, skipping...',
        );
        return;
      }

      _hasAttemptedRestoration = true;
      isRestorationInProgress = true;

      final prefs = await SharedPreferences.getInstance();

      // ✅ Restore ride state FIRST
      _isRideInProgress = prefs.getBool("is_ride_in_progress") ?? false;
      _activeRideId = prefs.getString("active_ride_id");
      if (_isRideInProgress) {
        AppLogger.d('🔄 Restoring active ride state: ID=$_activeRideId');
      }

      final wasOnline = prefs.getBool("driver_is_online") ?? false;

      if (wasOnline) {
        AppLogger.d('🔄 Restoring online status from prefs...');
        // Wait for socket to be ready before going online
        int retries = 0;
        while (!_isSocketConnected && retries < 10) {
          await Future.delayed(const Duration(milliseconds: 200));
          retries++;
        }

        if (_isSocketConnected) {
          AppLogger.d('✅ Socket connected, restoring online status...');
          await goOnline();
        } else {
          AppLogger.d(
            '⚠️ Socket not connected, but user was online - marking as ready',
          );
          isOnDuty = true;
        }
      } else {
        // Ensure service is stopped if we are offline
        AppLogger.d(
          '✅ [SocketManager] Driver is offline, ensuring service is stopped',
        );
        await _stopNativeService();
      }

      isRestorationInProgress = false;
    } catch (error) {
      AppLogger.d('❌ Error restoring online status: $error');
      isRestorationInProgress = false;
    }
  }

  // ==================== LOCATION ====================
  Future<void> _getInitialLocation() async {
    try {
      // Check if app is ready for location requests
      if (!_isAppReady) {
        AppLogger.d('⏳ App not ready yet, using cached location if available');
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

      AppLogger.d('✅ Initial location: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      AppLogger.d('⚠️ Quick location failed: $e');
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _currentLatitude = lastPosition.latitude;
          _currentLongitude = lastPosition.longitude;
          AppLogger.d(
            '📍 Using last known location: $_currentLatitude, $_currentLongitude',
          );
        } else {
          _currentLatitude = 23.2508131;
          _currentLongitude = 77.4647936;
          AppLogger.d(
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
      AppLogger.d('ℹ️ Location watch already active');
      return;
    }

    AppLogger.d('📍 Starting continuous location watch');

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

            // AppLogger.d('📍 Location updated: $_currentLatitude, $_currentLongitude');
          },
          onError: (error) {
            AppLogger.d('⚠️ Location watch error: $error');
          },
        );
  }

  void stopLocationWatch() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
      AppLogger.d('⏹️ Stopped location watch');
    }
  }

  // ==================== SOCKET CONNECTION ====================
  Future<bool> connectSocket() async {
    AppLogger.d("🔄 Connecting socket...");

    try {
      if (_socket != null && _isSocketConnected) {
        AppLogger.d('✅ Socket already connected');
        return true;
      }

      // Disconnect existing socket object but keep online state alive
      _cleanupSocketConnection();

      AppLogger.d('🔌 Creating socket connection...');

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
      AppLogger.d('❌ Socket connection error: $error');
      return false;
    }
  }

  Future<bool> _waitForConnection() async {
    final completer = Completer<bool>();

    final timeout = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        AppLogger.d('❌ Connection timeout');
        completer.complete(false);
      }
    });

    _socket!.once('connect', (_) {
      timeout.cancel();
      if (!completer.isCompleted) {
        AppLogger.d('✅ Socket connected!');
        completer.complete(true);
      }
    });

    _socket!.once('connect_error', (error) {
      timeout.cancel();
      if (!completer.isCompleted) {
        AppLogger.d('❌ Connection error: $error');
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
        AppLogger.d(
          '[SOCKET RECEIVED] $event: ${data != null ? jsonEncode(data).substring(0, data.toString().length > 100 ? 100 : data.toString().length) : "No data"}',
        );
      }
    });

    // CONNECTION EVENTS
    _socket!.onConnect((_) {
      AppLogger.d('✅ Driver socket connected: ${_socket!.id}');
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
      AppLogger.d('❌ Driver socket disconnected');
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
      AppLogger.d('❌ Socket connection error: $data');
      onSocketError?.call({'error': data.toString(), 'type': 'connect_error'});
    });

    _socket!.onReconnect((data) {
      AppLogger.d('🔄 Socket reconnected after $data attempts');
      _isSocketConnected = true;
      _socketStatus = 'Connected';
      _cancelReconnect();
      onConnectionStatusChange?.call(true);

      // Re-emit online status and restart location after reconnect
      if (isOnDuty) {
        AppLogger.d(
          '🔄 [Reconnect] Driver is on duty — re-emitting user:online',
        );
        goOnline();
      }
    });

    // DRIVER STATUS EVENTS
    _socket!.on('driver:online_success', (data) {
      AppLogger.d('✅ Driver online confirmed: $data');
      _handleOnlineSuccess(data);
    });

    _socket!.on('driver:online_failed', (data) {
      AppLogger.d('❌ Driver online failed: $data');
      _handleOnlineFailure(data);
    });

    // RIDE REQUEST EVENTS
    _socket!.on('ride:newRide', (data) {
      final rideData = _mapRideData(data);

      // Pretty print the full ride request data
      AppLogger.d('🚕 NEW RIDE REQUEST RECEIVED: $rideData');

      // Convert rideData to JSON with pretty formatting
      final prettyJson = JsonEncoder.withIndent('  ').convert(rideData);
      prettyJson.split('\n').forEach((line) {
        AppLogger.d('║ $line');
      });

      if (!isOnDuty) {
        AppLogger.d('⚠️ Received ride request but driver is offline');
        return;
      }

      _lastRideData = rideData;
      _hasPendingRideRequest = true;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('last_ride_request', jsonEncode(data));
      });

      final queue = Get.isRegistered<RideRequestQueueController>()
          ? Get.find<RideRequestQueueController>()
          : Get.put(RideRequestQueueController(), permanent: true);

      queue.addOrUpdateRide(rideData);

      // Navigate once to the queue screen; subsequent rides just stack as cards.
      Future.microtask(() {
        if (!isOnDuty || !_hasPendingRideRequest) return;
        if (queue.isQueueScreenOpen.value) return;
        AppLogger.d('🧾 [RideQueue] Opening RideRequestQueueScreen (newRide)');
        Get.to(() => const RideRequestQueueScreen());
      });

      // Trigger heads-up notification for background/lock screen
      NotificationService.instance.showRideRequestNotification(rideData);

      onNewRide?.call(rideData);
    });

    // NOTE: ride:orderCancelled is fully handled below (line ~915).
    // The duplicate empty handler that was here has been removed.

    _socket!.on('ride:confirmed', (data) async {
      AppLogger.d(">>>>>>>>> [SOCKET] Ride Confirmed");

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

      AppLogger.d("✅ Ride Data Stored Successfully");

      // =====================================================
      // 🔄 READ AGAIN FROM SHARED PREFERENCES (Verification)
      // =====================================================

      final storedRideString = prefs.getString('active_ride_full_data');

      AppLogger.d("📦 Stored Ride Data From Prefs: $storedRideString");

      if (storedRideString != null) {
        final storedRideMap =
            jsonDecode(storedRideString) as Map<String, dynamic>;

        AppLogger.d("🚗 Stored Order ID: ${storedRideMap['orderId']}");
        AppLogger.d(
          "👤 Stored Profile Image: ${storedRideMap['rider']?['profileImage']}",
        );
        AppLogger.d("💰 Stored Fare: ${storedRideMap['fare']}");
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

      // Clear any queued offers once a ride is confirmed.
      if (Get.isRegistered<RideRequestQueueController>()) {
        Get.find<RideRequestQueueController>().clearAll(reason: 'ride_confirmed');
      }
    });

    _socket!.on('ride:status', (data) {
      AppLogger.d('📊 Ride status update: $data');

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
          AppLogger.d('✅ Ride end status received: $status');
          _completeRide(orderId, isStatusCompleted: status == 'completed');
        }
      }

      onRideStatusUpdate?.call(data);
    });

    _socket!.on('ride:orderCancelled', (data) {
      AppLogger.d("myyyy_cancelledddddd2>>>>>");

      AppLogger.d("my_cancelledddd_full_datatattt ${data}");
      AppLogger.d('❌ Ride cancelled: $data');

      // Block any pending ride:newRide microtask from navigating after cancel
      _hasPendingRideRequest = false;

      // Ensure any looping background ringtone shuts off if driver hasn't touched the screen
      NotificationService.instance.cancelRideNotification();

      // FIX: Use rideId instead of orderId
      final rideId = data['rideId'] ?? data['orderId'];

      final rideIdStr = rideId?.toString() ?? '';
      if (rideIdStr.isEmpty) {
        AppLogger.d('⚠️ No valid rideId found in cancellation data');
        return;
      }

      // If it's a queued ride (not active), just remove from queue.
      if (Get.isRegistered<RideRequestQueueController>()) {
        final queue = Get.find<RideRequestQueueController>();
        if (queue.findByOrderId(rideIdStr) != null) {
          AppLogger.i('🧾 [RideQueue] orderCancelled for queued orderId=$rideIdStr → removing card');
          queue.removeRide(rideIdStr, reason: 'orderCancelled');
          return;
        }
      }

      // Otherwise treat as active ride cancellation (existing behavior).
      _completeRide(rideIdStr);
      _currentRide = null;
      onRideCancelled?.call(data);
      Get.offAll(() => BottomnavmainScreen(isOnDuty: true));
    });

    _socket!.on('ride:location', (data) {
      // AppLogger.d('📍 Rider location during ride: $data');
      onRideLocationUpdate?.call(data);
    });

    _socket!.on('ride:reconnected', (data) async {
      AppLogger.d('>>>>>>>>>>> Reconnected to active ride: $data');

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
        AppLogger.d('💾 Reconnected ride data saved to SharedPreferences');
      } catch (e) {
        AppLogger.d('⚠️ Error saving reconnected ride data: $e');
      }

      onRideReconnected?.call(fullRideData);

      // Handle reconnection navigation and step setup
      _handleRideReconnection(fullRideData, orderStatus);
    });

    // _socket!.on('chat:history', (data) {
    //   AppLogger.d('>>>>>>>>>>> Chat history: $data');

    //   // _currentRide = {
    //   //   'orderId': data['orderId'],
    //   //   'status': data['orderStatus'] ?? data['status'],
    //   // };

    //   // onRideReconnected?.call(data);
    // });

    // CHAT EVENTS
    _socket!.on('chat:join_success', (data) {
      AppLogger.d('✅ Joined chat room: $data');
      onChatJoin?.call({'success': true, 'data': data});
    });

    _socket!.on('chat:join_error', (data) {
      AppLogger.d('❌ Chat join error: $data');
      onChatError?.call(data);
    });

    // Listen to both possible event names for maximum compatibility
    _socket!.on('chat:receiveMessage', (data) {
      AppLogger.d('💬 New chat message received (chat:receiveMessage): $data');
      onChatMessage?.call(data);
      _chatMessageStreamController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('chat:message', (data) {
      AppLogger.d('💬 New chat message received (chat:message): $data');
      onChatMessage?.call(data);
      _chatMessageStreamController.add(Map<String, dynamic>.from(data));
    });

    _socket!.on('chat:message_sent', (data) {
      AppLogger.d('✅ Message sent successfully: $data');
      onChatMessageSent?.call(data);
    });

    _socket!.on('chat:typing', (data) {
      AppLogger.d('✍️ User is typing: $data');
      onChatTyping?.call(data);
    });

    _socket!.on('chat:error', (data) {
      AppLogger.d('❌ Chat error: $data');
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
    } else if (rideData['startLocation'] != null &&
        rideData['startLocation']['coordinates'] != null) {
      final coords = rideData['startLocation']['coordinates'];
      if (coords is List && coords.length >= 2) {
        // Assume [lat, lng] or [lng, lat] handles below, but here we just need to preserve them
        // usually backend sends [lat, lng] or GeoJSON [lng, lat]
        // The _extractCoordinates handles the order, we'll just store as Map to let the fallback handle it
        // Or store it nicely. For simplicity, just read [0] and [1] assuming [lat, lng] like before,
        // to populate pickupCoords so it gets converted nicely
        pickupCoords = {
          'latitude': double.parse(coords[0].toString()),
          'longitude': double.parse(coords[1].toString()),
        };
      } else if (coords is Map) {
        if (coords['latitude'] != null && coords['longitude'] != null) {
          pickupCoords = {
            'latitude': double.parse(coords['latitude'].toString()),
            'longitude': double.parse(coords['longitude'].toString()),
          };
        }
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
    } else if (rideData['endLocation'] != null &&
        rideData['endLocation']['coordinates'] != null) {
      final coords = rideData['endLocation']['coordinates'];
      if (coords is List && coords.length >= 2) {
        dropoffCoords = {
          'latitude': double.parse(coords[0].toString()),
          'longitude': double.parse(coords[1].toString()),
        };
      } else if (coords is Map) {
        if (coords['latitude'] != null && coords['longitude'] != null) {
          dropoffCoords = {
            'latitude': double.parse(coords['latitude'].toString()),
            'longitude': double.parse(coords['longitude'].toString()),
          };
        }
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
      // Store coordinates as [latitude, longitude] List so _extractCoordinates()
      // in accepted_screen.dart can parse them with the standard index-based logic.
      'startLocation': {
        'address': pickupAddress,
        'coordinates': pickupCoords != null
            ? [pickupCoords['latitude'], pickupCoords['longitude']]
            : null,
      },
      'endLocation': {
        'address': dropAddress,
        'coordinates': dropoffCoords != null
            ? [dropoffCoords['latitude'], dropoffCoords['longitude']]
            : null,
      },
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
    AppLogger.d('🟢 GOING ONLINE...');

    if (_isProcessingOnline) {
      AppLogger.d('⏳ Already processing...');
      return;
    }

    _isProcessingOnline = true;

    // Notify UI to show loading state
    onDriverStatusChange?.call(isOnDuty);

    try {
      // If socket is not connected, try to reconnect first
      if (_socket == null || !_isSocketConnected) {
        AppLogger.d('⚠️ Socket not connected, attempting to reconnect...');

        final reconnected = await connectSocket();

        if (!reconnected) {
          AppLogger.d('❌ Failed to reconnect socket');
          _handleOnlineFailure(
            'Failed to connect to server. Please check your internet connection.',
          );
          return;
        }

        AppLogger.d('✅ Socket reconnected successfully');

        // Wait a bit for socket to stabilize
        await Future.delayed(const Duration(milliseconds: 500));
      }

      AppLogger.d(
        '📍 Using current location: $_currentLatitude, $_currentLongitude',
      );

      // Debug print to show what vehicle data we have
      AppLogger.d('🚗 Vehicle Type ID: $_vehicleType');
      AppLogger.d('🚗 Vehicle ID: $_vehicleNumber');

      // Check if we have required vehicle data (vehicleSubType is optional)
      if (_vehicleType == null || _vehicleNumber == null) {
        AppLogger.d('⚠️ Missing vehicle data! Trying to load from prefs...');
        await refreshVehicleData();

        if (_vehicleType == null || _vehicleNumber == null) {
          AppLogger.d('⚠️ Still missing data. Attempting to fetch from API...');
          try {
            await HomeApiServices.get_driverid_data();
            await refreshVehicleData();

            if (_vehicleType == null || _vehicleNumber == null) {
              AppLogger.d(
                '❌ Still missing vehicle data after API fetch. Cannot go online.',
              );
              _handleOnlineFailure(
                'Vehicle data not found. Please complete your vehicle registration.',
              );
              return;
            }
          } catch (e) {
            AppLogger.d(
              "❌ Error fetching driver data during online attempt: $e",
            );
            _handleOnlineFailure('Failed to fetch vehicle details.');
            return;
          }
        }
      }

      // Log if vehicleSubType is missing (non-blocking)
      if (_vehicleType2 == null) {
        AppLogger.d('⚠️ vehicleSubType is null - proceeding without it');
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

      AppLogger.d("vehical_type_coming>>>  ${_vehicleType}");
      AppLogger.d("vehical_subtyp[e_coming>>>  ${_vehicleType2}");
      AppLogger.d('>>>>>>   Emitting user:online: $payload');
      _socket!.emit('user:online', payload);

      // Start location updates
      _startLocationUpdates();
      startLocationWatch();

      // START NATIVE FOREGROUND SERVICE (keeps app alive in background)
      AppLogger.d('🚀 [SocketManager] Starting Native Foreground Service...');

      // ✅ CRITICAL FIX: Save online status to SharedPreferences IMMEDIATELY before starting the native service.
      // If we wait for the backend's 'driver:online_success' to save this, the native Android service
      // starts up, checks 'flutter.driver_is_online', sees false, and instantly commits suicide (stopSelf()).
      isOnDuty = true;
      await _saveOnlineStatusToPrefs(true);

      await _startNativeService();

      // Native SocketForegroundService handles killed-state socket via Kotlin

      // START APP KEEP-ALIVE (isolated try-catch)
      // try {
      //   AppLogger.d('🚀 [SocketManager] Enabling FlutterBackground keep-alive...');
      //   bool hasPermissions = await bg_lib.FlutterBackground.hasPermissions;

      //   if (!hasPermissions) {
      //     AppLogger.d(
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
      //     AppLogger.d(
      //       '✅ [SocketManager] FlutterBackground execution enabled: $enabled',
      //     );
      //   } else {
      //     AppLogger.d(
      //       '❌ [SocketManager] FlutterBackground permissions still missing after init attempt',
      //     );
      //   }
      // } catch (bgKeepAliveError) {
      //   AppLogger.d(
      //     '⚠️ [SocketManager] FlutterBackground keep-alive failed (non-fatal): $bgKeepAliveError',
      //   );
      // }

      // START ADVANCED GEOLOCATION TRACKING
      try {
        AppLogger.d(
          '🚀 [SocketManager] Starting Native Geolocation Tracking...',
        );
        // await bg.BackgroundGeolocation.start();
        AppLogger.d('✅ [SocketManager] Native Geolocation Tracking started');
      } catch (geoError) {
        AppLogger.d(
          '⚠️ [SocketManager] Geolocation start failed (non-fatal): $geoError',
        );
      }

      AppLogger.d('🟢 [SocketManager] Driver online request sent successfully');
    } catch (error) {
      AppLogger.d('❌ Error going online: $error');
      _handleOnlineFailure('Error: $error');
    }
  }

  Future<void> goOffline() async {
    AppLogger.d('🔴 GOING OFFLINE...');

    // Stop any looping ride request sounds
    NotificationService.instance.cancelRideNotification();

    AppLogger.d("hellooooo222 ${_isProcessingOnline}");
    if (_isProcessingOnline) return;
    AppLogger.d("hellooooo3333 ${_isProcessingOnline}");
    // _isProcessingOnline = true;
    AppLogger.d("hellooooo4444 ${_isProcessingOnline}");

    // Notify UI to show loading state
    onDriverStatusChange?.call(isOnDuty);

    try {
      // Emit offline event before disconnecting
      if (_socket != null && _isSocketConnected) {
        AppLogger.d('🔴 Emitting offline status...');

        final payload = {
          'driverId': _driverId,
          'timestamp': DateTime.now().toIso8601String(),
        };
        _socket!.emit('driver:offline', payload);
        AppLogger.d('📡 Emitted driver:offline event: $payload');

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
      AppLogger.d("hellooooo5555");

      // Save offline status to SharedPreferences
      await _saveOnlineStatusToPrefs(false);

      onDriverStatusChange?.call(false);
      AppLogger.d("hellooooo6666");

      // Disconnect socket (this will also stop location updates)
      _disconnectSocket();
      AppLogger.d("hellooooo7777");

      AppLogger.d("hellooooo7777");
      // Native SocketForegroundService is stopped via _stopNativeService() below
      // And we already called _saveOnlineStatusToPrefs(false) above

      // STOP FOREGROUND SERVICE
      AppLogger.d('🛑 Stopping Native Foreground Service...');
      await _stopNativeService();

      // STOP APP KEEP-ALIVE
      AppLogger.d(
        '🛑 [SocketManager] Disabling FlutterBackground keep-alive...',
      );
      try {
        // await bg_lib.FlutterBackground.disableBackgroundExecution();
      } catch (e) {
        AppLogger.d('⚠️ Error disabling background execution: $e');
      }

      // STOP ADVANCED GEOLOCATION TRACKING
      AppLogger.d('🛑 [SocketManager] Stopping Native Geolocation Tracking...');
      // await bg.BackgroundGeolocation.stop();

      AppLogger.d('✅ Driver is now offline and socket disconnected');
    } catch (error) {
      AppLogger.d('❌ Error going offline: $error');
      _isProcessingOnline = false;
      // Notify UI to hide loading state
      onDriverStatusChange?.call(isOnDuty);
    }
  }

  void _handleOnlineSuccess(dynamic data) {
    if (!_isProcessingOnline) return;

    AppLogger.d('✅ DRIVER ONLINE SUCCESS');
    isOnDuty = true;
    _isProcessingOnline = false;

    // Save online status to SharedPreferences
    _saveOnlineStatusToPrefs(true);

    onDriverStatusChange?.call(true);
  }

  void _handleOnlineFailure(dynamic data) {
    if (!_isProcessingOnline) return;

    AppLogger.d('❌ DRIVER ONLINE FAILED');
    isOnDuty = false;
    _isProcessingOnline = false;

    // Stop foreground service if online attempt failed
    _saveOnlineStatusToPrefs(false);
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

      AppLogger.d("📍 [RIDE-MODE] my_ride_location_payload>>> $ridePayload");
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

        AppLogger.d(
          '📍 [DRIVER-MODE] Sending general driver location update: $_currentLatitude, $_currentLongitude',
        );
        _socket!.emit('driver:location:update', driverPayload);
      } else {
        // Extra safety: we are in a ride, but rideId was missing/empty
        AppLogger.d(
          '⚠️ [SAFETY-BLOCK] Suppressing driver:location:update - Ride is in progress but ID is invalid: "$rideId"',
        );
      }
    }
  }

  void _startLocationUpdates() {
    _stopLocationUpdates();

    AppLogger.d('🔄 Starting location update broadcasts every 3 seconds');

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
      AppLogger.d('⏹️ Stopped location update broadcasts');
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
      AppLogger.d(
        '🔄 [AutoReconnect] Attempt #$attempt in ${delay.inSeconds}s',
      );

      _reconnectTimer = Timer(delay, () async {
        if (!isOnDuty || _isSocketConnected) return;

        AppLogger.d('🔌 [AutoReconnect] Trying to reconnect...');
        final connected = await connectSocket();
        if (connected && isOnDuty) {
          AppLogger.d(
            '✅ [AutoReconnect] Reconnected — re-emitting user:online',
          );
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
      AppLogger.d('🚀 [SocketManager] Accepting ride from memory: $orderId');
      acceptRide(_lastRideData!);
    } else {
      AppLogger.d(
        '🔍 [SocketManager] Memory check failed for $orderId, checking SharedPreferences...',
      );
      try {
        final prefs = await SharedPreferences.getInstance();
        final lastRideJson = prefs.getString('last_ride_request');
        if (lastRideJson != null) {
          final rideDataRaw = jsonDecode(lastRideJson);
          final rideDataMapped = _mapRideData(rideDataRaw);

          if (rideDataMapped['orderId'] == orderId) {
            AppLogger.d(
              '🚀 [SocketManager] Accepting ride from SharedPreferences: $orderId',
            );
            _lastRideData = rideDataMapped;

            // ✅ Wait for socket to be connected before emitting accept
            if (!_isSocketConnected) {
              AppLogger.d(
                '⏳ Socket not connected, waiting for connection before accepting ride...',
              );
              int retries = 0;
              while (!_isSocketConnected && retries < 15) {
                await Future.delayed(const Duration(milliseconds: 500));
                retries++;
              }
            }

            if (_isSocketConnected) {
              // 1. Call API to properly accept the ride so the backend notifies the rider
              try {
                final response = await HomeApiServices.order_update_data(
                  orderstatus: "Accepted",
                  orderid: orderId,
                );

                if (response.success == true) {
                  AppLogger.d(
                    "✅ [SocketManager] Ride successfully accepted via API!",
                  );

                  // Keep local socket state updated
                  acceptRide(rideDataMapped);

                  // Wait a tick for the backend to process
                  await Future.delayed(const Duration(milliseconds: 300));

                  // Navigate to ArrivingClient
                  _handleRideReconnection(rideDataMapped, 'accepted');
                } else {
                  AppLogger.d(
                    "❌ [SocketManager] Failed to accept ride via API: ${response.message}",
                  );
                  CustomToast.showError(
                    'Failed to accept ride: ${response.message}',
                  );
                }
              } catch (e) {
                AppLogger.d(
                  "❌ [SocketManager] Error accepting ride from API: $e",
                );
                CustomToast.showError(
                  'Connection failed. Please manually check the app.',
                );
              }
            } else {
              AppLogger.d(
                '❌ [SocketManager] Failed to connect socket within timeout. Cannot accept ride.',
              );
              CustomToast.showError(
                'Connection failed. Please accept the ride manually.',
              );
            }
            return;
          }
        }
      } catch (e) {
        AppLogger.d(
          '❌ [SocketManager] Error reading last ride request from prefs: $e',
        );
      }
      AppLogger.d(
        '⚠️ [SocketManager] Could not find ride data for $orderId. Cannot accept from notification.',
      );
    }
  }

  bool acceptRide(Map<String, dynamic> rideData) {
    if (_socket == null || !_isSocketConnected) {
      AppLogger.d('❌ Cannot accept ride - socket not connected');
      return false;
    }

    final orderId =
        rideData['orderId'] ??
        rideData['_id'] ??
        rideData['id'] ??
        rideData['rideId'];

    if (orderId == null) {
      AppLogger.d('❌ No order ID found in ride data');
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

    AppLogger.d('✅ Ride marked as IN PROGRESS (ID: $orderId)');
    _saveRideStateToPrefs(); // Persistence for background isolate synchronization
    AppLogger.d('✅ Emitting ride:accept: $payload');
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

    AppLogger.d('❌ Declining ride: $payload');
    _socket!.emit('ride:decline', payload);

    // Ensure we return to general location updates
    _isRideInProgress = false;
    _activeRideId = null;
    _currentRide = null;
    _saveRideStateToPrefs(); // Reset state for background isolate

    return true;
  }

  void _completeRide(String? rideId, {bool isStatusCompleted = false}) {
    if (rideId != null && rideId.isNotEmpty) {
      if (_activeRideId == rideId) {
        AppLogger.d('✅ Ride completed (ID: $rideId)');
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

        if (!isStatusCompleted) {
          // Clear persisted ride data
          clearPersistedRide();
        }
      }
    } else {
      AppLogger.d('⚠️ Invalid rideId provided to _completeRide');
    }
  }

  // ==================== RIDE RECONNECTION ====================
  void _handleRideReconnection(
    Map<String, dynamic> rideData,
    String orderStatus,
  ) {
    try {
      AppLogger.d('🔄 Handling ride reconnection with status: $orderStatus');

      // Determine the step based on order status
      final step = _getStepFromOrderStatus(orderStatus);
      AppLogger.d('📍 Setting active step to: $step for status: $orderStatus');

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

      AppLogger.d('✅ Navigated to ArrivingClient screen');
    } catch (e) {
      AppLogger.d('❌ Error handling ride reconnection: $e');
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
        AppLogger.d(
          '⚠️ Unknown order status: $orderStatus, defaulting to step 0',
        );
        return 0;
    }
  }

  // ==================== CHAT FUNCTIONALITY ====================
  bool joinChatRoom(String orderId, {String userRole = 'driver'}) {
    if (_socket == null || !_isSocketConnected) {
      AppLogger.d('❌ Cannot join chat - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      'userRole': userRole,
      'userId': _driverId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    AppLogger.d('💬 Joining chat room: $payload');
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
      AppLogger.d('❌ Cannot send message - socket not connected');
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

    AppLogger.d('💬 Sending message: $payload');

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

    AppLogger.d('💬 Requesting chat history for: $orderId');
    _socket!.emit('chat:getHistory', {'orderId': orderId});
    return true;
  }

  bool leaveChatRoom(String orderId) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    AppLogger.d('💬 Leaving chat room: $orderId');
    _socket!.emit('chat:leave', {'orderId': orderId});
    return true;
  }

  void _joinRideRoom(String rideId) {
    if (_socket != null && _isSocketConnected) {
      final roomName = 'ride:$rideId';
      _socket!.emit('join:room', {'roomName': roomName});
      AppLogger.d('✅ Joined ride room: $roomName');
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
        'riderName': rideData['riderName']?.toString() ?? 'Riderr',
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
      AppLogger.d('💾 Active ride saved to storage: ${activeRide['orderId']}');
      return true;
    } catch (error) {
      AppLogger.d('❌ Failed to save active ride: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getPersistedRide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? activeRideJson = prefs.getString('activeRide');

      if (activeRideJson != null) {
        final activeRide = jsonDecode(activeRideJson) as Map<String, dynamic>;
        AppLogger.d('📂 Found persisted ride: ${activeRide['orderId']}');

        // Check if ride data is not too old (max 4 hours)
        final savedAt = DateTime.parse(activeRide['savedAt']);
        final now = DateTime.now();
        final hoursDiff = now.difference(savedAt).inHours;

        if (hoursDiff > 4) {
          AppLogger.d('⚠️ Persisted ride is too old, clearing');
          await clearPersistedRide();
          return null;
        }

        return activeRide;
      }

      return null;
    } catch (error) {
      AppLogger.d('❌ Failed to get persisted ride: $error');
      return null;
    }
  }

  Future<bool> clearPersistedRide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('activeRide');
      await prefs.remove('pending_payment_ride');
      AppLogger.d('🗑️ Cleared persisted ride data');
      return true;
    } catch (error) {
      AppLogger.d('❌ Failed to clear persisted ride: $error');
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
        AppLogger.d('📝 Updated persisted ride screen to: $screen');
      }
    } catch (error) {
      AppLogger.d('❌ Failed to update persisted ride screen: $error');
    }
  }

  // ==================== LISTENER MANAGEMENT ====================
  void addEventListener(String event, Function(dynamic) callback) {
    if (!_socketListeners.containsKey(event)) {
      _socketListeners[event] = [];
    }
    _socketListeners[event]!.add(callback);
    AppLogger.d('✅ Added listener for: $event');
  }

  void removeEventListener(String event, Function(dynamic) callback) {
    if (_socketListeners.containsKey(event)) {
      final callbacks = _socketListeners[event]!;
      final index = callbacks.indexOf(callback);
      if (index > -1) {
        callbacks.removeAt(index);
        AppLogger.d('❌ Removed listener for: $event');
      }
    }
  }

  // ==================== UTILITY METHODS ====================
  void _disconnectSocket() {
    // Don't disconnect if ride is in progress
    if (_isRideInProgress && _activeRideId != null) {
      AppLogger.d(
        '⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.',
      );
      return;
    }

    stopLocationWatch();
    _stopLocationUpdates();

    _cleanupSocketConnection();

    _isSocketConnected = false;
    _socketId = null;
    isOnDuty = false;

    onConnectionStatusChange?.call(false);
    onDriverStatusChange?.call(false);

    AppLogger.d('🔌 Driver socket disconnected and driver is offline');
  }

  /// Disposes of the internal socket physics without altering
  /// high-level online state (`isOnDuty`, `_isRideInProgress`).
  void _cleanupSocketConnection() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  /// Instantly forces a socket reconnection if the driver is online.
  /// Typically called when network connectivity is restored.
  Future<void> forceReconnect() async {
    if (!isOnDuty) return;

    AppLogger.d('⚡ [SocketManager] Forcing immediate socket reconnection...');
    _cancelReconnect(); // Cancel backoff timers

    final connected = await connectSocket();
    if (connected && isOnDuty) {
      AppLogger.d(
        '✅ [SocketManager] Force reconnect successful - re-emitting user:online',
      );
      await goOnline();
    } else {
      AppLogger.d(
        '⚠️ [SocketManager] Force reconnect failed. Falling back to retry loop.',
      );
      if (isOnDuty) {
        _scheduleReconnect();
      }
    }
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
    AppLogger.d('🔍 === DRIVER SOCKET DEBUG ===');
    AppLogger.d('Connected: $_isSocketConnected');
    AppLogger.d('Socket ID: $_socketId');
    AppLogger.d('Driver ID: $_driverId');
    AppLogger.d('On Duty: $isOnDuty');
    AppLogger.d('Current Ride: $_currentRide');
    AppLogger.d('Ride In Progress: $_isRideInProgress');
    AppLogger.d('Active Ride ID: $_activeRideId');
    AppLogger.d('Location: $_currentLatitude, $_currentLongitude');
    AppLogger.d('Vehicle Type: $_vehicleType');
    AppLogger.d('Vehicle ID: $_vehicleNumber');
    AppLogger.d('==============================');
  }

  // Cleanup - Only call this on actual logout/app termination, NOT on screen navigation
  void dispose() {
    AppLogger.d('🔌 Disposing SocketManager (full cleanup)');
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
      AppLogger.d('🚪 Logging out driver...');

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

      AppLogger.d('✅ All data cleared on logout');
    } catch (error) {
      AppLogger.d('❌ Error during logout: $error');
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
