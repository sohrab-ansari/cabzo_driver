
// import 'dart:async';
// import 'package:corezap_driver/apiervices/services/driver_socket_service.dart';
// import 'package:corezap_driver/controllers/controllers.dart';
// import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/views/home_related/live_ride.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';

// // Import the new DriverSocketService
// // import 'package:corezap_driver/services/driver_socket_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
//   Controllers controllers = Get.put(Controllers());
//   final HomeController homeController = Get.find<HomeController>();
//   final StepperController stepperController = Get.find<StepperController>();
  
//   // Use the new DriverSocketService
//   final DriverSocketService _socketService = DriverSocketService();
  
//   // Socket state
//   bool _isSocketConnected = false;
//   bool _isOnDuty = false;
//   bool _isProcessingOnline = false;
//   String _socketStatus = 'Not Connected';
//   String _socketId = '';
  
//   // App lifecycle state
//   AppLifecycleState? _appLifecycleState;
//   bool _appInBackground = false;
//   DateTime? _appBackgroundTime;
  
//   // Location variables
//   double? _currentLatitude;
//   double? _currentLongitude;
//   String _vehicleType = 'Car';
//   String? _vehicleImage;
//   String? _fleetId;
  
//   // Driver data
//   String _driverId = '';
//   String? _token;
//   String? _userId;
  
//   // Ride variables
//   Map<String, dynamic>? _newRideRequest;
//   bool _hasPendingRideRequest = false;
//   Timer? _rideRequestTimer;
  
//   // Reconnection tracking
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;
//   Timer? _backgroundReconnectTimer;

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
    
//     // Disconnect socket service
//     _socketService.disconnect();
    
//     super.dispose();
//   }
  
//   void _cleanupResources() {
//     // Clear all timers
//     _clearRideRequestTimer();
//     _stopBackgroundReconnectTimer();
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
//       _socketService.setAppReady(true);
      
//       // Check connection status
//       final status = _socketService.getConnectionStatus();
//       final isConnected = status['isConnected'] ?? false;
//       final isOnDuty = status['isOnDuty'] ?? false;
      
//       if (isConnected && isOnDuty) {
//         print('✅ Socket still connected, resuming operations...');
//       } else if (isOnDuty) {
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
    
//     // Wait for token to load
//     await gettoken();
    
//     // Setup socket event listeners
//     _setupSocketListeners();
    
//     // Then connect socket with valid token
//     if (_token != null && _driverId.isNotEmpty) {
//       await _connectSocket();
//     } else {
//       print('❌ Cannot connect: Token or Driver ID is missing');
//       _showToast('Failed to load credentials');
//     }
//   }

//   Future<void> _requestPermissions() async {
//     try {
//       // Request location permission
//       final locationStatus = await Permission.location.request();
//       if (locationStatus.isGranted) {
//         print('✅ Location permission granted');
//       } else {
//         print('⚠️ Location permission not granted: $locationStatus');
//       }
      
//       // Request notification permission (if needed)
//       final notificationStatus = await Permission.notification.request();
//       if (notificationStatus.isGranted) {
//         print('✅ Notification permission granted');
//       }
      
//       // Mark app as ready
//       _socketService.setAppReady(true);
      
//     } catch (error) {
//       print('❌ Error requesting permissions: $error');
//     }
//   }

//   Future<void> gettoken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString("auth_token");
//       final String? userId = prefs.getString("driver_userid");

//       setState(() {
//         _token = token;
//         _userId = userId;
//         _driverId = userId.toString();
//       });

//       print('✅ Token loaded from SharedPreferences');
//       print('User ID: $_userId');
//       print("myyyy_tokenn>>> ${_token?.substring(0, _token!.length > 20 ? 20 : _token!.length)}...");
//       print("myyyy_driverid>>> ${_driverId}");

//     } catch (e) {
//       print('❌ Error loading token: $e');
//     }
//   }

//   Future<void> _connectSocket() async {
//     print("🔄 Starting socket connection via DriverSocketService...");
    
//     try {
//       final connected = await _socketService.connect();
      
//       if (connected) {
//         print('✅ Socket connection successful');
//         // Connection status will be updated via event listeners
//       } else {
//         print('❌ Socket connection failed');
//         setState(() {
//           _socketStatus = 'Connection Failed';
//         });
        
