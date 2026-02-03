// // // // import 'dart:async';
// // // // import 'dart:typed_data';
// // // // import 'dart:ui' as ui;
// // // // import 'package:nzcu_driver/apiervices/services/driver_socket_service.dart';
// // // // import 'package:nzcu_driver/controllers/controllers.dart';
// // // // import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// // // // import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
// // // // import 'package:nzcu_driver/utilities/colors.dart';
// // // // import 'package:nzcu_driver/utilities/custom_font.dart';
// // // // import 'package:nzcu_driver/utilities/map_helper.dart';
// // // // import 'package:nzcu_driver/views/book_ride/book_ride.dart';
// // // // import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // // // import 'package:nzcu_driver/views/home_related/live_ride.dart';

// // // // import 'package:nzcu_driver/views/widgets/home_screen_widgets.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'package:flutter_animate/flutter_animate.dart';
// // // // import 'package:flutter_svg/svg.dart';
// // // // import 'package:geolocator/geolocator.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:permission_handler/permission_handler.dart';

// // // // import 'dart:async';
// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:socket_io_client/socket_io_client.dart' as IO;
// // // // import 'package:geolocator/geolocator.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:flutter/foundation.dart';
// // // // import 'package:permission_handler/permission_handler.dart';

// // // // class HomeScreen extends StatefulWidget {
// // // //   const HomeScreen({super.key});

// // // //   @override
// // // //   State<HomeScreen> createState() => _HomeScreenState();
// // // // }

// // // // class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
// // // //   Controllers controllers = Get.put(Controllers());
// // // //   final HomeController homeController = Get.find<HomeController>();
// // // //   final StepperController stepperController = Get.find<StepperController>();
  
// // // //   // Use the new DriverSocketService
// // // //   final DriverSocketService _socketService = DriverSocketService();
  
// // // //   // Socket state
// // // //   bool _isSocketConnected = false;
// // // //   bool _isOnDuty = false;
// // // //   bool _isProcessingOnline = false;
// // // //   String _socketStatus = 'Not Connected';
// // // //   String _socketId = '';
  
// // // //   // App lifecycle state
// // // //   AppLifecycleState? _appLifecycleState;
// // // //   bool _appInBackground = false;
// // // //   DateTime? _appBackgroundTime;
// // // //   String _selectedTab = "Driver";
// // // //   // Location variables
// // // //   double? _currentLatitude;
// // // //   double? _currentLongitude;
// // // //   String _vehicleType = 'Car';
// // // //   String? _vehicleImage;
// // // //   String? _fleetId;
  
// // // //   // Driver data
// // // //   String _driverId = '';
// // // //   String? _token;
// // // //   String? _userId;
  
// // // //   // Ride variables
// // // //   Map<String, dynamic>? _newRideRequest;
// // // //   bool _hasPendingRideRequest = false;
// // // //   Timer? _rideRequestTimer;
  
// // // //   // Reconnection tracking
// // // //   int _reconnectAttempts = 0;
// // // //   final int _maxReconnectAttempts = 5;
// // // //   Timer? _backgroundReconnectTimer;
  
// // // //   // Location streaming
// // // //   StreamSubscription<Position>? _positionStream;

// // // //   @override
// // // //   void initState() {
// // // //     homeController.home_data_method();
// // // //     super.initState();
    
// // // //     // Add observer for app lifecycle
// // // //     WidgetsBinding.instance.addObserver(this);
    
// // // //     // Initialize connection
// // // //     _initializeConnection();
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     // Remove observer
// // // //     WidgetsBinding.instance.removeObserver(this);
    
// // // //     // Clean up resources
// // // //     _cleanupResources();
    
// // // //     // Remove all socket event listeners
// // // //     _removeSocketListeners();
    
// // // //     // Disconnect socket service
// // // //     _socketService.disconnect();
    
// // // //     super.dispose();
// // // //   }
  
// // // //   void _cleanupResources() {
// // // //     // Clear all timers
// // // //     _clearRideRequestTimer();
// // // //     _stopBackgroundReconnectTimer();
// // // //     // Cancel position stream
// // // //     _positionStream?.cancel();
// // // //   }

// // // //   @override
// // // //   void didChangeAppLifecycleState(AppLifecycleState state) {
// // // //     print('📱 App lifecycle changed: $state');
    
// // // //     setState(() {
// // // //       _appLifecycleState = state;
// // // //     });
    
// // // //     switch (state) {
// // // //       case AppLifecycleState.resumed:
// // // //         _onAppResumed();
// // // //         break;
// // // //       case AppLifecycleState.inactive:
// // // //         _onAppInactive();
// // // //         break;
// // // //       case AppLifecycleState.paused:
// // // //         _onAppPaused();
// // // //         break;
// // // //       case AppLifecycleState.detached:
// // // //         _onAppDetached();
// // // //         break;
// // // //       case AppLifecycleState.hidden:
// // // //         _onAppHidden();
// // // //         break;
// // // //     }
// // // //   }

// // // //   void _onAppResumed() {
// // // //     print('📱 App resumed from background');
    
// // // //     if (_appInBackground) {
// // // //       _appInBackground = false;
      
// // // //       // Stop background reconnect timer
// // // //       _stopBackgroundReconnectTimer();
      
// // // //       // Mark app as ready for location requests
// // // //       _socketService.setAppReady(true);
      
// // // //       // Check connection status
// // // //       final status = _socketService.getConnectionStatus();
// // // //       final isConnected = status['isConnected'] ?? false;
// // // //       final isOnDuty = status['isOnDuty'] ?? false;
      
// // // //       if (isConnected && isOnDuty) {
// // // //         print('✅ Socket still connected, resuming operations...');
// // // //       } else if (isOnDuty) {
// // // //         // Was on duty but disconnected, try to reconnect
// // // //         print('⚠️ Socket disconnected while in background, reconnecting...');
// // // //         _reconnectWithRetry();
// // // //       }
      
// // // //       _appBackgroundTime = null;
// // // //     }
// // // //   }

// // // //    final CameraPosition _initialCameraPosition = const CameraPosition(
// // // //     target: LatLng(23.2508131, 77.4647936), 
// // // //     zoom: 17,
// // // //   );
// // // //    late GoogleMapController _mapController;
   
// // // //    // Markers and circles
// // // //    Set<Marker> markers = {};
// // // //    Set<Circle> circles = {};
// // // //    BitmapDescriptor? _bikeMarkerIcon;
   
// // // //    // Nearby riders/drivers
// // // //    List<Map<String, dynamic>> _nearbyRiders = [];
// // // //    Map<String, BitmapDescriptor> _vehicleIcons = {};

// // // //   void _onAppPaused() {
// // // //     print('📱 App going to background');
    
// // // //     _appInBackground = true;
// // // //     _appBackgroundTime = DateTime.now();
    
// // // //     // Clear pending ride request
// // // //     _clearPendingRideRequest();
    
// // // //     // If we're online, set up background reconnect attempts
// // // //     if (_isOnDuty) {
// // // //       _startBackgroundReconnectTimer();
// // // //     }
// // // //   }

// // // //   void _onAppInactive() {
// // // //     print('📱 App inactive (between states)');
// // // //   }

// // // //   void _onAppDetached() {
// // // //     print('📱 App detached (destroyed)');
// // // //     _cleanupResources();
// // // //   }

// // // //   void _onAppHidden() {
// // // //     print('📱 App hidden');
// // // //     _appInBackground = true;
// // // //   }




// // // //   Future<void> _initializeConnection() async {
// // // //     // Request permissions
// // // //     await _requestPermissions();
    
// // // //     // Load custom bike marker and vehicle icons
// // // //     await _loadCustomBikeMarker();
// // // //     await _loadVehicleIcons();
    
// // // //     // Wait for token to load
// // // //     await gettoken();
    
// // // //     // Start real-time location stream
// // // //     _listenToLocation();
    
// // // //     // Setup socket event listeners
// // // //     _setupSocketListeners();
    
// // // //     // Then connect socket with valid token
// // // //     if (_token != null && _driverId.isNotEmpty) {
// // // //       await _connectSocket();
// // // //     } else {
// // // //       print('❌ Cannot connect: Token or Driver ID is missing');
// // // //       _showToast('Failed to load credentials');
// // // //     }
// // // //   }

// // // //   Future<void> _requestPermissions() async {
// // // //     try {
// // // //       // Request location service
// // // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // // //       if (!serviceEnabled) {
// // // //         print('❌ Location service disabled');
// // // //         return;
// // // //       }
      
// // // //       // Request location permission
// // // //       LocationPermission permission = await Geolocator.checkPermission();
// // // //       if (permission == LocationPermission.denied) {
// // // //         permission = await Geolocator.requestPermission();
// // // //       }
      
// // // //       if (permission == LocationPermission.deniedForever) {
// // // //         print('❌ Location permission permanently denied');
// // // //         return;
// // // //       }
      
// // // //       if (permission == LocationPermission.denied) {
// // // //         print('⚠️ Location permission denied');
// // // //         return;
// // // //       }
      
// // // //       print('✅ Location permission granted');
      
// // // //       // Request notification permission (if needed)
// // // //       final notificationStatus = await Permission.notification.request();
// // // //       if (notificationStatus.isGranted) {
// // // //         print('✅ Notification permission granted');
// // // //       }
      
// // // //       // Mark app as ready
// // // //       _socketService.setAppReady(true);
      
// // // //     } catch (error) {
// // // //       print('❌ Error requesting permissions: $error');
// // // //     }
// // // //   }

// // // //   Future<void> gettoken() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final String? token = prefs.getString("auth_token");
// // // //       final String? userId = prefs.getString("driver_userid");

// // // //       setState(() {
// // // //         _token = token;
// // // //         _userId = userId;
// // // //         _driverId = userId.toString();
// // // //       });

// // // //       print('✅ Token loaded from SharedPreferences');
// // // //       print('User ID: $_userId');
// // // //       print("myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...");
// // // //       print("myyyy_driverid>>> ${_driverId}");

// // // //     } catch (e) {
// // // //       print('❌ Error loading token: $e');
// // // //     }
// // // //   }

// // // //   Future<bool> _connectSocket() async {
// // // //     print("🔄 Connecting socket...");
    
// // // //     try {
// // // //       // Check if already connected
// // // //       final status = _socketService.getConnectionStatus();
// // // //       if (status['isConnected'] ?? false) {
// // // //         print('✅ Socket already connected');
// // // //         return true;
// // // //       }

// // // //       // Connect with timeout
// // // //       final connected = await Future.any([
// // // //         _socketService.connect(),
// // // //         Future.delayed(const Duration(seconds: 5), () => false),
// // // //       ]);
      
// // // //       if (connected) {
// // // //         print('✅ Socket connected quickly');
// // // //         // Connection status will be updated via event listeners
// // // //         return true;
// // // //       } else {
// // // //         print('❌ Socket connection timeout');
// // // //         setState(() {
// // // //           _socketStatus = 'Connection Timeout';
// // // //         });
// // // //         return false;
// // // //       }
// // // //     } catch (error) {
// // // //       print('❌ Socket connection error: $error');
// // // //       setState(() {
// // // //         _socketStatus = 'Connection Error: $error';
// // // //       });
// // // //       return false;
// // // //     }
// // // //   }

// // // //   void _setupSocketListeners() {
// // // //     // ==================== CONNECTION EVENTS ====================
// // // //     _socketService.addEventListener('socket:connected', (data) {
// // // //       if (!mounted) return;
// // // //       print('✅✅✅ DRIVER SOCKET CONNECTED: ${data['socketId']}');
// // // //       setState(() {
// // // //         _isSocketConnected = true;
// // // //         _socketStatus = 'Connected';
// // // //         _socketId = data['socketId'] ?? '';
// // // //         _reconnectAttempts = 0;
// // // //       });
      
// // // //       // If we were online before, restore status
// // // //       if (_isOnDuty) {
// // // //         print('🔄 Restoring online status after connection...');
// // // //         Future.delayed(const Duration(seconds: 1), () {
// // // //           if (mounted) {
// // // //             _restoreOnlineStatus();
// // // //           }
// // // //         });
// // // //       }
// // // //     });

// // // //     _socketService.addEventListener('socket:disconnected', (data) {
// // // //       if (!mounted) return;
// // // //       print('❌ Driver socket disconnected: ${data['reason']}');
// // // //       setState(() {
// // // //         _isSocketConnected = false;
// // // //         _socketStatus = 'Disconnected';
// // // //       });
      
// // // //       // Clear pending ride request
// // // //       _clearPendingRideRequest();
      
// // // //       // If we're online and app is active, try to reconnect
// // // //       if (_isOnDuty && !_appInBackground && mounted) {
// // // //         print('🔄 Online but disconnected, will attempt reconnect...');
// // // //         Future.delayed(const Duration(seconds: 2), () {
// // // //           if (mounted && !_isSocketConnected && _isOnDuty) {
// // // //             _reconnectWithRetry();
// // // //           }
// // // //         });
// // // //       }
// // // //     });

// // // //     _socketService.addEventListener('socket:error', (data) {
// // // //       if (!mounted) return;
// // // //       print('❌ Socket error: ${data['error']}');
// // // //       _reconnectAttempts++;
// // // //       setState(() {
// // // //         _socketStatus = 'Connection Error';
// // // //       });
// // // //     });

// // // //     _socketService.addEventListener('socket:reconnected', (data) {
// // // //       if (!mounted) return;
// // // //       print('🔄 Socket reconnected after ${data['attemptNumber']} attempts');
// // // //       setState(() {
// // // //         _isSocketConnected = true;
// // // //         _socketStatus = 'Reconnected';
// // // //         _reconnectAttempts = 0;
// // // //       });
      
// // // //       // If we were online, restore status
// // // //       if (_isOnDuty) {
// // // //         _restoreOnlineStatus();
// // // //       }
// // // //     });

// // // //     // ==================== DRIVER STATUS EVENTS ====================
// // // //     _socketService.addEventListener('driver:online:success', (data) {
// // // //       if (!mounted) return;
// // // //       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
// // // //       _handleOnlineSuccess(data);
// // // //     });

// // // //     _socketService.addEventListener('driver:online:failed', (data) {
// // // //       if (!mounted) return;
// // // //       print('❌❌❌ DRIVER ONLINE FAILED: $data');
// // // //       _handleOnlineFailure(data);
// // // //     });

// // // //     _socketService.addEventListener('driver:offline', (data) {
// // // //       if (!mounted) return;
// // // //       print('🔴 Driver offline confirmed: ${data['message']}');
// // // //       setState(() {
// // // //         _isOnDuty = false;
// // // //         _isProcessingOnline = false;
// // // //       });
// // // //     });

// // // //     // ==================== RIDE REQUEST EVENTS ====================
// // // //     _socketService.addEventListener('ride:newRequest', (data) {
// // // //       if (!mounted) return;
// // // //       print('🚕🚕🚕 NEW RIDE REQUEST RECEIVED 🚕🚕🚕');
      
// // // //       // Print ALL data received
// // // //       print('📦 RAW RIDE DATA RECEIVED:');
// // // //       data.forEach((key, value) {
// // // //         print('  $key: $value (${value.runtimeType})');
// // // //       });
      
// // // //       // Check if we're online and can accept rides
// // // //       if (!_isOnDuty) {
// // // //         print('⚠️ Received ride request but driver is offline');
// // // //         return;
// // // //       }
      
// // // //       // Process the ride request
// // // //       _processRideRequest(data);
// // // //     });

// // // //     _socketService.addEventListener('ride:acceptedConfirmed', (data) async {
// // // //       if (!mounted) return;
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
// // // //       await prefs.setString("order_id", data['orderId']);

// // // //       // Navigate to ride screen
// // // //       _navigateToRideScreen(data);
// // // //     });

// // // //     _socketService.addEventListener('ride:status', (data) {
// // // //       if (!mounted) return;
// // // //       print('📊 Ride status update: ${data['status']}');
// // // //       // Handle ride status updates
// // // //     });

// // // //     _socketService.addEventListener('ride:cancelled', (data) {
// // // //       if (!mounted) return;
// // // //       print('❌ Ride cancelled: ${data['orderId']}');
// // // //       _clearPendingRideRequest();
// // // //       _showToast('Ride cancelled');
// // // //     });

// // // //     _socketService.addEventListener('ride:completed', (data) {
// // // //       if (!mounted) return;
// // // //       print('✅ Ride completed: ${data['rideId']}');
// // // //       _showToast('Ride completed successfully');
// // // //     });

// // // //     // ==================== LOCATION EVENTS ====================
// // // //     _socketService.addEventListener('ride:location', (data) {
// // // //       if (!mounted) return;
// // // //       print('📍 Rider location during ride: ${data['location']}');
// // // //     });

// // // //     // ==================== CHAT EVENTS (optional) ====================
// // // //     _socketService.addEventListener('chat:message', (data) {
// // // //       if (!mounted) return;
// // // //       print('💬 Chat message received: ${data['message']}');
// // // //     });
// // // //   }

// // // //   void _removeSocketListeners() {
// // // //     // Remove all socket event listeners to prevent setState() on disposed widgets
// // // //     _socketService.removeEventListener('socket:connected', (_) {});
// // // //     _socketService.removeEventListener('socket:disconnected', (_) {});
// // // //     _socketService.removeEventListener('socket:error', (_) {});
// // // //     _socketService.removeEventListener('socket:reconnected', (_) {});
// // // //     _socketService.removeEventListener('driver:online:success', (_) {});
// // // //     _socketService.removeEventListener('driver:online:failed', (_) {});
// // // //     _socketService.removeEventListener('driver:offline', (_) {});
// // // //     _socketService.removeEventListener('ride:newRequest', (_) {});
// // // //     _socketService.removeEventListener('ride:acceptedConfirmed', (_) {});
// // // //     _socketService.removeEventListener('ride:status', (_) {});
// // // //     _socketService.removeEventListener('ride:cancelled', (_) {});
// // // //     _socketService.removeEventListener('ride:completed', (_) {});
// // // //     _socketService.removeEventListener('ride:location', (_) {});
// // // //     _socketService.removeEventListener('chat:message', (_) {});
// // // //     print('🧹 Socket listeners removed');
// // // //   }

// // // //   void _processRideRequest(Map<String, dynamic> rideData) {
// // // //     print('🚕 Processing ride request...');
    
// // // //     try {
// // // //       // Create a deep copy to ensure data doesn't get modified
// // // //       final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
      
// // // //       // Add any missing fields with default values
// // // //       if (!rideDataCopy.containsKey('riderName')) {
// // // //         rideDataCopy['riderName'] = 'Customer';
// // // //       }
// // // //       if (!rideDataCopy.containsKey('riderNumber')) {
// // // //         rideDataCopy['riderNumber'] = 'N/A';
// // // //       }
// // // //       if (!rideDataCopy.containsKey('totalFare')) {
// // // //         rideDataCopy['totalFare'] = '0';
// // // //       }
// // // //       if (!rideDataCopy.containsKey('distance')) {
// // // //         rideDataCopy['distance'] = '0';
// // // //       }
// // // //       if (!rideDataCopy.containsKey('rideId')) {
// // // //         rideDataCopy['rideId'] = rideDataCopy['orderId'] ?? 'N/A';
// // // //       }
// // // //       if (!rideDataCopy.containsKey('timestamp')) {
// // // //         rideDataCopy['timestamp'] = DateTime.now().millisecondsSinceEpoch;
// // // //       }
      
// // // //       // Ensure nested structures exist
// // // //       if (!rideDataCopy.containsKey('startLocation')) {
// // // //         rideDataCopy['startLocation'] = {
// // // //           'address': 'Location not specified',
// // // //           'coordinates': [78.4772, 17.4065]
// // // //         };
// // // //       }
      
// // // //       if (!rideDataCopy.containsKey('endLocation')) {
// // // //         rideDataCopy['endLocation'] = {
// // // //           'address': 'Destination not specified',
// // // //           'coordinates': [78.4850, 17.4120]
// // // //         };
// // // //       }
      
// // // //       // Extract and print key information
// // // //       print('\n📋 KEY RIDE INFORMATION (Before Navigation):');
// // // //       print('├─ Ride ID: ${rideDataCopy['rideId']}');
// // // //       print('├─ Order ID: ${rideDataCopy['orderId']}');
// // // //       print('├─ Rider Name: ${rideDataCopy['riderName']}');
// // // //       print('├─ Rider Phone: ${rideDataCopy['riderNumber']}');
// // // //       print('├─ Total Fare: ₹${rideDataCopy['totalFare']}');
// // // //       print('├─ Distance: ${rideDataCopy['distance']} km');
      
// // // //       if (rideDataCopy.containsKey('startLocation')) {
// // // //         print('├─ Pickup Address: ${rideDataCopy['startLocation']?['address']}');
// // // //       }
// // // //       if (rideDataCopy.containsKey('endLocation')) {
// // // //         print('├─ Destination: ${rideDataCopy['endLocation']?['address']}');
// // // //       }
      
// // // //       // Store the new ride request
// // // //       setState(() {
// // // //         _newRideRequest = rideDataCopy;
// // // //         _hasPendingRideRequest = true;
// // // //       });

// // // //       print("myyyyyyyyyyyyyyyy_rideeeee_datattt ${rideData}");

// // // //       // Navigate to LiveRide screen IMMEDIATELY (without delay)
// // // //       if (mounted) {
// // // //         WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //           Navigator.push(
// // // //             context,
// // // //             MaterialPageRoute(
// // // //               builder: (context) => RideRequestScreen(rideData: rideData),
// // // //             ),
// // // //           );
// // // //         });
// // // //       }

// // // //       // Auto-reject timer
// // // //       final timeoutSeconds = rideDataCopy['timeout']?.toDouble() ?? 30.0;
// // // //       _startRideRequestTimer(rideDataCopy['orderId'], timeoutSeconds);

// // // //       print('✅ New ride request stored and navigating...');
// // // //       print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');
// // // //     } catch (error) {
// // // //       print('❌ Error processing ride request: $error');
// // // //       print('Stack trace: ${error.toString()}');
// // // //     }
// // // //   }

// // // //   void _navigateToRideScreen(Map<String, dynamic> rideData) {
// // // //     // Clear pending request
// // // //     _clearPendingRideRequest();
    
// // // //     // Create a deep copy for navigation
// // // //     final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
    

// // // //      print("myyyyyyyyyyyyyyyy_rideeeee_datattt222222222222 ${rideData}");
// // // //     // Navigate to ride screen
// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       Navigator.push(
// // // //         context,
// // // //         MaterialPageRoute(
// // // //           builder: (context) => RideRequestScreen(rideData: rideData),
// // // //         ),
// // // //       );
// // // //     });
// // // //   }

// // // //   // ==================== RIDE REQUEST TIMER ====================
// // // //   void _startRideRequestTimer(String orderId, double timeoutSeconds) {
// // // //     _clearRideRequestTimer();
    
// // // //     final seconds = timeoutSeconds.toInt();
    
// // // //     _rideRequestTimer = Timer(Duration(seconds: seconds), () {
// // // //       if (_hasPendingRideRequest && _newRideRequest != null) {
// // // //         print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
// // // //         _socketService.declineRide(orderId, reason: 'timeout');
// // // //         _showToast('Ride request auto-rejected (timeout)');
        
// // // //         _clearPendingRideRequest();
// // // //       }
// // // //     });
// // // //   }

// // // //   void _clearRideRequestTimer() {
// // // //     if (_rideRequestTimer != null) {
// // // //       _rideRequestTimer!.cancel();
// // // //       _rideRequestTimer = null;
// // // //     }
// // // //   }

// // // //   void _clearPendingRideRequest() {
// // // //     _clearRideRequestTimer();
// // // //     setState(() {
// // // //       _newRideRequest = null;
// // // //       _hasPendingRideRequest = false;
// // // //     });
// // // //   }

// // // //   // ==================== BACKGROUND RECONNECT ====================
// // // //   void _startBackgroundReconnectTimer() {
// // // //     _stopBackgroundReconnectTimer();
    
// // // //     print('🔄 Starting background reconnect monitoring...');
    
// // // //     _backgroundReconnectTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
// // // //       if (_appInBackground && _isOnDuty && !_isSocketConnected) {
// // // //         print('🔧 Background: Checking connection...');
// // // //         _checkAndReconnect();
// // // //       }
// // // //     });
// // // //   }

// // // //   void _stopBackgroundReconnectTimer() {
// // // //     if (_backgroundReconnectTimer != null) {
// // // //       _backgroundReconnectTimer!.cancel();
// // // //       _backgroundReconnectTimer = null;
// // // //     }
// // // //   }

// // // //   void _checkAndReconnect() {
// // // //     final status = _socketService.getConnectionStatus();
// // // //     if (!(status['isConnected'] ?? false)) {
// // // //       print('🔄 Background: Socket disconnected, attempting reconnect...');
// // // //       _socketService.connect();
// // // //     }
// // // //   }

// // // //   void _reconnectWithRetry() {
// // // //     if (_isSocketConnected) return;
    
// // // //     print('🔄 Attempting socket reconnection...');
    
// // // //     int attempts = 0;
// // // //     const maxAttempts = 3;
    
// // // //     Future.delayed(Duration.zero, () async {
// // // //       while (attempts < maxAttempts && !_isSocketConnected && mounted) {
// // // //         attempts++;
// // // //         print('🔄 Reconnection attempt $attempts/$maxAttempts');
        
// // // //         try {
// // // //           await _connectSocket();
          
// // // //           // Wait for connection
// // // //           await Future.delayed(const Duration(seconds: 2));
          
// // // //           final status = _socketService.getConnectionStatus();
// // // //           if (status['isConnected'] ?? false) {
// // // //             print('✅ Reconnection successful');
            
// // // //             // If we were online before, restore online status
// // // //             if (_isOnDuty) {
// // // //               print('🔄 Restoring online status...');
// // // //               await _restoreOnlineStatus();
// // // //             }
            
// // // //             break;
// // // //           }
// // // //         } catch (error) {
// // // //           print('❌ Reconnection attempt $attempts failed: $error');
// // // //         }
        
// // // //         if (attempts < maxAttempts) {
// // // //           await Future.delayed(Duration(seconds: attempts * 2));
// // // //         }
// // // //       }
      
// // // //       if (!_isSocketConnected) {
// // // //         print('❌ Failed to reconnect after $maxAttempts attempts');
// // // //         _showToast('Connection lost. Please check your internet.');
// // // //       }
// // // //     });
// // // //   }

// // // //   Future<void> _restoreOnlineStatus() async {
// // // //     final status = _socketService.getConnectionStatus();
// // // //     if (!(status['isConnected'] ?? false)) return;
    
// // // //     print('🔄 Restoring driver online status...');
    
// // // //     try {
// // // //       // Get current location
// // // //       final location = await _getCurrentLocation();
      
// // // //       // Go online
// // // //       await _socketService.goOnline();
      
// // // //       print('✅ Online status restored');
      
// // // //     } catch (error) {
// // // //       print('❌ Error restoring online status: $error');
// // // //     }
// // // //   }

