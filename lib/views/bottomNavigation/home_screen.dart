import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:corezap_driver/controllers/controllers.dart';
import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/map_helper.dart';
import 'package:corezap_driver/views/book_ride/book_ride.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:corezap_driver/views/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.find<HomeController>();
  final StepperController stepperController = Get.find<StepperController>();

  // Socket instance
  IO.Socket? _socket;
  bool _isSocketConnected = false;
  String? _socketId;

  // Socket configuration
  // static const String SOCKET_URL = 'https://corezap.smarttechbros.com';

  static const String SOCKET_URL = 'https://api.corezap.framekarts.com';

  static const int MAX_RECONNECT_ATTEMPTS = 5;
  static const int CONNECTION_TIMEOUT = 10000;
  static const int LOCATION_UPDATE_INTERVAL = 2000; // 2 seconds
  static const double LOCATION_CHANGE_THRESHOLD = 0.0001; // ~11 meters

  // Driver data
  String? _driverId;
  String? _driverName;
  String? _driverPhone;
  String? _driverImage;
  String? _vehicleType;
  String? _vehicleNumber;
  String? _vehicleImage;
  String? _fleetId;

  // Location
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  double? _lastSentLatitude;
  double? _lastSentLongitude;
  DateTime? _lastLocationUpdate;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;

  // Driver status
  bool _isOnDuty = false;
  bool _isProcessingOnline = false;
  bool _isRideInProgress = false;
  bool _isAppReady = false;
  bool _permissionCheckInProgress = false;

  // Ride tracking
  Map<String, dynamic>? _currentRide;
  String? _activeRideId;
  DateTime? _rideStartTime;

  // App lifecycle state
  AppLifecycleState? _appLifecycleState;
  bool _appInBackground = false;
  DateTime? _appBackgroundTime;
  String _selectedTab = "Driver";

  // Ride variables
  Map<String, dynamic>? _newRideRequest;
  bool _hasPendingRideRequest = false;
  Timer? _rideRequestTimer;

  // Reconnection tracking
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  Timer? _backgroundReconnectTimer;

  // Map variables
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(23.2508131, 77.4647936),
    zoom: 17,
  );
  late GoogleMapController _mapController;

  // Markers and circles
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  BitmapDescriptor? _bikeMarkerIcon;

  // Nearby riders/drivers
  List<Map<String, dynamic>> _nearbyRiders = [];
  Map<String, BitmapDescriptor> _vehicleIcons = {};

  // Event listeners storage
  final Map<String, List<Function(dynamic)>> _socketListeners = {};

  // Token
  String? _token;
  String? _userId;
  String _socketStatus = 'Not Connected';

  @override
  void initState() {
    homeController.home_data_method();
    super.initState();

    // Add observer for app lifecycle
    WidgetsBinding.instance.addObserver(this);

    // Initialize connection
    _initializeConnection();
  }

  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);

    // Clean up resources
    _cleanupResources();

    // Disconnect socket
    _disconnectSocket();

    super.dispose();
  }

  void _cleanupResources() {
    // Clear all timers
    _clearRideRequestTimer();
    _stopBackgroundReconnectTimer();
    _stopLocationWatch();
    _stopLocationUpdates();

    // Cancel position stream
    _positionStreamSubscription?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 App lifecycle changed: $state');

    setState(() {
      _appLifecycleState = state;
    });

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
        _onAppInactive();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
      case AppLifecycleState.hidden:
        _onAppHidden();
        break;
    }
  }

  void _onAppResumed() {
    print('📱 App resumed from background');

    if (_appInBackground) {
      _appInBackground = false;

      // Stop background reconnect timer
      _stopBackgroundReconnectTimer();

      // Mark app as ready for location requests
      _isAppReady = true;

      // Check connection status
      if (_isSocketConnected && _isOnDuty) {
        print('✅ Socket still connected, resuming operations...');
      } else if (_isOnDuty) {
        // Was on duty but disconnected, try to reconnect
        print('⚠️ Socket disconnected while in background, reconnecting...');
        _reconnectWithRetry();
      }

      _appBackgroundTime = null;
    }
  }

  void _onAppPaused() {
    print('📱 App going to background');

    _appInBackground = true;
    _appBackgroundTime = DateTime.now();

    // Clear pending ride request
    _clearPendingRideRequest();

    // If we're online, set up background reconnect attempts
    if (_isOnDuty) {
      _startBackgroundReconnectTimer();
    }
  }

  void _onAppInactive() {
    print('📱 App inactive (between states)');
  }

  void _onAppDetached() {
    print('📱 App detached (destroyed)');
    _cleanupResources();
  }

  void _onAppHidden() {
    print('📱 App hidden');
    _appInBackground = true;
  }

  Future<void> _initializeConnection() async {
    // Request permissions
    await _requestPermissions();

    // Load custom bike marker and vehicle icons
    await _loadCustomBikeMarker();
    await _loadVehicleIcons();

    // Get initial location IMMEDIATELY (no waiting)
    await _getInitialLocationImmediately();

    // Start background location listener
    _startBackgroundLocationListener();

    // Wait for token to load
    await _getToken();

    // Then connect socket with valid token
    if (_token != null && _driverId != null && _driverId!.isNotEmpty) {
      await _connectSocket();
    } else {
      print('❌ Cannot connect: Token or Driver ID is missing');
      _showToast('Failed to load credentials');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Request location service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location service disabled');
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permission permanently denied');
        return;
      }

      if (permission == LocationPermission.denied) {
        print('⚠️ Location permission denied');
        return;
      }

      print('✅ Location permission granted');

      // Request notification permission (if needed)
      final notificationStatus = await Permission.notification.request();
      if (notificationStatus.isGranted) {
        print('✅ Notification permission granted');
      }

      // Mark app as ready
      _isAppReady = true;
    } catch (error) {
      print('❌ Error requesting permissions: $error');
    }
  }

  // New method: Get initial location without starting stream
  Future<void> _getInitialLocationImmediately() async {
    try {
      // Check if we already have location
      if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
        print(
          '✅ Using existing location: $_currentLatitude, $_currentLongitude',
        );
        return;
      }

      // Get quick location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Use medium for speed
        timeLimit: const Duration(seconds: 3), // Short timeout
      );

      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
      _lastLocationUpdate = DateTime.now();

      print(
        '✅ Initial location obtained (quick): $_currentLatitude, $_currentLongitude',
      );

      // Update marker immediately
      if (mounted) {
        _updateMarkerOnly(
          LatLng(_currentLatitude, _currentLongitude),
          50.0, // Default accuracy
        );
      }
    } catch (e) {
      print('⚠️ Quick location failed: $e');
      // Try to get last known location as fallback
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _currentLatitude = lastPosition.latitude;
          _currentLongitude = lastPosition.longitude;
          print(
            '📍 Using last known location: $_currentLatitude, $_currentLongitude',
          );
        } else {
          // Default location if everything fails
          _currentLatitude = 23.2508131;
          _currentLongitude = 77.4647936;
          print(
            '📍 Using default location: $_currentLatitude, $_currentLongitude',
          );
        }
      } catch (e) {
        print('⚠️ Could not get last known position: $e');
        _currentLatitude = 23.2508131;
        _currentLongitude = 77.4647936;
      }
    }
  }

  Future<void> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");
      final String? userId = prefs.getString("driver_userid");

      setState(() {
        _token = token;
        _userId = userId;
        _driverId = userId;
      });

      print('✅ Token loaded from SharedPreferences');
      print('User ID: $_userId');
      print(
        "myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...",
      );
      print("myyyy_driverid>>> ${_driverId}");
    } catch (e) {
      print('❌ Error loading token: $e');
    }
  }

  // ==================== SOCKET METHODS ====================

  Future<bool> _connectSocket() async {
    print("🔄 Connecting socket...");

    try {
      if (_socket != null && _isSocketConnected) {
        print('✅ Socket already connected');
        return true;
      }

      // Get driver data
      await _fetchDriverData();

      // Disconnect existing
      _disconnectSocket();

      print('🔌 Connecting driver socket...');

      // Create socket connection with optimized settings
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

      // Wait for connection with timeout
      return await _waitForConnection();
    } catch (error) {
      print('❌ Socket connection error: $error');
      return false;
    }
  }

  Future<bool> _waitForConnection() async {
    final completer = Completer<bool>();

    final timeout = Timer(const Duration(seconds: 5), () {
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
        completer.complete(false);
      }
    });

    return completer.future;
  }

  void _setupSocketEventListeners() {
    if (_socket == null) return;

    // CONNECTION EVENTS
    _socket!.onConnect((_) {
      print('✅ Driver socket connected: ${_socket!.id}');
      setState(() {
        _isSocketConnected = true;
        _socketId = _socket!.id;
        _reconnectAttempts = 0;
        _socketStatus = 'Connected';
      });

      // Auto go online if driver was on duty
      if (_isOnDuty) {
        Timer(const Duration(seconds: 1), () {
          _goOnline();
        });
      }
    });

    _socket!.onDisconnect((_) {
      print('❌ Driver socket disconnected');
      setState(() {
        _isSocketConnected = false;
        _socketStatus = 'Disconnected';
      });

      _stopLocationUpdates();
      _clearPendingRideRequest();

      // If we're online and app is active, try to reconnect
      if (_isOnDuty && !_appInBackground && mounted) {
        print('🔄 Online but disconnected, will attempt reconnect...');
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isSocketConnected && _isOnDuty) {
            _reconnectWithRetry();
          }
        });
      }
    });

    _socket!.onConnectError((data) {
      print('❌ Socket connection error: $data');
      _reconnectAttempts++;
      setState(() {
        _socketStatus = 'Connection Error';
      });
    });

    _socket!.onReconnect((data) {
      print('🔄 Socket reconnected');
      setState(() {
        _isSocketConnected = true;
        _socketStatus = 'Reconnected';
        _reconnectAttempts = 0;
      });

      // If we were online, restore status
      if (_isOnDuty) {
        _restoreOnlineStatus();
      }
    });

    // DRIVER STATUS EVENTS
    _socket!.on('driver:online_success', (data) {
      print('✅ Driver online confirmed: ${data}');
      _handleOnlineSuccess(data);
    });

    _socket!.on('driver:online_failed ', (data) {
      print('❌ Driver online failed:${data}');
      _handleOnlineFailure(data);
    });

    // RIDE REQUEST EVENTS
    _socket!.on('ride:newRide', (data) {
      final rideData = _mapRideData(data);
      print('🚕 NEW RIDE REQUEST RECEIVED : ${rideData}');

      // Check if we're online and can accept rides
      if (!_isOnDuty) {
        print('⚠️ Received ride request but driver is offline');
        return;
      }

      // Process the ride request
      _processRideRequest(rideData);
    });

    _socket!.on('ride:orderCancelled', (data) {
      print('userrrr_side____Canceeledddd>>>>>>>>>>>>>>>>: ${data}');
      // _handleOnlineSuccess(data);
    });

    _socket!.on('ride:confirmed', (data) async {
      final prefs = await SharedPreferences.getInstance();

      final orderId = data['orderId'] ?? data['_id'];

      print("🚗 [SOCKET] Ride Confirmed");
      print("📦 Full Ride Data: ${jsonEncode(data)}");

      // ✅ Save FULL backend data
      await prefs.setString('active_ride_full_data', jsonEncode(data));

      // Save order id separately
      await prefs.setString('active_order_id', orderId.toString());

      // App memory state
      _currentRide = Map<String, dynamic>.from(data);
      _activeRideId = orderId.toString();
      _isRideInProgress = true;
      _rideStartTime = DateTime.now();

      // Join socket room
      _joinRideRoom(orderId.toString());

      // Navigate to ride screen
      _navigateToRideScreen(_currentRide!);
    });

    // _socket!.on('ride:confirmed', (data) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final orderId = data['orderId'] ?? data['_id'];

    //   print("myyyyy_ rideee_confimmmed_datata");

    //   print('✅ [SOCKET] Ride accepted - Backend confirmed: $orderId');
    //   print('🚗 [SOCKET] Ride data: ${jsonEncode(data)}');

    //   await prefs.setString("order_id", orderId.toString());

    //   // Update current ride state with complete data
    //   _currentRide = {
    //     'orderId': orderId,
    //     'rideId': data['rideId'] ?? orderId,
    //     'status': 'confirmed',
    //     'rider': data['rider'] ?? data['user'],
    //     'riderId': data['riderId'] ?? data['rider']?['_id'] ?? data['userId'],
    //     'riderName':
    //         data['riderName'] ??
    //         data['rider']?['name'] ??
    //         data['user']?['name'] ??
    //         'Customer',
    //     'riderPhone':
    //         data['riderNumber'] ??
    //         data['rider']?['phone'] ??
    //         data['user']?['phone'] ??
    //         '',
    //     'pickup': data['pickupLocation'] ?? data['startLocation'],
    //     'dropoff': data['dropoffLocation'] ?? data['endLocation'],
    //     'fare': data['fare'] ?? data['totalFare'],
    //     'totalFare': data['totalFare'] ?? data['fare'],
    //     'distance': data['distance'],
    //     'duration': data['duration'] ?? data['estimatedTime'],
    //     'otp': data['otp'],
    //     'rideOtp': data['otp'],
    //     'completeData': data,
    //   };

    //   // Ensure ride is marked as in progress
    //   if (_activeRideId == orderId) {
    //     print('🚗 [SOCKET] Ride confirmation matched active ride');
    //   } else {
    //     print(
    //       '⚠️ [SOCKET] Ride confirmation for different ride, updating active ride',
    //     );
    //     _activeRideId = orderId.toString();
    //     _rideStartTime = DateTime.now();
    //     _isRideInProgress = true;
    //   }

    //   print('🚗 [SOCKET] Ride state updated to CONFIRMED');

    //   // Save ride to persistence
    //   await _saveActiveRide(_currentRide!);

    //   // Join ride room for real-time updates
    //   _joinRideRoom(orderId.toString());

    //   // Navigate to ride screen
    //   _navigateToRideScreen(_currentRide!);
    // });

    _socket!.on('ride:status', (data) {
      print('📊 Ride status update: ${data}');

      final orderId = data['orderId'] ?? data['rideId'];
      if (orderId != null) {
        if (_currentRide != null && _currentRide!['orderId'] == orderId) {
          _currentRide!['status'] = data['status'];
        }

        // Mark ride as complete
        final status = data['status'];
        if (status == 'completed' ||
            status == 'finished' ||
            status == 'ended') {
          print('✅ Ride completion status received: $status');
          _completeRide(orderId);
        }
      }
    });

    _socket!.on('ride:orderCancelled', (data) {
      print('❌ Ride cancelled: ${data}');

      // FIX: Use rideId instead of orderId
      final rideId = data['rideId'] ?? data['orderId'];

      if (rideId != null && rideId is String) {
        _completeRide(rideId);
        _currentRide = null;
        _clearPendingRideRequest();
        _showToast('Ride cancelled');
      } else {
        print('⚠️ No valid rideId found in cancellation data');
      }
    });

    _socket!.on('ride:location', (data) {
      print('📍 Rider location during ride: ${data}');
    });

    _socket!.on('ride:reconnected', (data) {
      print('>>>>>>Reconnected to active ride: ${data}');
      if (mounted) {
        setState(() {
          _currentRide = {
            'orderId': data['orderId'],
            'status': data['orderStatus'] ?? data['status'],
          };
        });
      }
    });

    // CHAT EVENTS
    _socket!.on('chat:join_success', (data) {
      print('✅ Joined chat room: ${data}');
    });

    _socket!.on('chat:join_error', (data) {
      print('❌ Chat join error: ${data}');
    });

    _socket!.on('chat:receiveMessage', (data) {
      print('💬 New chat message received (chat:receiveMessage): ${data}');
    });

    _socket!.on('chat:message', (data) {
      print('💬 New chat message received (chat:message): ${data}');
    });

    _socket!.on('chat:message_sent', (data) {
      print('✅ Message sent successfully: ${data}');
    });

    _socket!.on('chat:typing', (data) {
      print('✍️ User is typing: ${data}');
    });

    _socket!.on('chat:error', (data) {
      print('❌ Chat error: ${data}');
    });

    // Generic event listener for debugging
    _socket!.onAny((event, data) {
      print('[RECEIVED] $event: ${data}');
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

    // Build mapped data
    return {
      ...rideData,
      'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
      'pickup': pickupCoords,
      'destination': dropoffCoords,
      'startLocation': {
        'address': rideData['startLocation']?['address'] ?? 'Pickup Location',
        'coordinates': pickupCoords,
      },
      'endLocation': rideData['endLocation'] != null
          ? {
              'address': rideData['endLocation']?['address'] ?? 'Drop Location',
              'coordinates': dropoffCoords,
            }
          : null,
      'riderId':
          rideData['riderId'] ??
          rideData['userId']?['_id'] ??
          rideData['userId'],
      'riderName':
          rideData['riderName'] ?? rideData['userId']?['name'] ?? 'Customer',
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

  void _disconnectSocket() {
    // Don't disconnect if ride is in progress
    if (_isRideInProgress && _activeRideId != null) {
      print(
        '⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.',
      );
      return;
    }

    _stopLocationWatch();
    _stopLocationUpdates();

    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }

    setState(() {
      _isSocketConnected = false;
      _socketId = null;
      _isOnDuty = false;
    });

    print('🔌 Driver socket disconnected');
  }

  // ==================== DRIVER ONLINE/OFFLINE ====================

  Future<void> _goOnline() async {
    print('🟢 GOING ONLINE...');

    if (_isProcessingOnline) {
      print('⏳ Already processing...');
      return;
    }

    setState(() {
      _isProcessingOnline = true;
    });

    try {
      // If socket is not connected, try to reconnect first
      if (_socket == null || !_isSocketConnected) {
        print('⚠️ Socket not connected, attempting to reconnect...');

        final reconnected = await _connectSocket();

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

      // Use current location immediately (already set from initState)
      print('📍 Using current location: $_currentLatitude, $_currentLongitude');

      final payload = {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
        'vehicleType': _vehicleType,
        'vehicleImage': _vehicleImage,
        'fleetId': _fleetId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      print('📡 Emitting user:online: $payload');
      _socket!.emit('user:online', payload);

      // Start sending location updates every 2 seconds
      _startLocationUpdates();

      print('🟢 Driver online request sent immediately');
    } catch (error) {
      print('❌ Error going online: $error');
      _handleOnlineFailure('Error: $error');
    }
  }

  Future<void> _goOffline() async {
    print('🔴 GOING OFFLINE...');

    try {
      // Emit offline event but keep socket connected
      if (_socket != null && _isSocketConnected) {
        print('🔴 Emitting offline status...');

        final payload = {
          'driverId': _driverId,
          'timestamp': DateTime.now().toIso8601String(),
        };
        _socket!.emit('user:offline', payload);
        print('📡 Emitted user:offline event: $payload');
      }

      // Stop location updates
      _stopLocationUpdates();

      setState(() {
        _isOnDuty = false;
        _isProcessingOnline = false;
      });

      // Remove bike marker and circle
      _removeBikeMarkerAndCircle();

      // Clear pending ride request
      _clearPendingRideRequest();

      print('✅ Driver is now offline (socket remains connected)');
      _showToast('Driver is now offline');
    } catch (error) {
      print('❌ Error going offline: $error');
      _showToast('Error going offline');
    }
  }

  void _handleOnlineSuccess(dynamic data) {
    if (!_isProcessingOnline) return;

    print('✅ DRIVER ONLINE SUCCESS');

    setState(() {
      _isOnDuty = true;
      _isProcessingOnline = false;
    });

    String successMessage = 'Driver is now online';
    if (data is Map<String, dynamic>) {
      successMessage = data['message'] ?? successMessage;
    }

    _showToast(successMessage);

    // Update map with current location
    if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
      _updateMarkerOnly(
        LatLng(_currentLatitude, _currentLongitude),
        50.0, // Default accuracy
      );
    }
  }

  void _handleOnlineFailure(dynamic data) {
    if (!_isProcessingOnline) return;

    print('❌ DRIVER ONLINE FAILED');

    setState(() {
      _isOnDuty = false;
      _isProcessingOnline = false;
    });

    String errorMessage = 'Failed to go online';
    if (data is String) {
      errorMessage = data;
    } else if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ?? data['error'] ?? errorMessage;
    }

    _showToast(errorMessage);
  }

  // ==================== LOCATION METHODS ====================

  // Start location listener in initState after getting initial location
  void _startBackgroundLocationListener() {
    print('📍 Starting background location listener');

    _positionStreamSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 5, // Update every 5 meters
          ),
        ).listen(
          (position) {
            // Just update the coordinates silently
            _currentLatitude = position.latitude;
            _currentLongitude = position.longitude;
            _lastLocationUpdate = DateTime.now();

            // Update marker on map
            if (mounted) {
              _updateMarkerOnly(
                LatLng(_currentLatitude, _currentLongitude),
                position.accuracy,
              );
            }

            print(
              '📍 Location updated silently: $_currentLatitude, $_currentLongitude',
            );
          },
          onError: (error) {
            print('⚠️ Background location error: $error');
          },
        );
  }

  void _updateMarkerOnly(LatLng location, double accuracy) {
    if (!mounted) return;

    setState(() {
      markers.clear();
      circles.clear();

      // Bike marker
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: location,
          icon:
              _bikeMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
          zIndex: 2,
        ),
      );

      // Grey outer circle (accuracy shadow)
      circles.add(
        Circle(
          circleId: const CircleId('outer_shadow'),
          center: location,
          radius: accuracy + 80,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.transparent,
        ),
      );

      // Green inner circle (center)
      circles.add(
        Circle(
          circleId: const CircleId('inner_green'),
          center: location,
          radius: 60,
          fillColor: Colors.green.withOpacity(0.35),
          strokeColor: Colors.green,
          strokeWidth: 1,
        ),
      );
    });
  }

  void _sendLocationUpdate() {
    if (_socket == null || !_isSocketConnected) return;

    // Only send if location has changed significantly
    final latDiff = (_currentLatitude - (_lastSentLatitude ?? _currentLatitude))
        .abs();
    final lngDiff =
        (_currentLongitude - (_lastSentLongitude ?? _currentLongitude)).abs();

    if (latDiff < LOCATION_CHANGE_THRESHOLD &&
        lngDiff < LOCATION_CHANGE_THRESHOLD) {
      return; // Skip sending if location change is too small
    }

    // Update last sent coordinates
    _lastSentLatitude = _currentLatitude;
    _lastSentLongitude = _currentLongitude;

    // 1. General driver location update
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
      '📍 Sending location update every 2 seconds: $_currentLatitude, $_currentLongitude',
    );
    _socket!.emit('driver:location:update', driverPayload);

    // 2. Specific ride location update (if in a ride)
    final rideId =
        _activeRideId ?? _currentRide?['orderId'] ?? _currentRide?['rideId'];

    if (rideId != null && rideId is String) {
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

      _socket!.emit('ride:location:update', ridePayload);
    }
  }

  void _startLocationUpdates() {
    _stopLocationUpdates();

    print('🔄 Starting location update broadcasts every 2 seconds');

    _locationUpdateTimer = Timer.periodic(
      const Duration(milliseconds: LOCATION_UPDATE_INTERVAL), // 2 seconds
      (_) {
        if (_socket != null && _isSocketConnected && _isOnDuty) {
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

  void _stopLocationWatch() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
      print('⏹️ Stopped location watch');
    }
  }

  // ==================== RIDE METHODS ====================

  bool _acceptRide(Map<String, dynamic> rideData) {
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

    // Mark ride as in progress
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

    print('✅ Emitting ride:accept with driver data: ${payload}');
    _socket!.emit('ride:accept', payload);

    return true;
  }

  bool _declineRide(String rideId, {String reason = ''}) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    final payload = {
      'orderId': rideId,
      'driverId': _driverId,
      'reason': reason,
      'declinedAt': DateTime.now().toIso8601String(),
    };

    print('❌ Declining ride: ${payload}');
    _socket!.emit('ride:decline', payload);
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

        // Navigate back to home if needed
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);

          // After navigating back, check socket connection
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              // Check if socket is still connected
              if (_socket == null || !_isSocketConnected) {
                print(
                  '⚠️ Socket disconnected after ride completion, attempting reconnect...',
                );
                _reconnectWithRetry();
              } else {
                print('✅ Socket still connected after ride completion');
              }
            }
          });
        }
      }
    } else {
      print('⚠️ Invalid rideId provided to _completeRide');
    }
  }

  // ==================== RIDE REQUEST HANDLING ====================

  void _processRideRequest(Map<String, dynamic> rideData) {
    print('🚕 Processing ride request...');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideRequestScreen(rideData: rideData),
      ),
    );
  }

  void _navigateToRideScreen(Map<String, dynamic> rideData) {
    // Clear pending request
    _clearPendingRideRequest();
  }

  void _startRideRequestTimer(String orderId, double timeoutSeconds) {
    _clearRideRequestTimer();

    final seconds = timeoutSeconds.toInt();

    _rideRequestTimer = Timer(Duration(seconds: seconds), () {
      if (_hasPendingRideRequest && _newRideRequest != null) {
        print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');

        _declineRide(orderId, reason: 'timeout');
        _showToast('Ride request auto-rejected (timeout)');

        _clearPendingRideRequest();
      }
    });
  }

  void _clearRideRequestTimer() {
    if (_rideRequestTimer != null) {
      _rideRequestTimer!.cancel();
      _rideRequestTimer = null;
    }
  }

  void _clearPendingRideRequest() {
    _clearRideRequestTimer();
    setState(() {
      _newRideRequest = null;
      _hasPendingRideRequest = false;
    });
  }

  // ==================== BACKGROUND RECONNECT ====================

  void _startBackgroundReconnectTimer() {
    _stopBackgroundReconnectTimer();

    print('🔄 Starting background reconnect monitoring...');

    _backgroundReconnectTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) {
      if (_appInBackground && _isOnDuty && !_isSocketConnected) {
        print('🔧 Background: Checking connection...');
        _checkAndReconnect();
      }
    });
  }

  void _stopBackgroundReconnectTimer() {
    if (_backgroundReconnectTimer != null) {
      _backgroundReconnectTimer!.cancel();
      _backgroundReconnectTimer = null;
    }
  }

  void _checkAndReconnect() {
    if (!_isSocketConnected) {
      print('🔄 Background: Socket disconnected, attempting reconnect...');
      _connectSocket();
    }
  }

  void _reconnectWithRetry() {
    if (_isSocketConnected) return;

    print('🔄 Attempting socket reconnection...');

    int attempts = 0;
    const maxAttempts = 3;

    Future.delayed(Duration.zero, () async {
      while (attempts < maxAttempts && !_isSocketConnected && mounted) {
        attempts++;
        print('🔄 Reconnection attempt $attempts/$maxAttempts');

        try {
          await _connectSocket();

          // Wait for connection
          await Future.delayed(const Duration(seconds: 2));

          if (_isSocketConnected) {
            print('✅ Reconnection successful');

            // If we were online before, restore online status
            if (_isOnDuty) {
              print('🔄 Restoring online status...');
              await _restoreOnlineStatus();
            }

            break;
          }
        } catch (error) {
          print('❌ Reconnection attempt $attempts failed: $error');
        }

        if (attempts < maxAttempts) {
          await Future.delayed(Duration(seconds: attempts * 2));
        }
      }

      if (!_isSocketConnected) {
        print('❌ Failed to reconnect after $maxAttempts attempts');
        _showToast('Connection lost. Please check your internet.');
      }
    });
  }

  Future<void> _restoreOnlineStatus() async {
    if (!_isSocketConnected) return;

    print('🔄 Restoring driver online status...');

    try {
      // Go online with current location
      await _goOnline();

      print('✅ Online status restored');
    } catch (error) {
      print('❌ Error restoring online status: $error');
    }
  }

  // ==================== DRIVER DATA ====================

  Future<void> _fetchDriverData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedDriverData = prefs.getString('driverData');

      if (storedDriverData != null) {
        final driverData = json.decode(storedDriverData);

        // Store complete driver profile data
        _driverName = driverData['name'] ?? driverData['driverName'];
        _driverPhone = driverData['phone'] ?? driverData['phoneNumber'];
        _driverImage =
            driverData['profileImage'] ??
            driverData['image'] ??
            driverData['driverImage'];
        _vehicleType = driverData['vehicleType'];
        _vehicleNumber = driverData['vehicleNumber'] ?? driverData['vehicleNo'];
        _vehicleImage = driverData['vehicleImage'];
        _fleetId = driverData['fleetId'];
      }
    } catch (error) {
      print('❌ Error fetching driver data: $error');
    }
  }

  // ==================== HELPER METHODS ====================

  void _showToast(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _toggleOnlineStatus() {
    if (_isOnDuty) {
      _goOffline();
    } else {
      _goOnline();
    }
  }

  // Helper method to extract ride ID from data
  String? _extractRideId(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['orderId'] ?? data['rideId'] ?? data['_id'] ?? data['id'];
    }
    return null;
  }

  // ==================== UI BUILD ====================

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return _isOnDuty == false
        ? Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(w * .300),
              child:
                  Container(
                        height: w * .290,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(w * 0.04),
                            bottomRight: Radius.circular(w * 0.04),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: w * 0.06,
                                      backgroundImage: const AssetImage(
                                        'assets/images/home2.png',
                                      ),
                                    ),
                                    SizedBox(width: w * 0.03),
                                    AppFonts.textPoppins(
                                      context,
                                      "Ayaan Malviya",
                                      w * 0.05,
                                      FontWeight.w600,
                                      AppColors.black,
                                      TextAlign.left,
                                      TextOverflow.visible,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: w * 0.01),
                                    // Online/Offline toggle
                                    GestureDetector(
                                      onTap: _isProcessingOnline
                                          ? null
                                          : _toggleOnlineStatus,
                                      child: Container(
                                        width: w * 0.26,
                                        height: w * 0.10,
                                        decoration: BoxDecoration(
                                          color: _isOnDuty
                                              ? const Color(0xFF34C759)
                                              : const Color(0xFFF26061),
                                          borderRadius: BorderRadius.circular(
                                            w * 0.06,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: _isProcessingOnline
                                            ? SizedBox(
                                                width: w * 0.04,
                                                height: w * 0.04,
                                                child:
                                                    const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : Text(
                                                _isOnDuty
                                                    ? 'Online'
                                                    : 'Offline',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: w * 0.032,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fade(duration: 800.ms, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Status indicators
                    if (_hasPendingRideRequest && _newRideRequest != null)
                      Container(
                        margin: EdgeInsets.only(bottom: w * 0.02),
                        padding: EdgeInsets.all(w * 0.015),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(w * 0.02),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_taxi,
                              color: Colors.orange,
                              size: w * 0.04,
                            ),
                            SizedBox(width: w * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '🚕 Pending Ride Request',
                                    style: TextStyle(
                                      fontSize: w * 0.03,
                                      color: Colors.orange[800]!,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Tap to view details',
                                    style: TextStyle(
                                      fontSize: w * 0.025,
                                      color: Colors.orange[600]!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.visibility, size: w * 0.04),
                              onPressed: () {
                                if (_newRideRequest != null) {
                                  // _showRideRequestNotification(_newRideRequest!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: w * 0.04),
                    Image.asset(
                      "assets/images/offline_image.png",
                      height: w * 0.5,
                    ),
                    Text(
                      _isOnDuty ? "You're Online" : "You're Offline",
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: _isOnDuty ? Colors.green : Colors.black,
                      ),
                    ),
                    Text(
                      _isOnDuty
                          ? "Ready to accept rides!"
                          : "Go online to start accepting rides.",
                      style: const TextStyle(
                        color: Color(0xFF5F6165),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: w * 0.04),
                    ElevatedButton(
                      onPressed: _isProcessingOnline
                          ? null
                          : _toggleOnlineStatus,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: _isOnDuty
                            ? const Color(0xFFF26061)
                            : const Color(0xFF34C759),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: _isProcessingOnline
                          ? SizedBox(
                              width: w * 0.04,
                              height: w * 0.04,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _isOnDuty ? "Go Offline" : "Go Online",
                              style: TextStyle(
                                fontSize: w * 0.04,
                                color: Colors.white,
                              ),
                            ),
                    ),

                    SizedBox(height: w * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child:
                          AppFonts.textPoppins(
                                context,
                                "Today's Update",
                                w * 0.038,
                                FontWeight.w600,
                                AppColors.black,
                                TextAlign.left,
                                TextOverflow.visible,
                              )
                              .animate()
                              .fade(duration: 820.ms, curve: Curves.easeInOut)
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                              ),
                    ),
                    SizedBox(height: w * 0.04),
                    Column(
                      children: [
                        HomeScreenWidgets.elevatedBox(
                          shadowColor: const Color(0xFF4CAF50),
                          width: double.infinity,
                          child: const Column(
                            children: [
                              Text(
                                "Today's Earnings",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "₹1000.00",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: w * 0.45,
                              child: HomeScreenWidgets.elevatedBox(
                                shadowColor: const Color(0xFFFEBC2F),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Online",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF414142),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "₹500 Total",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            SizedBox(
                              width: w * 0.45,
                              child: HomeScreenWidgets.elevatedBox(
                                shadowColor: const Color(0xFF7C7C8D),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cash",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF414142),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "₹500 On Hand",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: w * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: w * 0.45,
                              child: HomeScreenWidgets.elevatedBox(
                                shadowColor: const Color(0xFF439AFE),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Rides",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF414142),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "50 / 45 Completed",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: w * 0.02),
                            SizedBox(
                              width: w * 0.45,
                              child: HomeScreenWidgets.elevatedBox(
                                shadowColor: const Color(0xFFF26061),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Rides",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF414142),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "50 / 05 Cancelled",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.04),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  /// 1️⃣ Google Map (BOTTOM)
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: markers,
                    circles: circles,
                  ),

                  /// 2️⃣ Book Ride Button (Top Right)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const BookRide());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        elevation: 4,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Book Ride",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  /// 3️⃣ Bottom Offline Card (FIRST)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _bottomOfflineCard(),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _bottomOfflineCard() {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 200),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Driver & Earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeScreenWidgets.topAction(
                icon: _selectedTab == "Driver"
                    ? "assets/icons/drive.png"
                    : "assets/icons/driveoff.svg",
                label: "Driver",
                onTap: () {
                  setState(() {
                    _selectedTab = "Driver";
                  });
                },
                isSelected: _selectedTab == "Driver",
              ),
              SizedBox(width: w * 0.25),
              HomeScreenWidgets.topAction(
                icon: _selectedTab == "Earnings"
                    ? "assets/icons/dolleron.svg"
                    : "assets/icons/doller.png",
                label: "Earnings",
                onTap: () {
                  setState(() {
                    _selectedTab = "Earnings";
                  });
                },
                isSelected: _selectedTab == "Earnings",
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Conditional Content
          if (_selectedTab == "Driver")
            _driverContent()
          else
            _earningsContent(),
        ],
      ),
    );
  }

  Widget _driverContent() {
    return Column(
      children: [
        /// Offline Image
        Image.asset("assets/images/onlinee.png", height: 120),

        const SizedBox(height: 12),

        const Text(
          "You're Online",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        const Text(
          "Go offline to stop accepting rides.",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        /// Go Online Button (Bottom)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              _goOffline();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Go Offline",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Earnings Content
  Widget _earningsContent() {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child:
              AppFonts.textPoppins(
                    context,
                    "Today's Update",
                    w * 0.038,
                    FontWeight.w600,
                    AppColors.black,
                    TextAlign.left,
                    TextOverflow.visible,
                  )
                  .animate()
                  .fade(duration: 820.ms, curve: Curves.easeInOut)
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),
        ),
        SizedBox(height: w * 0.02),

        Column(
          children: [
            /// Today's Earnings (Full Width)
            HomeScreenWidgets.elevatedBox(
              width: double.infinity,
              shadowColor: const Color(0xFF4CAF50),
              child: Column(
                children: const [
                  Text(
                    "Today's Earnings",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "₹1000.00",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: w * 0.02),

            /// Online & Cash
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: w * 0.4,
                  child: HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFFFEBC2F),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Online",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "₹500 Total",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: w * 0.01),
                SizedBox(
                  width: w * 0.45,
                  child: HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFF7C7C8D),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Cash",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "₹500 On Hand",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: w * 0.02),

            /// Ride Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: w * 0.4,
                  child: HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFF439AFE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 1),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "50",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " / 45 Completed",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: w * 0.02),
                SizedBox(
                  width: w * 0.45,
                  child: HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFFF26061),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 1),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "50",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " / 45 Completed",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ==================== ASSET LOADING METHODS ====================

  Future<void> _loadCustomBikeMarker() async {
    try {
      _bikeMarkerIcon = await MapHelper.loadCustomIcon(
        assetPath: 'assets/images/bike2.png',
        width: 150,
        height: 150,
      );
      print('✅ Custom bike marker icon loaded');
    } catch (e) {
      print('❌ Error loading custom bike marker: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }
  }

  Future<void> _loadVehicleIcons() async {
    try {
      _vehicleIcons = await MapHelper.loadVehicleIcons(iconSize: 70);
      print('✅ Vehicle icons loaded');
    } catch (e) {
      print('❌ Error loading vehicle icons: $e');
    }
  }

  void _removeBikeMarkerAndCircle() {
    setState(() {
      markers.clear();
      circles.clear();
    });
    print('✅ Bike marker and circle removed');
  }

  // ==================== RIDE PERSISTENCE METHODS ====================

  /// Save active ride to SharedPreferences for persistence
  Future<bool> _saveActiveRide(Map<String, dynamic> rideData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Extract coordinates properly
      LatLng? pickupCoords;
      if (rideData['pickupCoordinates'] != null) {
        pickupCoords = rideData['pickupCoordinates'] as LatLng;
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
        dropoffCoords = rideData['dropoffCoordinates'] as LatLng;
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

  /// Restore active ride from SharedPreferences
  Future<Map<String, dynamic>?> _getPersistedRide() async {
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

  /// Clear persisted ride data
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

  /// Update the screen to restore to
  Future<void> _updatePersistedRideScreen(String screen) async {
    try {
      final activeRide = await _getPersistedRide();
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

  // ==================== CHAT FUNCTIONALITY ====================

  /// Join chat room for a ride
  bool joinChatRoom(String orderId, {String userRole = 'driver'}) {
    if (_socket == null || !_isSocketConnected) {
      print('❌ [CHAT] Cannot join chat - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      'userRole': userRole,
      'userId': _driverId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('💬 [CHAT] Joining chat room: $payload');
    _socket!.emit('chat:join', payload);
    return true;
  }

  /// Send a chat message
  bool sendChatMessage(
    String orderId,
    String message, {
    String? receiverId,
    String? chatId,
  }) {
    if (_socket == null || !_isSocketConnected) {
      print('❌ [CHAT] Cannot send message - socket not connected');
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

    print('💬 [CHAT] Sending message: $payload');

    // Emit to both known events for compatibility
    _socket!.emit('chat:sendMessage', payload);
    _socket!.emit('sendChatMessage', payload);

    return true;
  }

  /// Send typing indicator
  bool sendTypingIndicator(
    String orderId,
    bool isTyping, {
    String userRole = 'driver',
  }) {
    if (_socket == null || !_isSocketConnected) {
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

  /// Get chat history
  bool getChatHistory(String orderId) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    print('💬 [CHAT] Requesting chat history for: $orderId');
    _socket!.emit('chat:getHistory', {'orderId': orderId});
    return true;
  }

  /// Leave chat room
  bool leaveChatRoom(String orderId) {
    if (_socket == null || !_isSocketConnected) {
      return false;
    }

    print('💬 [CHAT] Leaving chat room: $orderId');
    _socket!.emit('chat:leave', {'orderId': orderId});
    return true;
  }

  /// Join ride room for real-time updates
  void _joinRideRoom(String rideId) {
    if (_socket != null && _isSocketConnected) {
      final roomName = 'ride:$rideId';
      _socket!.emit('join:room', {'roomName': roomName});
      print('✅ Joined ride room: $roomName');
    }
  }
}