//         // Try reconnection
//         if (_reconnectAttempts < _maxReconnectAttempts) {
//           _reconnectAttempts++;
//           print('🔄 Retrying connection...');
//           Future.delayed(Duration(seconds: _reconnectAttempts * 2), () {
//             if (mounted && !_isSocketConnected) {
//               _connectSocket();
//             }
//           });
//         }
//       }
//     } catch (error) {
//       print('❌ Socket connection error: $error');
//       setState(() {
//         _socketStatus = 'Connection Error: $error';
//       });
//     }
//   }

//   void _setupSocketListeners() {
//     // ==================== CONNECTION EVENTS ====================
//     _socketService.addEventListener('socket:connected', (data) {
//       print('✅✅✅ DRIVER SOCKET CONNECTED: ${data['socketId']}');
//       setState(() {
//         _isSocketConnected = true;
//         _socketStatus = 'Connected';
//         _socketId = data['socketId'] ?? '';
//         _reconnectAttempts = 0;
//       });
      
//       // If we were online before, restore status
//       if (_isOnDuty) {
//         print('🔄 Restoring online status after connection...');
//         Future.delayed(const Duration(seconds: 1), () {
//           _restoreOnlineStatus();
//         });
//       }
//     });

//     _socketService.addEventListener('socket:disconnected', (data) {
//       print('❌ Driver socket disconnected: ${data['reason']}');
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnected';
//       });
      
//       // Clear pending ride request
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

//     _socketService.addEventListener('socket:error', (data) {
//       print('❌ Socket error: ${data['error']}');
//       _reconnectAttempts++;
//       setState(() {
//         _socketStatus = 'Connection Error';
//       });
//     });

//     _socketService.addEventListener('socket:reconnected', (data) {
//       print('🔄 Socket reconnected after ${data['attemptNumber']} attempts');
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

//     // ==================== DRIVER STATUS EVENTS ====================
//     _socketService.addEventListener('driver:online:success', (data) {
//       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
//       _handleOnlineSuccess(data);
//     });

//     _socketService.addEventListener('driver:online:failed', (data) {
//       print('❌❌❌ DRIVER ONLINE FAILED: $data');
//       _handleOnlineFailure(data);
//     });

//     _socketService.addEventListener('driver:offline', (data) {
//       print('🔴 Driver offline confirmed: ${data['message']}');
//       setState(() {
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });
//     });

//     // ==================== RIDE REQUEST EVENTS ====================
//     _socketService.addEventListener('ride:newRequest', (data) {
//       print('🚕🚕🚕 NEW RIDE REQUEST RECEIVED 🚕🚕🚕');
      
//       // Check if we're online and can accept rides
//       if (!_isOnDuty) {
//         print('⚠️ Received ride request but driver is offline');
//         return;
//       }
      
//       // Process the ride request
//       _processRideRequest(data);
//     });

//     _socketService.addEventListener('ride:acceptedConfirmed', (data) async {
//        final prefs = await SharedPreferences.getInstance();
//       print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
// await prefs.setString("order_id", data['orderId']);

//       // Navigate to ride screen
//       _navigateToRideScreen(data);
//     });

//     _socketService.addEventListener('ride:status', (data) {
//       print('📊 Ride status update: ${data['status']}');
//       // Handle ride status updates
//     });

//     _socketService.addEventListener('ride:cancelled', (data) {
//       print('❌ Ride cancelled: ${data['orderId']}');
//       _clearPendingRideRequest();
//       _showToast('Ride cancelled');
//     });

//     _socketService.addEventListener('ride:completed', (data) {
//       print('✅ Ride completed: ${data['rideId']}');
//       _showToast('Ride completed successfully');
//     });

//     // ==================== LOCATION EVENTS ====================
//     _socketService.addEventListener('ride:location', (data) {
//       print('📍 Rider location during ride: ${data['location']}');
//     });

//     // ==================== CHAT EVENTS (optional) ====================
//     _socketService.addEventListener('chat:message', (data) {
//       print('💬 Chat message received: ${data['message']}');
//     });
//   }

//   void _processRideRequest(Map<String, dynamic> rideData) {
//     print('🚕 Processing ride request...');
    