// // // //   // ==================== DRIVER ONLINE/OFFLINE ====================
// // // //   Future<void> _goOnline() async {
// // // //     print('🟢 GOING ONLINE...');

// // // //     if (_isProcessingOnline) {
// // // //       print('⏳ Already processing...');
// // // //       return;
// // // //     }

// // // //     setState(() {
// // // //       _isProcessingOnline = true;
// // // //     });

// // // //     try {
// // // //       // Check if already connected
// // // //       final status = _socketService.getConnectionStatus();
// // // //       bool isConnected = status['isConnected'] ?? false;

// // // //       // If not connected, connect quickly (target: 1 second)
// // // //       if (!isConnected) {
// // // //         print('🔌 Socket not connected, connecting...');
// // // //         final connected = await _connectSocket();
        
// // // //         if (!connected) {
// // // //           _handleOnlineFailure('Network connection failed');
// // // //           return;
// // // //         }
        
// // // //         // Give socket a moment to be ready
// // // //         await Future.delayed(const Duration(milliseconds: 300));
// // // //       }

// // // //       // Go online with cached location (no delay for fetching)
// // // //       print('🚀 Sending online status with cached location...');
// // // //       final success = await _socketService.goOnline();

// // // //       if (success) {
// // // //         print('✅ Online request sent successfully');
// // // //       } else {
// // // //         _handleOnlineFailure('Failed to go online');
// // // //       }
// // // //     } catch (e) {
// // // //       print('❌ Error: $e');
// // // //       _handleOnlineFailure('Error: $e');
// // // //     }
// // // //   }

// // // //   void _handleOnlineSuccess(dynamic data) {
// // // //     if (!_isProcessingOnline) return;

// // // //     print('✅ DRIVER ONLINE SUCCESS');

// // // //     setState(() {
// // // //       _isOnDuty = true;
// // // //       _isProcessingOnline = false;
// // // //     });

// // // //     String successMessage = 'Driver is now online';
// // // //     if (data is Map<String, dynamic>) {
// // // //       successMessage = data['message'] ?? successMessage;
// // // //     }

// // // //     _showToast(successMessage);

// // // //     // Animate camera and create marker (async operations)
   
// // // //     // _createBikeMarkerAndCircle(); // Returns Future but we don't await to avoid blocking UI
// // // //   }

// // // //   void _handleOnlineFailure(dynamic data) {
// // // //     if (!_isProcessingOnline) return;

// // // //     print('❌ DRIVER ONLINE FAILED');

// // // //     setState(() {
// // // //       _isOnDuty = false;
// // // //       _isProcessingOnline = false;
// // // //     });

// // // //     String errorMessage = 'Failed to go online';
// // // //     if (data is String) {
// // // //       errorMessage = data;
// // // //     } else if (data is Map<String, dynamic>) {
// // // //       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
// // // //     }

// // // //     _showToast(errorMessage);
// // // //   }

// // // //   Future<void> _goOffline() async {
// // // //     print('🔴 GOING OFFLINE...');
    
// // // //     try {
// // // //       // Stop processing any online requests
// // // //       setState(() {
// // // //         _isProcessingOnline = false;
// // // //       });

// // // //       // Go offline via socket service (fully disconnects)
// // // //       await _socketService.goOffline();
      
// // // //       setState(() {
// // // //         _isOnDuty = false;
// // // //       });

// // // //       // Remove bike marker and circle
// // // //       _removeBikeMarkerAndCircle();

// // // //       // Clear pending ride request
// // // //       _clearPendingRideRequest();

// // // //       print('✅ Driver is now offline - socket disconnected');
// // // //       _showToast('Offline - Socket disconnected');
      
// // // //     } catch (error) {
// // // //       print('❌ Error going offline: $error');
// // // //       _showToast('Error going offline');
// // // //     }
// // // //   }

// // // //   // ==================== LOCATION METHODS ====================
// // // //   /// 📡 LIVE LOCATION LISTENER (Marker moves in real-time)
// // // //   void _listenToLocation() {
// // // //     _positionStream = Geolocator.getPositionStream(
// // // //       locationSettings: const LocationSettings(
// // // //         accuracy: LocationAccuracy.high,
// // // //         distanceFilter: 10, // Update every 10 meters
// // // //       ),
// // // //     ).listen((Position position) {
// // // //       final LatLng newLocation =
// // // //           LatLng(position.latitude, position.longitude);

// // // //       // Update marker and circles only (camera stays put)
// // // //       _updateMarkerOnly(newLocation, position.accuracy);
      
// // // //       // Also update socket service coordinates
// // // //       _currentLatitude = position.latitude;
// // // //       _currentLongitude = position.longitude;
      
// // // //       print('📍 Location updated: ${position.latitude}, ${position.longitude} (Accuracy: ${position.accuracy}m)');
// // // //     });
// // // //   }
  
// // // //   /// 🔄 Update only marker and circles (camera stays put)
// // // //   void _updateMarkerOnly(LatLng location, double accuracy) {
// // // //     _currentLatitude = location.latitude;
// // // //     _currentLongitude = location.longitude;

// // // //     setState(() {
// // // //       markers.clear();
// // // //       circles.clear();
   
// // // //       // Bike marker
// // // //       markers.add(
// // // //         Marker(
// // // //           markerId: const MarkerId('driver_location'),
// // // //           position: location,
// // // //           icon: _bikeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
// // // //           anchor: const Offset(0.5, 0.5),
// // // //           infoWindow: const InfoWindow(
// // // //             title: 'Your Location',
// // // //             snippet: 'You are here',
// // // //           ),
// // // //           zIndex: 2,
// // // //         ),
// // // //       );

// // // //       // Grey outer circle (accuracy shadow)
// // // //       circles.add(
// // // //         Circle(
// // // //           circleId: const CircleId('outer_shadow'),
// // // //           center: location,
// // // //           radius: accuracy + 80,
// // // //           fillColor: Colors.grey.withOpacity(0.25),
// // // //           strokeColor: Colors.transparent,
// // // //         ),
// // // //       );

// // // //       // Green inner circle (center)
// // // //       circles.add(
// // // //         Circle(
// // // //           circleId: const CircleId('inner_green'),
// // // //           center: location,
// // // //           radius: 60,
// // // //           fillColor: Colors.green.withOpacity(0.35),
// // // //           strokeColor: Colors.green,
// // // //           strokeWidth: 1,
// // // //         ),
// // // //       );
// // // //     });

// // // //     print('✅ Driver marker and circles updated at (${location.latitude}, ${location.longitude})');
// // // //   }
  
// // // //   /// 📍 Get current location (can be called manually if needed)
// // // //   Future<Map<String, dynamic>> _getCurrentLocation() async {
// // // //     try {
// // // //       final position = await Geolocator.getCurrentPosition(
// // // //         locationSettings: const LocationSettings(
// // // //           accuracy: LocationAccuracy.high,
// // // //         ),
// // // //       );
      
// // // //       final coordinates = {
// // // //         'latitude': position.latitude,
// // // //         'longitude': position.longitude,
// // // //         'accuracy': position.accuracy,
// // // //       };

// // // //       setState(() {
// // // //         _currentLatitude = position.latitude;
// // // //         _currentLongitude = position.longitude;
// // // //       });
      
// // // //       print('✅ Got current location: ${position.latitude}, ${position.longitude}');
      
// // // //       return coordinates;
// // // //     } catch (e) {
// // // //       print('❌ Error getting location: $e');
// // // //       return {'latitude': 23.2508438, 'longitude': 77.4647827, 'accuracy': 0.0};
// // // //     }
// // // //   }


 

// // // //   // Create bike marker and circle at current location (async)

// // // //   // Remove bike marker and circle
// // // //   void _removeBikeMarkerAndCircle() {
// // // //     setState(() {
// // // //       markers.clear();
// // // //       circles.clear();
// // // //     });
// // // //     print('✅ Bike marker and circle removed');
// // // //   }

// // // //   // Load custom bike marker icon from assets
// // // //   Future<void> _loadCustomBikeMarker() async {
// // // //     try {
// // // //       _bikeMarkerIcon = await MapHelper.loadCustomIcon(
// // // //         assetPath: 'assets/images/bike2.png',
// // // //         width: 80,
// // // //         height: 80,
// // // //       );
// // // //       print('✅ Custom bike marker icon loaded');
// // // //     } catch (e) {
// // // //       print('❌ Error loading custom bike marker: $e');
// // // //       _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
// // // //     }
// // // //   }

// // // //   // Load vehicle icons for nearby riders
// // // //   Future<void> _loadVehicleIcons() async {
// // // //     try {
// // // //       _vehicleIcons = await MapHelper.loadVehicleIcons(
// // // //         iconSize: 70,
// // // //       );
// // // //       print('✅ Vehicle icons loaded');
// // // //     } catch (e) {
// // // //       print('❌ Error loading vehicle icons: $e');
// // // //     }
// // // //   }




// // // //   // ==================== NOTIFICATIONS ====================
// // // //   void _showRideRequestNotification(Map<String, dynamic> rideData) {
// // // //     if (!mounted) return;

// // // //     // Extract data
// // // //     final riderName = rideData['riderName']?.toString() ?? 'Customer';
// // // //     final riderPhone = rideData['riderNumber']?.toString() ?? '';
// // // //     final distance = rideData['distance']?.toString() ?? '0';
// // // //     final fare = rideData['totalFare']?.toString() ?? '0';
// // // //     final pickup = rideData['startLocation']?['address']?.toString() ?? 'Location not specified';
// // // //     final destination = rideData['endLocation']?['address']?.toString() ?? 'Destination not specified';
// // // //     final orderId = rideData['orderId']?.toString() ?? '';

// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: false,
// // // //       builder: (context) => AlertDialog(
// // // //         title: const Row(
// // // //           children: [
// // // //             Icon(Icons.local_taxi, color: Colors.green),
// // // //             SizedBox(width: 10),
// // // //             Text('🚕 New Ride Request'),
// // // //           ],
// // // //         ),
// // // //         content: SingleChildScrollView(
// // // //           child: Column(
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               ListTile(
// // // //                 leading: CircleAvatar(
// // // //                   child: Text(riderName.substring(0, 1).toUpperCase()),
// // // //                 ),
// // // //                 title: Text(riderName, style: const TextStyle(fontWeight: FontWeight.bold)),
// // // //                 subtitle: Text(riderPhone),
// // // //               ),
// // // //               const Divider(),
// // // //               Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       const Text('Fare', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // // //                       Text('₹$fare', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // // //                     ],
// // // //                   ),
// // // //                   Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       const Text('Distance', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // // //                       Text('$distance km', style: const TextStyle(fontSize: 16)),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 16),
// // // //               Row(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   const Icon(Icons.location_on, color: Colors.green, size: 20),
// // // //                   const SizedBox(width: 8),
// // // //                   Expanded(
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         const Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // // //                         Text(pickup, style: const TextStyle(fontSize: 14)),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 8),
// // // //               Row(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   const Icon(Icons.location_on, color: Colors.red, size: 20),
// // // //                   const SizedBox(width: 8),
// // // //                   Expanded(
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         const Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // // //                         Text(destination, style: const TextStyle(fontSize: 14)),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               if (orderId.isNotEmpty) {
// // // //                 _socketService.declineRide(orderId);
// // // //                 _showToast('Ride rejected');
// // // //                 _clearPendingRideRequest();
// // // //               }
// // // //             },
// // // //             child: const Text('Reject', style: TextStyle(color: Colors.red)),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               if (orderId.isNotEmpty) {
// // // //                 _socketService.acceptRide(rideData);
// // // //                 print('✅ Ride accepted: $orderId');
// // // //                 _showToast('Ride accepted!');
// // // //                 _clearPendingRideRequest();
// // // //               }
// // // //             },
// // // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// // // //             child: const Text('Accept'),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showToast(String message) {
// // // //     if (!mounted) return;

// // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // //       SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
// // // //     );
// // // //   }


// // // //   void _toggleOnlineStatus() {
// // // //     if (_isOnDuty) {
// // // //       _goOffline();
// // // //     } else {
// // // //       _goOnline();
// // // //     }
// // // //   }

  

// // // //   // ==================== UI BUILD ====================
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     double w = MediaQuery.of(context).size.width;

// // // //     return
    
    
// // // //              _isOnDuty == false ? 
// // // //  Scaffold(
// // // //       backgroundColor: AppColors.white,
// // // //       appBar: PreferredSize(
// // // //         preferredSize: Size.fromHeight(w * .300),
// // // //         child: Container(
// // // //           height: w * .290,
// // // //           decoration: BoxDecoration(
// // // //             color: AppColors.white,
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                 color: Colors.grey.withOpacity(0.2),
// // // //                 spreadRadius: 1,
// // // //                 blurRadius: 2,
// // // //                 offset: const Offset(0, 3),
// // // //               ),
// // // //             ],
// // // //             borderRadius: BorderRadius.only(
// // // //               bottomLeft: Radius.circular(w * 0.04),
// // // //               bottomRight: Radius.circular(w * 0.04),
// // // //             ),
// // // //           ),
// // // //           child: SafeArea(
// // // //             child: Padding(
// // // //               padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // // //               child: Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                 children: [
// // // //                   Row(
// // // //                     children: [
// // // //                       CircleAvatar(
// // // //                         radius: w * 0.06,
// // // //                         backgroundImage: const AssetImage('assets/images/home2.png'),
// // // //                       ),
// // // //                       SizedBox(width: w * 0.03),
// // // //                       AppFonts.textPoppins(
// // // //                         context,
// // // //                         "Ayaan Malviya",
// // // //                         w * 0.05,
// // // //                         FontWeight.w600,
// // // //                         AppColors.black,
// // // //                         TextAlign.left,
// // // //                         TextOverflow.visible,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   Column(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       // Connection status indicator
// // // //                       // Container(
// // // //                       //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // // //                       //   decoration: BoxDecoration(
// // // //                       //     color: _getConnectionColor(),
// // // //                       //     borderRadius: BorderRadius.circular(12),
// // // //                       //   ),
// // // //                       //   child: Row(
// // // //                       //     mainAxisSize: MainAxisSize.min,
// // // //                       //     children: [
// // // //                       //       Icon(_getConnectionIcon(), size: 12, color: Colors.white),
// // // //                       //       const SizedBox(width: 4),
// // // //                       //       Text(
// // // //                       //         _getConnectionText(),
// // // //                       //         style: const TextStyle(color: Colors.white, fontSize: 10),
// // // //                       //       ),
// // // //                       //     ],
// // // //                       //   ),
// // // //                       // ),
// // // //                       SizedBox(height: w * 0.01),
// // // //                       // Online/Offline toggle
// // // //                       GestureDetector(
// // // //                         onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
// // // //                         child: Container(
// // // //                           width: w * 0.26,
// // // //                           height: w * 0.10,
// // // //                           decoration: BoxDecoration(
// // // //                             color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
// // // //                             borderRadius: BorderRadius.circular(w * 0.06),
// // // //                           ),
// // // //                           alignment: Alignment.center,
// // // //                           child: _isProcessingOnline
// // // //                               ? SizedBox(
// // // //                                   width: w * 0.04,
// // // //                                   height: w * 0.04,
// // // //                                   child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// // // //                                 )
// // // //                               : Text(
// // // //                                   _isOnDuty ? 'Online' : 'Offline',
// // // //                                   style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
// // // //                                 ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
// // // //           begin: const Offset(0.95, 0.95),
// // // //           end: const Offset(1, 1),
// // // //         ),
// // // //       ),
// // // //       body: 
      

// // // //      SingleChildScrollView(
// // // //         child: Padding(
// // // //           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.center,
// // // //             children: [

// // // //               // Status indicators
// // // //               if (_hasPendingRideRequest && _newRideRequest != null)
// // // //                 Container(
// // // //                   margin: EdgeInsets.only(bottom: w * 0.02),
// // // //                   padding: EdgeInsets.all(w * 0.015),
// // // //                   decoration: BoxDecoration(
// // // //                     color: Colors.orange[50],
// // // //                     borderRadius: BorderRadius.circular(w * 0.02),
// // // //                     border: Border.all(color: Colors.orange),
// // // //                   ),
// // // //                   child: Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       Icon(Icons.local_taxi, color: Colors.orange, size: w * 0.04),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       Expanded(
// // // //                         child: Column(
// // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // //                           children: [
// // // //                             Text('🚕 Pending Ride Request', style: TextStyle(fontSize: w * 0.03, color: Colors.orange[800]!, fontWeight: FontWeight.w600)),
// // // //                             Text('Tap to view details', style: TextStyle(fontSize: w * 0.025, color: Colors.orange[600]!)),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       IconButton(
// // // //                         icon: Icon(Icons.visibility, size: w * 0.04),
// // // //                         onPressed: () {
// // // //                           if (_newRideRequest != null) {
// // // //                             Text("ajayyyyyyyyyyyyyyyyyyyy");
// // // //                             // _showRideRequestNotification(_newRideRequest!);
// // // //                           }
// // // //                         },
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),

