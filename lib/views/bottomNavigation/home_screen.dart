import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:corezap_driver/apiervices/services/driver_socket_service.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
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
  
  // Use the new DriverSocketService
  final DriverSocketService _socketService = DriverSocketService();
  
  // Socket state
  bool _isSocketConnected = false;
  bool _isOnDuty = false;
  bool _isProcessingOnline = false;
  String _socketStatus = 'Not Connected';
  String _socketId = '';
  
  // App lifecycle state
  AppLifecycleState? _appLifecycleState;
  bool _appInBackground = false;
  DateTime? _appBackgroundTime;
  String _selectedTab = "Driver";
  // Location variables
  double? _currentLatitude;
  double? _currentLongitude;
  String _vehicleType = 'Car';
  String? _vehicleImage;
  String? _fleetId;
  
  // Driver data
  String _driverId = '';
  String? _token;
  String? _userId;
  
  // Ride variables
  Map<String, dynamic>? _newRideRequest;
  bool _hasPendingRideRequest = false;
  Timer? _rideRequestTimer;
  
  // Reconnection tracking
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  Timer? _backgroundReconnectTimer;

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
    
    // Remove all socket event listeners
    _removeSocketListeners();
    
    // Disconnect socket service
    _socketService.disconnect();
    
    super.dispose();
  }
  
  void _cleanupResources() {
    // Clear all timers
    _clearRideRequestTimer();
    _stopBackgroundReconnectTimer();
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
      _socketService.setAppReady(true);
      
      // Check connection status
      final status = _socketService.getConnectionStatus();
      final isConnected = status['isConnected'] ?? false;
      final isOnDuty = status['isOnDuty'] ?? false;
      
      if (isConnected && isOnDuty) {
        print('✅ Socket still connected, resuming operations...');
      } else if (isOnDuty) {
        // Was on duty but disconnected, try to reconnect
        print('⚠️ Socket disconnected while in background, reconnecting...');
        _reconnectWithRetry();
      }
      
      _appBackgroundTime = null;
    }
  }

   final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(23.2508131, 77.4647936), 
    zoom: 14,
  );
   late GoogleMapController _mapController;
   
   // Markers and circles
   Set<Marker> markers = {};
   Set<Circle> circles = {};
   BitmapDescriptor? _bikeMarkerIcon;
   
   // Nearby riders/drivers
   List<Map<String, dynamic>> _nearbyRiders = [];
   Map<String, BitmapDescriptor> _vehicleIcons = {};

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
    
    // Wait for token to load
    await gettoken();
    
    // Fetch location immediately and cache it
    try {
      await _getCurrentLocation();
      _createDriverMarker(); // Create driver marker after getting location
      print('✅ Location cached on HomeScreen init');
    } catch (e) {
      print('⚠️ Failed to cache location: $e');
    }
    
    // Setup socket event listeners
    _setupSocketListeners();
    
    // Then connect socket with valid token
    if (_token != null && _driverId.isNotEmpty) {
      await _connectSocket();
    } else {
      print('❌ Cannot connect: Token or Driver ID is missing');
      _showToast('Failed to load credentials');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Request location permission
      final locationStatus = await Permission.location.request();
      if (locationStatus.isGranted) {
        print('✅ Location permission granted');
      } else {
        print('⚠️ Location permission not granted: $locationStatus');
      }
      
      // Request notification permission (if needed)
      final notificationStatus = await Permission.notification.request();
      if (notificationStatus.isGranted) {
        print('✅ Notification permission granted');
      }
      
      // Mark app as ready
      _socketService.setAppReady(true);
      
    } catch (error) {
      print('❌ Error requesting permissions: $error');
    }
  }

  Future<void> gettoken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");
      final String? userId = prefs.getString("driver_userid");

      setState(() {
        _token = token;
        _userId = userId;
        _driverId = userId.toString();
      });

      print('✅ Token loaded from SharedPreferences');
      print('User ID: $_userId');
      print("myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...");
      print("myyyy_driverid>>> ${_driverId}");

    } catch (e) {
      print('❌ Error loading token: $e');
    }
  }

  Future<bool> _connectSocket() async {
    print("🔄 Connecting socket...");
    
    try {
      // Check if already connected
      final status = _socketService.getConnectionStatus();
      if (status['isConnected'] ?? false) {
        print('✅ Socket already connected');
        return true;
      }

      // Connect with timeout
      final connected = await Future.any([
        _socketService.connect(),
        Future.delayed(const Duration(seconds: 5), () => false),
      ]);
      
      if (connected) {
        print('✅ Socket connected quickly');
        // Connection status will be updated via event listeners
        return true;
      } else {
        print('❌ Socket connection timeout');
        setState(() {
          _socketStatus = 'Connection Timeout';
        });
        return false;
      }
    } catch (error) {
      print('❌ Socket connection error: $error');
      setState(() {
        _socketStatus = 'Connection Error: $error';
      });
      return false;
    }
  }

  void _setupSocketListeners() {
    // ==================== CONNECTION EVENTS ====================
    _socketService.addEventListener('socket:connected', (data) {
      if (!mounted) return;
      print('✅✅✅ DRIVER SOCKET CONNECTED: ${data['socketId']}');
      setState(() {
        _isSocketConnected = true;
        _socketStatus = 'Connected';
        _socketId = data['socketId'] ?? '';
        _reconnectAttempts = 0;
      });
      
      // If we were online before, restore status
      if (_isOnDuty) {
        print('🔄 Restoring online status after connection...');
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _restoreOnlineStatus();
          }
        });
      }
    });

    _socketService.addEventListener('socket:disconnected', (data) {
      if (!mounted) return;
      print('❌ Driver socket disconnected: ${data['reason']}');
      setState(() {
        _isSocketConnected = false;
        _socketStatus = 'Disconnected';
      });
      
      // Clear pending ride request
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

    _socketService.addEventListener('socket:error', (data) {
      if (!mounted) return;
      print('❌ Socket error: ${data['error']}');
      _reconnectAttempts++;
      setState(() {
        _socketStatus = 'Connection Error';
      });
    });

    _socketService.addEventListener('socket:reconnected', (data) {
      if (!mounted) return;
      print('🔄 Socket reconnected after ${data['attemptNumber']} attempts');
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

    // ==================== DRIVER STATUS EVENTS ====================
    _socketService.addEventListener('driver:online:success', (data) {
      if (!mounted) return;
      print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
      _handleOnlineSuccess(data);
    });

    _socketService.addEventListener('driver:online:failed', (data) {
      if (!mounted) return;
      print('❌❌❌ DRIVER ONLINE FAILED: $data');
      _handleOnlineFailure(data);
    });

    _socketService.addEventListener('driver:offline', (data) {
      if (!mounted) return;
      print('🔴 Driver offline confirmed: ${data['message']}');
      setState(() {
        _isOnDuty = false;
        _isProcessingOnline = false;
      });
    });

    // ==================== RIDE REQUEST EVENTS ====================
    _socketService.addEventListener('ride:newRequest', (data) {
      if (!mounted) return;
      print('🚕🚕🚕 NEW RIDE REQUEST RECEIVED 🚕🚕🚕');
      
      // Print ALL data received
      print('📦 RAW RIDE DATA RECEIVED:');
      data.forEach((key, value) {
        print('  $key: $value (${value.runtimeType})');
      });
      
      // Check if we're online and can accept rides
      if (!_isOnDuty) {
        print('⚠️ Received ride request but driver is offline');
        return;
      }
      
      // Process the ride request
      _processRideRequest(data);
    });

    _socketService.addEventListener('ride:acceptedConfirmed', (data) async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
      await prefs.setString("order_id", data['orderId']);

      // Navigate to ride screen
      _navigateToRideScreen(data);
    });

    _socketService.addEventListener('ride:status', (data) {
      if (!mounted) return;
      print('📊 Ride status update: ${data['status']}');
      // Handle ride status updates
    });

    _socketService.addEventListener('ride:cancelled', (data) {
      if (!mounted) return;
      print('❌ Ride cancelled: ${data['orderId']}');
      _clearPendingRideRequest();
      _showToast('Ride cancelled');
    });

    _socketService.addEventListener('ride:completed', (data) {
      if (!mounted) return;
      print('✅ Ride completed: ${data['rideId']}');
      _showToast('Ride completed successfully');
    });

    // ==================== LOCATION EVENTS ====================
    _socketService.addEventListener('ride:location', (data) {
      if (!mounted) return;
      print('📍 Rider location during ride: ${data['location']}');
    });

    // ==================== CHAT EVENTS (optional) ====================
    _socketService.addEventListener('chat:message', (data) {
      if (!mounted) return;
      print('💬 Chat message received: ${data['message']}');
    });
  }

  void _removeSocketListeners() {
    // Remove all socket event listeners to prevent setState() on disposed widgets
    _socketService.removeEventListener('socket:connected', (_) {});
    _socketService.removeEventListener('socket:disconnected', (_) {});
    _socketService.removeEventListener('socket:error', (_) {});
    _socketService.removeEventListener('socket:reconnected', (_) {});
    _socketService.removeEventListener('driver:online:success', (_) {});
    _socketService.removeEventListener('driver:online:failed', (_) {});
    _socketService.removeEventListener('driver:offline', (_) {});
    _socketService.removeEventListener('ride:newRequest', (_) {});
    _socketService.removeEventListener('ride:acceptedConfirmed', (_) {});
    _socketService.removeEventListener('ride:status', (_) {});
    _socketService.removeEventListener('ride:cancelled', (_) {});
    _socketService.removeEventListener('ride:completed', (_) {});
    _socketService.removeEventListener('ride:location', (_) {});
    _socketService.removeEventListener('chat:message', (_) {});
    print('🧹 Socket listeners removed');
  }

  void _processRideRequest(Map<String, dynamic> rideData) {
    print('🚕 Processing ride request...');
    
    try {
      // Create a deep copy to ensure data doesn't get modified
      final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
      
      // Add any missing fields with default values
      if (!rideDataCopy.containsKey('riderName')) {
        rideDataCopy['riderName'] = 'Customer';
      }
      if (!rideDataCopy.containsKey('riderNumber')) {
        rideDataCopy['riderNumber'] = 'N/A';
      }
      if (!rideDataCopy.containsKey('totalFare')) {
        rideDataCopy['totalFare'] = '0';
      }
      if (!rideDataCopy.containsKey('distance')) {
        rideDataCopy['distance'] = '0';
      }
      if (!rideDataCopy.containsKey('rideId')) {
        rideDataCopy['rideId'] = rideDataCopy['orderId'] ?? 'N/A';
      }
      if (!rideDataCopy.containsKey('timestamp')) {
        rideDataCopy['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      }
      
      // Ensure nested structures exist
      if (!rideDataCopy.containsKey('startLocation')) {
        rideDataCopy['startLocation'] = {
          'address': 'Location not specified',
          'coordinates': [78.4772, 17.4065]
        };
      }
      
      if (!rideDataCopy.containsKey('endLocation')) {
        rideDataCopy['endLocation'] = {
          'address': 'Destination not specified',
          'coordinates': [78.4850, 17.4120]
        };
      }
      
      // Extract and print key information
      print('\n📋 KEY RIDE INFORMATION (Before Navigation):');
      print('├─ Ride ID: ${rideDataCopy['rideId']}');
      print('├─ Order ID: ${rideDataCopy['orderId']}');
      print('├─ Rider Name: ${rideDataCopy['riderName']}');
      print('├─ Rider Phone: ${rideDataCopy['riderNumber']}');
      print('├─ Total Fare: ₹${rideDataCopy['totalFare']}');
      print('├─ Distance: ${rideDataCopy['distance']} km');
      
      if (rideDataCopy.containsKey('startLocation')) {
        print('├─ Pickup Address: ${rideDataCopy['startLocation']?['address']}');
      }
      if (rideDataCopy.containsKey('endLocation')) {
        print('├─ Destination: ${rideDataCopy['endLocation']?['address']}');
      }
      
      // Store the new ride request
      setState(() {
        _newRideRequest = rideDataCopy;
        _hasPendingRideRequest = true;
      });

      // Navigate to LiveRide screen IMMEDIATELY (without delay)
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveRide(rideData: rideDataCopy),
            ),
          );
        });
      }

      // Auto-reject timer
      final timeoutSeconds = rideDataCopy['timeout']?.toDouble() ?? 30.0;
      _startRideRequestTimer(rideDataCopy['orderId'], timeoutSeconds);

      print('✅ New ride request stored and navigating...');
      print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');
    } catch (error) {
      print('❌ Error processing ride request: $error');
      print('Stack trace: ${error.toString()}');
    }
  }

  void _navigateToRideScreen(Map<String, dynamic> rideData) {
    // Clear pending request
    _clearPendingRideRequest();
    
    // Create a deep copy for navigation
    final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
    
    // Navigate to ride screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LiveRide(rideData: rideDataCopy),
        ),
      );
    });
  }

  // ==================== RIDE REQUEST TIMER ====================
  void _startRideRequestTimer(String orderId, double timeoutSeconds) {
    _clearRideRequestTimer();
    
    final seconds = timeoutSeconds.toInt();
    
    _rideRequestTimer = Timer(Duration(seconds: seconds), () {
      if (_hasPendingRideRequest && _newRideRequest != null) {
        print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
        _socketService.declineRide(orderId, reason: 'timeout');
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
    
    _backgroundReconnectTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
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
    final status = _socketService.getConnectionStatus();
    if (!(status['isConnected'] ?? false)) {
      print('🔄 Background: Socket disconnected, attempting reconnect...');
      _socketService.connect();
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
          
          final status = _socketService.getConnectionStatus();
          if (status['isConnected'] ?? false) {
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
    final status = _socketService.getConnectionStatus();
    if (!(status['isConnected'] ?? false)) return;
    
    print('🔄 Restoring driver online status...');
    
    try {
      // Get current location
      final location = await _getCurrentLocation();
      
      // Go online
      await _socketService.goOnline();
      
      print('✅ Online status restored');
      
    } catch (error) {
      print('❌ Error restoring online status: $error');
    }
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
      // Check if already connected
      final status = _socketService.getConnectionStatus();
      bool isConnected = status['isConnected'] ?? false;

      // If not connected, connect quickly (target: 1 second)
      if (!isConnected) {
        print('🔌 Socket not connected, connecting...');
        final connected = await _connectSocket();
        
        if (!connected) {
          _handleOnlineFailure('Network connection failed');
          return;
        }
        
        // Give socket a moment to be ready
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Go online with cached location (no delay for fetching)
      print('🚀 Sending online status with cached location...');
      final success = await _socketService.goOnline();

      if (success) {
        print('✅ Online request sent successfully');
      } else {
        _handleOnlineFailure('Failed to go online');
      }
    } catch (e) {
      print('❌ Error: $e');
      _handleOnlineFailure('Error: $e');
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

    // Animate camera and create marker (async operations)
   
    // _createBikeMarkerAndCircle(); // Returns Future but we don't await to avoid blocking UI
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

  Future<void> _goOffline() async {
    print('🔴 GOING OFFLINE...');
    
    try {
      // Stop processing any online requests
      setState(() {
        _isProcessingOnline = false;
      });

      // Go offline via socket service (fully disconnects)
      await _socketService.goOffline();
      
      setState(() {
        _isOnDuty = false;
      });

      // Remove bike marker and circle
      _removeBikeMarkerAndCircle();

      // Clear pending ride request
      _clearPendingRideRequest();

      print('✅ Driver is now offline - socket disconnected');
      _showToast('Offline - Socket disconnected');
      
    } catch (error) {
      print('❌ Error going offline: $error');
      _showToast('Error going offline');
    }
  }

  // ==================== LOCATION METHODS ====================
  Future<Map<String, dynamic>> _getCurrentLocation() async {
    try {
      final coordinates = _socketService.getCurrentCoordinates();

      print("socckettt_coordianted  ${coordinates['latitude']}");

      print("socckettt_coordianted222  ${coordinates['longitude']}");
      setState(() {
        _currentLatitude = coordinates['latitude'] as double? ?? 0.0;
        _currentLongitude = coordinates['longitude'] as double? ?? 0.0;
      });
      
      print('✅ Got current location: $_currentLatitude, $_currentLongitude');
      
      // Update driver marker with new location
      _createDriverMarker();
      
      return coordinates;
    } catch (e) {
      print('❌ Error getting location: $e');
      return {'latitude': 23.2508438, 'longitude': 77.4647827};
    }
  }


 

  // Create bike marker and circle at current location (async)

  // Remove bike marker and circle
  void _removeBikeMarkerAndCircle() {
    setState(() {
      markers.clear();
      circles.clear();
    });
    print('✅ Bike marker and circle removed');
  }

  // Load custom bike marker icon from assets
  Future<void> _loadCustomBikeMarker() async {
    try {
      _bikeMarkerIcon = await MapHelper.loadCustomIcon(
        assetPath: 'assets/images/bike2.png',
        width: 80,
        height: 80,
      );
      print('✅ Custom bike marker icon loaded');
    } catch (e) {
      print('❌ Error loading custom bike marker: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  // Load vehicle icons for nearby riders
  Future<void> _loadVehicleIcons() async {
    try {
      _vehicleIcons = await MapHelper.loadVehicleIcons(
        iconSize: 70,
      );
      print('✅ Vehicle icons loaded');
    } catch (e) {
      print('❌ Error loading vehicle icons: $e');
    }
  }

  // Create driver marker with custom bike icon at current location
  void _createDriverMarker() {
    if (_currentLatitude == null || _currentLongitude == null) {
      print('⚠️ Current location not available for driver marker');
      return;
    }

    try {
      final driverMarker = Marker(
        markerId: const MarkerId('driver_location'),
        position: LatLng(_currentLatitude!, _currentLongitude!),
        icon: _bikeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'You are here',
        ),
        zIndex: 2, // Above rider markers
      );

      setState(() {
        // Remove existing driver marker if any
        markers.removeWhere((m) => m.markerId.value == 'driver_location');
        // Add new driver marker
        markers.add(driverMarker);
      });

      print('✅ Driver marker created/updated at ($_currentLatitude, $_currentLongitude)');
    } catch (e) {
      print('❌ Error creating driver marker: $e');
    }
  }

  // Update nearby riders on map
  Future<void> _updateNearbyRiders(List<Map<String, dynamic>> riders) async {
    if (_currentLatitude == null || _currentLongitude == null) {
      print('⚠️ Current location not available for filtering riders');
      return;
    }

    try {
      // Filter riders within 5km
      final filteredRiders = MapHelper.filterRidersByDistance(
        riders,
        _currentLatitude!,
        _currentLongitude!,
        5.0, // 5km radius
      );

      setState(() {
        _nearbyRiders = filteredRiders;
      });

      // Create markers for nearby riders
      final riderMarkers = MapHelper.createRiderMarkers(
        riders: filteredRiders,
        vehicleIcons: _vehicleIcons.isNotEmpty ? _vehicleIcons : null,
      );

      // Combine driver marker + rider markers
      setState(() {
        markers.addAll(riderMarkers);
      });

      print('✅ Updated ${filteredRiders.length} nearby riders on map');
    } catch (e) {
      print('❌ Error updating nearby riders: $e');
    }
  }

  // Add a single nearby rider (real-time update)
  void _addNearbyRider(Map<String, dynamic> rider) {
    try {
      final riderId = rider['riderId'] as String?;
      if (riderId == null) return;

      // Check if already exists
      final exists = _nearbyRiders.any((r) => r['riderId'] == riderId);
      if (exists) return;

      setState(() {
        _nearbyRiders.add(rider);
      });

      // Add marker to map
      final riderMarker = MapHelper.createSingleRiderMarker(
        riderId: riderId,
        position: LatLng(
          rider['location']['lat'] as double,
          rider['location']['lng'] as double,
        ),
        icon: _vehicleIcons[rider['vehicleType']] ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        name: rider['name'],
        status: rider['status'],
        vehicleType: rider['vehicleType'],
      );

      setState(() {
        markers.add(riderMarker);
      });

      print('✅ Added nearby rider: $riderId');
    } catch (e) {
      print('❌ Error adding nearby rider: $e');
    }
  }

  // Remove nearby rider from map
  void _removeNearbyRider(String riderId) {
    setState(() {
      _nearbyRiders.removeWhere((r) => r['riderId'] == riderId);
      markers.removeWhere((m) => m.markerId.value == 'rider_$riderId');
    });
    print('✅ Removed nearby rider: $riderId');
  }

  // Update rider location in real-time
  void _updateRiderLocation(String riderId, double lat, double lng) {
    final index = _nearbyRiders.indexWhere((r) => r['riderId'] == riderId);
    if (index != -1) {
      setState(() {
        _nearbyRiders[index]['location'] = {'lat': lat, 'lng': lng};
      });

      // Update marker
      final riderMarker = MapHelper.createSingleRiderMarker(
        riderId: riderId,
        position: LatLng(lat, lng),
        icon: _vehicleIcons[_nearbyRiders[index]['vehicleType']] ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        name: _nearbyRiders[index]['name'],
        status: _nearbyRiders[index]['status'],
        vehicleType: _nearbyRiders[index]['vehicleType'],
      );

      setState(() {
        markers.removeWhere((m) => m.markerId.value == 'rider_$riderId');
        markers.add(riderMarker);
      });

      print('✅ Updated rider location: $riderId');
    }
  }

  // ==================== NOTIFICATIONS ====================
  void _showRideRequestNotification(Map<String, dynamic> rideData) {
    if (!mounted) return;

    // Extract data
    final riderName = rideData['riderName']?.toString() ?? 'Customer';
    final riderPhone = rideData['riderNumber']?.toString() ?? '';
    final distance = rideData['distance']?.toString() ?? '0';
    final fare = rideData['totalFare']?.toString() ?? '0';
    final pickup = rideData['startLocation']?['address']?.toString() ?? 'Location not specified';
    final destination = rideData['endLocation']?['address']?.toString() ?? 'Destination not specified';
    final orderId = rideData['orderId']?.toString() ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.local_taxi, color: Colors.green),
            SizedBox(width: 10),
            Text('🚕 New Ride Request'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text(riderName.substring(0, 1).toUpperCase()),
                ),
                title: Text(riderName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(riderPhone),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fare', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('₹$fare', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Distance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('$distance km', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(pickup, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(destination, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (orderId.isNotEmpty) {
                _socketService.declineRide(orderId);
                _showToast('Ride rejected');
                _clearPendingRideRequest();
              }
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (orderId.isNotEmpty) {
                _socketService.acceptRide(rideData);
                print('✅ Ride accepted: $orderId');
                _showToast('Ride accepted!');
                _clearPendingRideRequest();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // ==================== UTILITY METHODS ====================
  void _toggleConnection() {
    final status = _socketService.getConnectionStatus();
    if (status['isConnected'] ?? false) {
      _socketService.disconnect();
      setState(() {
        _isSocketConnected = false;
        _socketStatus = 'Disconnecting...';
        _isOnDuty = false;
        _isProcessingOnline = false;
      });
      _showToast('Socket disconnected');
    } else {
      _connectSocket();
      _showToast('Connecting socket...');
    }
  }

  void _toggleOnlineStatus() {
    if (_isOnDuty) {
      _goOffline();
    } else {
      _goOnline();
    }
  }

  // Helper methods for connection status
  Color _getConnectionColor() {
    if (!_isSocketConnected) return Colors.red;
    if (_appInBackground) return Colors.orange;
    return Colors.green;
  }

  IconData _getConnectionIcon() {
    if (!_isSocketConnected) return Icons.signal_wifi_off;
    if (_appInBackground) return Icons.phone_android;
    return Icons.signal_wifi_4_bar;
  }

  String _getConnectionText() {
    if (!_isSocketConnected) return 'Offline';
    if (_appInBackground) return 'Background';
    if (!_isOnDuty) return 'Online (Idle)';
    return 'Online';
  }

  // ==================== UI BUILD ====================
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return
    
    
             _isOnDuty == false ? 
 Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * .300),
        child: Container(
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
                        backgroundImage: const AssetImage('assets/images/home2.png'),
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
                      // Connection status indicator
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      //   decoration: BoxDecoration(
                      //     color: _getConnectionColor(),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Icon(_getConnectionIcon(), size: 12, color: Colors.white),
                      //       const SizedBox(width: 4),
                      //       Text(
                      //         _getConnectionText(),
                      //         style: const TextStyle(color: Colors.white, fontSize: 10),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: w * 0.01),
                      // Online/Offline toggle
                      GestureDetector(
                        onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
                        child: Container(
                          width: w * 0.26,
                          height: w * 0.10,
                          decoration: BoxDecoration(
                            color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
                            borderRadius: BorderRadius.circular(w * 0.06),
                          ),
                          alignment: Alignment.center,
                          child: _isProcessingOnline
                              ? SizedBox(
                                  width: w * 0.04,
                                  height: w * 0.04,
                                  child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  _isOnDuty ? 'Online' : 'Offline',
                                  style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
        ),
      ),
      body: 
      

     SingleChildScrollView(
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
                      Icon(Icons.local_taxi, color: Colors.orange, size: w * 0.04),
                      SizedBox(width: w * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('🚕 Pending Ride Request', style: TextStyle(fontSize: w * 0.03, color: Colors.orange[800]!, fontWeight: FontWeight.w600)),
                            Text('Tap to view details', style: TextStyle(fontSize: w * 0.025, color: Colors.orange[600]!)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility, size: w * 0.04),
                        onPressed: () {
                          if (_newRideRequest != null) {
                            _showRideRequestNotification(_newRideRequest!);
                          }
                        },
                      ),
                    ],
                  ),
                ),

              SizedBox(height: w * 0.04),
              Image.asset("assets/images/offline_image.png",height: w * 0.5,),
              Text(
                _isOnDuty ? "You're Online" : "You're Offline",
                style: TextStyle(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.bold,
                  color: _isOnDuty ? Colors.green : Colors.black,
                ),
              ),
              Text(
                _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
                style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
              ),
              SizedBox(height: w * 0.04),
              ElevatedButton(
                onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
                style: ElevatedButton.styleFrom(
                  // padding: EdgeInsets.symmetric(vertical: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
                  backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: _isProcessingOnline
                    ? SizedBox(
                        width: w * 0.04,
                        height: w * 0.04,
                        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _isOnDuty ? "Go Offline" : "Go Online",
                        style: TextStyle(fontSize: w * 0.04, color: Colors.white),
                      ),
              ),

              // Debug button
              // SizedBox(height: w * 0.02),
              // TextButton(
              //   onPressed: () {
              //     final status = _socketService.getConnectionStatus();
              //     print('🔧 Debug Info:');
              //     print('  Socket Connected: ${status['isConnected']}');
              //     print('  On Duty: ${status['isOnDuty']}');
              //     print('  Socket ID: ${status['socketId']}');
              //     print('  Driver ID: ${status['driverId']}');
              //     print('  Ride In Progress: ${status['rideInProgress']}');
              //     print('  App in Background: $_appInBackground');
              //   },
              //   child: Text('Debug Info', style: TextStyle(fontSize: w * 0.03, color: Colors.blue)),
              // ),

              SizedBox(height: w * 0.03),
              Align(
                alignment: Alignment.centerLeft,
                child: AppFonts.textPoppins(
                  context,
                  "Today's Update",
                  w * 0.038,
                  FontWeight.w600,
                  AppColors.black,
                  TextAlign.left,
                  TextOverflow.visible,
                ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
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
                        Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
                        SizedBox(height: 6),
                        Text("₹1000.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                              Text("Online", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
                              SizedBox(height: 4),
                              Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
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
                              Text("Cash", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
                              SizedBox(height: 4),
                              Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
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
                              Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
                              SizedBox(height: 4),
                              Text("50 / 45 Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                              Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
                              SizedBox(height: 4),
                              Text("50 / 05 Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
      )
   
   
  
    )

    :  Scaffold(
      body: 
      SafeArea(
        child: Stack(
          children: [
            /// 1️⃣ Google Map (BOTTOM)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: false, // Disabled to show custom marker instead
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

            /// 4️⃣ Go Online Floating Button (LAST → ALWAYS ON TOP)
            // Positioned(
            //   bottom: 320,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.green,
            //         elevation: 2,
            //         shape: const StadiumBorder(),
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 36,
            //           vertical: 14,
            //         ),
            //       ),
            //       child: const Text(
            //         "Go Online",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 15,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),

      /// Bottom Navigation
      // bottomNavigationBar: BottomnavmainScreen(),
    );
  }


  Widget _bottomOfflineCard() {
    double w = MediaQuery.of(context).size.width;
    return Container(
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
              print("hellooo");
              Get.offAll(() =>  BottomnavmainScreen());
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

            // const SizedBox(height: 16),
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
                        Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "50",
                                style: TextStyle(
                                  fontSize: 18, // bigger height
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

                        // Text("50 / 45 Completed",
                        //     style: TextStyle(fontWeight: FontWeight.w600)),
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
                        Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "50",
                                style: TextStyle(
                                  fontSize: 18, // bigger height
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

                        // Text("50 / 05 Cancelled",
                        //     style: TextStyle(fontWeight: FontWeight.w600)),
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
}