//     try {
//       // Extract and print key information
//       print('\n📋 KEY RIDE INFORMATION:');
//       print('├─ Order ID: ${rideData['orderId']}');
//       print('├─ Rider Name: ${rideData['riderName']}');
//       print('├─ Rider Phone: ${rideData['riderNumber']}');
//       print('├─ Pickup Address: ${rideData['startLocation']?['address']}');
//       print('├─ Destination: ${rideData['endLocation']?['address']}');
//       print('├─ Total Fare: ₹${rideData['totalFare']}');
//       print('├─ Distance: ${rideData['distance']} km');
      
//       // Store the new ride request
//       setState(() {
//         _newRideRequest = rideData;
//         _hasPendingRideRequest = true;
//       });

//       // Navigate to LiveRide screen
//       Future.delayed(const Duration(seconds: 1), () {
//         if (mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => LiveRide(rideData: rideData),
//             ),
//           );
//         }
//       });

//       // Auto-reject timer
//       final timeoutSeconds = rideData['timeout']?.toDouble() ?? 30.0;
//       _startRideRequestTimer(rideData['orderId'], timeoutSeconds);

//       print('✅ New ride request stored');
//       print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');
//     } catch (error) {
//       print('❌ Error processing ride request: $error');
//     }
//   }

//   void _navigateToRideScreen(Map<String, dynamic> rideData) {
//     // Clear pending request
//     _clearPendingRideRequest();
    
//     // Navigate to ride screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LiveRide(rideData: rideData),
//       ),
//     );
//   }

//   // ==================== RIDE REQUEST TIMER ====================
//   void _startRideRequestTimer(String orderId, double timeoutSeconds) {
//     _clearRideRequestTimer();
    
//     final seconds = timeoutSeconds.toInt();
    
//     _rideRequestTimer = Timer(Duration(seconds: seconds), () {
//       if (_hasPendingRideRequest && _newRideRequest != null) {
//         print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
//         _socketService.declineRide(orderId, reason: 'timeout');
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
//     final status = _socketService.getConnectionStatus();
//     if (!(status['isConnected'] ?? false)) {
//       print('🔄 Background: Socket disconnected, attempting reconnect...');
//       _socketService.connect();
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
          
//           final status = _socketService.getConnectionStatus();
//           if (status['isConnected'] ?? false) {
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
//     final status = _socketService.getConnectionStatus();
//     if (!(status['isConnected'] ?? false)) return;
    
//     print('🔄 Restoring driver online status...');
    
//     try {
//       // Get current location
//       final location = await _getCurrentLocation();
      
//       // Go online
//       await _socketService.goOnline();
      
//       print('✅ Online status restored');
      
//     } catch (error) {
//       print('❌ Error restoring online status: $error');
//     }
//   }

//   // ==================== DRIVER ONLINE/OFFLINE ====================
//   Future<void> _goOnline() async {
//     print('🟢 ============ GOING ONLINE PROCESS ============');

//     if (_isProcessingOnline) {
//       print('⏳ Already processing online request...');
//       return;
//     }

//     setState(() {
//       _isProcessingOnline = true;
//     });

//     // First, ensure socket is connected
//     final status = _socketService.getConnectionStatus();
//     if (!(status['isConnected'] ?? false)) {
//       print('⚠️ Socket not connected, connecting first...');
//       await _connectSocket();

//       // Wait a bit for connection
//       await Future.delayed(const Duration(seconds: 2));

//       final newStatus = _socketService.getConnectionStatus();
//       if (!(newStatus['isConnected'] ?? false)) {
//         setState(() {
//           _isProcessingOnline = false;
//         });
//         _showToast('Cannot connect to server');
//         return;
//       }
//     }

//     // Now go online
//     print('🚀 Going online via DriverSocketService...');
//     final success = await _socketService.goOnline();

//     if (success) {
//       print('✅ Go online request sent');
//       // Actual success will be handled by event listener
//     } else {
//       print('❌ Failed to send go online request');
//       _handleOnlineFailure('Failed to send request');
//     }

//     print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
//   }

//   void _handleOnlineSuccess(dynamic data) {
//     if (!_isProcessingOnline) return;

//     print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

//     setState(() {
//       _isOnDuty = true;
//       _isProcessingOnline = false;
//     });

//     // Extract success message
//     String successMessage = 'Driver is now online';
//     if (data is Map<String, dynamic>) {
//       successMessage = data['message'] ?? successMessage;
//     }