// // // //               SizedBox(height: w * 0.04),
// // // //               Image.asset("assets/images/offline_image.png",height: w * 0.5,),
// // // //               Text(
// // // //                 _isOnDuty ? "You're Online" : "You're Offline",
// // // //                 style: TextStyle(
// // // //                   fontSize: w * 0.05,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: _isOnDuty ? Colors.green : Colors.black,
// // // //                 ),
// // // //               ),
// // // //               Text(
// // // //                 _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
// // // //                 style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
// // // //               ),
// // // //               SizedBox(height: w * 0.04),
// // // //               ElevatedButton(
// // // //                 onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   // padding: EdgeInsets.symmetric(vertical: 2),
// // // //                   shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
// // // //                   backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
// // // //                   minimumSize: const Size(double.infinity, 45),
// // // //                 ),
// // // //                 child: _isProcessingOnline
// // // //                     ? SizedBox(
// // // //                         width: w * 0.04,
// // // //                         height: w * 0.04,
// // // //                         child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// // // //                       )
// // // //                     : Text(
// // // //                         _isOnDuty ? "Go Offline" : "Go Online",
// // // //                         style: TextStyle(fontSize: w * 0.04, color: Colors.white),
// // // //                       ),
// // // //               ),

            
// // // //               SizedBox(height: w * 0.03),
// // // //               Align(
// // // //                 alignment: Alignment.centerLeft,
// // // //                 child: AppFonts.textPoppins(
// // // //                   context,
// // // //                   "Today's Update",
// // // //                   w * 0.038,
// // // //                   FontWeight.w600,
// // // //                   AppColors.black,
// // // //                   TextAlign.left,
// // // //                   TextOverflow.visible,
// // // //                 ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
// // // //                   begin: const Offset(0.95, 0.95),
// // // //                   end: const Offset(1, 1),
// // // //                 ),
// // // //               ),
// // // //               SizedBox(height: w * 0.04),
// // // //               Column(
// // // //                 children: [
// // // //                   HomeScreenWidgets.elevatedBox(
// // // //                     shadowColor: const Color(0xFF4CAF50),
// // // //                     width: double.infinity,
// // // //                     child: const Column(
// // // //                       children: [
// // // //                         Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
// // // //                         SizedBox(height: 6),
// // // //                         Text("₹1000.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 16),
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     children: [
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: HomeScreenWidgets.elevatedBox(
// // // //                           shadowColor: const Color(0xFFFEBC2F),
// // // //                           child: const Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text("Online", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // // //                               SizedBox(height: 4),
// // // //                               Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: HomeScreenWidgets.elevatedBox(
// // // //                           shadowColor: const Color(0xFF7C7C8D),
// // // //                           child: const Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text("Cash", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // // //                               SizedBox(height: 4),
// // // //                               Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                   SizedBox(height: w * 0.05),
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: HomeScreenWidgets.elevatedBox(
// // // //                           shadowColor: const Color(0xFF439AFE),
// // // //                           child: const Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // // //                               SizedBox(height: 4),
// // // //                               Text("50 / 45 Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: HomeScreenWidgets.elevatedBox(
// // // //                           shadowColor: const Color(0xFFF26061),
// // // //                           child: const Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // // //                               SizedBox(height: 4),
// // // //                               Text("50 / 05 Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               SizedBox(height: w * 0.04),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       )
   
   
  
// // // //     )

// // // //     :  Scaffold(
// // // //       body: 
// // // //       SafeArea(
// // // //         child: Stack(
// // // //           children: [
// // // //             /// 1️⃣ Google Map (BOTTOM)
// // // //             GoogleMap(
// // // //               initialCameraPosition: _initialCameraPosition,
// // // //               myLocationEnabled: false, // Disabled to show custom marker instead
// // // //               myLocationButtonEnabled: false,
// // // //               zoomControlsEnabled: false,
// // // //               onMapCreated: (controller) {
// // // //                 _mapController = controller;
// // // //               },
// // // //               markers: markers,
// // // //               circles: circles,
// // // //             ),

// // // //             /// 2️⃣ Book Ride Button (Top Right)
// // // //             Positioned(
// // // //               top: 16,
// // // //               right: 16,
// // // //               child: ElevatedButton(
// // // //                 onPressed: () {
// // // //                   Get.to(() => const BookRide());
// // // //                 },
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: Colors.cyan,
// // // //                   elevation: 4,
// // // //                   shape: const StadiumBorder(),
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 18,
// // // //                     vertical: 10,
// // // //                   ),
// // // //                 ),
// // // //                 child: const Text(
// // // //                   "Book Ride",
// // // //                   style: TextStyle(
// // // //                     color: Colors.black,
// // // //                     fontWeight: FontWeight.w600,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),

// // // //             /// 3️⃣ Bottom Offline Card (FIRST)
// // // //             Positioned(
// // // //               bottom: 0,
// // // //               left: 0,
// // // //               right: 0,
// // // //               child: _bottomOfflineCard(),
// // // //             ),

// // // //             /// 4️⃣ Go Online Floating Button (LAST → ALWAYS ON TOP)
// // // //             // Positioned(
// // // //             //   bottom: 320,
// // // //             //   left: 0,
// // // //             //   right: 0,
// // // //             //   child: Center(
// // // //             //     child: ElevatedButton(
// // // //             //       onPressed: () {},
// // // //             //       style: ElevatedButton.styleFrom(
// // // //             //         backgroundColor: Colors.green,
// // // //             //         elevation: 2,
// // // //             //         shape: const StadiumBorder(),
// // // //             //         padding: const EdgeInsets.symmetric(
// // // //             //           horizontal: 36,
// // // //             //           vertical: 14,
// // // //             //         ),
// // // //             //       ),
// // // //             //       child: const Text(
// // // //             //         "Go Online",
// // // //             //         style: TextStyle(
// // // //             //           color: Colors.white,
// // // //             //           fontSize: 15,
// // // //             //           fontWeight: FontWeight.w600,
// // // //             //         ),
// // // //             //       ),
// // // //             //     ),
// // // //             //   ),
// // // //             // ),
// // // //           ],
// // // //         ),
// // // //       ),

// // // //       /// Bottom Navigation
// // // //       // bottomNavigationBar: BottomnavmainScreen(),
// // // //     );
// // // //   }


// // // //   Widget _bottomOfflineCard() {
// // // //     double w = MediaQuery.of(context).size.width;
// // // //     return Container(
// // // //       margin: EdgeInsets.only(top: 200),
// // // //       padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
// // // //       decoration: const BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// // // //         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
// // // //       ),
// // // //       child: Column(
// // // //         mainAxisSize: MainAxisSize.min,
// // // //         children: [
// // // //           /// Driver & Earnings
// // // //           Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //             children: [
// // // //               HomeScreenWidgets.topAction(
// // // //                 icon: _selectedTab == "Driver"
// // // //                     ? "assets/icons/drive.png"
// // // //                     : "assets/icons/driveoff.svg",
// // // //                 label: "Driver",
// // // //                 onTap: () {
// // // //                   setState(() {
// // // //                     _selectedTab = "Driver";
// // // //                   });
// // // //                 },
// // // //                 isSelected: _selectedTab == "Driver",
// // // //               ),
// // // //               SizedBox(width: w * 0.25),
// // // //               HomeScreenWidgets.topAction(
// // // //                 icon: _selectedTab == "Earnings"
// // // //                     ? "assets/icons/dolleron.svg"
// // // //                     : "assets/icons/doller.png",
// // // //                 label: "Earnings",
// // // //                 onTap: () {
// // // //                   setState(() {
// // // //                     _selectedTab = "Earnings";
// // // //                   });
// // // //                 },
// // // //                 isSelected: _selectedTab == "Earnings",
// // // //               ),
// // // //             ],
// // // //           ),

// // // //           const SizedBox(height: 16),

// // // //           /// Conditional Content
// // // //           if (_selectedTab == "Driver")
// // // //             _driverContent()
// // // //           else
// // // //             _earningsContent(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //    Widget _driverContent() {
// // // //     return Column(
// // // //       children: [
// // // //         /// Offline Image
// // // //         Image.asset("assets/images/onlinee.png", height: 120),

// // // //         const SizedBox(height: 12),

// // // //         const Text(
// // // //           "You're Online",
// // // //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //         ),

// // // //         const SizedBox(height: 6),

// // // //         const Text(
// // // //           "Go offline to stop accepting rides.",
// // // //           style: TextStyle(color: Colors.grey),
// // // //           textAlign: TextAlign.center,
// // // //         ),

// // // //         const SizedBox(height: 16),

// // // //         /// Go Online Button (Bottom)
// // // //         SizedBox(
// // // //           width: double.infinity,
// // // //           height: 48,
// // // //           child: ElevatedButton(
// // // //             onPressed: () {
// // // //               print("hellooo");
// // // //               Get.offAll(() =>  BottomnavmainScreen());
// // // //             },
// // // //             style: ElevatedButton.styleFrom(
// // // //               backgroundColor: Colors.redAccent,
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //             ),
// // // //             child: const Text(
// // // //               "Go Offline",
// // // //               style: TextStyle(
// // // //                 color: Colors.white,
// // // //                 fontSize: 16,
// // // //                 fontWeight: FontWeight.w600,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   /// Earnings Content
// // // //   Widget _earningsContent() {
// // // //     double w = MediaQuery.of(context).size.width;
// // // //     return Column(
// // // //       children: [
// // // //         Align(
// // // //           alignment: Alignment.centerLeft,
// // // //           child:
// // // //               AppFonts.textPoppins(
// // // //                     context,
// // // //                     "Today's Update",
// // // //                     w * 0.038,
// // // //                     FontWeight.w600,
// // // //                     AppColors.black,
// // // //                     TextAlign.left,
// // // //                     TextOverflow.visible,
// // // //                   )
// // // //                   .animate()
// // // //                   .fade(duration: 820.ms, curve: Curves.easeInOut)
// // // //                   .scale(
// // // //                     begin: const Offset(0.95, 0.95),
// // // //                     end: const Offset(1, 1),
// // // //                   ),
// // // //         ),
// // // //         SizedBox(height: w * 0.02),

// // // //         Column(
// // // //           children: [
// // // //             /// Today's Earnings (Full Width)
// // // //             HomeScreenWidgets.elevatedBox(
// // // //               width: double.infinity,
// // // //               shadowColor: const Color(0xFF4CAF50),
// // // //               child: Column(
// // // //                 children: const [
// // // //                   Text(
// // // //                     "Today's Earnings",
// // // //                     style: TextStyle(fontSize: 14, color: Colors.grey),
// // // //                   ),
// // // //                   SizedBox(height: 1),
// // // //                   Text(
// // // //                     "₹1000.00",
// // // //                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),

// // // //             SizedBox(height: w * 0.02),

// // // //             /// Online & Cash
// // // //             Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,

// // // //               children: [
// // // //                 SizedBox(
// // // //                   width: w * 0.4,
// // // //                   child: HomeScreenWidgets.elevatedBox(
// // // //                     shadowColor: const Color(0xFFFEBC2F),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: const [
// // // //                         Text(
// // // //                           "Online",
// // // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // // //                         ),
// // // //                         SizedBox(height: 1),
// // // //                         Text(
// // // //                           "₹500 Total",
// // // //                           style: TextStyle(fontWeight: FontWeight.w600),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(width: w * 0.01),
// // // //                 SizedBox(
// // // //                   width: w * 0.45,
// // // //                   child: HomeScreenWidgets.elevatedBox(
// // // //                     shadowColor: const Color(0xFF7C7C8D),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: const [
// // // //                         Text(
// // // //                           "Cash",
// // // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // // //                         ),
// // // //                         SizedBox(height: 1),
// // // //                         Text(
// // // //                           "₹500 On Hand",
// // // //                           style: TextStyle(fontWeight: FontWeight.w600),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),

// // // //             // const SizedBox(height: 16),
// // // //             SizedBox(height: w * 0.02),

// // // //             /// Ride Stats
// // // //             Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 SizedBox(
// // // //                   width: w * 0.4,
// // // //                   child: HomeScreenWidgets.elevatedBox(
// // // //                     shadowColor: const Color(0xFF439AFE),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text(
// // // //                           "Total Rides",
// // // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // // //                         ),
// // // //                         SizedBox(height: 1),
// // // //                         RichText(
// // // //                           text: const TextSpan(
// // // //                             children: [
// // // //                               TextSpan(
// // // //                                 text: "50",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 18, // bigger height
// // // //                                   fontWeight: FontWeight.bold,
// // // //                                   color: Colors.black,
// // // //                                 ),
// // // //                               ),
// // // //                               TextSpan(
// // // //                                 text: " / 45 Completed",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 14,
// // // //                                   fontWeight: FontWeight.w600,
// // // //                                   color: Colors.black,
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),

// // // //                         // Text("50 / 45 Completed",
// // // //                         //     style: TextStyle(fontWeight: FontWeight.w600)),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(width: w * 0.02),
// // // //                 SizedBox(
// // // //                   width: w * 0.45,
// // // //                   child: HomeScreenWidgets.elevatedBox(
// // // //                     shadowColor: const Color(0xFFF26061),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text(
// // // //                           "Total Rides",
// // // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // // //                         ),
// // // //                         SizedBox(height: 1),
// // // //                         RichText(
// // // //                           text: const TextSpan(
// // // //                             children: [
// // // //                               TextSpan(
// // // //                                 text: "50",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 18, // bigger height
// // // //                                   fontWeight: FontWeight.bold,
// // // //                                   color: Colors.black,
// // // //                                 ),
// // // //                               ),
// // // //                               TextSpan(
// // // //                                 text: " / 45 Completed",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 14,
// // // //                                   fontWeight: FontWeight.w600,
// // // //                                   color: Colors.black,
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),

// // // //                         // Text("50 / 05 Cancelled",
// // // //                         //     style: TextStyle(fontWeight: FontWeight.w600)),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }




// // // // class DriverSocketService {
// // // //   // Singleton instance
// // // //   static final DriverSocketService _instance = DriverSocketService._internal();
// // // //   factory DriverSocketService() => _instance;
// // // //   DriverSocketService._internal();

// // // //   // Socket
// // // //   IO.Socket? _socket;
// // // //   bool _isConnected = false;
// // // //   String? _socketId;
  
// // // //   // Driver data
// // // //   String? _driverId;
// // // //   String? _driverName;
// // // //   String? _driverPhone;
// // // //   String? _driverImage;
// // // //   String? _vehicleType;
// // // //   String? _vehicleNumber;
// // // //   String? _vehicleImage;
// // // //   String? _fleetId;
  
// // // //   // Location
// // // //   double _currentLatitude = 0.0;
// // // //   double _currentLongitude = 0.0;
// // // //   DateTime? _lastLocationUpdate;
// // // //   StreamSubscription<Position>? _positionStreamSubscription;
// // // //   Timer? _locationUpdateTimer;
  
// // // //   // Location optimization
// // // //   double? _lastSentLatitude;
// // // //   double? _lastSentLongitude;
// // // //   static const double LOCATION_CHANGE_THRESHOLD = 0.0001; // ~11 meters
  
// // // //   // Ride tracking
// // // //   Map<String, dynamic>? _currentRide;
// // // //   String? _activeRideId;
// // // //   DateTime? _rideStartTime;
// // // //   bool _isRideInProgress = false;
// // // //   bool _isOnDuty = false;
  
// // // //   // Configuration
// // // //   static const String SOCKET_URL = 'https://corezap.smarttechbros.com';
// // // //   static const int LOCATION_UPDATE_INTERVAL = 5000; // 5 seconds (optimized from 3)
// // // //   static const int LOCATION_TIMEOUT = 15000; // 15 seconds (reduced from 30)
// // // //   static const int MAX_RECONNECT_ATTEMPTS = 5; // Reduced from 10
// // // //   static const int CONNECTION_TIMEOUT = 10000; // 10 seconds
// // // //   int _reconnectAttempts = 0;
  
// // // //   // App state
// // // //   bool _isAppReady = false;
// // // //   bool _permissionCheckInProgress = false;
  
// // // //   // Event listeners
// // // //   final Map<String, List<Function(dynamic)>> _listeners = {};
  
// // // //   // Debug
// // // //   bool _debug = true;

// // // //   // ==================== PUBLIC API ====================

// // // //   Future<bool> connect() async {
// // // //     try {
// // // //       if (_socket != null && _isConnected) {
// // // //         _log('Socket already connected');
// // // //         return true;
// // // //       }

// // // //       // Get driver ID
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       _driverId = prefs.getString('driver_userid');

// // // //       if (_driverId == null || _driverId!.isEmpty) {
// // // //         _logError('No driver ID found');
// // // //         return false;
// // // //       }

// // // //       // Get token
// // // //       final token = prefs.getString('auth_token');

// // // //       if (token == null || token.isEmpty) {
// // // //         _logError('No authentication token found');
// // // //         return false;
// // // //       }

// // // //       // Get driver data
// // // //       await _fetchDriverData();

// // // //       // Disconnect existing
// // // //       disconnect();

// // // //       _log('🔌 Connecting driver socket...');

// // // //       // Create socket connection with optimized settings
// // // //       _socket = IO.io(
// // // //         SOCKET_URL,
// // // //         IO.OptionBuilder()
// // // //             .setTransports(['websocket', 'polling'])
// // // //             .enableAutoConnect()
// // // //             .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
// // // //             .setReconnectionDelay(1000)
// // // //             .setReconnectionDelayMax(5000)
// // // //             .setTimeout(CONNECTION_TIMEOUT) // Faster timeout
// // // //             .setAuth({'token': token})
// // // //             .setQuery({
// // // //               'userRole': 'Driver',
// // // //               'platform': 'flutter',
// // // //               'driverId': _driverId,
// // // //             })
// // // //             .build(),
// // // //       );

// // // //       // Setup event listeners
// // // //       _setupEventListeners();

// // // //       // Connect
// // // //       _socket!.connect();

// // // //       // Wait for connection with timeout
// // // //       return await _waitForConnection();
// // // //     } catch (error) {
// // // //       _logError('Socket connection error: $error');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   Future<void> disconnect() async {
// // // //     // Don't disconnect if ride is in progress
// // // //     if (_isRideInProgress && _activeRideId != null) {
// // // //       _log('⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.');
// // // //       return;
// // // //     }

// // // //     _stopLocationWatch();
// // // //     _stopLocationUpdates();
    
// // // //     if (_socket != null) {
// // // //       _socket!.disconnect();
// // // //       _socket!.dispose();
// // // //       _socket = null;
// // // //     }
    
// // // //     _isConnected = false;
// // // //     _socketId = null;
// // // //     _isOnDuty = false;
// // // //     _log('🔌 Driver socket disconnected');
// // // //   }

// // // //   Future<bool> goOnline() async {
// // // //     try {
// // // //       if (_socket == null || !_isConnected) {
// // // //         _log('⚠️ Socket not connected, cannot go online');
// // // //         return false;
// // // //       }

// // // //       // Get location
// // // //       try {
// // // //         await _getCurrentLocation();
// // // //       } catch (error) {
// // // //         _log('⚠️ Location fetch failed: $error');
// // // //       }

// // // //       final payload = {
// // // //         'latitude': _currentLatitude,
// // // //         'longitude': _currentLongitude,
// // // //         'vehicleType': _vehicleType,
// // // //         'vehicleImage': _vehicleImage,
// // // //         'fleetId': _fleetId,
// // // //         'timestamp': DateTime.now().toIso8601String(),
// // // //       };

// // // //       _log('📡 Emitting user:online:', payload);
// // // //       _socket!.emit('user:online', payload);

// // // //       // Start location tracking
// // // //       _startLocationWatch();
// // // //       _startLocationUpdates();

// // // //       _isOnDuty = true;
// // // //       _log('🟢 Driver is now online and ready for rides');
      
// // // //       return true;
// // // //     } catch (error) {
// // // //       _logError('Error going online: $error');
// // // //       _isOnDuty = false;
// // // //       return false;
// // // //     }
// // // //   }

// // // //   Future<void> goOffline() async {
// // // //     try {
// // // //       if (_socket != null && _isConnected) {
// // // //         _log('🔴 Going offline');
        
// // // //         // Emit offline event to backend
// // // //         final payload = {
// // // //           'driverId': _driverId,
// // // //           'timestamp': DateTime.now().toIso8601String(),
// // // //         };
// // // //         _socket!.emit('user:offline', payload);
// // // //         _log('📡 Emitted user:offline event:', payload);
        
// // // //         // Stop location updates immediately
// // // //         _stopLocationWatch();
// // // //         _stopLocationUpdates();
// // // //         _isOnDuty = false;
        
// // // //         // Disconnect socket completely (instantly, no delay)
// // // //         _socket!.disconnect();
// // // //         _socket!.dispose();
// // // //         _socket = null;
// // // //         _isConnected = false;
// // // //         _socketId = null;
        
// // // //         _log('✅ Socket completely disconnected');
        
// // // //         _notifyListeners('driver:offline', {
// // // //           'message': 'Driver is now offline and socket disconnected',
// // // //           'timestamp': DateTime.now().toIso8601String(),
// // // //         });
// // // //       }
// // // //     } catch (error) {
// // // //       _logError('Error going offline: $error');
// // // //     }
// // // //   }

// // // //   bool acceptRide(Map<String, dynamic> rideData) {
// // // //     if (_socket == null || !_isConnected) {
// // // //       _logError('Cannot accept ride - socket not connected');
// // // //       return false;
// // // //     }

// // // //     final orderId = rideData['orderId'] ?? 
// // // //                    rideData['_id'] ?? 
// // // //                    rideData['id'] ?? 
// // // //                    rideData['rideId'];
    
// // // //     if (orderId == null) {
// // // //       _logError('No order ID found in ride data');
// // // //       return false;
// // // //     }

// // // //     // Mark ride as in progress
// // // //     _activeRideId = orderId;
// // // //     _rideStartTime = DateTime.now();
// // // //     _isRideInProgress = true;
    
// // // //     _currentRide = {
// // // //       'orderId': orderId,
// // // //       'status': 'accepting',
// // // //       'data': rideData,
// // // //     };

// // // //     final payload = {
// // // //       'orderId': orderId,
// // // //       'driverId': _driverId,
// // // //       'driverName': _driverName,
// // // //       'driverPhone': _driverPhone,
// // // //       'driverImage': _driverImage,
// // // //       'acceptedAt': DateTime.now().toIso8601String(),
// // // //       'location': {
// // // //         'latitude': _currentLatitude,
// // // //         'longitude': _currentLongitude,
// // // //       },
// // // //       'vehicleType': _vehicleType,
// // // //       'vehicleNumber': _vehicleNumber,
// // // //       'vehicleImage': _vehicleImage,
// // // //     };

// // // //     _log('✅ Emitting ride:accept with driver data:', payload);
// // // //     _socket!.emit('ride:accept', payload);
    
// // // //     return true;
// // // //   }

// // // //   bool declineRide(String rideId, {String reason = ''}) {
// // // //     if (_socket == null || !_isConnected) {
// // // //       return false;
// // // //     }

// // // //     final payload = {
// // // //       'orderId': rideId,
// // // //       'driverId': _driverId,
// // // //       'reason': reason,
// // // //       'declinedAt': DateTime.now().toIso8601String(),
// // // //     };

// // // //     _log('❌ Declining ride:', payload);
// // // //     _socket!.emit('ride:decline', payload);
// // // //     return true;
// // // //   }

// // // //   bool joinChatRoom(String orderId, {String userRole = 'driver'}) {
// // // //     if (_socket == null || !_isConnected) {
// // // //       _logError('Cannot join chat - socket not connected');
// // // //       return false;
// // // //     }

// // // //     final payload = {
// // // //       'rideId': orderId,
// // // //       'orderId': orderId,
// // // //       'userRole': userRole,
// // // //       'userId': _driverId,
// // // //       'timestamp': DateTime.now().toIso8601String(),
// // // //     };

// // // //     _log('💬 Joining chat room:', payload);
// // // //     _socket!.emit('chat:join', payload);
// // // //     return true;
// // // //   }

// // // //   bool sendChatMessage(
// // // //     String orderId, 
// // // //     String message, {
// // // //     String? receiverId,
// // // //     String? chatId,
// // // //   }) {
// // // //     if (_socket == null || !_isConnected) {
// // // //       _logError('Cannot send message - socket not connected');
// // // //       return false;
// // // //     }

// // // //     final payload = {
// // // //       'rideId': orderId,
// // // //       'orderId': orderId,
// // // //       'chatId': chatId,
// // // //       'message': message.trim(),
// // // //       'senderId': _driverId,
// // // //       'senderType': 'Driver',
// // // //       'senderRole': 'driver',
// // // //       'receiverId': receiverId,
// // // //       'receiverRole': 'user',
// // // //       'timestamp': DateTime.now().toIso8601String(),
// // // //     };

// // // //     _log('💬 Sending message:', payload);
    
// // // //     // Emit to both known events for compatibility
// // // //     _socket!.emit('chat:sendMessage', payload);
// // // //     _socket!.emit('sendChatMessage', payload);
    
// // // //     return true;
// // // //   }

// // // //   bool sendTypingIndicator(String orderId, bool isTyping, {String userRole = 'driver'}) {
// // // //     if (_socket == null || !_isConnected) {
// // // //       return false;
// // // //     }

// // // //     final payload = {
// // // //       'orderId': orderId,
// // // //       'userRole': userRole,
// // // //       'isTyping': isTyping,
// // // //     };

// // // //     _socket!.emit('chat:typing', payload);
// // // //     return true;
// // // //   }

// // // //   void completeRide(String rideId) {
// // // //     if (_activeRideId == rideId || rideId.isNotEmpty) {
// // // //       _log('✅ Ride completed (ID: $rideId)');
// // // //       _activeRideId = null;
// // // //       _rideStartTime = null;
// // // //       _isRideInProgress = false;
// // // //       _currentRide = null;
      
// // // //       _notifyListeners('ride:completed', {
// // // //         'rideId': rideId,
// // // //         'message': 'Ride completed successfully',
// // // //       });
// // // //     }
// // // //   }

// // // //   void addEventListener(String event, Function(dynamic) callback) {
// // // //     if (!_listeners.containsKey(event)) {
// // // //       _listeners[event] = [];
// // // //     }
// // // //     _listeners[event]!.add(callback);
// // // //     _log('✅ Added listener for: $event');
// // // //   }

// // // //   void removeEventListener(String event, Function(dynamic) callback) {
// // // //     if (_listeners.containsKey(event)) {
// // // //       _listeners[event]!.remove(callback);
// // // //       _log('❌ Removed listener for: $event');
// // // //     }
// // // //   }

// // // //   void setAppReady(bool ready) {
// // // //     _isAppReady = ready;
// // // //     _log(ready ? '✅ App ready for location requests' : '⏳ App not ready');
// // // //   }

// // // //   Map<String, dynamic> getConnectionStatus() {
// // // //     return {
// // // //       'isConnected': _isConnected,
// // // //       'socketId': _socketId,
// // // //       'driverId': _driverId,
// // // //       'isOnDuty': _isOnDuty,
// // // //       'currentRide': _currentRide,
// // // //       'location': {
// // // //         'latitude': _currentLatitude,
// // // //         'longitude': _currentLongitude,
// // // //       },
// // // //       'rideInProgress': _isRideInProgress,
// // // //       'activeRideId': _activeRideId,
// // // //     };
// // // //   }

// // // //   Map<String, dynamic> getCurrentCoordinates() {
// // // //     return {
// // // //       'latitude': _currentLatitude,
// // // //       'longitude': _currentLongitude,
// // // //     };
// // // //   }

// // // //   Map<String, dynamic> getRideStatus() {
// // // //     return {
// // // //       'activeRideId': _activeRideId,
// // // //       'isRideInProgress': _isRideInProgress,
// // // //       'rideStartTime': _rideStartTime?.millisecondsSinceEpoch,
// // // //       'duration': _rideStartTime != null 
// // // //           ? DateTime.now().difference(_rideStartTime!).inMilliseconds 
// // // //           : 0,
// // // //     };
// // // //   }

// // // //   void debugSocket() {
// // // //     print('🔍 === DRIVER SOCKET DEBUG ===');
// // // //     print('Connected: $_isConnected');
// // // //     print('Socket ID: $_socketId');
// // // //     print('Driver ID: $_driverId');
// // // //     print('On Duty: $_isOnDuty');
// // // //     print('Current Ride: $_currentRide');
// // // //     print('Ride In Progress: $_isRideInProgress');
// // // //     print('Active Ride ID: $_activeRideId');
// // // //     print('Location: ${getCurrentCoordinates()}');
// // // //     print('==============================');
// // // //   }

// // // //   // ==================== PRIVATE METHODS ====================

// // // //   void _setupEventListeners() {
// // // //     if (_socket == null) return;

// // // //     // CONNECTION EVENTS
// // // //     _socket!.onConnect((_) {
// // // //       _log('✅ Driver socket connected: ${_socket!.id}');
// // // //       _isConnected = true;
// // // //       _socketId = _socket!.id;
// // // //       _reconnectAttempts = 0;
      
// // // //       _notifyListeners('socket:connected', {
// // // //         'socketId': _socket!.id,
// // // //         'message': 'Driver socket connected successfully',
// // // //       });
      
// // // //       // Auto go online if driver was on duty
// // // //       if (_isOnDuty) {
// // // //         Timer(const Duration(seconds: 1), () {
// // // //           goOnline();
// // // //         });
// // // //       }
// // // //     });

// // // //     _socket!.onDisconnect((_) {
// // // //       _log('❌ Driver socket disconnected');
// // // //       _isConnected = false;
// // // //       _stopLocationUpdates();
// // // //       _notifyListeners('socket:disconnected', {'reason': 'disconnected'});
// // // //     });

// // // //     _socket!.onConnectError((data) {
// // // //       _logError('Socket connection error: $data');
// // // //       _reconnectAttempts++;
// // // //       _notifyListeners('socket:error', {'error': data.toString()});
// // // //     });

// // // //     _socket!.onReconnect((data) {
// // // //       _log('🔄 Socket reconnected');
// // // //       _reconnectAttempts = 0;
// // // //       _notifyListeners('socket:reconnected', {'attemptNumber': _reconnectAttempts});
// // // //     });

// // // //     // DRIVER STATUS EVENTS
// // // //     _socket!.on('driver:online_success', (data) {
// // // //       _log('✅ Driver online confirmed:', data);
// // // //       _isOnDuty = true;
// // // //       _notifyListeners('driver:online:success', data);
// // // //     });

// // // //     _socket!.on('driver:online_failed', (data) {
// // // //       _logError('❌ Driver online failed:', data);
// // // //       _isOnDuty = false;
// // // //       _notifyListeners('driver:online:failed', data);
// // // //     });

// // // //     // RIDE REQUEST EVENTS
// // // //     _socket!.on('ride:newRide', (data) {
// // // //       final rideData = _mapRideData(data);
// // // //       _log('🚕 NEW RIDE REQUEST RECEIVED:', rideData);
// // // //       // Navigator.push(context, Mater)
      
// // // //       _notifyListeners('ride:newRequest', rideData);
// // // //     });

// // // //     _socket!.on('ride:confirmed', (data) {
// // // //       _log('✅ Ride accepted - Backend confirmed:', data);
      
// // // //       final orderId = data['orderId'] ?? data['_id'];
// // // //       if (orderId == null) return;
      
// // // //       // Update current ride state
// // // //       _currentRide = {
// // // //         'orderId': orderId,
// // // //         'status': 'confirmed',
// // // //         'rider': data['rider'] ?? data['user'],
// // // //         'pickup': data['pickupLocation'] ?? data['startLocation'],
// // // //         'dropoff': data['dropoffLocation'] ?? data['endLocation'],
// // // //         'fare': data['fare'] ?? data['totalFare'],
// // // //         'distance': data['distance'],
// // // //         'duration': data['duration'] ?? data['estimatedTime'],
// // // //         'otp': data['otp'],
// // // //         'completeData': data,
// // // //       };
      
// // // //       if (_activeRideId == orderId) {
// // // //         _log('🚗 Ride confirmation matched active ride');
// // // //       } else {
// // // //         _log('⚠️ Ride confirmation for different ride, updating active ride');
// // // //         _activeRideId = orderId;
// // // //         _rideStartTime = DateTime.now();
// // // //         _isRideInProgress = true;
// // // //       }
      
// // // //       _log('🚗 Ride state updated to CONFIRMED');
// // // //       _notifyListeners('ride:acceptedConfirmed', _currentRide);
// // // //     });

// // // //     _socket!.on('ride:status', (data) {
// // // //       _log('📊 Ride status update:', data);
      
// // // //       final orderId = data['orderId'];
// // // //       if (_currentRide != null && _currentRide!['orderId'] == orderId) {
// // // //         _currentRide!['status'] = data['status'];
// // // //       }
      
// // // //       // Mark ride as complete
// // // //       final status = data['status'];
// // // //       if (status == 'completed' || status == 'finished' || status == 'ended') {
// // // //         _log('✅ Ride completion status received: $status');
// // // //         completeRide(orderId);
// // // //       }
      
// // // //       _notifyListeners('ride:status', data);
// // // //     });

// // // //     _socket!.on('ride:orderCancelled', (data) {
// // // //       _log('❌ Ride cancelled:', data);
// // // //       completeRide(data['orderId']);
// // // //       _currentRide = null;
// // // //       _notifyListeners('ride:cancelled', data);
// // // //     });

// // // //     _socket!.on('ride:location', (data) {
// // // //       _log('📍 Rider location during ride:', data);
// // // //       _notifyListeners('ride:location', data);
// // // //     });

// // // //     // CHAT EVENTS
// // // //     _socket!.on('chat:join_success', (data) {
// // // //       _log('✅ Joined chat room:', data);
// // // //       _notifyListeners('chat:joined', data);
// // // //     });

// // // //     _socket!.on('chat:receiveMessage', (data) {
// // // //       _log('💬 New chat message received:', data);
// // // //       _notifyListeners('chat:message', data);
// // // //     });

// // // //     _socket!.on('chat:message', (data) {
// // // //       _log('💬 New chat message received:', data);
// // // //       _notifyListeners('chat:message', data);
// // // //     });

// // // //     // Generic event listener for debugging
// // // //     _socket!.onAny((event, data) {
// // // //       _log('[RECEIVED] $event:', data);
// // // //     });
// // // //   }

// // // //   Map<String, dynamic> _mapRideData(dynamic data) {
// // // //     final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
    
// // // //     // Extract pickup coordinates
// // // //     Map<String, dynamic>? pickupCoords;
// // // //     if (rideData['pickup'] != null) {
// // // //       final pickup = Map<String, dynamic>.from(rideData['pickup']);
// // // //       if (pickup['latitude'] != null && pickup['longitude'] != null) {
// // // //         pickupCoords = {
// // // //           'latitude': double.parse(pickup['latitude'].toString()),
// // // //           'longitude': double.parse(pickup['longitude'].toString()),
// // // //         };
// // // //       }
// // // //     }
    
// // // //     // Extract dropoff coordinates
// // // //     Map<String, dynamic>? dropoffCoords;
// // // //     if (rideData['destination'] != null) {
// // // //       final destination = Map<String, dynamic>.from(rideData['destination']);
// // // //       if (destination['latitude'] != null && destination['longitude'] != null) {
// // // //         dropoffCoords = {
// // // //           'latitude': double.parse(destination['latitude'].toString()),
// // // //           'longitude': double.parse(destination['longitude'].toString()),
// // // //         };
// // // //       }
// // // //     }
    
// // // //     // Build mapped data
// // // //     return {
// // // //       ...rideData,
// // // //       'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
// // // //       'pickup': pickupCoords,
// // // //       'destination': dropoffCoords,
// // // //       'startLocation': {
// // // //         'address': rideData['startLocation']?['address'] ?? 'Pickup Location',
// // // //         'coordinates': pickupCoords,
// // // //       },
// // // //       'endLocation': rideData['endLocation'] != null ? {
// // // //         'address': rideData['endLocation']?['address'] ?? 'Drop Location',
// // // //         'coordinates': dropoffCoords,
// // // //       } : null,
// // // //       'riderId': rideData['riderId'] ?? rideData['userId']?['_id'] ?? rideData['userId'],
// // // //       'riderName': rideData['riderName'] ?? rideData['userId']?['name'] ?? 'Customer',
// // // //       'riderNumber': (rideData['riderNumber'] ?? rideData['userId']?['phone'] ?? '').toString(),
// // // //       'totalFare': (rideData['totalFare'] ?? rideData['fare']?['total'] ?? rideData['fare'] ?? '0').toString(),
// // // //       'distance': (rideData['distance'] ?? '0').toString(),
// // // //       'estimatedTime': (rideData['estimatedTime'] ?? '15').toString(),
// // // //       'vehicleType': rideData['vehicleType'] ?? 'sedan',
// // // //       'otp': rideData['otp'],
// // // //     };
// // // //   }

// // // //   Future<bool> _waitForConnection() async {
// // // //     final completer = Completer<bool>();
    
// // // //     // Faster timeout for connection (5 seconds instead of 10)
// // // //     final timeout = Timer(const Duration(seconds: 5), () {
// // // //       if (!completer.isCompleted) {
// // // //         _logError('Connection timeout');
// // // //         completer.complete(false);
// // // //       }
// // // //     });
    
// // // //     _socket!.once('connect', (_) {
// // // //       timeout.cancel();
// // // //       if (!completer.isCompleted) {
// // // //         _log('✅ Socket connected!');
// // // //         completer.complete(true);
// // // //       }
// // // //     });
    
// // // //     _socket!.once('connect_error', (error) {
// // // //       timeout.cancel();
// // // //       if (!completer.isCompleted) {
// // // //         _logError('Connection error: $error');
// // // //         completer.complete(false);
// // // //       }
// // // //     });
    
// // // //     return completer.future;
// // // //   }

// // // //   // ==================== LOCATION METHODS ====================

// // // //   Future<bool> _requestLocationPermission() async {
// // // //     if (_permissionCheckInProgress) {
// // // //       return false;
// // // //     }

// // // //     try {
// // // //       _permissionCheckInProgress = true;

// // // //       // Check if permission is already granted
// // // //       var status = await Permission.location.status;
// // // //       if (status.isGranted) {
// // // //         _permissionCheckInProgress = false;
// // // //         return true;
// // // //       }

// // // //       // Request permission
// // // //       status = await Permission.location.request();
// // // //       _permissionCheckInProgress = false;
      
// // // //       return status.isGranted;
// // // //     } catch (error) {
// // // //       _permissionCheckInProgress = false;
// // // //       _logError('Location permission error: $error');
// // // //       return false;
// // // //     }
// // // //   }

// // // //   Future<Position> _getCurrentLocation() async {
// // // //     try {
// // // //       // If app is not ready, use cached location
// // // //       if (!_isAppReady) {
// // // //         _log('⏳ App not ready yet, using cached location if available');
// // // //         if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
// // // //           // Return a simple location object without creating a full Position
// // // //           return await Geolocator.getCurrentPosition(
// // // //             desiredAccuracy: LocationAccuracy.best,
// // // //           );
// // // //         }
// // // //         throw Exception('App not ready and no cached location available');
// // // //       }

// // // //       final hasPermission = await _requestLocationPermission();
// // // //       if (!hasPermission) {
// // // //         _log('⚠️ Location permission denied');
// // // //         if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
// // // //           _log('ℹ️ Using last known location');
// // // //           // Return current location instead of creating a Position manually
// // // //           return await Geolocator.getCurrentPosition(
// // // //             desiredAccuracy: LocationAccuracy.best,
// // // //           );
// // // //         }
// // // //         throw Exception('Location permission denied');
// // // //       }

// // // //       return await Geolocator.getCurrentPosition(
// // // //         desiredAccuracy: LocationAccuracy.best,
// // // //         timeLimit: const Duration(seconds: 30),
// // // //       ).timeout(
// // // //         const Duration(seconds: 30),
// // // //         onTimeout: () {
// // // //           _log('⚠️ Location request timeout');
// // // //           if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
// // // //             // Return a simple location by making a new request
// // // //             return Geolocator.getCurrentPosition(
// // // //               desiredAccuracy: LocationAccuracy.best,
// // // //             );
// // // //           }
// // // //           throw TimeoutException('Location timeout');
// // // //         },
// // // //       ).then((position) {
// // // //         _currentLatitude = position.latitude;
// // // //         _currentLongitude = position.longitude;
// // // //         _lastLocationUpdate = DateTime.now();
        
// // // //         _log('📍 Location fetched:', {
// // // //           'latitude': _currentLatitude,
// // // //           'longitude': _currentLongitude,
// // // //           'accuracy': position.accuracy,
// // // //         });
        
// // // //         return position;
// // // //       });
// // // //     } catch (error) {
// // // //       _logError('Failed to get location: $error');
      
// // // //       // Fallback to cached location
// // // //       if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
// // // //         _log('✅ Returning fallback cached location');
// // // //         // Return the last known coordinates via a new location request
// // // //         return await Geolocator.getCurrentPosition(
// // // //           desiredAccuracy: LocationAccuracy.best,
// // // //         );
// // // //       }
      
// // // //       rethrow;
// // // //     }
// // // //   }

// // // //   void _startLocationWatch() {
// // // //     if (_positionStreamSubscription != null) {
// // // //       _log('ℹ️ Location watch already active');
// // // //       return;
// // // //     }

// // // //     _log('📍 Starting continuous location watch');

// // // //     // Get initial location immediately
// // // //     _getInitialLocation();

// // // //     _positionStreamSubscription = Geolocator.getPositionStream(
// // // //       locationSettings: const LocationSettings(
// // // //         accuracy: LocationAccuracy.best,
// // // //         distanceFilter: 5,
// // // //       ),
// // // //     ).listen((position) {
// // // //       _currentLatitude = position.latitude;
// // // //       _currentLongitude = position.longitude;
// // // //       _lastLocationUpdate = DateTime.now();
// // // //       _log('📍 Location updated: $_currentLatitude, $_currentLongitude');
      
// // // //       // Send location update if on duty
// // // //       if (_isOnDuty && _socket != null && _isConnected) {
// // // //         _sendLocationUpdate();
// // // //       }
// // // //     }, onError: (error) {
// // // //       _log('⚠️ Location watch error: $error');
// // // //     });
// // // //   }

// // // //   Future<void> _getInitialLocation() async {
// // // //     try {
// // // //       final position = await Geolocator.getCurrentPosition(
// // // //         forceAndroidLocationManager: false,
// // // //         timeLimit: const Duration(seconds: 5),
// // // //       );
// // // //       _currentLatitude = position.latitude;
// // // //       _currentLongitude = position.longitude;
// // // //       _lastLocationUpdate = DateTime.now();
// // // //       _log('✅ Initial location obtained: $_currentLatitude, $_currentLongitude');
// // // //     } catch (e) {
// // // //       _log('⚠️ Error getting initial location: $e');
// // // //       // Try to get last known location as fallback
// // // //       try {
// // // //         final lastPosition = await Geolocator.getLastKnownPosition();
// // // //         if (lastPosition != null) {
// // // //           _currentLatitude = lastPosition.latitude;
// // // //           _currentLongitude = lastPosition.longitude;
// // // //           _log('📍 Using last known location: $_currentLatitude, $_currentLongitude');
// // // //         }
// // // //       } catch (e) {
// // // //         _log('⚠️ Could not get last known position: $e');
// // // //       }
// // // //     }
// // // //   }

// // // //   void _stopLocationWatch() {
// // // //     if (_positionStreamSubscription != null) {
// // // //       _positionStreamSubscription!.cancel();
// // // //       _positionStreamSubscription = null;
// // // //       _log('⏹️ Stopped location watch');
// // // //     }
// // // //   }

// // // //   void _sendLocationUpdate() {
// // // //     if (_socket == null || !_isConnected) return;

// // // //     // Only send if location has changed significantly
// // // //     final latDiff = (_currentLatitude - (_lastSentLatitude ?? _currentLatitude)).abs();
// // // //     final lngDiff = (_currentLongitude - (_lastSentLongitude ?? _currentLongitude)).abs();
    
// // // //     if (latDiff < LOCATION_CHANGE_THRESHOLD && lngDiff < LOCATION_CHANGE_THRESHOLD) {
// // // //       return; // Skip sending if location change is too small
// // // //     }

// // // //     // Update last sent coordinates
// // // //     _lastSentLatitude = _currentLatitude;
// // // //     _lastSentLongitude = _currentLongitude;

// // // //     // 1. General driver location update
// // // //     final driverPayload = {
// // // //       'latitude': _currentLatitude,
// // // //       'longitude': _currentLongitude,
// // // //       'role': 'Driver',
// // // //       'vehicleType': _vehicleType,
// // // //       'vehicleImage': _vehicleImage,
// // // //       'fleetId': _fleetId,
// // // //       'timestamp': DateTime.now().toIso8601String(),
// // // //     };

// // // //     _socket!.emit('driver:location:update', driverPayload);

// // // //     // 2. Specific ride location update (if in a ride)
// // // //     final rideId = _activeRideId ?? _currentRide?['orderId'] ?? _currentRide?['rideId'];
    
// // // //     if (rideId != null) {
// // // //       final ridePayload = {
// // // //         'rideId': rideId,
// // // //         'location': {
// // // //           'latitude': _currentLatitude,
// // // //           'longitude': _currentLongitude,
// // // //           'lat': _currentLatitude,
// // // //           'lng': _currentLongitude,
// // // //           'timestamp': DateTime.now().toIso8601String(),
// // // //           'accuracy': 0.0,
// // // //           'speed': 0.0,
// // // //         },
// // // //       };

// // // //       _socket!.emit('ride:location:update', ridePayload);
// // // //     }
// // // //   }

// // // //   void _startLocationUpdates() {
// // // //     _stopLocationUpdates();

// // // //     _log('🔄 Starting location update broadcasts every 3 seconds');

// // // //     _locationUpdateTimer = Timer.periodic(
// // // //       const Duration(milliseconds: LOCATION_UPDATE_INTERVAL),
// // // //       (_) {
// // // //         if (_socket != null && _isConnected && _isOnDuty) {
// // // //           if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
// // // //             _sendLocationUpdate();
// // // //           }
// // // //         }
// // // //       },
// // // //     );
// // // //   }

// // // //   void _stopLocationUpdates() {
// // // //     if (_locationUpdateTimer != null) {
// // // //       _locationUpdateTimer!.cancel();
// // // //       _locationUpdateTimer = null;
// // // //       _log('⏹️ Stopped location update broadcasts');
// // // //     }
// // // //   }

// // // //   // ==================== DRIVER DATA ====================

// // // //   Future<void> _fetchDriverData() async {
// // // //     try {
// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       final storedDriverData = prefs.getString('driverData');
      
// // // //       if (storedDriverData != null) {
// // // //         final driverData = json.decode(storedDriverData);
        
// // // //         // Store complete driver profile data
// // // //         _driverName = driverData['name'] ?? driverData['driverName'];
// // // //         _driverPhone = driverData['phone'] ?? driverData['phoneNumber'];
// // // //         _driverImage = driverData['profileImage'] ?? 
// // // //                        driverData['image'] ?? 
// // // //                        driverData['driverImage'];
// // // //         _vehicleType = driverData['vehicleType'];
// // // //         _vehicleNumber = driverData['vehicleNumber'] ?? driverData['vehicleNo'];
// // // //         _vehicleImage = driverData['vehicleImage'];
// // // //         _fleetId = driverData['fleetId'];
        
// // // //         _log('✅ Driver profile loaded:', {
// // // //           'name': _driverName,
// // // //           'phone': _driverPhone,
// // // //           'vehicleType': _vehicleType,
// // // //           'vehicleNumber': _vehicleNumber,
// // // //         });
// // // //       }
// // // //     } catch (error) {
// // // //       _logError('Error fetching driver data: $error');
// // // //     }
// // // //   }

// // // //   // ==================== HELPER METHODS ====================

// // // //   void _notifyListeners(String event, dynamic data) {
// // // //     if (_listeners.containsKey(event)) {
// // // //       for (final callback in _listeners[event]!) {
// // // //         try {
// // // //           callback(data);
// // // //         } catch (error) {
// // // //           _logError('Error in $event listener: $error');
// // // //         }
// // // //       }
// // // //     }
// // // //   }

// // // //   void _log(String message, [dynamic data]) {
// // // //     if (_debug) {
// // // //       if (data != null) {
// // // //         print('[DRIVER SOCKET] $message ${data.toString()}');
// // // //       } else {
// // // //         print('[DRIVER SOCKET] $message');
// // // //       }
// // // //     }
// // // //   }

// // // //   void _logError(String message, [dynamic data]) {
// // // //     if (_debug) {
// // // //       if (data != null) {
// // // //         print('[DRIVER SOCKET ERROR] $message ${data.toString()}');
// // // //       } else {
// // // //         print('[DRIVER SOCKET ERROR] $message');
// // // //       }
// // // //     }
// // // //   }
// // // // }




// // // import 'dart:async';
// // // import 'dart:typed_data';
// // // import 'dart:ui' as ui;
// // // import 'package:nzcu_driver/api/services/driver_socket_service.dart';
// // // import 'package:nzcu_driver/controllers/controllers.dart';
// // // import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// // // import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
// // // import 'package:nzcu_driver/utilities/colors.dart';
// // // import 'package:nzcu_driver/utilities/custom_font.dart';
// // // import 'package:nzcu_driver/utilities/map_helper.dart';
// // // import 'package:nzcu_driver/views/book_ride/book_ride.dart';
// // // import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // // import 'package:nzcu_driver/views/home_related/live_ride.dart';
// // // import 'package:nzcu_driver/views/widgets/home_screen_widgets.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:flutter_animate/flutter_animate.dart';
// // // import 'package:flutter_svg/svg.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:get/get.dart';
// // // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:permission_handler/permission_handler.dart';

// // // class HomeScreen extends StatefulWidget {
// // //   const HomeScreen({super.key});

// // //   @override
// // //   State<HomeScreen> createState() => _HomeScreenState();
// // // }

// // // class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
// // //   Controllers controllers = Get.put(Controllers());
// // //   final HomeController homeController = Get.find<HomeController>();
// // //   final StepperController stepperController = Get.find<StepperController>();
  
// // //   // Use the new DriverSocketService
// // //   final DriverSocketService _socketService = DriverSocketService();
  
// // //   // Socket state
// // //   bool _isSocketConnected = false;
// // //   bool _isOnDuty = false;
// // //   bool _isProcessingOnline = false;
// // //   String _socketStatus = 'Not Connected';
// // //   String _socketId = '';
  
// // //   // App lifecycle state
// // //   AppLifecycleState? _appLifecycleState;
// // //   bool _appInBackground = false;
// // //   DateTime? _appBackgroundTime;
// // //   String _selectedTab = "Driver";
  
// // //   // Location variables
// // //   double? _currentLatitude;
// // //   double? _currentLongitude;
// // //   String _vehicleType = 'Car';
// // //   String? _vehicleImage;
// // //   String? _fleetId;
  
// // //   // Driver data
// // //   String _driverId = '';
// // //   String? _token;
// // //   String? _userId;
  
// // //   // Ride variables
// // //   Map<String, dynamic>? _newRideRequest;
// // //   bool _hasPendingRideRequest = false;
// // //   Timer? _rideRequestTimer;
  
// // //   // Reconnection tracking
// // //   int _reconnectAttempts = 0;
// // //   final int _maxReconnectAttempts = 5;
// // //   Timer? _backgroundReconnectTimer;
  
// // //   // Location streaming
// // //   StreamSubscription<Position>? _positionStream;
  
// // //   // Map variables
// // //   final CameraPosition _initialCameraPosition = const CameraPosition(
// // //     target: LatLng(23.2508131, 77.4647936), 
// // //     zoom: 17,
// // //   );
// // //   late GoogleMapController _mapController;
  
// // //   // Markers and circles
// // //   Set<Marker> markers = {};
// // //   Set<Circle> circles = {};
// // //   BitmapDescriptor? _bikeMarkerIcon;
  
// // //   // Nearby riders/drivers
// // //   List<Map<String, dynamic>> _nearbyRiders = [];
// // //   Map<String, BitmapDescriptor> _vehicleIcons = {};

// // //   @override
// // //   void initState() {
// // //     homeController.home_data_method();
// // //     super.initState();
    
// // //     // Add observer for app lifecycle
// // //     WidgetsBinding.instance.addObserver(this);
    
// // //     // Initialize connection
// // //     _initializeConnection();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     // Remove observer
// // //     WidgetsBinding.instance.removeObserver(this);
    
// // //     // Clean up resources
// // //     _cleanupResources();
    
// // //     // Remove all socket event listeners
// // //     _removeSocketListeners();
    
// // //     // Disconnect socket service
// // //     _socketService.disconnect();
    
// // //     super.dispose();
// // //   }
  
// // //   void _cleanupResources() {
// // //     // Clear all timers
// // //     _clearRideRequestTimer();
// // //     _stopBackgroundReconnectTimer();
// // //     // Cancel position stream
// // //     _positionStream?.cancel();
// // //   }

// // //   @override
// // //   void didChangeAppLifecycleState(AppLifecycleState state) {
// // //     print('📱 App lifecycle changed: $state');
    
// // //     setState(() {
// // //       _appLifecycleState = state;
// // //     });
    
// // //     switch (state) {
// // //       case AppLifecycleState.resumed:
// // //         _onAppResumed();
// // //         break;
// // //       case AppLifecycleState.inactive:
// // //         _onAppInactive();
// // //         break;
// // //       case AppLifecycleState.paused:
// // //         _onAppPaused();
// // //         break;
// // //       case AppLifecycleState.detached:
// // //         _onAppDetached();
// // //         break;
// // //       case AppLifecycleState.hidden:
// // //         _onAppHidden();
// // //         break;
// // //     }
// // //   }

// // //   void _onAppResumed() {
// // //     print('📱 App resumed from background');
    
// // //     if (_appInBackground) {
// // //       _appInBackground = false;
      
// // //       // Stop background reconnect timer
// // //       _stopBackgroundReconnectTimer();
      
// // //       // Mark app as ready for location requests
// // //       _socketService.setAppReady(true);
      
// // //       // Check connection status
// // //       final status = _socketService.getConnectionStatus();
// // //       final isConnected = status['isConnected'] ?? false;
// // //       final isOnDuty = status['isOnDuty'] ?? false;
      
// // //       if (isConnected && isOnDuty) {
// // //         print('✅ Socket still connected, resuming operations...');
// // //       } else if (isOnDuty) {
// // //         // Was on duty but disconnected, try to reconnect
// // //         print('⚠️ Socket disconnected while in background, reconnecting...');
// // //         _reconnectWithRetry();
// // //       }
      
// // //       _appBackgroundTime = null;
// // //     }
// // //   }

// // //   void _onAppPaused() {
// // //     print('📱 App going to background');
    
// // //     _appInBackground = true;
// // //     _appBackgroundTime = DateTime.now();
    
// // //     // Clear pending ride request
// // //     _clearPendingRideRequest();
    
// // //     // If we're online, set up background reconnect attempts
// // //     if (_isOnDuty) {
// // //       _startBackgroundReconnectTimer();
// // //     }
// // //   }

// // //   void _onAppInactive() {
// // //     print('📱 App inactive (between states)');
// // //   }

// // //   void _onAppDetached() {
// // //     print('📱 App detached (destroyed)');
// // //     _cleanupResources();
// // //   }

// // //   void _onAppHidden() {
// // //     print('📱 App hidden');
// // //     _appInBackground = true;
// // //   }

// // //   Future<void> _initializeConnection() async {
// // //     // Request permissions
// // //     await _requestPermissions();
    
// // //     // Load custom bike marker and vehicle icons
// // //     await _loadCustomBikeMarker();
// // //     await _loadVehicleIcons();
    
// // //     // Wait for token to load
// // //     await gettoken();
    
// // //     // Start real-time location stream
// // //     _listenToLocation();
    
// // //     // Setup socket event listeners
// // //     _setupSocketListeners();
    
// // //     // Then connect socket with valid token
// // //     if (_token != null && _driverId.isNotEmpty) {
// // //       await _connectSocket();
// // //     } else {
// // //       print('❌ Cannot connect: Token or Driver ID is missing');
// // //       _showToast('Failed to load credentials');
// // //     }
// // //   }

// // //   Future<void> _requestPermissions() async {
// // //     try {
// // //       // Request location service
// // //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// // //       if (!serviceEnabled) {
// // //         print('❌ Location service disabled');
// // //         return;
// // //       }
      
// // //       // Request location permission
// // //       LocationPermission permission = await Geolocator.checkPermission();
// // //       if (permission == LocationPermission.denied) {
// // //         permission = await Geolocator.requestPermission();
// // //       }
      
// // //       if (permission == LocationPermission.deniedForever) {
// // //         print('❌ Location permission permanently denied');
// // //         return;
// // //       }
      
// // //       if (permission == LocationPermission.denied) {
// // //         print('⚠️ Location permission denied');
// // //         return;
// // //       }
      
// // //       print('✅ Location permission granted');
      
// // //       // Request notification permission (if needed)
// // //       final notificationStatus = await Permission.notification.request();
// // //       if (notificationStatus.isGranted) {
// // //         print('✅ Notification permission granted');
// // //       }
      
// // //       // Mark app as ready
// // //       _socketService.setAppReady(true);
      
// // //     } catch (error) {
// // //       print('❌ Error requesting permissions: $error');
// // //     }
// // //   }

// // //   Future<void> gettoken() async {
// // //     try {
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final String? token = prefs.getString("auth_token");
// // //       final String? userId = prefs.getString("driver_userid");

// // //       setState(() {
// // //         _token = token;
// // //         _userId = userId;
// // //         _driverId = userId ?? '';
// // //       });

// // //       print('✅ Token loaded from SharedPreferences');
// // //       print('User ID: $_userId');
// // //       print("myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...");
// // //       print("myyyy_driverid>>> ${_driverId}");

// // //     } catch (e) {
// // //       print('❌ Error loading token: $e');
// // //     }
// // //   }

// // //   Future<bool> _connectSocket() async {
// // //     print("🔄 Connecting socket...");
    
// // //     try {
// // //       // Check if already connected
// // //       final status = _socketService.getConnectionStatus();
// // //       if (status['isConnected'] ?? false) {
// // //         print('✅ Socket already connected');
// // //         return true;
// // //       }

// // //       // Connect with timeout
// // //       final connected = await Future.any([
// // //         _socketService.connect(),
// // //         Future.delayed(const Duration(seconds: 5), () => false),
// // //       ]);
      
// // //       if (connected) {
// // //         print('✅ Socket connected quickly');
// // //         // Connection status will be updated via event listeners
// // //         return true;
// // //       } else {
// // //         print('❌ Socket connection timeout');
// // //         setState(() {
// // //           _socketStatus = 'Connection Timeout';
// // //         });
// // //         return false;
// // //       }
// // //     } catch (error) {
// // //       print('❌ Socket connection error: $error');
// // //       setState(() {
// // //         _socketStatus = 'Connection Error: $error';
// // //       });
// // //       return false;
// // //     }
// // //   }

// // //   void _setupSocketListeners() {
// // //     // ==================== CONNECTION EVENTS ====================
// // //     _socketService.addEventListener('socket:connected', (data) {
// // //       if (!mounted) return;
// // //       print('✅✅✅ DRIVER SOCKET CONNECTED: ${data['socketId']}');
// // //       setState(() {
// // //         _isSocketConnected = true;
// // //         _socketStatus = 'Connected';
// // //         _socketId = data['socketId'] ?? '';
// // //         _reconnectAttempts = 0;
// // //       });
      
// // //       // If we were online before, restore status
// // //       if (_isOnDuty) {
// // //         print('🔄 Restoring online status after connection...');
// // //         Future.delayed(const Duration(seconds: 1), () {
// // //           if (mounted) {
// // //             _restoreOnlineStatus();
// // //           }
// // //         });
// // //       }
// // //     });

// // //     _socketService.addEventListener('socket:disconnected', (data) {
// // //       if (!mounted) return;
// // //       print('❌ Driver socket disconnected: ${data['reason']}');
// // //       setState(() {
// // //         _isSocketConnected = false;
// // //         _socketStatus = 'Disconnected';
// // //       });
      
// // //       // Clear pending ride request
// // //       _clearPendingRideRequest();
      
// // //       // If we're online and app is active, try to reconnect
// // //       if (_isOnDuty && !_appInBackground && mounted) {
// // //         print('🔄 Online but disconnected, will attempt reconnect...');
// // //         Future.delayed(const Duration(seconds: 2), () {
// // //           if (mounted && !_isSocketConnected && _isOnDuty) {
// // //             _reconnectWithRetry();
// // //           }
// // //         });
// // //       }
// // //     });

// // //     _socketService.addEventListener('socket:error', (data) {
// // //       if (!mounted) return;
// // //       print('❌ Socket error: ${data['error']}');
// // //       _reconnectAttempts++;
// // //       setState(() {
// // //         _socketStatus = 'Connection Error';
// // //       });
// // //     });

// // //     _socketService.addEventListener('socket:reconnected', (data) {
// // //       if (!mounted) return;
// // //       print('🔄 Socket reconnected after ${data['attemptNumber']} attempts');
// // //       setState(() {
// // //         _isSocketConnected = true;
// // //         _socketStatus = 'Reconnected';
// // //         _reconnectAttempts = 0;
// // //       });
      
// // //       // If we were online, restore status
// // //       if (_isOnDuty) {
// // //         _restoreOnlineStatus();
// // //       }
// // //     });

// // //     // ==================== DRIVER STATUS EVENTS ====================
// // //     _socketService.addEventListener('driver:online:success', (data) {
// // //       if (!mounted) return;
// // //       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
// // //       _handleOnlineSuccess(data);
// // //     });

// // //     _socketService.addEventListener('driver:online:failed', (data) {
// // //       if (!mounted) return;
// // //       print('❌❌❌ DRIVER ONLINE FAILED: $data');
// // //       _handleOnlineFailure(data);
// // //     });

// // //     _socketService.addEventListener('driver:offline', (data) {
// // //       if (!mounted) return;
// // //       print('🔴 Driver offline confirmed: ${data['message']}');
// // //       setState(() {
// // //         _isOnDuty = false;
// // //         _isProcessingOnline = false;
// // //       });
// // //     });

// // //     // ==================== RIDE REQUEST EVENTS ====================
// // //     _socketService.addEventListener('ride:newRequest', (data) {
// // //       if (!mounted) return;
// // //       print('🚕🚕🚕 NEW RIDE REQUEST RECEIVED 🚕🚕🚕');
      
// // //       // Print ALL data received
// // //       print('📦 RAW RIDE DATA RECEIVED:');
// // //       data.forEach((key, value) {
// // //         print('  $key: $value (${value.runtimeType})');
// // //       });
      
// // //       // Check if we're online and can accept rides
// // //       if (!_isOnDuty) {
// // //         print('⚠️ Received ride request but driver is offline');
// // //         return;
// // //       }
      
// // //       // Process the ride request
// // //       _processRideRequest(data);
// // //     });

// // //     _socketService.addEventListener('ride:acceptedConfirmed', (data) async {
// // //       if (!mounted) return;
// // //       final prefs = await SharedPreferences.getInstance();
// // //       print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
// // //       await prefs.setString("order_id", data['orderId']);

// // //       // Navigate to ride screen
// // //       _navigateToRideScreen(data);
// // //     });

// // //     _socketService.addEventListener('ride:status', (data) {
// // //       if (!mounted) return;
// // //       print('📊 Ride status update: ${data['status']}');
// // //       // Handle ride status updates
// // //     });

// // //     _socketService.addEventListener('ride:cancelled', (data) {
// // //       if (!mounted) return;
// // //       print('❌ Ride cancelled: ${data['orderId']}');
// // //       _clearPendingRideRequest();
// // //       _showToast('Ride cancelled');
// // //     });

// // //     _socketService.addEventListener('ride:completed', (data) {
// // //       if (!mounted) return;
// // //       print('✅ Ride completed: ${data['rideId']}');
// // //       _showToast('Ride completed successfully');
// // //     });

// // //     // ==================== LOCATION EVENTS ====================
// // //     _socketService.addEventListener('ride:location', (data) {
// // //       if (!mounted) return;
// // //       print('📍 Rider location during ride: ${data['location']}');
// // //     });

// // //     // ==================== CHAT EVENTS (optional) ====================
// // //     _socketService.addEventListener('chat:message', (data) {
// // //       if (!mounted) return;
// // //       print('💬 Chat message received: ${data['message']}');
// // //     });
// // //   }

// // //   void _removeSocketListeners() {
// // //     // Remove all socket event listeners to prevent setState() on disposed widgets
// // //     _socketService.removeEventListener('socket:connected', (_) {});
// // //     _socketService.removeEventListener('socket:disconnected', (_) {});
// // //     _socketService.removeEventListener('socket:error', (_) {});
// // //     _socketService.removeEventListener('socket:reconnected', (_) {});
// // //     _socketService.removeEventListener('driver:online:success', (_) {});
// // //     _socketService.removeEventListener('driver:online:failed', (_) {});
// // //     _socketService.removeEventListener('driver:offline', (_) {});
// // //     _socketService.removeEventListener('ride:newRequest', (_) {});
// // //     _socketService.removeEventListener('ride:acceptedConfirmed', (_) {});
// // //     _socketService.removeEventListener('ride:status', (_) {});
// // //     _socketService.removeEventListener('ride:cancelled', (_) {});
// // //     _socketService.removeEventListener('ride:completed', (_) {});
// // //     _socketService.removeEventListener('ride:location', (_) {});
// // //     _socketService.removeEventListener('chat:message', (_) {});
// // //     print('🧹 Socket listeners removed');
// // //   }

// // //   void _processRideRequest(Map<String, dynamic> rideData) {
// // //     print('🚕 Processing ride request...');
    
// // //     try {
// // //       // Create a deep copy to ensure data doesn't get modified
// // //       final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
      
// // //       // Add any missing fields with default values
// // //       if (!rideDataCopy.containsKey('riderName')) {
// // //         rideDataCopy['riderName'] = 'Customer';
// // //       }
// // //       if (!rideDataCopy.containsKey('riderNumber')) {
// // //         rideDataCopy['riderNumber'] = 'N/A';
// // //       }
// // //       if (!rideDataCopy.containsKey('totalFare')) {
// // //         rideDataCopy['totalFare'] = '0';
// // //       }
// // //       if (!rideDataCopy.containsKey('distance')) {
// // //         rideDataCopy['distance'] = '0';
// // //       }
// // //       if (!rideDataCopy.containsKey('rideId')) {
// // //         rideDataCopy['rideId'] = rideDataCopy['orderId'] ?? 'N/A';
// // //       }
// // //       if (!rideDataCopy.containsKey('timestamp')) {
// // //         rideDataCopy['timestamp'] = DateTime.now().millisecondsSinceEpoch;
// // //       }
      
// // //       // Ensure nested structures exist
// // //       if (!rideDataCopy.containsKey('startLocation')) {
// // //         rideDataCopy['startLocation'] = {
// // //           'address': 'Location not specified',
// // //           'coordinates': [78.4772, 17.4065]
// // //         };
// // //       }
      
// // //       if (!rideDataCopy.containsKey('endLocation')) {
// // //         rideDataCopy['endLocation'] = {
// // //           'address': 'Destination not specified',
// // //           'coordinates': [78.4850, 17.4120]
// // //         };
// // //       }
      
// // //       // Extract and print key information
// // //       print('\n📋 KEY RIDE INFORMATION (Before Navigation):');
// // //       print('├─ Ride ID: ${rideDataCopy['rideId']}');
// // //       print('├─ Order ID: ${rideDataCopy['orderId']}');
// // //       print('├─ Rider Name: ${rideDataCopy['riderName']}');
// // //       print('├─ Rider Phone: ${rideDataCopy['riderNumber']}');
// // //       print('├─ Total Fare: ₹${rideDataCopy['totalFare']}');
// // //       print('├─ Distance: ${rideDataCopy['distance']} km');
      
// // //       if (rideDataCopy.containsKey('startLocation')) {
// // //         print('├─ Pickup Address: ${rideDataCopy['startLocation']?['address']}');
// // //       }
// // //       if (rideDataCopy.containsKey('endLocation')) {
// // //         print('├─ Destination: ${rideDataCopy['endLocation']?['address']}');
// // //       }
      
// // //       // Store the new ride request
// // //       setState(() {
// // //         _newRideRequest = rideDataCopy;
// // //         _hasPendingRideRequest = true;
// // //       });

// // //       print("myyyyyyyyyyyyyyyy_rideeeee_datattt ${rideData}");

// // //       // Navigate to LiveRide screen IMMEDIATELY (without delay)
// // //       if (mounted) {
// // //         WidgetsBinding.instance.addPostFrameCallback((_) {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(
// // //               builder: (context) => RideRequestScreen(rideData: rideData),
// // //             ),
// // //           );
// // //         });
// // //       }

// // //       // Auto-reject timer
// // //       final timeoutSeconds = rideDataCopy['timeout']?.toDouble() ?? 30.0;
// // //       _startRideRequestTimer(rideDataCopy['orderId'], timeoutSeconds);

// // //       print('✅ New ride request stored and navigating...');
// // //       print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');
// // //     } catch (error) {
// // //       print('❌ Error processing ride request: $error');
// // //       print('Stack trace: ${error.toString()}');
// // //     }
// // //   }

// // //   void _navigateToRideScreen(Map<String, dynamic> rideData) {
// // //     // Clear pending request
// // //     _clearPendingRideRequest();
    
// // //     // Create a deep copy for navigation
// // //     final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);

// // //     print("myyyyyyyyyyyyyyyy_rideeeee_datattt222222222222 ${rideData}");
// // //     // Navigate to ride screen
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       Navigator.push(
// // //         context,
// // //         MaterialPageRoute(
// // //           builder: (context) => RideRequestScreen(rideData: rideData),
// // //         ),
// // //       );
// // //     });
// // //   }

// // //   // ==================== RIDE REQUEST TIMER ====================
// // //   void _startRideRequestTimer(String orderId, double timeoutSeconds) {
// // //     _clearRideRequestTimer();
    
// // //     final seconds = timeoutSeconds.toInt();
    
// // //     _rideRequestTimer = Timer(Duration(seconds: seconds), () {
// // //       if (_hasPendingRideRequest && _newRideRequest != null) {
// // //         print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
// // //         _socketService.declineRide(orderId, reason: 'timeout');
// // //         _showToast('Ride request auto-rejected (timeout)');
        
// // //         _clearPendingRideRequest();
// // //       }
// // //     });
// // //   }

// // //   void _clearRideRequestTimer() {
// // //     if (_rideRequestTimer != null) {
// // //       _rideRequestTimer!.cancel();
// // //       _rideRequestTimer = null;
// // //     }
// // //   }

// // //   void _clearPendingRideRequest() {
// // //     _clearRideRequestTimer();
// // //     setState(() {
// // //       _newRideRequest = null;
// // //       _hasPendingRideRequest = false;
// // //     });
// // //   }

// // //   // ==================== BACKGROUND RECONNECT ====================
// // //   void _startBackgroundReconnectTimer() {
// // //     _stopBackgroundReconnectTimer();
    
// // //     print('🔄 Starting background reconnect monitoring...');
    
// // //     _backgroundReconnectTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
// // //       if (_appInBackground && _isOnDuty && !_isSocketConnected) {
// // //         print('🔧 Background: Checking connection...');
// // //         _checkAndReconnect();
// // //       }
// // //     });
// // //   }

// // //   void _stopBackgroundReconnectTimer() {
// // //     if (_backgroundReconnectTimer != null) {
// // //       _backgroundReconnectTimer!.cancel();
// // //       _backgroundReconnectTimer = null;
// // //     }
// // //   }

// // //   void _checkAndReconnect() {
// // //     final status = _socketService.getConnectionStatus();
// // //     if (!(status['isConnected'] ?? false)) {
// // //       print('🔄 Background: Socket disconnected, attempting reconnect...');
// // //       _socketService.connect();
// // //     }
// // //   }

// // //   void _reconnectWithRetry() {
// // //     if (_isSocketConnected) return;
    
// // //     print('🔄 Attempting socket reconnection...');
    
// // //     int attempts = 0;
// // //     const maxAttempts = 3;
    
// // //     Future.delayed(Duration.zero, () async {
// // //       while (attempts < maxAttempts && !_isSocketConnected && mounted) {
// // //         attempts++;
// // //         print('🔄 Reconnection attempt $attempts/$maxAttempts');
        
// // //         try {
// // //           await _connectSocket();
          
// // //           // Wait for connection
// // //           await Future.delayed(const Duration(seconds: 2));
          
// // //           final status = _socketService.getConnectionStatus();
// // //           if (status['isConnected'] ?? false) {
// // //             print('✅ Reconnection successful');
            
// // //             // If we were online before, restore online status
// // //             if (_isOnDuty) {
// // //               print('🔄 Restoring online status...');
// // //               await _restoreOnlineStatus();
// // //             }
            
// // //             break;
// // //           }
// // //         } catch (error) {
// // //           print('❌ Reconnection attempt $attempts failed: $error');
// // //         }
        
// // //         if (attempts < maxAttempts) {
// // //           await Future.delayed(Duration(seconds: attempts * 2));
// // //         }
// // //       }
      
// // //       if (!_isSocketConnected) {
// // //         print('❌ Failed to reconnect after $maxAttempts attempts');
// // //         _showToast('Connection lost. Please check your internet.');
// // //       }
// // //     });
// // //   }

// // //   Future<void> _restoreOnlineStatus() async {
// // //     final status = _socketService.getConnectionStatus();
// // //     if (!(status['isConnected'] ?? false)) return;
    
// // //     print('🔄 Restoring driver online status...');
    
// // //     try {
// // //       // Get current location
// // //       final location = await _getCurrentLocation();
      
// // //       // Go online
// // //       await _socketService.goOnline();
      
// // //       print('✅ Online status restored');
      
// // //     } catch (error) {
// // //       print('❌ Error restoring online status: $error');
// // //     }
// // //   }

// // //   // ==================== DRIVER ONLINE/OFFLINE ====================
// // //   Future<void> _goOnline() async {
// // //     print('🟢 GOING ONLINE...');

// // //     if (_isProcessingOnline) {
// // //       print('⏳ Already processing...');
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isProcessingOnline = true;
// // //     });

// // //     try {
// // //       // Check if already connected
// // //       final status = _socketService.getConnectionStatus();
// // //       bool isConnected = status['isConnected'] ?? false;

// // //       // If not connected, connect quickly (target: 1 second)
// // //       if (!isConnected) {
// // //         print('🔌 Socket not connected, connecting...');
// // //         final connected = await _connectSocket();
        
// // //         if (!connected) {
// // //           _handleOnlineFailure('Network connection failed');
// // //           return;
// // //         }
        
// // //         // Give socket a moment to be ready
// // //         await Future.delayed(const Duration(milliseconds: 300));
// // //       }

// // //       // Go online with cached location (no delay for fetching)
// // //       print('🚀 Sending online status with cached location...');
// // //       final success = await _socketService.goOnline();

// // //       if (success) {
// // //         print('✅ Online request sent successfully');
// // //       } else {
// // //         _handleOnlineFailure('Failed to go online');
// // //       }
// // //     } catch (e) {
// // //       print('❌ Error: $e');
// // //       _handleOnlineFailure('Error: $e');
// // //     }
// // //   }

// // //   void _handleOnlineSuccess(dynamic data) {
// // //     if (!_isProcessingOnline) return;

// // //     print('✅ DRIVER ONLINE SUCCESS');

// // //     setState(() {
// // //       _isOnDuty = true;
// // //       _isProcessingOnline = false;
// // //     });

// // //     String successMessage = 'Driver is now online';
// // //     if (data is Map<String, dynamic>) {
// // //       successMessage = data['message'] ?? successMessage;
// // //     }

// // //     _showToast(successMessage);

// // //     // Update map with current location
// // //     if (_currentLatitude != null && _currentLongitude != null) {
// // //       _updateMarkerOnly(
// // //         LatLng(_currentLatitude!, _currentLongitude!),
// // //         50.0, // Default accuracy
// // //       );
// // //     }
// // //   }

// // //   void _handleOnlineFailure(dynamic data) {
// // //     if (!_isProcessingOnline) return;

// // //     print('❌ DRIVER ONLINE FAILED');

// // //     setState(() {
// // //       _isOnDuty = false;
// // //       _isProcessingOnline = false;
// // //     });

// // //     String errorMessage = 'Failed to go online';
// // //     if (data is String) {
// // //       errorMessage = data;
// // //     } else if (data is Map<String, dynamic>) {
// // //       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
// // //     }

// // //     _showToast(errorMessage);
// // //   }

// // //   Future<void> _goOffline() async {
// // //     print('🔴 GOING OFFLINE...');
    
// // //     try {
// // //       // Stop processing any online requests
// // //       setState(() {
// // //         _isProcessingOnline = false;
// // //       });

// // //       // Go offline via socket service (fully disconnects)
// // //       await _socketService.goOffline();
      
// // //       setState(() {
// // //         _isOnDuty = false;
// // //       });

// // //       // Remove bike marker and circle
// // //       _removeBikeMarkerAndCircle();

// // //       // Clear pending ride request
// // //       _clearPendingRideRequest();

// // //       print('✅ Driver is now offline - socket disconnected');
// // //       _showToast('Offline - Socket disconnected');
      
// // //     } catch (error) {
// // //       print('❌ Error going offline: $error');
// // //       _showToast('Error going offline');
// // //     }
// // //   }

// // //   // ==================== LOCATION METHODS ====================
// // //   /// 📡 LIVE LOCATION LISTENER (Marker moves in real-time)
// // //   void _listenToLocation() {
// // //     _positionStream = Geolocator.getPositionStream(
// // //       locationSettings: const LocationSettings(
// // //         accuracy: LocationAccuracy.high,
// // //         distanceFilter: 10, // Update every 10 meters
// // //       ),
// // //     ).listen((Position position) {
// // //       final LatLng newLocation =
// // //           LatLng(position.latitude, position.longitude);

// // //       // Update marker and circles only (camera stays put)
// // //       _updateMarkerOnly(newLocation, position.accuracy);
      
// // //       // Also update socket service coordinates
// // //       _currentLatitude = position.latitude;
// // //       _currentLongitude = position.longitude;
      
// // //       print('📍 Location updated: ${position.latitude}, ${position.longitude} (Accuracy: ${position.accuracy}m)');
// // //     });
// // //   }
  
// // //   /// 🔄 Update only marker and circles (camera stays put)
// // //   void _updateMarkerOnly(LatLng location, double accuracy) {
// // //     _currentLatitude = location.latitude;
// // //     _currentLongitude = location.longitude;

// // //     setState(() {
// // //       markers.clear();
// // //       circles.clear();
   
// // //       // Bike marker
// // //       markers.add(
// // //         Marker(
// // //           markerId: const MarkerId('driver_location'),
// // //           position: location,
// // //           icon: _bikeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
// // //           anchor: const Offset(0.5, 0.5),
// // //           infoWindow: const InfoWindow(
// // //             title: 'Your Location',
// // //             snippet: 'You are here',
// // //           ),
// // //           zIndex: 2,
// // //         ),
// // //       );

// // //       // Grey outer circle (accuracy shadow)
// // //       circles.add(
// // //         Circle(
// // //           circleId: const CircleId('outer_shadow'),
// // //           center: location,
// // //           radius: accuracy + 80,
// // //           fillColor: Colors.grey.withOpacity(0.25),
// // //           strokeColor: Colors.transparent,
// // //         ),
// // //       );

// // //       // Green inner circle (center)
// // //       circles.add(
// // //         Circle(
// // //           circleId: const CircleId('inner_green'),
// // //           center: location,
// // //           radius: 60,
// // //           fillColor: Colors.green.withOpacity(0.35),
// // //           strokeColor: Colors.green,
// // //           strokeWidth: 1,
// // //         ),
// // //       );
// // //     });

// // //     print('✅ Driver marker and circles updated at (${location.latitude}, ${location.longitude})');
// // //   }
  
// // //   /// 📍 Get current location (can be called manually if needed)
// // //   Future<Map<String, dynamic>> _getCurrentLocation() async {
// // //     try {
// // //       final position = await Geolocator.getCurrentPosition(
// // //         locationSettings: const LocationSettings(
// // //           accuracy: LocationAccuracy.high,
// // //         ),
// // //       );
      
// // //       final coordinates = {
// // //         'latitude': position.latitude,
// // //         'longitude': position.longitude,
// // //         'accuracy': position.accuracy,
// // //       };

// // //       setState(() {
// // //         _currentLatitude = position.latitude;
// // //         _currentLongitude = position.longitude;
// // //       });
      
// // //       print('✅ Got current location: ${position.latitude}, ${position.longitude}');
      
// // //       return coordinates;
// // //     } catch (e) {
// // //       print('❌ Error getting location: $e');
// // //       return {'latitude': 23.2508438, 'longitude': 77.4647827, 'accuracy': 0.0};
// // //     }
// // //   }

// // //   // Remove bike marker and circle
// // //   void _removeBikeMarkerAndCircle() {
// // //     setState(() {
// // //       markers.clear();
// // //       circles.clear();
// // //     });
// // //     print('✅ Bike marker and circle removed');
// // //   }

// // //   // Load custom bike marker icon from assets
// // //   Future<void> _loadCustomBikeMarker() async {
// // //     try {
// // //       _bikeMarkerIcon = await MapHelper.loadCustomIcon(
// // //         assetPath: 'assets/images/bike2.png',
// // //         width: 80,
// // //         height: 80,
// // //       );
// // //       print('✅ Custom bike marker icon loaded');
// // //     } catch (e) {
// // //       print('❌ Error loading custom bike marker: $e');
// // //       _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
// // //     }
// // //   }

// // //   // Load vehicle icons for nearby riders
// // //   Future<void> _loadVehicleIcons() async {
// // //     try {
// // //       _vehicleIcons = await MapHelper.loadVehicleIcons(
// // //         iconSize: 70,
// // //       );
// // //       print('✅ Vehicle icons loaded');
// // //     } catch (e) {
// // //       print('❌ Error loading vehicle icons: $e');
// // //     }
// // //   }

// // //   // ==================== NOTIFICATIONS ====================
// // //   void _showRideRequestNotification(Map<String, dynamic> rideData) {
// // //     if (!mounted) return;

// // //     // Extract data
// // //     final riderName = rideData['riderName']?.toString() ?? 'Customer';
// // //     final riderPhone = rideData['riderNumber']?.toString() ?? '';
// // //     final distance = rideData['distance']?.toString() ?? '0';
// // //     final fare = rideData['totalFare']?.toString() ?? '0';
// // //     final pickup = rideData['startLocation']?['address']?.toString() ?? 'Location not specified';
// // //     final destination = rideData['endLocation']?['address']?.toString() ?? 'Destination not specified';
// // //     final orderId = rideData['orderId']?.toString() ?? '';

// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => AlertDialog(
// // //         title: const Row(
// // //           children: [
// // //             Icon(Icons.local_taxi, color: Colors.green),
// // //             SizedBox(width: 10),
// // //             Text('🚕 New Ride Request'),
// // //           ],
// // //         ),
// // //         content: SingleChildScrollView(
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               ListTile(
// // //                 leading: CircleAvatar(
// // //                   child: Text(riderName.substring(0, 1).toUpperCase()),
// // //                 ),
// // //                 title: Text(riderName, style: const TextStyle(fontWeight: FontWeight.bold)),
// // //                 subtitle: Text(riderPhone),
// // //               ),
// // //               const Divider(),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       const Text('Fare', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //                       Text('₹$fare', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                     ],
// // //                   ),
// // //                   Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       const Text('Distance', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //                       Text('$distance km', style: const TextStyle(fontSize: 16)),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 16),
// // //               Row(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   const Icon(Icons.location_on, color: Colors.green, size: 20),
// // //                   const SizedBox(width: 8),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //                         Text(pickup, style: const TextStyle(fontSize: 14)),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Row(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   const Icon(Icons.location_on, color: Colors.red, size: 20),
// // //                   const SizedBox(width: 8),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
// // //                         Text(destination, style: const TextStyle(fontSize: 14)),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               if (orderId.isNotEmpty) {
// // //                 _socketService.declineRide(orderId);
// // //                 _showToast('Ride rejected');
// // //                 _clearPendingRideRequest();
// // //               }
// // //             },
// // //             child: const Text('Reject', style: TextStyle(color: Colors.red)),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               if (orderId.isNotEmpty) {
// // //                 _socketService.acceptRide(rideData);
// // //                 print('✅ Ride accepted: $orderId');
// // //                 _showToast('Ride accepted!');
// // //                 _clearPendingRideRequest();
// // //               }
// // //             },
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// // //             child: const Text('Accept'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _showToast(String message) {
// // //     if (!mounted) return;

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
// // //     );
// // //   }

// // //   void _toggleOnlineStatus() {
// // //     if (_isOnDuty) {
// // //       _goOffline();
// // //     } else {
// // //       _goOnline();
// // //     }
// // //   }

// // //   // ==================== UI BUILD ====================
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;

// // //     return _isOnDuty == false ? 
// // //       Scaffold(
// // //         backgroundColor: AppColors.white,
// // //         appBar: PreferredSize(
// // //           preferredSize: Size.fromHeight(w * .300),
// // //           child: Container(
// // //             height: w * .290,
// // //             decoration: BoxDecoration(
// // //               color: AppColors.white,
// // //               boxShadow: [
// // //                 BoxShadow(
// // //                   color: Colors.grey.withOpacity(0.2),
// // //                   spreadRadius: 1,
// // //                   blurRadius: 2,
// // //                   offset: const Offset(0, 3),
// // //                 ),
// // //               ],
// // //               borderRadius: BorderRadius.only(
// // //                 bottomLeft: Radius.circular(w * 0.04),
// // //                 bottomRight: Radius.circular(w * 0.04),
// // //               ),
// // //             ),
// // //             child: SafeArea(
// // //               child: Padding(
// // //                 padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // //                 child: Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     Row(
// // //                       children: [
// // //                         CircleAvatar(
// // //                           radius: w * 0.06,
// // //                           backgroundImage: const AssetImage('assets/images/home2.png'),
// // //                         ),
// // //                         SizedBox(width: w * 0.03),
// // //                         AppFonts.textPoppins(
// // //                           context,
// // //                           "Ayaan Malviya",
// // //                           w * 0.05,
// // //                           FontWeight.w600,
// // //                           AppColors.black,
// // //                           TextAlign.left,
// // //                           TextOverflow.visible,
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         // Connection status indicator
// // //                         // Container(
// // //                         //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // //                         //   decoration: BoxDecoration(
// // //                         //     color: _getConnectionColor(),
// // //                         //     borderRadius: BorderRadius.circular(12),
// // //                         //   ),
// // //                         //   child: Row(
// // //                         //     mainAxisSize: MainAxisSize.min,
// // //                         //     children: [
// // //                         //       Icon(_getConnectionIcon(), size: 12, color: Colors.white),
// // //                         //       const SizedBox(width: 4),
// // //                         //       Text(
// // //                         //         _getConnectionText(),
// // //                         //         style: const TextStyle(color: Colors.white, fontSize: 10),
// // //                         //       ),
// // //                         //     ],
// // //                         //   ),
// // //                         // ),
// // //                         SizedBox(height: w * 0.01),
// // //                         // Online/Offline toggle
// // //                         GestureDetector(
// // //                           onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
// // //                           child: Container(
// // //                             width: w * 0.26,
// // //                             height: w * 0.10,
// // //                             decoration: BoxDecoration(
// // //                               color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
// // //                               borderRadius: BorderRadius.circular(w * 0.06),
// // //                             ),
// // //                             alignment: Alignment.center,
// // //                             child: _isProcessingOnline
// // //                                 ? SizedBox(
// // //                                     width: w * 0.04,
// // //                                     height: w * 0.04,
// // //                                     child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// // //                                   )
// // //                                 : Text(
// // //                                     _isOnDuty ? 'Online' : 'Offline',
// // //                                     style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
// // //                                   ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
// // //             begin: const Offset(0.95, 0.95),
// // //             end: const Offset(1, 1),
// // //           ),
// // //         ),
// // //         body: SingleChildScrollView(
// // //           child: Padding(
// // //             padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.center,
// // //               children: [
// // //                 // Status indicators
// // //                 if (_hasPendingRideRequest && _newRideRequest != null)
// // //                   Container(
// // //                     margin: EdgeInsets.only(bottom: w * 0.02),
// // //                     padding: EdgeInsets.all(w * 0.015),
// // //                     decoration: BoxDecoration(
// // //                       color: Colors.orange[50],
// // //                       borderRadius: BorderRadius.circular(w * 0.02),
// // //                       border: Border.all(color: Colors.orange),
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.local_taxi, color: Colors.orange, size: w * 0.04),
// // //                         SizedBox(width: w * 0.02),
// // //                         Expanded(
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Text('🚕 Pending Ride Request', style: TextStyle(fontSize: w * 0.03, color: Colors.orange[800]!, fontWeight: FontWeight.w600)),
// // //                               Text('Tap to view details', style: TextStyle(fontSize: w * 0.025, color: Colors.orange[600]!)),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                         IconButton(
// // //                           icon: Icon(Icons.visibility, size: w * 0.04),
// // //                           onPressed: () {
// // //                             if (_newRideRequest != null) {
// // //                               Text("ajayyyyyyyyyyyyyyyyyyyy");
// // //                               // _showRideRequestNotification(_newRideRequest!);
// // //                             }
// // //                           },
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),

// // //                 SizedBox(height: w * 0.04),
// // //                 Image.asset("assets/images/offline_image.png", height: w * 0.5),
// // //                 Text(
// // //                   _isOnDuty ? "You're Online" : "You're Offline",
// // //                   style: TextStyle(
// // //                     fontSize: w * 0.05,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: _isOnDuty ? Colors.green : Colors.black,
// // //                   ),
// // //                 ),
// // //                 Text(
// // //                   _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
// // //                   style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
// // //                 ),
// // //                 SizedBox(height: w * 0.04),
// // //                 ElevatedButton(
// // //                   onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
// // //                   style: ElevatedButton.styleFrom(
// // //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// // //                     backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
// // //                     minimumSize: const Size(double.infinity, 45),
// // //                   ),
// // //                   child: _isProcessingOnline
// // //                       ? SizedBox(
// // //                           width: w * 0.04,
// // //                           height: w * 0.04,
// // //                           child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// // //                         )
// // //                       : Text(
// // //                           _isOnDuty ? "Go Offline" : "Go Online",
// // //                           style: TextStyle(fontSize: w * 0.04, color: Colors.white),
// // //                         ),
// // //                 ),

// // //                 SizedBox(height: w * 0.03),
// // //                 Align(
// // //                   alignment: Alignment.centerLeft,
// // //                   child: AppFonts.textPoppins(
// // //                     context,
// // //                     "Today's Update",
// // //                     w * 0.038,
// // //                     FontWeight.w600,
// // //                     AppColors.black,
// // //                     TextAlign.left,
// // //                     TextOverflow.visible,
// // //                   ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
// // //                     begin: const Offset(0.95, 0.95),
// // //                     end: const Offset(1, 1),
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: w * 0.04),
// // //                 Column(
// // //                   children: [
// // //                     HomeScreenWidgets.elevatedBox(
// // //                       shadowColor: const Color(0xFF4CAF50),
// // //                       width: double.infinity,
// // //                       child: const Column(
// // //                         children: [
// // //                           Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
// // //                           SizedBox(height: 6),
// // //                           Text("₹1000.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                       children: [
// // //                         SizedBox(
// // //                           width: w * 0.45,
// // //                           child: HomeScreenWidgets.elevatedBox(
// // //                             shadowColor: const Color(0xFFFEBC2F),
// // //                             child: const Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Text("Online", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // //                                 SizedBox(height: 4),
// // //                                 Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         SizedBox(width: w * 0.02),
// // //                         SizedBox(
// // //                           width: w * 0.45,
// // //                           child: HomeScreenWidgets.elevatedBox(
// // //                             shadowColor: const Color(0xFF7C7C8D),
// // //                             child: const Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Text("Cash", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // //                                 SizedBox(height: 4),
// // //                                 Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     SizedBox(height: w * 0.05),
// // //                     Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         SizedBox(
// // //                           width: w * 0.45,
// // //                           child: HomeScreenWidgets.elevatedBox(
// // //                             shadowColor: const Color(0xFF439AFE),
// // //                             child: const Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // //                                 SizedBox(height: 4),
// // //                                 Text("50 / 45 Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         SizedBox(width: w * 0.02),
// // //                         SizedBox(
// // //                           width: w * 0.45,
// // //                           child: HomeScreenWidgets.elevatedBox(
// // //                             shadowColor: const Color(0xFFF26061),
// // //                             child: const Column(
// // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // //                               children: [
// // //                                 Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
// // //                                 SizedBox(height: 4),
// // //                                 Text("50 / 05 Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
// // //                               ],
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: w * 0.04),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       )
// // //     : Scaffold(
// // //         body: SafeArea(
// // //           child: Stack(
// // //             children: [
// // //               /// 1️⃣ Google Map (BOTTOM)
// // //               GoogleMap(
// // //                 initialCameraPosition: _initialCameraPosition,
// // //                 myLocationEnabled: false, // Disabled to show custom marker instead
// // //                 myLocationButtonEnabled: false,
// // //                 zoomControlsEnabled: false,
// // //                 onMapCreated: (controller) {
// // //                   _mapController = controller;
// // //                 },
// // //                 markers: markers,
// // //                 circles: circles,
// // //               ),