//     _showToast(successMessage);
//   }

//   void _handleOnlineFailure(dynamic data) {
//     if (!_isProcessingOnline) return;

//     print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

//     setState(() {
//       _isOnDuty = false;
//       _isProcessingOnline = false;
//     });

//     // Extract error message
//     String errorMessage = 'Failed to go online';
//     if (data is String) {
//       errorMessage = data;
//     } else if (data is Map<String, dynamic>) {
//       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
//     }

//     _showToast(errorMessage);
//   }

//   Future<void> _goOffline() async {
//     try {
//       print('🔴 Going offline via DriverSocketService...');
//       await _socketService.goOffline();
      
//       setState(() {
//         _isOnDuty = false;
//       });

//       // Clear pending ride request
//       _clearPendingRideRequest();

//       print('✅ Driver is now offline');
//       _showToast('Driver is now offline');
//     } catch (error) {
//       print('❌ Error going offline: $error');
//       _showToast('Error going offline: $error');
//     }
//   }

//   // ==================== LOCATION METHODS ====================
//   // Future<Map<String, double>> _getCurrentLocation() async {
//   //   try {
//   //     final coordinates = _socketService.getCurrentCoordinates();
//   //     setState(() {
//   //       _currentLatitude = coordinates['latitude'];
//   //       _currentLongitude = coordinates['longitude'];
//   //     });
      
//   //     print('✅ Got current location: $_currentLatitude, $_currentLongitude');
//   //     return coordinates;
//   //   } catch (e) {
//   //     print('❌ Error getting location: $e');
//   //     return {'latitude': 23.2508438, 'longitude': 77.4647827};
//   //   }
//   // }

//   // ==================== LOCATION METHODS ====================
// Future<Map<String, dynamic>> _getCurrentLocation() async {
//   try {
//     final coordinates = _socketService.getCurrentCoordinates();
//     setState(() {
//       _currentLatitude = coordinates['latitude'] as double? ?? 0.0;
//       _currentLongitude = coordinates['longitude'] as double? ?? 0.0;
//     });
    
//     print('✅ Got current location: $_currentLatitude, $_currentLongitude');
//     return coordinates;
//   } catch (e) {
//     print('❌ Error getting location: $e');
//     return {'latitude': 23.2508438, 'longitude': 77.4647827};
//   }
// }

//   // ==================== NOTIFICATIONS ====================
//   void _showRideRequestNotification(Map<String, dynamic> rideData) {
//     if (!mounted) return;

//     // Extract data
//     final riderName = rideData['riderName']?.toString() ?? 'Customer';
//     final riderPhone = rideData['riderNumber']?.toString() ?? '';
//     final distance = rideData['distance']?.toString() ?? '0';
//     final fare = rideData['totalFare']?.toString() ?? '0';
//     final pickup = rideData['startLocation']?['address']?.toString() ?? 'Location not specified';
//     final destination = rideData['endLocation']?['address']?.toString() ?? 'Destination not specified';
//     final orderId = rideData['orderId']?.toString() ?? '';

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Icons.local_taxi, color: Colors.green),
//             SizedBox(width: 10),
//             Text('🚕 New Ride Request'),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 leading: CircleAvatar(
//                   child: Text(riderName.substring(0, 1).toUpperCase()),
//                 ),
//                 title: Text(riderName, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(riderPhone),
//               ),
//               const Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Fare', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       Text('₹$fare', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Distance', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       Text('$distance km', style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.location_on, color: Colors.green, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                         Text(pickup, style: const TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.location_on, color: Colors.red, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                         Text(destination, style: const TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               if (orderId.isNotEmpty) {
//                 _socketService.declineRide(orderId);
//                 _showToast('Ride rejected');
//                 _clearPendingRideRequest();
//               }
//             },
//             child: const Text('Reject', style: TextStyle(color: Colors.red)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               if (orderId.isNotEmpty) {
//                 _socketService.acceptRide(rideData);
//                 print('✅ Ride accepted: $orderId');
//                 _showToast('Ride accepted!');
//                 _clearPendingRideRequest();
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: const Text('Accept'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showToast(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
//     );
//   }

//   // ==================== UTILITY METHODS ====================
//   void _toggleConnection() {
//     final status = _socketService.getConnectionStatus();
//     if (status['isConnected'] ?? false) {
//       _socketService.disconnect();
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnecting...';
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });
//       _showToast('Socket disconnected');
//     } else {
//       _connectSocket();
//       _showToast('Connecting socket...');
//     }
//   }