// // //               /// 2️⃣ Book Ride Button (Top Right)
// // //               Positioned(
// // //                 top: 16,
// // //                 right: 16,
// // //                 child: ElevatedButton(
// // //                   onPressed: () {
// // //                     Get.to(() => const BookRide());
// // //                   },
// // //                   style: ElevatedButton.styleFrom(
// // //                     backgroundColor: Colors.cyan,
// // //                     elevation: 4,
// // //                     shape: const StadiumBorder(),
// // //                     padding: const EdgeInsets.symmetric(
// // //                       horizontal: 18,
// // //                       vertical: 10,
// // //                     ),
// // //                   ),
// // //                   child: const Text(
// // //                     "Book Ride",
// // //                     style: TextStyle(
// // //                       color: Colors.black,
// // //                       fontWeight: FontWeight.w600,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),

// // //               /// 3️⃣ Bottom Offline Card (FIRST)
// // //               Positioned(
// // //                 bottom: 0,
// // //                 left: 0,
// // //                 right: 0,
// // //                 child: _bottomOfflineCard(),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         // bottomNavigationBar: BottomnavmainScreen(),
// // //       );
// // //   }

// // //   Widget _bottomOfflineCard() {
// // //     double w = MediaQuery.of(context).size.width;
// // //     return Container(
// // //       margin: EdgeInsets.only(top: 200),
// // //       padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
// // //       decoration: const BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// // //         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
// // //       ),
// // //       child: Column(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           /// Driver & Earnings
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //             children: [
// // //               HomeScreenWidgets.topAction(
// // //                 icon: _selectedTab == "Driver"
// // //                     ? "assets/icons/drive.png"
// // //                     : "assets/icons/driveoff.svg",
// // //                 label: "Driver",
// // //                 onTap: () {
// // //                   setState(() {
// // //                     _selectedTab = "Driver";
// // //                   });
// // //                 },
// // //                 isSelected: _selectedTab == "Driver",
// // //               ),
// // //               SizedBox(width: w * 0.25),
// // //               HomeScreenWidgets.topAction(
// // //                 icon: _selectedTab == "Earnings"
// // //                     ? "assets/icons/dolleron.svg"
// // //                     : "assets/icons/doller.png",
// // //                 label: "Earnings",
// // //                 onTap: () {
// // //                   setState(() {
// // //                     _selectedTab = "Earnings";
// // //                   });
// // //                 },
// // //                 isSelected: _selectedTab == "Earnings",
// // //               ),
// // //             ],
// // //           ),