//   void _toggleOnlineStatus() {
//     if (_isOnDuty) {
//       _goOffline();
//     } else {
//       _goOnline();
//     }
//   }

//   // Helper methods for connection status
//   Color _getConnectionColor() {
//     if (!_isSocketConnected) return Colors.red;
//     if (_appInBackground) return Colors.orange;
//     return Colors.green;
//   }

//   IconData _getConnectionIcon() {
//     if (!_isSocketConnected) return Icons.signal_wifi_off;
//     if (_appInBackground) return Icons.phone_android;
//     return Icons.signal_wifi_4_bar;
//   }

//   String _getConnectionText() {
//     if (!_isSocketConnected) return 'Offline';
//     if (_appInBackground) return 'Background';
//     if (!_isOnDuty) return 'Online (Idle)';
//     return 'Online';
//   }

//   // ==================== UI BUILD ====================
//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(w * .300),
//         child: Container(
//           height: w * .290,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 2,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(w * 0.04),
//               bottomRight: Radius.circular(w * 0.04),
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: w * 0.06,
//                         backgroundImage: const AssetImage('assets/images/home2.png'),
//                       ),
//                       SizedBox(width: w * 0.03),
//                       AppFonts.textPoppins(
//                         context,
//                         "Ayaan Malviya",
//                         w * 0.05,
//                         FontWeight.w600,
//                         AppColors.black,
//                         TextAlign.left,
//                         TextOverflow.visible,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Connection status indicator
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: _getConnectionColor(),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(_getConnectionIcon(), size: 12, color: Colors.white),
//                             const SizedBox(width: 4),
//                             Text(
//                               _getConnectionText(),
//                               style: const TextStyle(color: Colors.white, fontSize: 10),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: w * 0.01),
//                       // Online/Offline toggle
//                       GestureDetector(
//                         onTap: _isProcessingOnline ? null : _toggleOnlineStatus,
//                         child: Container(
//                           width: w * 0.26,
//                           height: w * 0.10,
//                           decoration: BoxDecoration(
//                             color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
//                             borderRadius: BorderRadius.circular(w * 0.06),
//                           ),
//                           alignment: Alignment.center,
//                           child: _isProcessingOnline
//                               ? SizedBox(
//                                   width: w * 0.04,
//                                   height: w * 0.04,
//                                   child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                                 )
//                               : Text(
//                                   _isOnDuty ? 'Online' : 'Offline',
//                                   style: TextStyle(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.w600),
//                                 ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ).animate().fade(duration: 800.ms, curve: Curves.easeInOut).scale(
//           begin: const Offset(0.95, 0.95),
//           end: const Offset(1, 1),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Status indicators
//               if (_hasPendingRideRequest && _newRideRequest != null)
//                 Container(
//                   margin: EdgeInsets.only(bottom: w * 0.02),
//                   padding: EdgeInsets.all(w * 0.015),
//                   decoration: BoxDecoration(
//                     color: Colors.orange[50],
//                     borderRadius: BorderRadius.circular(w * 0.02),
//                     border: Border.all(color: Colors.orange),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.local_taxi, color: Colors.orange, size: w * 0.04),
//                       SizedBox(width: w * 0.02),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('🚕 Pending Ride Request', style: TextStyle(fontSize: w * 0.03, color: Colors.orange[800]!, fontWeight: FontWeight.w600)),
//                             Text('Tap to view details', style: TextStyle(fontSize: w * 0.025, color: Colors.orange[600]!)),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.visibility, size: w * 0.04),
//                         onPressed: () {
//                           if (_newRideRequest != null) {
//                             _showRideRequestNotification(_newRideRequest!);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//               // if (_isOnDuty)
//               //   Container(
//               //     margin: EdgeInsets.only(bottom: w * 0.02),
//               //     padding: EdgeInsets.all(w * 0.015),
//               //     decoration: BoxDecoration(
//               //       color: Colors.blue[50],
//               //       borderRadius: BorderRadius.circular(w * 0.02),
//               //       border: Border.all(color: Colors.blue),
//               //     ),
//               //     child: Row(
//               //       mainAxisAlignment: MainAxisAlignment.center,
//               //       children: [
//               //         Icon(Icons.location_on, size: w * 0.04, color: Colors.blue),
//               //         SizedBox(width: w * 0.02),
//               //         const Column(
//               //           crossAxisAlignment: CrossAxisAlignment.start,
//               //           children: [
//               //             Text('📍 Location Updates Active', style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w600)),
//               //             Text('Sending every 3 seconds', style: TextStyle(fontSize: 12, color: Colors.blue)),
//               //           ],
//               //         ),
//               //       ],
//               //     ),
//               //   ),