// // //           const SizedBox(height: 16),

// // //           /// Conditional Content
// // //           if (_selectedTab == "Driver")
// // //             _driverContent()
// // //           else
// // //             _earningsContent(),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _driverContent() {
// // //     return Column(
// // //       children: [
// // //         /// Offline Image
// // //         Image.asset("assets/images/onlinee.png", height: 120),

// // //         const SizedBox(height: 12),

// // //         const Text(
// // //           "You're Online",
// // //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //         ),

// // //         const SizedBox(height: 6),

// // //         const Text(
// // //           "Go offline to stop accepting rides.",
// // //           style: TextStyle(color: Colors.grey),
// // //           textAlign: TextAlign.center,
// // //         ),

// // //         const SizedBox(height: 16),

// // //         /// Go Online Button (Bottom)
// // //         SizedBox(
// // //           width: double.infinity,
// // //           height: 48,
// // //           child: ElevatedButton(
// // //             onPressed: () {
// // //               print("hellooo");
// // //               Get.offAll(() =>  BottomnavmainScreen());
// // //             },
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: Colors.redAccent,
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //             ),
// // //             child: const Text(
// // //               "Go Offline",
// // //               style: TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.w600,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   /// Earnings Content
// // //   Widget _earningsContent() {
// // //     double w = MediaQuery.of(context).size.width;
// // //     return Column(
// // //       children: [
// // //         Align(
// // //           alignment: Alignment.centerLeft,
// // //           child: AppFonts.textPoppins(
// // //             context,
// // //             "Today's Update",
// // //             w * 0.038,
// // //             FontWeight.w600,
// // //             AppColors.black,
// // //             TextAlign.left,
// // //             TextOverflow.visible,
// // //           ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
// // //             begin: const Offset(0.95, 0.95),
// // //             end: const Offset(1, 1),
// // //           ),
// // //         ),
// // //         SizedBox(height: w * 0.02),