//               SizedBox(height: w * 0.04),
//               Image.asset("assets/images/offline_image.png"),
//               Text(
//                 _isOnDuty ? "You're Online" : "You're Offline",
//                 style: TextStyle(
//                   fontSize: w * 0.05,
//                   fontWeight: FontWeight.bold,
//                   color: _isOnDuty ? Colors.green : Colors.black,
//                 ),
//               ),
//               Text(
//                 _isOnDuty ? "Ready to accept rides!" : "Go online to start accepting rides.",
//                 style: const TextStyle(color: Color(0xFF5F6165), fontWeight: FontWeight.w500),
//               ),
//               SizedBox(height: w * 0.04),
//               ElevatedButton(
//                 onPressed: _isProcessingOnline ? null : _toggleOnlineStatus,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: _isProcessingOnline
//                     ? SizedBox(
//                         width: w * 0.04,
//                         height: w * 0.04,
//                         child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                       )
//                     : Text(
//                         _isOnDuty ? "Go Offline" : "Go Online",
//                         style: TextStyle(fontSize: w * 0.04, color: Colors.white),
//                       ),
//               ),

//               // Debug button
//               SizedBox(height: w * 0.02),
//               TextButton(
//                 onPressed: () {
//                   final status = _socketService.getConnectionStatus();
//                   print('🔧 Debug Info:');
//                   print('  Socket Connected: ${status['isConnected']}');
//                   print('  On Duty: ${status['isOnDuty']}');
//                   print('  Socket ID: ${status['socketId']}');
//                   print('  Driver ID: ${status['driverId']}');
//                   print('  Ride In Progress: ${status['rideInProgress']}');
//                   print('  App in Background: $_appInBackground');
//                 },
//                 child: Text('Debug Info', style: TextStyle(fontSize: w * 0.03, color: Colors.blue)),
//               ),

//               SizedBox(height: w * 0.05),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: AppFonts.textPoppins(
//                   context,
//                   "Today's Update",
//                   w * 0.038,
//                   FontWeight.w600,
//                   AppColors.black,
//                   TextAlign.left,
//                   TextOverflow.visible,
//                 ).animate().fade(duration: 820.ms, curve: Curves.easeInOut).scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//               ),
//               SizedBox(height: w * 0.04),
//               Column(
//                 children: [
//                   _elevatedBox(
//                     shadowColor: const Color(0xFF4CAF50),
//                     width: double.infinity,
//                     child: const Column(
//                       children: [
//                         Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
//                         SizedBox(height: 6),
//                         Text("₹1000.00", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFFEBC2F),
//                           child: const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Online", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                               SizedBox(height: 4),
//                               Text("₹500 Total", style: TextStyle(fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF7C7C8D),
//                           child: const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Cash", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                               SizedBox(height: 4),
//                               Text("₹500 On Hand", style: TextStyle(fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: w * 0.05),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF439AFE),
//                           child: const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                               SizedBox(height: 4),
//                               Text("50 / 45 Completed", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFF26061),
//                           child: const Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Total Rides", style: TextStyle(fontSize: 13, color: Color(0xFF414142))),
//                               SizedBox(height: 4),
//                               Text("50 / 05 Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: w * 0.04),
//             ],
//           ),
//         ),
//       ),


//       // floatingActionButton: Column(
//       //   mainAxisAlignment: MainAxisAlignment.end,
//       //   children: [
//       //     FloatingActionButton.small(
//       //       onPressed: _toggleConnection,
//       //       backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
//       //       child: Icon(_isSocketConnected ? Icons.link : Icons.link_off, size: w * 0.04),
//       //     ),
//       //     SizedBox(height: w * 0.01),
//       //     if (_hasPendingRideRequest)
//       //       FloatingActionButton.extended(
//       //         onPressed: () {
//       //           if (_newRideRequest != null) {
//       //             _showRideRequestNotification(_newRideRequest!);
//       //           }
//       //         },
//       //         backgroundColor: Colors.orange,
//       //         icon: Icon(Icons.local_taxi, size: w * 0.04),
//       //         label: Text('View Ride', style: TextStyle(fontSize: w * 0.03)),
//       //       ),
//       //   ],
//       // ),
    
    
//     );
//   }