// // //         Column(
// // //           children: [
// // //             /// Today's Earnings (Full Width)
// // //             HomeScreenWidgets.elevatedBox(
// // //               width: double.infinity,
// // //               shadowColor: const Color(0xFF4CAF50),
// // //               child: Column(
// // //                 children: const [
// // //                   Text(
// // //                     "Today's Earnings",
// // //                     style: TextStyle(fontSize: 14, color: Colors.grey),
// // //                   ),
// // //                   SizedBox(height: 1),
// // //                   Text(
// // //                     "₹1000.00",
// // //                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),

// // //             SizedBox(height: w * 0.02),

// // //             /// Online & Cash
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 SizedBox(
// // //                   width: w * 0.4,
// // //                   child: HomeScreenWidgets.elevatedBox(
// // //                     shadowColor: const Color(0xFFFEBC2F),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: const [
// // //                         Text(
// // //                           "Online",
// // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // //                         ),
// // //                         SizedBox(height: 1),
// // //                         Text(
// // //                           "₹500 Total",
// // //                           style: TextStyle(fontWeight: FontWeight.w600),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: w * 0.01),
// // //                 SizedBox(
// // //                   width: w * 0.45,
// // //                   child: HomeScreenWidgets.elevatedBox(
// // //                     shadowColor: const Color(0xFF7C7C8D),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: const [
// // //                         Text(
// // //                           "Cash",
// // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // //                         ),
// // //                         SizedBox(height: 1),
// // //                         Text(
// // //                           "₹500 On Hand",
// // //                           style: TextStyle(fontWeight: FontWeight.w600),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),

// // //             SizedBox(height: w * 0.02),

// // //             /// Ride Stats
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 SizedBox(
// // //                   width: w * 0.4,
// // //                   child: HomeScreenWidgets.elevatedBox(
// // //                     shadowColor: const Color(0xFF439AFE),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text(
// // //                           "Total Rides",
// // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // //                         ),
// // //                         const SizedBox(height: 1),
// // //                         RichText(
// // //                           text: const TextSpan(
// // //                             children: [
// // //                               TextSpan(
// // //                                 text: "50",
// // //                                 style: TextStyle(
// // //                                   fontSize: 18,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   color: Colors.black,
// // //                                 ),
// // //                               ),
// // //                               TextSpan(
// // //                                 text: " / 45 Completed",
// // //                                 style: TextStyle(
// // //                                   fontSize: 14,
// // //                                   fontWeight: FontWeight.w600,
// // //                                   color: Colors.black,
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 SizedBox(width: w * 0.02),
// // //                 SizedBox(
// // //                   width: w * 0.45,
// // //                   child: HomeScreenWidgets.elevatedBox(
// // //                     shadowColor: const Color(0xFFF26061),
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         const Text(
// // //                           "Total Rides",
// // //                           style: TextStyle(fontSize: 13, color: Colors.grey),
// // //                         ),
// // //                         const SizedBox(height: 1),
// // //                         RichText(
// // //                           text: const TextSpan(
// // //                             children: [
// // //                               TextSpan(
// // //                                 text: "50",
// // //                                 style: TextStyle(
// // //                                   fontSize: 18,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   color: Colors.black,
// // //                                 ),
// // //                               ),
// // //                               TextSpan(
// // //                                 text: " / 45 Completed",
// // //                                 style: TextStyle(
// // //                                   fontSize: 14,
// // //                                   fontWeight: FontWeight.w600,
// // //                                   color: Colors.black,
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }

// // import 'dart:async';
// // import 'dart:ui' as ui;
// // import 'package:nzcu_driver/apiservices/services/driver_socket_service.dart';
// // import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// // import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
// // import 'package:nzcu_driver/utilities/colors.dart';
// // import 'package:nzcu_driver/utilities/custom_font.dart';
// // import 'package:nzcu_driver/utilities/map_helper.dart';
// // import 'package:nzcu_driver/views/book_ride/book_ride.dart';
// // import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // import 'package:nzcu_driver/views/home_related/live_ride.dart';
// // import 'package:nzcu_driver/views/widgets/home_screen_widgets.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
// //   final HomeController homeController = Get.find<HomeController>();
// //   final StepperController stepperController = Get.find<StepperController>();
// //   final DriverSocketService _socketService = DriverSocketService();
  
// //   // State variables
// //   bool _isOnDuty = false;
// //   bool _isProcessingOnline = false;
// //   String _selectedTab = "Driver";
  
// //   // Location
// //   double? _currentLatitude;
// //   double? _currentLongitude;
// //   String? _driverId;
// //   String? _token;
  
// //   // Ride request
// //   String? _currentRideId;
// //   Timer? _rideRequestTimer;
  
// //   // Map
// //   late GoogleMapController _mapController;
// //   final CameraPosition _initialCameraPosition = const CameraPosition(
// //     target: LatLng(23.2508131, 77.4647936), 
// //     zoom: 17,
// //   );
// //   Set<Marker> markers = {};
// //   Set<Circle> circles = {};
// //   BitmapDescriptor? _bikeMarkerIcon;
  
// //   // App lifecycle
// //   bool _appInBackground = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     homeController.home_data_method();
// //     WidgetsBinding.instance.addObserver(this);
// //     _initializeConnection();
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     _cleanupResources();
// //     _socketService.disconnect();
// //     super.dispose();
// //   }
  
// //   void _cleanupResources() {
// //     _rideRequestTimer?.cancel();
// //     _rideRequestTimer = null;
// //   }

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     switch (state) {
// //       case AppLifecycleState.resumed:
// //         _appInBackground = false;
// //         _socketService.setAppReady(true);
// //         if (_isOnDuty && !_socketService.isConnected) {
// //           _reconnect();
// //         }
// //         break;
// //       case AppLifecycleState.paused:
// //         _appInBackground = true;
// //         _clearPendingRideRequest();
// //         break;
// //       default:
// //         break;
// //     }
// //   }

// //   Future<void> _initializeConnection() async {
// //     await _requestPermissions();
// //     await _loadCustomBikeMarker();
// //     await _loadToken();
// //     _listenToLocation();
// //     _setupSocketListeners();
    
// //     if (_token != null && _driverId != null) {
// //       await _connectSocket();
// //     }
// //   }

// //   Future<void> _requestPermissions() async {
// //     try {
// //       // Check location service
// //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //       if (!serviceEnabled) return;
      
// //       // Check permission
// //       LocationPermission permission = await Geolocator.checkPermission();
// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //       }
      
// //       if (permission == LocationPermission.deniedForever) {
// //         return;
// //       }
      
// //       if (permission == LocationPermission.denied) {
// //         return;
// //       }
      
// //       // Request notification permission
// //       await Permission.notification.request();
// //       _socketService.setAppReady(true);
      
// //     } catch (error) {
// //       print('Error requesting permissions: $error');
// //     }
// //   }

// //   Future<void> _loadToken() async {
// //     try {
// //       final prefs = await SharedPreferences.getInstance();
// //       _token = prefs.getString("auth_token");
// //       _driverId = prefs.getString("driver_userid");
      
// //       print('✅ Token loaded: ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...');
// //       print('✅ Driver ID: $_driverId');
// //     } catch (e) {
// //       print('Error loading token: $e');
// //     }
// //   }

// //   Future<bool> _connectSocket() async {
// //     print("Connecting socket...");
    
// //     try {
// //       if (_socketService.isConnected) return true;
      
// //       final connected = await Future.any([
// //         _socketService.connect(),
// //         Future.delayed(const Duration(seconds: 5), () => false),
// //       ]);
      
// //       return connected;
// //     } catch (error) {
// //       print('Socket connection error: $error');
// //       return false;
// //     }
// //   }

// //   void _setupSocketListeners() {
// //     // Connection events
// //     _socketService.addEventListener('socket:connected', (data) {
// //       if (!mounted) return;
// //       print('✅ Socket connected');
      
// //       if (_isOnDuty) {
// //         _restoreOnlineStatus();
// //       }
// //     });

// //     _socketService.addEventListener('socket:disconnected', (data) {
// //       if (!mounted) return;
// //       print('❌ Socket disconnected');
      
// //       if (_isOnDuty && !_appInBackground) {
// //         Future.delayed(const Duration(seconds: 2), () {
// //           if (mounted && !_socketService.isConnected && _isOnDuty) {
// //             _reconnect();
// //           }
// //         });
// //       }
// //     });

// //     // Driver status
// //     _socketService.addEventListener('driver:online:success', (data) {
// //       if (!mounted) return;
// //       print('✅ Driver online success');
// //       setState(() {
// //         _isOnDuty = true;
// //         _isProcessingOnline = false;
// //       });
// //     });

// //     _socketService.addEventListener('driver:online:failed', (data) {
// //       if (!mounted) return;
// //       print('❌ Driver online failed');
// //       setState(() {
// //         _isOnDuty = false;
// //         _isProcessingOnline = false;
// //       });
// //     });

// //     // Ride request - SINGLE LISTENER
// //     _socketService.addEventListener('ride:newRequest', (data) {
// //       if (!mounted) return;
      
// //       if (!_isOnDuty) {
// //         print('Received ride but offline');
// //         return;
// //       }
      
// //       _handleRideRequest(data);
// //     });

// //     _socketService.addEventListener('ride:acceptedConfirmed', (data) async {
// //       if (!mounted) return;
// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString("order_id", data['orderId']);
// //     });
// //   }

// //   void _handleRideRequest(Map<String, dynamic> rideData) {
// //     final String rideId = rideData['orderId'] ?? rideData['rideId'] ?? 'unknown';
    
// //     // Prevent duplicate processing
// //     if (_currentRideId == rideId) {
// //       print('Already processing this ride: $rideId');
// //       return;
// //     }
    
// //     _currentRideId = rideId;
    
// //     print('🚕 New ride request: $rideId');
    
// //     // Clear any existing timer
// //     _rideRequestTimer?.cancel();
    
// //     // Navigate to ride screen
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!mounted) return;
      
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => RideRequestScreen(rideData: rideData),
// //         ),
// //       ).then((_) {
// //         // Reset when screen is popped
// //         _currentRideId = null;
// //       });
// //     });
    
// //     // Start auto-reject timer
// //     final timeoutSeconds = rideData['timeout']?.toDouble() ?? 30.0;
// //     _rideRequestTimer = Timer(Duration(seconds: timeoutSeconds.toInt()), () {
// //       if (_currentRideId == rideId) {
// //         print('Auto-rejecting ride: $rideId');
// //         _socketService.declineRide(rideId, reason: 'timeout');
// //         _currentRideId = null;
// //       }
// //     });
// //   }

// //   void _clearPendingRideRequest() {
// //     _currentRideId = null;
// //     _rideRequestTimer?.cancel();
// //     _rideRequestTimer = null;
// //   }

// //   void _reconnect() async {
// //     print('Reconnecting...');
    
// //     for (int i = 0; i < 3; i++) {
// //       print('Attempt ${i + 1}/3');
      
// //       try {
// //         await _connectSocket();
// //         await Future.delayed(const Duration(seconds: 2));
        
// //         if (_socketService.isConnected) {
// //           print('Reconnection successful');
// //           if (_isOnDuty) {
// //             await _restoreOnlineStatus();
// //           }
// //           return;
// //         }
// //       } catch (error) {
// //         print('Reconnection failed: $error');
// //       }
      
// //       if (i < 2) {
// //         await Future.delayed(Duration(seconds: (i + 1) * 2));
// //       }
// //     }
    
// //     print('Failed to reconnect');
// //   }

// //   Future<void> _restoreOnlineStatus() async {
// //     if (!_socketService.isConnected) return;
    
// //     try {
// //       await _socketService.goOnline();
// //     } catch (error) {
// //       print('Error restoring online status: $error');
// //     }
// //   }

// //   // ==================== LOCATION METHODS ====================
// //   void _listenToLocation() {
// //     Geolocator.getPositionStream(
// //       locationSettings: const LocationSettings(
// //         accuracy: LocationAccuracy.high,
// //         distanceFilter: 10,
// //       ),
// //     ).listen((Position position) {
// //       final LatLng newLocation = LatLng(position.latitude, position.longitude);
      
// //       _updateMarkerOnly(newLocation, position.accuracy);
      
// //       _currentLatitude = position.latitude;
// //       _currentLongitude = position.longitude;
// //     });
// //   }
  
// //   void _updateMarkerOnly(LatLng location, double accuracy) {
// //     setState(() {
// //       markers.clear();
// //       circles.clear();
      
// //       markers.add(
// //         Marker(
// //           markerId: const MarkerId('driver_location'),
// //           position: location,
// //           icon: _bikeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
// //           anchor: const Offset(0.5, 0.5),
// //         ),
// //       );

// //       circles.add(
// //         Circle(
// //           circleId: const CircleId('accuracy_circle'),
// //           center: location,
// //           radius: accuracy,
// //           fillColor: Colors.blue.withOpacity(0.2),
// //           strokeColor: Colors.blue,
// //           strokeWidth: 1,
// //         ),
// //       );
// //     });
// //   }

// //   Future<void> _loadCustomBikeMarker() async {
// //     try {
// //       _bikeMarkerIcon = await MapHelper.loadCustomIcon(
// //         assetPath: 'assets/images/bike2.png',
// //         width: 80,
// //         height: 80,
// //       );
// //     } catch (e) {
// //       print('Error loading marker: $e');
// //       _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
// //     }
// //   }

// //   // ==================== ONLINE/OFFLINE ====================
// //   Future<void> _goOnline() async {
// //     if (_isProcessingOnline) return;
    
// //     setState(() {
// //       _isProcessingOnline = true;
// //     });
    
// //     try {
// //       if (!_socketService.isConnected) {
// //         final connected = await _connectSocket();
// //         if (!connected) {
// //           _handleOnlineFailure('Connection failed');
// //           return;
// //         }
// //         await Future.delayed(const Duration(milliseconds: 300));
// //       }
      
// //       final success = await _socketService.goOnline();
// //       if (!success) {
// //         _handleOnlineFailure('Failed to go online');
// //       }
// //     } catch (e) {
// //       _handleOnlineFailure('Error: $e');
// //     }
// //   }

// //   void _handleOnlineFailure(String message) {
// //     setState(() {
// //       _isOnDuty = false;
// //       _isProcessingOnline = false;
// //     });
// //   }

// //   Future<void> _goOffline() async {
// //     try {
// //       await _socketService.goOffline();
// //       setState(() {
// //         _isOnDuty = false;
// //       });
// //       _clearPendingRideRequest();
// //     } catch (error) {
// //       print('Error going offline: $error');
// //     }
// //   }

// //   void _toggleOnlineStatus() {
// //     if (_isOnDuty) {
// //       _goOffline();
// //     } else {
// //       _goOnline();
// //     }
// //   }

// //   // ==================== UI BUILD ====================
// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;
    
// //     return _isOnDuty ? _buildOnlineScreen(w) : _buildOfflineScreen(w);
// //   }

// //   Widget _buildOfflineScreen(double w) {
// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(w * .300),
// //         child: Container(
// //           height: w * .290,
// //           decoration: BoxDecoration(
// //             color: AppColors.white,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.grey.withOpacity(0.2),
// //                 spreadRadius: 1,
// //                 blurRadius: 2,
// //                 offset: const Offset(0, 3),
// //               ),
// //             ],
// //             borderRadius: BorderRadius.only(
// //               bottomLeft: Radius.circular(w * 0.04),
// //               bottomRight: Radius.circular(w * 0.04),
// //             ),
// //           ),
// //           child: SafeArea(
// //             child: Padding(
// //               padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       CircleAvatar(
// //                         radius: w * 0.06,
// //                         backgroundImage: const AssetImage('assets/images/home2.png'),
// //                       ),
// //                       SizedBox(width: w * 0.03),
// //                       AppFonts.textPoppins(
// //                         context,
// //                         "Ayaan Malviya",
// //                         w * 0.05,
// //                         FontWeight.w600,
// //                         AppColors.black,
// //                         TextAlign.left,
// //                         TextOverflow.visible,
// //                       ),
// //                     ],
// //                   ),
// //                   GestureDetector(
// //                     onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
// //                     child: Container(
// //                       width: w * 0.26,
// //                       height: w * 0.10,
// //                       decoration: BoxDecoration(
// //                         color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
// //                         borderRadius: BorderRadius.circular(w * 0.06),
// //                       ),
// //                       alignment: Alignment.center,
// //                       child: _isProcessingOnline
// //                           ? SizedBox(
// //                               width: w * 0.04,
// //                               height: w * 0.04,
// //                               child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// //                             )
// //                           : Text(
// //                               _isOnDuty ? 'Online' : 'Offline',
// //                               style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
// //                             ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               SizedBox(height: w * 0.04),
// //               Image.asset("assets/images/offline_image.png", height: w * 0.5),
// //               Text(
// //                 _isOnDuty ? "You're Online" : "You're Offline",
// //                 style: TextStyle(
// //                   fontSize: w * 0.05,
// //                   fontWeight: FontWeight.bold,
// //                   color: _isOnDuty ? Colors.green : Colors.black,
// //                 ),
// //               ),
// //               Text(
// //                 _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
// //                 style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
// //               ),
// //               SizedBox(height: w * 0.04),
// //               ElevatedButton(
// //                 onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
// //                 style: ElevatedButton.styleFrom(
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
// //                   backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
// //                   minimumSize: Size(w * 0.9, 45),
// //                 ),
// //                 child: _isProcessingOnline
// //                     ? SizedBox(
// //                         width: w * 0.04,
// //                         height: w * 0.04,
// //                         child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
// //                       )
// //                     : Text(
// //                         _isOnDuty ? "Go Offline" : "Go Online",
// //                         style: TextStyle(fontSize: w * 0.04, color: Colors.white),
// //                       ),
// //               ),
// //               SizedBox(height: w * 0.03),
// //               Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: AppFonts.textPoppins(
// //                   context,
// //                   "Today's Update",
// //                   w * 0.038,
// //                   FontWeight.w600,
// //                   AppColors.black,
// //                   TextAlign.left,
// //                   TextOverflow.visible,
// //                 ),
// //               ),
// //               SizedBox(height: w * 0.04),
// //               _buildStatsSection(w),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildOnlineScreen(double w) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Stack(
// //           children: [
// //             GoogleMap(
// //               initialCameraPosition: _initialCameraPosition,
// //               myLocationEnabled: false,
// //               myLocationButtonEnabled: false,
// //               zoomControlsEnabled: false,
// //               onMapCreated: (controller) => _mapController = controller,
// //               markers: markers,
// //               circles: circles,
// //             ),
// //             Positioned(
// //               top: 16,
// //               right: 16,
// //               child: ElevatedButton(
// //                 onPressed: () => Get.to(() => const BookRide()),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.cyan,
// //                   shape: const StadiumBorder(),
// //                   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
// //                 ),
// //                 child: const Text(
// //                   "Book Ride",
// //                   style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
// //                 ),
// //               ),
// //             ),
// //             Positioned(
// //               bottom: 0,
// //               left: 0,
// //               right: 0,
// //               child: _bottomCard(w),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _bottomCard(double w) {
// //     return Container(
// //       padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
// //         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// //             children: [
// //               _buildTabButton("Driver", "assets/icons/drive.png", "assets/icons/driveoff.svg", w),
// //               SizedBox(width: w * 0.25),
// //               _buildTabButton("Earnings", "assets/icons/dolleron.svg", "assets/icons/doller.png", w),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           _selectedTab == "Driver" ? _driverContent() : _earningsContent(w),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTabButton(String label, String activeIcon, String inactiveIcon, double w) {
// //     bool isActive = _selectedTab == label;
// //     return GestureDetector(
// //       onTap: () => setState(() => _selectedTab = label),
// //       child: Column(
// //         children: [
// //           Image.asset(isActive ? activeIcon : inactiveIcon, width: w * 0.06),
// //           const SizedBox(height: 4),
// //           Text(
// //             label,
// //             style: TextStyle(
// //               color: isActive ? Colors.blue : Colors.grey,
// //               fontSize: w * 0.03,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _driverContent() {
// //     return Column(
// //       children: [
// //         Image.asset("assets/images/onlinee.png", height: 120),
// //         const SizedBox(height: 12),
// //         const Text(
// //           "You're Online",
// //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 6),
// //         const Text(
// //           "Go offline to stop accepting rides.",
// //           style: TextStyle(color: Colors.grey),
// //         ),
// //         const SizedBox(height: 16),
// //         SizedBox(
// //           width: double.infinity,
// //           height: 48,
// //           child: ElevatedButton(
// //             onPressed: _goOffline,
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.redAccent,
// //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //             ),
// //             child: const Text(
// //               "Go Offline",
// //               style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _earningsContent(double w) {
// //     return Column(
// //       children: [
// //         Align(
// //           alignment: Alignment.centerLeft,
// //           child: AppFonts.textPoppins(
// //             context,
// //             "Today's Update",
// //             w * 0.038,
// //             FontWeight.w600,
// //             AppColors.black,
// //             TextAlign.left,
// //             TextOverflow.visible,
// //           ),
// //         ),
// //         SizedBox(height: w * 0.02),
// //         _buildStatsSection(w),
// //       ],
// //     );
// //   }

// //   Widget _buildStatsSection(double w) {
// //     return Column(
// //       children: [
// //         HomeScreenWidgets.elevatedBox(
// //           width: double.infinity,
// //           shadowColor: const Color(0xFF4CAF50),
// //           child: const Column(
// //             children: [
// //               Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Colors.grey)),
// //               SizedBox(height: 4),
// //               Text("₹1000.00", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
// //             ],
// //           ),
// //         ),
// //         SizedBox(height: w * 0.02),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             SizedBox(
// //               width: w * 0.45,
// //               child: HomeScreenWidgets.elevatedBox(
// //                 shadowColor: const Color(0xFFFEBC2F),
// //                 child: const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Online", style: TextStyle(fontSize: 13, color: Colors.grey)),
// //                     SizedBox(height: 4),
// //                     Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               width: w * 0.45,
// //               child: HomeScreenWidgets.elevatedBox(
// //                 shadowColor: const Color(0xFF7C7C8D),
// //                 child: const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Cash", style: TextStyle(fontSize: 13, color: Colors.grey)),
// //                     SizedBox(height: 4),
// //                     Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         SizedBox(height: w * 0.02),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             SizedBox(
// //               width: w * 0.45,
// //               child: HomeScreenWidgets.elevatedBox(
// //                 shadowColor: const Color(0xFF439AFE),
// //                 child: const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Total Rides", style: TextStyle(fontSize: 13, color: Colors.grey)),
// //                     SizedBox(height: 4),
// //                     Text("50 / 45 Completed", style: TextStyle(fontWeight: FontWeight.w600)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               width: w * 0.45,
// //               child: HomeScreenWidgets.elevatedBox(
// //                 shadowColor: const Color(0xFFF26061),
// //                 child: const Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Total Rides", style: TextStyle(fontSize: 13, color: Colors.grey)),
// //                     SizedBox(height: 4),
// //                     Text("50 / 05 Cancelled", style: TextStyle(fontWeight: FontWeight.w600)),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }


// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:nzcu_driver/controllers/controllers.dart';
// import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/utilities/custom_font.dart';
// import 'package:nzcu_driver/utilities/map_helper.dart';
// import 'package:nzcu_driver/views/book_ride/book_ride.dart';
// import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:nzcu_driver/views/home_related/live_ride.dart';
// import 'package:nzcu_driver/views/widgets/home_screen_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   Controllers controllers = Get.put(Controllers());
//   final HomeController homeController = Get.find<HomeController>();
//   final StepperController stepperController = Get.find<StepperController>();
  
//   // Socket instance
//   IO.Socket? _socket;
//   bool _isSocketConnected = false;
//   String? _socketId;
  
//   // Socket configuration
//   static const String SOCKET_URL = 'https://corezap.smarttechbros.com';
//   static const int MAX_RECONNECT_ATTEMPTS = 5;
//   static const int CONNECTION_TIMEOUT = 10000;
//   static const int LOCATION_UPDATE_INTERVAL = 5000; // 5 seconds
//   static const double LOCATION_CHANGE_THRESHOLD = 0.0001; // ~11 meters
  
//   // Driver data
//   String? _driverId;
//   String? _driverName;
//   String? _driverPhone;
//   String? _driverImage;
//   String? _vehicleType;
//   String? _vehicleNumber;
//   String? _vehicleImage;
//   String? _fleetId;
  
//   // Location
//   double _currentLatitude = 0.0;
//   double _currentLongitude = 0.0;
//   double? _lastSentLatitude;
//   double? _lastSentLongitude;
//   DateTime? _lastLocationUpdate;
//   StreamSubscription<Position>? _positionStreamSubscription;
//   Timer? _locationUpdateTimer;
  
//   // Driver status
//   bool _isOnDuty = false;
//   bool _isProcessingOnline = false;
//   bool _isRideInProgress = false;
//   bool _isAppReady = false;
//   bool _permissionCheckInProgress = false;
  
//   // Ride tracking
//   Map<String, dynamic>? _currentRide;
//   String? _activeRideId;
//   DateTime? _rideStartTime;
  
//   // App lifecycle state
//   AppLifecycleState? _appLifecycleState;
//   bool _appInBackground = false;
//   DateTime? _appBackgroundTime;
//   String _selectedTab = "Driver";
  
//   // Ride variables
//   Map<String, dynamic>? _newRideRequest;
//   bool _hasPendingRideRequest = false;
//   Timer? _rideRequestTimer;
  
//   // Reconnection tracking
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;
//   Timer? _backgroundReconnectTimer;
  
//   // Map variables
//   final CameraPosition _initialCameraPosition = const CameraPosition(
//     target: LatLng(23.2508131, 77.4647936), 
//     zoom: 17,
//   );
//   late GoogleMapController _mapController;
  
//   // Markers and circles
//   Set<Marker> markers = {};
//   Set<Circle> circles = {};
//   BitmapDescriptor? _bikeMarkerIcon;
  
//   // Nearby riders/drivers
//   List<Map<String, dynamic>> _nearbyRiders = [];
//   Map<String, BitmapDescriptor> _vehicleIcons = {};
  
//   // Event listeners storage
//   final Map<String, List<Function(dynamic)>> _socketListeners = {};
  
//   // Token
//   String? _token;
//   String? _userId;
//   String _socketStatus = 'Not Connected';

//   @override
//   void initState() {
//     homeController.home_data_method();
//     super.initState();
    
//     // Add observer for app lifecycle
//     WidgetsBinding.instance.addObserver(this);
    
//     // Initialize connection
//     _initializeConnection();
//   }

//   @override
//   void dispose() {
//     // Remove observer
//     WidgetsBinding.instance.removeObserver(this);
    
//     // Clean up resources
//     _cleanupResources();
    
//     // Disconnect socket
//     _disconnectSocket();
    
//     super.dispose();
//   }
  
//   void _cleanupResources() {
//     // Clear all timers
//     _clearRideRequestTimer();
//     _stopBackgroundReconnectTimer();
//     _stopLocationWatch();
//     _stopLocationUpdates();
    
//     // Cancel position stream
//     _positionStreamSubscription?.cancel();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print('📱 App lifecycle changed: $state');
    
//     setState(() {
//       _appLifecycleState = state;
//     });
    
//     switch (state) {
//       case AppLifecycleState.resumed:
//         _onAppResumed();
//         break;
//       case AppLifecycleState.inactive:
//         _onAppInactive();
//         break;
//       case AppLifecycleState.paused:
//         _onAppPaused();
//         break;
//       case AppLifecycleState.detached:
//         _onAppDetached();
//         break;
//       case AppLifecycleState.hidden:
//         _onAppHidden();
//         break;
//     }
//   }

//   void _onAppResumed() {
//     print('📱 App resumed from background');
    
//     if (_appInBackground) {
//       _appInBackground = false;
      
//       // Stop background reconnect timer
//       _stopBackgroundReconnectTimer();
      
//       // Mark app as ready for location requests
//       _isAppReady = true;
      
//       // Check connection status
//       if (_isSocketConnected && _isOnDuty) {
//         print('✅ Socket still connected, resuming operations...');
//       } else if (_isOnDuty) {
//         // Was on duty but disconnected, try to reconnect
//         print('⚠️ Socket disconnected while in background, reconnecting...');
//         _reconnectWithRetry();
//       }
      
//       _appBackgroundTime = null;
//     }
//   }

//   void _onAppPaused() {
//     print('📱 App going to background');
    
//     _appInBackground = true;
//     _appBackgroundTime = DateTime.now();
    
//     // Clear pending ride request
//     _clearPendingRideRequest();
    
//     // If we're online, set up background reconnect attempts
//     if (_isOnDuty) {
//       _startBackgroundReconnectTimer();
//     }
//   }

//   void _onAppInactive() {
//     print('📱 App inactive (between states)');
//   }

//   void _onAppDetached() {
//     print('📱 App detached (destroyed)');
//     _cleanupResources();
//   }

//   void _onAppHidden() {
//     print('📱 App hidden');
//     _appInBackground = true;
//   }

//   Future<void> _initializeConnection() async {
//     // Request permissions
//     await _requestPermissions();
    
//     // Load custom bike marker and vehicle icons
//     await _loadCustomBikeMarker();
//     await _loadVehicleIcons();
    
//     // Wait for token to load
//     await _getToken();
    
//     // Start real-time location stream
//     _listenToLocation();
    
//     // Then connect socket with valid token
//     if (_token != null && _driverId != null && _driverId!.isNotEmpty) {
//       await _connectSocket();
//     } else {
//       print('❌ Cannot connect: Token or Driver ID is missing');
//       _showToast('Failed to load credentials');
//     }
//   }

//   Future<void> _requestPermissions() async {
//     try {
//       // Request location service
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         print('❌ Location service disabled');
//         return;
//       }
      
//       // Request location permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
      
//       if (permission == LocationPermission.deniedForever) {
//         print('❌ Location permission permanently denied');
//         return;
//       }
      
//       if (permission == LocationPermission.denied) {
//         print('⚠️ Location permission denied');
//         return;
//       }
      
//       print('✅ Location permission granted');
      
//       // Request notification permission (if needed)
//       final notificationStatus = await Permission.notification.request();
//       if (notificationStatus.isGranted) {
//         print('✅ Notification permission granted');
//       }
      
//       // Mark app as ready
//       _isAppReady = true;
      
//     } catch (error) {
//       print('❌ Error requesting permissions: $error');
//     }
//   }

//   Future<void> _getToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString("auth_token");
//       final String? userId = prefs.getString("driver_userid");

//       setState(() {
//         _token = token;
//         _userId = userId;
//         _driverId = userId;
//       });

//       print('✅ Token loaded from SharedPreferences');
//       print('User ID: $_userId');
//       print("myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...");
//       print("myyyy_driverid>>> ${_driverId}");

//     } catch (e) {
//       print('❌ Error loading token: $e');
//     }
//   }

//   // ==================== SOCKET METHODS ====================

//   Future<bool> _connectSocket() async {
//     print("🔄 Connecting socket...");
    
//     try {
//       if (_socket != null && _isSocketConnected) {
//         print('✅ Socket already connected');
//         return true;
//       }

//       // Get driver data
//       await _fetchDriverData();

//       // Disconnect existing
//       _disconnectSocket();

//       print('🔌 Connecting driver socket...');

//       // Create socket connection with optimized settings
//       _socket = IO.io(
//         SOCKET_URL,
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling'])
//             .enableAutoConnect()
//             .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
//             .setReconnectionDelay(1000)
//             .setReconnectionDelayMax(5000)
//             .setTimeout(CONNECTION_TIMEOUT)
//             .setAuth({'token': _token})
//             .setQuery({
//               'userRole': 'Driver',
//               'platform': 'flutter',
//               'driverId': _driverId,
//             })
//             .build(),
//       );

//       // Setup event listeners
//       _setupSocketEventListeners();

//       // Connect
//       _socket!.connect();

//       // Wait for connection with timeout
//       return await _waitForConnection();
//     } catch (error) {
//       print('❌ Socket connection error: $error');
//       return false;
//     }
//   }

//   Future<bool> _waitForConnection() async {
//     final completer = Completer<bool>();
    
//     final timeout = Timer(const Duration(seconds: 5), () {
//       if (!completer.isCompleted) {
//         print('❌ Connection timeout');
//         completer.complete(false);
//       }
//     });
    
//     _socket!.once('connect', (_) {
//       timeout.cancel();
//       if (!completer.isCompleted) {
//         print('✅ Socket connected!');
//         completer.complete(true);
//       }
//     });
    
//     _socket!.once('connect_error', (error) {
//       timeout.cancel();
//       if (!completer.isCompleted) {
//         print('❌ Connection error: $error');
//         completer.complete(false);
//       }
//     });
    
//     return completer.future;
//   }

//   void _setupSocketEventListeners() {
//     if (_socket == null) return;

//     // CONNECTION EVENTS
//     _socket!.onConnect((_) {
//       print('✅ Driver socket connected: ${_socket!.id}');
//       setState(() {
//         _isSocketConnected = true;
//         _socketId = _socket!.id;
//         _reconnectAttempts = 0;
//         _socketStatus = 'Connected';
//       });
      
//       // Auto go online if driver was on duty
//       if (_isOnDuty) {
//         Timer(const Duration(seconds: 1), () {
//           _goOnline();
//         });
//       }
//     });

//     _socket!.onDisconnect((_) {
//       print('❌ Driver socket disconnected');
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnected';
//       });
      
//       _stopLocationUpdates();
//       _clearPendingRideRequest();
      
//       // If we're online and app is active, try to reconnect
//       if (_isOnDuty && !_appInBackground && mounted) {
//         print('🔄 Online but disconnected, will attempt reconnect...');
//         Future.delayed(const Duration(seconds: 2), () {
//           if (mounted && !_isSocketConnected && _isOnDuty) {
//             _reconnectWithRetry();
//           }
//         });
//       }
//     });

//     _socket!.onConnectError((data) {
//       print('❌ Socket connection error: $data');
//       _reconnectAttempts++;
//       setState(() {
//         _socketStatus = 'Connection Error';
//       });
//     });

//     _socket!.onReconnect((data) {
//       print('🔄 Socket reconnected');
//       setState(() {
//         _isSocketConnected = true;
//         _socketStatus = 'Reconnected';
//         _reconnectAttempts = 0;
//       });
      
//       // If we were online, restore status
//       if (_isOnDuty) {
//         _restoreOnlineStatus();
//       }
//     });

//     // DRIVER STATUS EVENTS
//     _socket!.on('driver:online_success', (data) {
//       print('✅ Driver online confirmed: ${data}', );
//       _handleOnlineSuccess(data);
//     });

//     _socket!.on('driver:online_failed ', (data) {
//       print('❌ Driver online failed:${data}', );
//       _handleOnlineFailure(data);
//     });

//     // RIDE REQUEST EVENTS
//     _socket!.on('ride:newRide', (data) {
//       final rideData = _mapRideData(data);
//       print('🚕 NEW RIDE REQUEST RECEIVED : ${rideData}', );
      
//       // Check if we're online and can accept rides
//       if (!_isOnDuty) {
//         print('⚠️ Received ride request but driver is offline');
//         return;
//       }

      
      
//       // Process the ride request
//       _processRideRequest(rideData);
//     });

//     _socket!.on('ride:confirmed', (data) async {
//       final prefs = await SharedPreferences.getInstance();
//       print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
//       await prefs.setString("order_id", data['orderId']);

//       // Update current ride state
//       _currentRide = {
//         'orderId': data['orderId'],
//         'status': 'confirmed',
//         'rider': data['rider'] ?? data['user'],
//         'pickup': data['pickupLocation'] ?? data['startLocation'],
//         'dropoff': data['dropoffLocation'] ?? data['endLocation'],
//         'fare': data['fare'] ?? data['totalFare'],
//         'distance': data['distance'],
//         'duration': data['duration'] ?? data['estimatedTime'],
//         'otp': data['otp'],
//         'completeData': data,
//       };
      
//       if (_activeRideId == data['orderId']) {
//         print('🚗 Ride confirmation matched active ride');
//       } else {
//         print('⚠️ Ride confirmation for different ride, updating active ride');
//         _activeRideId = data['orderId'];
//         _rideStartTime = DateTime.now();
//         _isRideInProgress = true;
//       }
      
//       print('🚗 Ride state updated to CONFIRMED');
      
//       // Navigate to ride screen
//       _navigateToRideScreen(_currentRide!);
//     });

//     _socket!.on('ride:status', (data) {
//       print('📊 Ride status update: ${data}', );
      
//       final orderId = data['orderId'];
//       if (_currentRide != null && _currentRide!['orderId'] == orderId) {
//         _currentRide!['status'] = data['status'];
//       }
      
//       // Mark ride as complete
//       final status = data['status'];
//       if (status == 'completed' || status == 'finished' || status == 'ended') {
//         print('✅ Ride completion status received: $status');
//         _completeRide(orderId);
//       }
//     });

//     _socket!.on('ride:orderCancelled', (data) {
//       print('❌ Ride cancelled: ${data}', );
//       _completeRide(data['orderId']);
//       _currentRide = null;
//       _clearPendingRideRequest();
//       _showToast('Ride cancelled');
//     });

//     _socket!.on('ride:location', (data) {
//       print('📍 Rider location during ride: ${data}', );
//     });

//     // CHAT EVENTS
//     _socket!.on('chat:join_success', (data) {
//       print('✅ Joined chat room: ${data}', );
//     });

//     _socket!.on('chat:receiveMessage', (data) {
//       print('💬 New chat message received: ${data}', );
//     });

//     _socket!.on('chat:message', (data) {
//       print('💬 New chat message received: ${data}', );
//     });

//     // Generic event listener for debugging
//     _socket!.onAny((event, data) {
//       print('[RECEIVED] $event: ${data}', );
//     });
//   }

//   Map<String, dynamic> _mapRideData(dynamic data) {
//     final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
    
//     // Extract pickup coordinates
//     Map<String, dynamic>? pickupCoords;
//     if (rideData['pickup'] != null) {
//       final pickup = Map<String, dynamic>.from(rideData['pickup']);
//       if (pickup['latitude'] != null && pickup['longitude'] != null) {
//         pickupCoords = {
//           'latitude': double.parse(pickup['latitude'].toString()),
//           'longitude': double.parse(pickup['longitude'].toString()),
//         };
//       }
//     }
    
//     // Extract dropoff coordinates
//     Map<String, dynamic>? dropoffCoords;
//     if (rideData['destination'] != null) {
//       final destination = Map<String, dynamic>.from(rideData['destination']);
//       if (destination['latitude'] != null && destination['longitude'] != null) {
//         dropoffCoords = {
//           'latitude': double.parse(destination['latitude'].toString()),
//           'longitude': double.parse(destination['longitude'].toString()),
//         };
//       }
//     }
    
//     // Build mapped data
//     return {
//       ...rideData,
//       'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
//       'pickup': pickupCoords,
//       'destination': dropoffCoords,
//       'startLocation': {
//         'address': rideData['startLocation']?['address'] ?? 'Pickup Location',
//         'coordinates': pickupCoords,
//       },
//       'endLocation': rideData['endLocation'] != null ? {
//         'address': rideData['endLocation']?['address'] ?? 'Drop Location',
//         'coordinates': dropoffCoords,
//       } : null,
//       'riderId': rideData['riderId'] ?? rideData['userId']?['_id'] ?? rideData['userId'],
//       'riderName': rideData['riderName'] ?? rideData['userId']?['name'] ?? 'Customer',
//       'riderNumber': (rideData['riderNumber'] ?? rideData['userId']?['phone'] ?? '').toString(),
//       'totalFare': (rideData['totalFare'] ?? rideData['fare']?['total'] ?? rideData['fare'] ?? '0').toString(),
//       'distance': (rideData['distance'] ?? '0').toString(),
//       'estimatedTime': (rideData['estimatedTime'] ?? '15').toString(),
//       'vehicleType': rideData['vehicleType'] ?? 'sedan',
//       'otp': rideData['otp'],
//     };
//   }

//   void _disconnectSocket() {
//     // Don't disconnect if ride is in progress
//     if (_isRideInProgress && _activeRideId != null) {
//       print('⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.');
//       return;
//     }

//     _stopLocationWatch();
//     _stopLocationUpdates();
    
//     if (_socket != null) {
//       _socket!.disconnect();
//       _socket!.dispose();
//       _socket = null;
//     }
    
//     setState(() {
//       _isSocketConnected = false;
//       _socketId = null;
//       _isOnDuty = false;
//     });
    
//     print('🔌 Driver socket disconnected');
//   }

//   // ==================== DRIVER ONLINE/OFFLINE ====================

//   Future<void> _goOnline() async {
//     print('🟢 GOING ONLINE...');

//     if (_isProcessingOnline) {
//       print('⏳ Already processing...');
//       return;
//     }

//     setState(() {
//       _isProcessingOnline = true;
//     });

//     try {
//       if (_socket == null || !_isSocketConnected) {
//         print('⚠️ Socket not connected, cannot go online');
//         _handleOnlineFailure('Socket not connected');
//         return;
//       }

//       // Get location
//       try {
//         await _getCurrentLocation();
//       } catch (error) {
//         print('⚠️ Location fetch failed: $error');
//       }

//       final payload = {
//         'latitude': _currentLatitude,
//         'longitude': _currentLongitude,
//         'vehicleType': _vehicleType,
//         'vehicleImage': _vehicleImage,
//         'fleetId': _fleetId,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       print('📡 Emitting user:online: ${payload}', );
//       _socket!.emit('user:online', payload);

//       // Start location tracking
//       _startLocationWatch();
//       _startLocationUpdates();

//       print('🟢 Driver is now online and ready for rides');
      
//     } catch (error) {
//       print('❌ Error going online: $error');
//       _handleOnlineFailure('Error: $error');
//     }
//   }

//   Future<void> _goOffline() async {
//     print('🔴 GOING OFFLINE...');
    
//     try {
//       if (_socket != null && _isSocketConnected) {
//         print('🔴 Going offline');
        
//         // Emit offline event to backend
//         final payload = {
//           'driverId': _driverId,
//           'timestamp': DateTime.now().toIso8601String(),
//         };
//         _socket!.emit('user:offline', payload);
//         print('📡 Emitted user:offline event: ${payload}', );
        
//         // Stop location updates immediately
//         _stopLocationWatch();
//         _stopLocationUpdates();
        
//         // Disconnect socket completely
//         _socket!.disconnect();
//         _socket!.dispose();
//         _socket = null;
        
//         print('✅ Socket completely disconnected');
//       }
      
//       setState(() {
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//         _isSocketConnected = false;
//         _socketId = null;
//       });

//       // Remove bike marker and circle
//       _removeBikeMarkerAndCircle();

//       // Clear pending ride request
//       _clearPendingRideRequest();

//       print('✅ Driver is now offline - socket disconnected');
//       _showToast('Offline - Socket disconnected');
      
//     } catch (error) {
//       print('❌ Error going offline: $error');
//       _showToast('Error going offline');
//     }
//   }

//   void _handleOnlineSuccess(dynamic data) {
//     if (!_isProcessingOnline) return;

//     print('✅ DRIVER ONLINE SUCCESS');

//     setState(() {
//       _isOnDuty = true;
//       _isProcessingOnline = false;
//     });

//     String successMessage = 'Driver is now online';
//     if (data is Map<String, dynamic>) {
//       successMessage = data['message'] ?? successMessage;
//     }

//     _showToast(successMessage);

//     // Update map with current location
//     if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
//       _updateMarkerOnly(
//         LatLng(_currentLatitude, _currentLongitude),
//         50.0, // Default accuracy
//       );
//     }
//   }

//   void _handleOnlineFailure(dynamic data) {
//     if (!_isProcessingOnline) return;

//     print('❌ DRIVER ONLINE FAILED');

//     setState(() {
//       _isOnDuty = false;
//       _isProcessingOnline = false;
//     });

//     String errorMessage = 'Failed to go online';
//     if (data is String) {
//       errorMessage = data;
//     } else if (data is Map<String, dynamic>) {
//       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
//     }

//     _showToast(errorMessage);
//   }

//   // ==================== RIDE METHODS ====================

//   bool _acceptRide(Map<String, dynamic> rideData) {
//     if (_socket == null || !_isSocketConnected) {
//       print('❌ Cannot accept ride - socket not connected');
//       return false;
//     }

//     final orderId = rideData['orderId'] ?? 
//                    rideData['_id'] ?? 
//                    rideData['id'] ?? 
//                    rideData['rideId'];
    
//     if (orderId == null) {
//       print('❌ No order ID found in ride data');
//       return false;
//     }

//     // Mark ride as in progress
//     _activeRideId = orderId;
//     _rideStartTime = DateTime.now();
//     _isRideInProgress = true;
    
//     _currentRide = {
//       'orderId': orderId,
//       'status': 'accepting',
//       'data': rideData,
//     };

//     final payload = {
//       'orderId': orderId,
//       'driverId': _driverId,
//       'driverName': _driverName,
//       'driverPhone': _driverPhone,
//       'driverImage': _driverImage,
//       'acceptedAt': DateTime.now().toIso8601String(),
//       'location': {
//         'latitude': _currentLatitude,
//         'longitude': _currentLongitude,
//       },
//       'vehicleType': _vehicleType,
//       'vehicleNumber': _vehicleNumber,
//       'vehicleImage': _vehicleImage,
//     };

//     print('✅ Emitting ride:accept with driver data: ${payload}', );
//     _socket!.emit('ride:accept', payload);
    
//     return true;
//   }

//   bool _declineRide(String rideId, {String reason = ''}) {
//     if (_socket == null || !_isSocketConnected) {
//       return false;
//     }

//     final payload = {
//       'orderId': rideId,
//       'driverId': _driverId,
//       'reason': reason,
//       'declinedAt': DateTime.now().toIso8601String(),
//     };

//     print('❌ Declining ride: ${payload}', );
//     _socket!.emit('ride:decline', payload);
//     return true;
//   }

//   void _completeRide(String rideId) {
//     if (_activeRideId == rideId || rideId.isNotEmpty) {
//       print('✅ Ride completed (ID: $rideId)');
//       _activeRideId = null;
//       _rideStartTime = null;
//       _isRideInProgress = false;
//       _currentRide = null;
//     }
//   }

//   // ==================== RIDE REQUEST HANDLING ====================

//   void _processRideRequest(Map<String, dynamic> rideData) {
//     print('🚕 Processing ride request...');
    

//     Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => RideRequestScreen(rideData: rideData),
//             ),
//           );


//     // try {
//     //   // Create a deep copy
//     //   final Map<String, dynamic> rideDataCopy = Map<String, dynamic>.from(rideData);
      
//     //   // Add any missing fields with default values
//     //   if (!rideDataCopy.containsKey('riderName')) {
//     //     rideDataCopy['riderName'] = 'Customer';
//     //   }
//     //   if (!rideDataCopy.containsKey('riderNumber')) {
//     //     rideDataCopy['riderNumber'] = 'N/A';
//     //   }
//     //   if (!rideDataCopy.containsKey('totalFare')) {
//     //     rideDataCopy['totalFare'] = '0';
//     //   }
//     //   if (!rideDataCopy.containsKey('distance')) {
//     //     rideDataCopy['distance'] = '0';
//     //   }
//     //   if (!rideDataCopy.containsKey('rideId')) {
//     //     rideDataCopy['rideId'] = rideDataCopy['orderId'] ?? 'N/A';
//     //   }
//     //   if (!rideDataCopy.containsKey('timestamp')) {
//     //     rideDataCopy['timestamp'] = DateTime.now().millisecondsSinceEpoch;
//     //   }
      
//     //   // Ensure nested structures exist
//     //   if (!rideDataCopy.containsKey('startLocation')) {
//     //     rideDataCopy['startLocation'] = {
//     //       'address': 'Location not specified',
//     //       'coordinates': [78.4772, 17.4065]
//     //     };
//     //   }
      
//     //   if (!rideDataCopy.containsKey('endLocation')) {
//     //     rideDataCopy['endLocation'] = {
//     //       'address': 'Destination not specified',
//     //       'coordinates': [78.4850, 17.4120]
//     //     };
//     //   }
      
//     //   // Store the new ride request
//     //   setState(() {
//     //     _newRideRequest = rideDataCopy;
//     //     _hasPendingRideRequest = true;
//     //   });

//     //   print("myyyyyyyyyyyyyyyy_rideeeee_datattt ${rideData}");

//     //   // Navigate to LiveRide screen IMMEDIATELY
//     //   if (mounted) {
//     //     WidgetsBinding.instance.addPostFrameCallback((_) {
//     //       Navigator.push(
//     //         context,
//     //         MaterialPageRoute(
//     //           builder: (context) => RideRequestScreen(rideData: rideData),
//     //         ),
//     //       );
//     //     });
//     //   }

//     //   // Auto-reject timer
//     //   final timeoutSeconds = rideDataCopy['timeout']?.toDouble() ?? 30.0;
//     //   _startRideRequestTimer(rideDataCopy['orderId'], timeoutSeconds);

//     //   print('✅ New ride request stored and navigating...');
//     //   print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');
//     // } catch (error) {
//     //   print('❌ Error processing ride request: $error');
//     // }
//   }

//   void _navigateToRideScreen(Map<String, dynamic> rideData) {
//     // Clear pending request
//     _clearPendingRideRequest();
    
//     // Navigate to ride screen
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => RideRequestScreen(rideData: rideData),
//     //     ),
//     //   );
//     // });
//   }

//   void _startRideRequestTimer(String orderId, double timeoutSeconds) {
//     _clearRideRequestTimer();
    
//     final seconds = timeoutSeconds.toInt();
    
//     _rideRequestTimer = Timer(Duration(seconds: seconds), () {
//       if (_hasPendingRideRequest && _newRideRequest != null) {
//         print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
//         _declineRide(orderId, reason: 'timeout');
//         _showToast('Ride request auto-rejected (timeout)');
        
//         _clearPendingRideRequest();
//       }
//     });
//   }

//   void _clearRideRequestTimer() {
//     if (_rideRequestTimer != null) {
//       _rideRequestTimer!.cancel();
//       _rideRequestTimer = null;
//     }
//   }

//   void _clearPendingRideRequest() {
//     _clearRideRequestTimer();
//     setState(() {
//       _newRideRequest = null;
//       _hasPendingRideRequest = false;
//     });
//   }

//   // ==================== BACKGROUND RECONNECT ====================

//   void _startBackgroundReconnectTimer() {
//     _stopBackgroundReconnectTimer();
    
//     print('🔄 Starting background reconnect monitoring...');
    
//     _backgroundReconnectTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       if (_appInBackground && _isOnDuty && !_isSocketConnected) {
//         print('🔧 Background: Checking connection...');
//         _checkAndReconnect();
//       }
//     });
//   }

//   void _stopBackgroundReconnectTimer() {
//     if (_backgroundReconnectTimer != null) {
//       _backgroundReconnectTimer!.cancel();
//       _backgroundReconnectTimer = null;
//     }
//   }

//   void _checkAndReconnect() {
//     if (!_isSocketConnected) {
//       print('🔄 Background: Socket disconnected, attempting reconnect...');
//       _connectSocket();
//     }
//   }

//   void _reconnectWithRetry() {
//     if (_isSocketConnected) return;
    
//     print('🔄 Attempting socket reconnection...');
    
//     int attempts = 0;
//     const maxAttempts = 3;
    
//     Future.delayed(Duration.zero, () async {
//       while (attempts < maxAttempts && !_isSocketConnected && mounted) {
//         attempts++;
//         print('🔄 Reconnection attempt $attempts/$maxAttempts');
        
//         try {
//           await _connectSocket();
          
//           // Wait for connection
//           await Future.delayed(const Duration(seconds: 2));
          
//           if (_isSocketConnected) {
//             print('✅ Reconnection successful');
            
//             // If we were online before, restore online status
//             if (_isOnDuty) {
//               print('🔄 Restoring online status...');
//               await _restoreOnlineStatus();
//             }
            
//             break;
//           }
//         } catch (error) {
//           print('❌ Reconnection attempt $attempts failed: $error');
//         }
        
//         if (attempts < maxAttempts) {
//           await Future.delayed(Duration(seconds: attempts * 2));
//         }
//       }
      
//       if (!_isSocketConnected) {
//         print('❌ Failed to reconnect after $maxAttempts attempts');
//         _showToast('Connection lost. Please check your internet.');
//       }
//     });
//   }

//   Future<void> _restoreOnlineStatus() async {
//     if (!_isSocketConnected) return;
    
//     print('🔄 Restoring driver online status...');
    
//     try {
//       // Get current location
//       await _getCurrentLocation();
      
//       // Go online
//       await _goOnline();
      
//       print('✅ Online status restored');
      
//     } catch (error) {
//       print('❌ Error restoring online status: $error');
//     }
//   }

//   // ==================== LOCATION METHODS ====================

//   Future<bool> _requestLocationPermission() async {
//     if (_permissionCheckInProgress) {
//       return false;
//     }

//     try {
//       _permissionCheckInProgress = true;

//       // Check if permission is already granted
//       var status = await Permission.location.status;
//       if (status.isGranted) {
//         _permissionCheckInProgress = false;
//         return true;
//       }

//       // Request permission
//       status = await Permission.location.request();
//       _permissionCheckInProgress = false;
      
//       return status.isGranted;
//     } catch (error) {
//       _permissionCheckInProgress = false;
//       print('❌ Location permission error: $error');
//       return false;
//     }
//   }

//   Future<Map<String, dynamic>> _getCurrentLocation() async {
//     try {
//       // If app is not ready, use cached location
//       if (!_isAppReady) {
//         print('⏳ App not ready yet, using cached location if available');
//         if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
//           return {
//             'latitude': _currentLatitude,
//             'longitude': _currentLongitude,
//           };
//         }
//         throw Exception('App not ready and no cached location available');
//       }

//       final hasPermission = await _requestLocationPermission();
//       if (!hasPermission) {
//         print('⚠️ Location permission denied');
//         if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
//           print('ℹ️ Using last known location');
//           return {
//             'latitude': _currentLatitude,
//             'longitude': _currentLongitude,
//           };
//         }
//         throw Exception('Location permission denied');
//       }

//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
      
//       _currentLatitude = position.latitude;
//       _currentLongitude = position.longitude;
//       _lastLocationUpdate = DateTime.now();
      
//       // print('📍 Location fetched:', {
//       //   'latitude ${_currentLatitude}' ,
//       //   'longitude : ${_currentLongitude}' ,
//       //   'accuracy': position.accuracy,
//       // });
      
//       return {
//         'latitude': _currentLatitude,
//         'longitude': _currentLongitude,
//       };
//     } catch (error) {
//       print('❌ Failed to get location: $error');
      
//       // Fallback to cached location
//       if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
//         print('✅ Returning fallback cached location');
//         return {
//           'latitude': _currentLatitude,
//           'longitude': _currentLongitude,
//         };
//       }
      
//       return {'latitude': 0.0, 'longitude': 0.0};
//     }
//   }

//   void _listenToLocation() {
//     _positionStreamSubscription = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 10,
//       ),
//     ).listen((Position position) {
//       final LatLng newLocation =
//           LatLng(position.latitude, position.longitude);

//       // Update marker and circles only (camera stays put)
//       _updateMarkerOnly(newLocation, position.accuracy);
      
//       // Update current coordinates
//       _currentLatitude = position.latitude;
//       _currentLongitude = position.longitude;
      
//       print('📍 Location updated: ${position.latitude}, ${position.longitude}');
//     });
//   }

//   void _updateMarkerOnly(LatLng location, double accuracy) {
//     _currentLatitude = location.latitude;
//     _currentLongitude = location.longitude;

//     setState(() {
//       markers.clear();
//       circles.clear();
   
//       // Bike marker
//       markers.add(
//         Marker(
//           markerId: const MarkerId('driver_location'),
//           position: location,
//           icon: _bikeMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           anchor: const Offset(0.5, 0.5),
//           infoWindow: const InfoWindow(
//             title: 'Your Location',
//             snippet: 'You are here',
//           ),
//           zIndex: 2,
//         ),
//       );

//       // Grey outer circle (accuracy shadow)
//       circles.add(
//         Circle(
//           circleId: const CircleId('outer_shadow'),
//           center: location,
//           radius: accuracy + 80,
//           fillColor: Colors.grey.withOpacity(0.25),
//           strokeColor: Colors.transparent,
//         ),
//       );

//       // Green inner circle (center)
//       circles.add(
//         Circle(
//           circleId: const CircleId('inner_green'),
//           center: location,
//           radius: 60,
//           fillColor: Colors.green.withOpacity(0.35),
//           strokeColor: Colors.green,
//           strokeWidth: 1,
//         ),
//       );
//     });

//     print('✅ Driver marker and circles updated at (${location.latitude}, ${location.longitude})');
//   }

//   void _startLocationWatch() {
//     if (_positionStreamSubscription != null) {
//       print('ℹ️ Location watch already active');
//       return;
//     }

//     print('📍 Starting continuous location watch');

//     // Get initial location immediately
//     _getInitialLocation();

//     _positionStreamSubscription = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 5,
//       ),
//     ).listen((position) {
//       _currentLatitude = position.latitude;
//       _currentLongitude = position.longitude;
//       _lastLocationUpdate = DateTime.now();
//       print('📍 Location updated: $_currentLatitude, $_currentLongitude');
      
//       // Send location update if on duty
//       if (_isOnDuty && _socket != null && _isSocketConnected) {
//         _sendLocationUpdate();
//       }
//     }, onError: (error) {
//       print('⚠️ Location watch error: $error');
//     });
//   }

//   Future<void> _getInitialLocation() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         forceAndroidLocationManager: false,
//         timeLimit: const Duration(seconds: 5),
//       );
//       _currentLatitude = position.latitude;
//       _currentLongitude = position.longitude;
//       _lastLocationUpdate = DateTime.now();
//       print('✅ Initial location obtained: $_currentLatitude, $_currentLongitude');
//     } catch (e) {
//       print('⚠️ Error getting initial location: $e');
//       // Try to get last known location as fallback
//       try {
//         final lastPosition = await Geolocator.getLastKnownPosition();
//         if (lastPosition != null) {
//           _currentLatitude = lastPosition.latitude;
//           _currentLongitude = lastPosition.longitude;
//           print('📍 Using last known location: $_currentLatitude, $_currentLongitude');
//         }
//       } catch (e) {
//         print('⚠️ Could not get last known position: $e');
//       }
//     }
//   }

//   void _stopLocationWatch() {
//     if (_positionStreamSubscription != null) {
//       _positionStreamSubscription!.cancel();
//       _positionStreamSubscription = null;
//       print('⏹️ Stopped location watch');
//     }
//   }

//   void _sendLocationUpdate() {
//     if (_socket == null || !_isSocketConnected) return;

//     // Only send if location has changed significantly
//     final latDiff = (_currentLatitude - (_lastSentLatitude ?? _currentLatitude)).abs();
//     final lngDiff = (_currentLongitude - (_lastSentLongitude ?? _currentLongitude)).abs();
    
//     if (latDiff < LOCATION_CHANGE_THRESHOLD && lngDiff < LOCATION_CHANGE_THRESHOLD) {
//       return; // Skip sending if location change is too small
//     }

//     // Update last sent coordinates
//     _lastSentLatitude = _currentLatitude;
//     _lastSentLongitude = _currentLongitude;

//     // 1. General driver location update
//     final driverPayload = {
//       'latitude': _currentLatitude,
//       'longitude': _currentLongitude,
//       'role': 'Driver',
//       'vehicleType': _vehicleType,
//       'vehicleImage': _vehicleImage,
//       'fleetId': _fleetId,
//       'timestamp': DateTime.now().toIso8601String(),
//     };

//     _socket!.emit('driver:location:update', driverPayload);

//     // 2. Specific ride location update (if in a ride)
//     final rideId = _activeRideId ?? _currentRide?['orderId'] ?? _currentRide?['rideId'];
    
//     if (rideId != null) {
//       final ridePayload = {
//         'rideId': rideId,
//         'location': {
//           'latitude': _currentLatitude,
//           'longitude': _currentLongitude,
//           'lat': _currentLatitude,
//           'lng': _currentLongitude,
//           'timestamp': DateTime.now().toIso8601String(),
//           'accuracy': 0.0,
//           'speed': 0.0,
//         },
//       };

//       _socket!.emit('ride:location:update', ridePayload);
//     }
//   }

//   void _startLocationUpdates() {
//     _stopLocationUpdates();

//     print('🔄 Starting location update broadcasts every 3 seconds');

//     _locationUpdateTimer = Timer.periodic(
//       const Duration(milliseconds: LOCATION_UPDATE_INTERVAL),
//       (_) {
//         if (_socket != null && _isSocketConnected && _isOnDuty) {
//           if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
//             _sendLocationUpdate();
//           }
//         }
//       },
//     );
//   }

//   void _stopLocationUpdates() {
//     if (_locationUpdateTimer != null) {
//       _locationUpdateTimer!.cancel();
//       _locationUpdateTimer = null;
//       print('⏹️ Stopped location update broadcasts');
//     }
//   }

//   // ==================== DRIVER DATA ====================

//   Future<void> _fetchDriverData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final storedDriverData = prefs.getString('driverData');
      
//       if (storedDriverData != null) {
//         final driverData = json.decode(storedDriverData);
        
//         // Store complete driver profile data
//         _driverName = driverData['name'] ?? driverData['driverName'];
//         _driverPhone = driverData['phone'] ?? driverData['phoneNumber'];
//         _driverImage = driverData['profileImage'] ?? 
//                        driverData['image'] ?? 
//                        driverData['driverImage'];
//         _vehicleType = driverData['vehicleType'];
//         _vehicleNumber = driverData['vehicleNumber'] ?? driverData['vehicleNo'];
//         _vehicleImage = driverData['vehicleImage'];
//         _fleetId = driverData['fleetId'];
        
//         // print('✅ Driver profile loaded:', {
//         //   'name': _driverName,
//         //   'phone': _driverPhone,
//         //   'vehicleType': _vehicleType,
//         //   'vehicleNumber': _vehicleNumber,
//         // });
//       }
//     } catch (error) {
//       print('❌ Error fetching driver data: $error');
//     }
//   }

//   // ==================== HELPER METHODS ====================

//   void _showToast(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
//     );
//   }

//   void _toggleOnlineStatus() {
//     if (_isOnDuty) {
//       _goOffline();
//     } else {
//       _goOnline();
//     }
//   }

//   // ==================== UI BUILD ====================

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return _isOnDuty == false ? 
//       Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(w * .300),
//           child: Container(
//             height: w * .290,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 1,
//                   blurRadius: 2,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(w * 0.04),
//                 bottomRight: Radius.circular(w * 0.04),
//               ),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: w * 0.06,
//                           backgroundImage: const AssetImage('assets/images/home2.png'),
//                         ),
//                         SizedBox(width: w * 0.03),
//                         AppFonts.textPoppins(
//                           context,
//                           "Ayaan Malviya",
//                           w * 0.05,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.left,
//                           TextOverflow.visible,
//                         ),
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(height: w * 0.01),
//                         // Online/Offline toggle
//                         GestureDetector(
//                           onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
//                           child: Container(
//                             width: w * 0.26,
//                             height: w * 0.10,
//                             decoration: BoxDecoration(
//                               color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
//                               borderRadius: BorderRadius.circular(w * 0.06),
//                             ),
//                             alignment: Alignment.center,
//                             child: _isProcessingOnline
//                                 ? SizedBox(
//                                     width: w * 0.04,
//                                     height: w * 0.04,
//                                     child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                                   )
//                                 : Text(
//                                     _isOnDuty ? 'Online' : 'Offline',
//                                     style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
//             begin: const Offset(0.95, 0.95),
//             end: const Offset(1, 1),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Status indicators
//                 if (_hasPendingRideRequest && _newRideRequest != null)
//                   Container(
//                     margin: EdgeInsets.only(bottom: w * 0.02),
//                     padding: EdgeInsets.all(w * 0.015),
//                     decoration: BoxDecoration(
//                       color: Colors.orange[50],
//                       borderRadius: BorderRadius.circular(w * 0.02),
//                       border: Border.all(color: Colors.orange),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.local_taxi, color: Colors.orange, size: w * 0.04),
//                         SizedBox(width: w * 0.02),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('🚕 Pending Ride Request', style: TextStyle(fontSize: w * 0.03, color: Colors.orange[800]!, fontWeight: FontWeight.w600)),
//                               Text('Tap to view details', style: TextStyle(fontSize: w * 0.025, color: Colors.orange[600]!)),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.visibility, size: w * 0.04),
//                           onPressed: () {
//                             if (_newRideRequest != null) {
//                               // _showRideRequestNotification(_newRideRequest!);
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),

//                 SizedBox(height: w * 0.04),
//                 Image.asset("assets/images/offline_image.png", height: w * 0.5),
//                 Text(
//                   _isOnDuty ? "You're Online" : "You're Offline",
//                   style: TextStyle(
//                     fontSize: w * 0.05,
//                     fontWeight: FontWeight.bold,
//                     color: _isOnDuty ? Colors.green : Colors.black,
//                   ),
//                 ),
//                 Text(
//                   _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
//                   style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(height: w * 0.04),
//                 ElevatedButton(
//                   onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
//                     minimumSize: const Size(double.infinity, 45),
//                   ),
//                   child: _isProcessingOnline
//                       ? SizedBox(
//                           width: w * 0.04,
//                           height: w * 0.04,
//                           child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                         )
//                       : Text(
//                           _isOnDuty ? "Go Offline" : "Go Online",
//                           style: TextStyle(fontSize: w * 0.04, color: Colors.white),
//                         ),
//                 ),

//                 SizedBox(height: w * 0.03),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: AppFonts.textPoppins(
//                     context,
//                     "Today's Update",
//                     w * 0.038,
//                     FontWeight.w600,
//                     AppColors.black,
//                     TextAlign.left,
//                     TextOverflow.visible,
//                   ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
//                     begin: const Offset(0.95, 0.95),
//                     end: const Offset(1, 1),
//                   ),
//                 ),
//                 SizedBox(height: w * 0.04),
//                 Column(
//                   children: [
//                     HomeScreenWidgets.elevatedBox(
//                       shadowColor: const Color(0xFF4CAF50),
//                       width: double.infinity,
//                       child: const Column(
//                         children: [
//                           Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
//                           SizedBox(height: 6),
//                           Text("₹1000.00", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: w * 0.45,
//                           child: HomeScreenWidgets.elevatedBox(
//                             shadowColor: const Color(0xFFFEBC2F),
//                             child: const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Online", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                                 SizedBox(height: 4),
//                                 Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: w * 0.02),
//                         SizedBox(
//                           width: w * 0.45,
//                           child: HomeScreenWidgets.elevatedBox(
//                             shadowColor: const Color(0xFF7C7C8D),
//                             child: const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Cash", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                                 SizedBox(height: 4),
//                                 Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: w * 0.05),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           width: w * 0.45,
//                           child: HomeScreenWidgets.elevatedBox(
//                             shadowColor: const Color(0xFF439AFE),
//                             child: const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                                 SizedBox(height: 4),
//                                 Text("50 / 45 Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: w * 0.02),
//                         SizedBox(
//                           width: w * 0.45,
//                           child: HomeScreenWidgets.elevatedBox(
//                             shadowColor: const Color(0xFFF26061),
//                             child: const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                                 SizedBox(height: 4),
//                                 Text("50 / 05 Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: w * 0.04),
//               ],
//             ),
//           ),
//         ),
//       )
//     : Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               /// 1️⃣ Google Map (BOTTOM)
//               GoogleMap(
//                 initialCameraPosition: _initialCameraPosition,
//                 myLocationEnabled: false,
//                 myLocationButtonEnabled: false,
//                 zoomControlsEnabled: false,
//                 onMapCreated: (controller) {
//                   _mapController = controller;
//                 },
//                 markers: markers,
//                 circles: circles,
//               ),

//               /// 2️⃣ Book Ride Button (Top Right)
//               Positioned(
//                 top: 16,
//                 right: 16,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Get.to(() => const BookRide());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.cyan,
//                     elevation: 4,
//                     shape: const StadiumBorder(),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 10,
//                     ),
//                   ),
//                   child: const Text(
//                     "Book Ride",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),

//               /// 3️⃣ Bottom Offline Card (FIRST)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: _bottomOfflineCard(),
//               ),
//             ],
//           ),
//         ),
//       );
//   }

//   Widget _bottomOfflineCard() {
//     double w = MediaQuery.of(context).size.width;
//     return Container(
//       margin: EdgeInsets.only(top: 200),
//       padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// Driver & Earnings
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               HomeScreenWidgets.topAction(
//                 icon: _selectedTab == "Driver"
//                     ? "assets/icons/drive.png"
//                     : "assets/icons/driveoff.svg",
//                 label: "Driver",
//                 onTap: () {
//                   setState(() {
//                     _selectedTab = "Driver";
//                   });
//                 },
//                 isSelected: _selectedTab == "Driver",
//               ),
//               SizedBox(width: w * 0.25),
//               HomeScreenWidgets.topAction(
//                 icon: _selectedTab == "Earnings"
//                     ? "assets/icons/dolleron.svg"
//                     : "assets/icons/doller.png",
//                 label: "Earnings",
//                 onTap: () {
//                   setState(() {
//                     _selectedTab = "Earnings";
//                   });
//                 },
//                 isSelected: _selectedTab == "Earnings",
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           /// Conditional Content
//           if (_selectedTab == "Driver")
//             _driverContent()
//           else
//             _earningsContent(),
//         ],
//       )
//     );
//   }

//   Widget _driverContent() {
//     return Column(
//       children: [
//         /// Offline Image
//         Image.asset("assets/images/onlinee.png", height: 120),

//         const SizedBox(height: 12),

//         const Text(
//           "You're Online",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),

//         const SizedBox(height: 6),

//         const Text(
//           "Go offline to stop accepting rides.",
//           style: TextStyle(color: Colors.grey),
//           textAlign: TextAlign.center,
//         ),

//         const SizedBox(height: 16),

//         /// Go Online Button (Bottom)
//         SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: () {
//               _goOffline();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text(
//               "Go Offline",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Earnings Content
//   Widget _earningsContent() {
//     double w = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: AppFonts.textPoppins(
//             context,
//             "Today's Update",
//             w * 0.038,
//             FontWeight.w600,
//             AppColors.black,
//             TextAlign.left,
//             TextOverflow.visible,
//           ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
//             begin: const Offset(0.95, 0.95),
//             end: const Offset(1, 1),
//           ),
//         ),
//         SizedBox(height: w * 0.02),

//         Column(
//           children: [
//             /// Today's Earnings (Full Width)
//             HomeScreenWidgets.elevatedBox(
//               width: double.infinity,
//               shadowColor: const Color(0xFF4CAF50),
//               child: Column(
//                 children: const [
//                   Text(
//                     "Today's Earnings",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   SizedBox(height: 1),
//                   Text(
//                     "₹1000.00",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: w * 0.02),

//             /// Online & Cash
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: w * 0.4,
//                   child: HomeScreenWidgets.elevatedBox(
//                     shadowColor: const Color(0xFFFEBC2F),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Online",
//                           style: TextStyle(fontSize: 13, color: Colors.grey),
//                         ),
//                         SizedBox(height: 1),
//                         Text(
//                           "₹500 Total",
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: w * 0.01),
//                 SizedBox(
//                   width: w * 0.45,
//                   child: HomeScreenWidgets.elevatedBox(
//                     shadowColor: const Color(0xFF7C7C8D),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Cash",
//                           style: TextStyle(fontSize: 13, color: Colors.grey),
//                         ),
//                         SizedBox(height: 1),
//                         Text(
//                           "₹500 On Hand",
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: w * 0.02),