//   Widget _elevatedBox({
//     required Widget child,
//     double? height,
//     double? width,
//     Color? shadowColor,
//   }) {
//     final Color shadow = shadowColor ?? Colors.black12;
//     return Container(
//       height: height,
//       width: width,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2))],
//       ),
//       child: child,
//     );
//   }
// }


import 'dart:async';
import 'package:corezap_driver/apiervices/services/driver_socket_service.dart';
import 'package:corezap_driver/controllers/controllers.dart';
import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
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
    
    // Wait for token to load
    await gettoken();
    
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

  Future<void> _connectSocket() async {
    print("🔄 Starting socket connection via DriverSocketService...");
    
    try {
      final connected = await _socketService.connect();
      
      if (connected) {
        print('✅ Socket connection successful');
        // Connection status will be updated via event listeners
      } else {
        print('❌ Socket connection failed');
        setState(() {
          _socketStatus = 'Connection Failed';
        });
        
        // Try reconnection
        if (_reconnectAttempts < _maxReconnectAttempts) {
          _reconnectAttempts++;
          print('🔄 Retrying connection...');
          Future.delayed(Duration(seconds: _reconnectAttempts * 2), () {
            if (mounted && !_isSocketConnected) {
              _connectSocket();
            }
          });
        }
      }
    } catch (error) {
      print('❌ Socket connection error: $error');
      setState(() {
        _socketStatus = 'Connection Error: $error';
      });
    }
  }

  void _setupSocketListeners() {
    // ==================== CONNECTION EVENTS ====================
    _socketService.addEventListener('socket:connected', (data) {
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
          _restoreOnlineStatus();
        });
      }
    });

    _socketService.addEventListener('socket:disconnected', (data) {
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
      print('❌ Socket error: ${data['error']}');
      _reconnectAttempts++;
      setState(() {
        _socketStatus = 'Connection Error';
      });
    });

    _socketService.addEventListener('socket:reconnected', (data) {
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
      print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
      _handleOnlineSuccess(data);
    });

    _socketService.addEventListener('driver:online:failed', (data) {
      print('❌❌❌ DRIVER ONLINE FAILED: $data');
      _handleOnlineFailure(data);
    });

    _socketService.addEventListener('driver:offline', (data) {
      print('🔴 Driver offline confirmed: ${data['message']}');
      setState(() {
        _isOnDuty = false;
        _isProcessingOnline = false;
      });
    });

    // ==================== RIDE REQUEST EVENTS ====================
    _socketService.addEventListener('ride:newRequest', (data) {
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
      final prefs = await SharedPreferences.getInstance();
      print('✅ Ride accepted - Backend confirmed: ${data['orderId']}');
      await prefs.setString("order_id", data['orderId']);

      // Navigate to ride screen
      _navigateToRideScreen(data);
    });

    _socketService.addEventListener('ride:status', (data) {
      print('📊 Ride status update: ${data['status']}');
      // Handle ride status updates
    });

    _socketService.addEventListener('ride:cancelled', (data) {
      print('❌ Ride cancelled: ${data['orderId']}');
      _clearPendingRideRequest();
      _showToast('Ride cancelled');
    });

    _socketService.addEventListener('ride:completed', (data) {
      print('✅ Ride completed: ${data['rideId']}');
      _showToast('Ride completed successfully');
    });

    // ==================== LOCATION EVENTS ====================
    _socketService.addEventListener('ride:location', (data) {
      print('📍 Rider location during ride: ${data['location']}');
    });

    // ==================== CHAT EVENTS (optional) ====================
    _socketService.addEventListener('chat:message', (data) {
      print('💬 Chat message received: ${data['message']}');
    });
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
    print('🟢 ============ GOING ONLINE PROCESS ============');

    if (_isProcessingOnline) {
      print('⏳ Already processing online request...');
      return;
    }

    setState(() {
      _isProcessingOnline = true;
    });

    // First, ensure socket is connected
    final status = _socketService.getConnectionStatus();
    if (!(status['isConnected'] ?? false)) {
      print('⚠️ Socket not connected, connecting first...');
      await _connectSocket();

      // Wait a bit for connection
      await Future.delayed(const Duration(seconds: 2));

      final newStatus = _socketService.getConnectionStatus();
      if (!(newStatus['isConnected'] ?? false)) {
        setState(() {
          _isProcessingOnline = false;
        });
        _showToast('Cannot connect to server');
        return;
      }
    }

    // Now go online
    print('🚀 Going online via DriverSocketService...');
    final success = await _socketService.goOnline();

    if (success) {
      print('✅ Go online request sent');
      // Actual success will be handled by event listener
    } else {
      print('❌ Failed to send go online request');
      _handleOnlineFailure('Failed to send request');
    }

    print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
  }

  void _handleOnlineSuccess(dynamic data) {
    if (!_isProcessingOnline) return;

    print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

    setState(() {
      _isOnDuty = true;
      _isProcessingOnline = false;
    });

    // Extract success message
    String successMessage = 'Driver is now online';
    if (data is Map<String, dynamic>) {
      successMessage = data['message'] ?? successMessage;
    }

    _showToast(successMessage);
  }

  void _handleOnlineFailure(dynamic data) {
    if (!_isProcessingOnline) return;

    print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

    setState(() {
      _isOnDuty = false;
      _isProcessingOnline = false;
    });

    // Extract error message
    String errorMessage = 'Failed to go online';
    if (data is String) {
      errorMessage = data;
    } else if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ?? data['error'] ?? errorMessage;
    }

    _showToast(errorMessage);
  }

  Future<void> _goOffline() async {
    try {
      print('🔴 Going offline via DriverSocketService...');
      await _socketService.goOffline();
      
      setState(() {
        _isOnDuty = false;
      });

      // Clear pending ride request
      _clearPendingRideRequest();

      print('✅ Driver is now offline');
      _showToast('Driver is now offline');
    } catch (error) {
      print('❌ Error going offline: $error');
      _showToast('Error going offline: $error');
    }
  }

  // ==================== LOCATION METHODS ====================
  Future<Map<String, dynamic>> _getCurrentLocation() async {
    try {
      final coordinates = _socketService.getCurrentCoordinates();
      setState(() {
        _currentLatitude = coordinates['latitude'] as double? ?? 0.0;
        _currentLongitude = coordinates['longitude'] as double? ?? 0.0;
      });
      
      print('✅ Got current location: $_currentLatitude, $_currentLongitude');
      return coordinates;
    } catch (e) {
      print('❌ Error getting location: $e');
      return {'latitude': 23.2508438, 'longitude': 77.4647827};
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

    return Scaffold(
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
              Image.asset("assets/images/offline_image.png"),
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
                  backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
                  minimumSize: const Size(double.infinity, 50),
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
              SizedBox(height: w * 0.02),
              TextButton(
                onPressed: () {
                  final status = _socketService.getConnectionStatus();
                  print('🔧 Debug Info:');
                  print('  Socket Connected: ${status['isConnected']}');
                  print('  On Duty: ${status['isOnDuty']}');
                  print('  Socket ID: ${status['socketId']}');
                  print('  Driver ID: ${status['driverId']}');
                  print('  Ride In Progress: ${status['rideInProgress']}');
                  print('  App in Background: $_appInBackground');
                },
                child: Text('Debug Info', style: TextStyle(fontSize: w * 0.03, color: Colors.blue)),
              ),

              SizedBox(height: w * 0.05),
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
                  _elevatedBox(
                    shadowColor: const Color(0xFF4CAF50),
                    width: double.infinity,
                    child: const Column(
                      children: [
                        Text("Today's Earnings", style: TextStyle(fontSize: 14, color: Color(0xFF414142))),
                        SizedBox(height: 6),
                        Text("₹1000.00", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
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
                        child: _elevatedBox(
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
                        child: _elevatedBox(
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
                        child: _elevatedBox(
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
      ),
    );
  }

  Widget _elevatedBox({
    required Widget child,
    double? height,
    double? width,
    Color? shadowColor,
  }) {
    final Color shadow = shadowColor ?? Colors.black12;
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2))],
      ),
      child: child,
    );
  }
}