//             /// Ride Stats
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: w * 0.4,
//                   child: HomeScreenWidgets.elevatedBox(
//                     shadowColor: const Color(0xFF439AFE),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Total Rides",
//                           style: TextStyle(fontSize: 13, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 1),
//                         RichText(
//                           text: const TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "50",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: " / 45 Completed",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: w * 0.02),
//                 SizedBox(
//                   width: w * 0.45,
//                   child: HomeScreenWidgets.elevatedBox(
//                     shadowColor: const Color(0xFFF26061),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Total Rides",
//                           style: TextStyle(fontSize: 13, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 1),
//                         RichText(
//                           text: const TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: "50",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: " / 45 Completed",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // ==================== ASSET LOADING METHODS ====================

//   Future<void> _loadCustomBikeMarker() async {
//     try {
//       _bikeMarkerIcon = await MapHelper.loadCustomIcon(
//         assetPath: 'assets/images/bike2.png',
//         width: 80,
//         height: 80,
//       );
//       print('✅ Custom bike marker icon loaded');
//     } catch (e) {
//       print('❌ Error loading custom bike marker: $e');
//       _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//     }
//   }

//   Future<void> _loadVehicleIcons() async {
//     try {
//       _vehicleIcons = await MapHelper.loadVehicleIcons(
//         iconSize: 70,
//       );
//       print('✅ Vehicle icons loaded');
//     } catch (e) {
//       print('❌ Error loading vehicle icons: $e');
//     }
//   }

//   void _removeBikeMarkerAndCircle() {
//     setState(() {
//       markers.clear();
//       circles.clear();
//     });
//     print('✅ Bike marker and circle removed');
//   }
// }