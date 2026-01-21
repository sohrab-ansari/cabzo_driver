// // // // import 'dart:async';
// // // // import 'dart:convert';
// // // // import 'dart:math';
// // // // import 'package:corezap_driver/controller/controllers.dart';
// // // // import 'package:corezap_driver/controller/home_controller.dart';
// // // // import 'package:corezap_driver/controller/stepper_controller.dart';
// // // // import 'package:corezap_driver/utilities/colors.dart';
// // // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_animate/flutter_animate.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:socket_io_client/socket_io_client.dart' as IO;

// // // // class HomeScreen extends StatefulWidget {
// // // //   const HomeScreen({super.key});

// // // //   @override
// // // //   State<HomeScreen> createState() => _HomeScreenState();
// // // // }

// // // // class _HomeScreenState extends State<HomeScreen> {
// // // //   Controllers controllers = Get.put(Controllers());
// // // //   final HomeController homeController = Get.put(HomeController());
// // // //   StepperController stepperController = Get.put(StepperController());

// // // //   // Socket variables
// // // //   IO.Socket? socket;
// // // //   bool _isSocketConnected = false;
// // // //   bool _isOnDuty = false;
// // // //   String _socketStatus = 'Not Connected';
// // // //   String _socketId = '';
// // // //   int _reconnectAttempts = 0;
// // // //   final int _maxReconnectAttempts = 5;
// // // //   Timer? _locationUpdateTimer;
// // // //   bool _isProcessingOnline = false;

// // // //   // Driver data
// // // //   final String _driverId = '6968ab566bf2182c63438143';
// // // //   final String _token =
// // // //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg4ODQ0NjAsImV4cCI6MTc3MTQ3NjQ2MH0.TTHqv0QpsdCG-K0zCYrvDAsqOkoktcaUsHHSOZjasHc';

// // // //   // Ride variables
// // // //   Map<String, dynamic>? _currentRide;
// // // //   String? _activeRideId;
// // // //   bool _isRideInProgress = false;
// // // //   DateTime? _rideStartTime;

// // // //   // Location variables (mock - you'll need to implement real location)
// // // //   double? _currentLatitude;
// // // //   double? _currentLongitude;
// // // //   String _vehicleType = 'Car';
// // // //   String? _vehicleImage;
// // // //   String? _fleetId;

// // // //   @override
// // // //   void initState() {
// // // //     homeController.home_data_method();
// // // //     super.initState();

// // // //     // Start socket connection
// // // //     connectSocket();
// // // //   }

// // // //   Future<void> connectSocket() async {
// // // //     print("🔄 Starting socket connection...");

// // // //     try {
// // // //       // Check if already connected
// // // //       if (socket != null && _isSocketConnected) {
// // // //         print('✅ Socket already connected');
// // // //         return;
// // // //       }

// // // //       // Dispose existing socket
// // // //       if (socket != null) {
// // // //         socket!.disconnect();
// // // //         socket!.dispose();
// // // //       }

// // // //       print('🔌 Connecting driver socket...');
// // // //       print('Driver ID: $_driverId');
// // // //       print('Token: ${_token.substring(0, 20)}...');

// // // //       // Create socket
// // // //       socket = IO.io(
// // // //         'https://corezap.smarttechbros.com',
// // // //         IO.OptionBuilder()
// // // //             .setTransports(['websocket', 'polling'])
// // // //             .enableAutoConnect()
// // // //             .setReconnectionAttempts(_maxReconnectAttempts)
// // // //             .setReconnectionDelay(1000)
// // // //             .setTimeout(20000)
// // // //             .setAuth({'token': _token})
// // // //             .build(),
// // // //       );

// // // //       // Setup all event listeners
// // // //       _setupEventListeners();

// // // //       // Connect socket
// // // //       socket!.connect();
// // // //     } catch (error) {
// // // //       print('❌ Socket connection error: $error');
// // // //       setState(() {
// // // //         _socketStatus = 'Connection Error';
// // // //       });
// // // //     }
// // // //   }

// // // //   void _setupEventListeners() {
// // // //     if (socket == null) return;

// // // //     // ==================== CONNECTION EVENTS ====================

// // // //     socket!.onConnect((_) {
// // // //       print('✅✅✅ DRIVER SOCKET CONNECTED: ${socket!.id}');
// // // //       setState(() {
// // // //         _isSocketConnected = true;
// // // //         _socketStatus = 'Connected';
// // // //         _socketId = socket!.id ?? '';
// // // //         _reconnectAttempts = 0;
// // // //       });

// // // //       print('📡 Socket is ready for communication');
// // // //     });

// // // //     socket!.on('disconnect', (reason) {
// // // //       print('❌ Driver socket disconnected: $reason');
// // // //       setState(() {
// // // //         _isSocketConnected = false;
// // // //         _socketStatus = 'Disconnected';
// // // //         _isOnDuty = false;
// // // //         _isProcessingOnline = false;
// // // //       });

// // // //       // Stop location updates when disconnected
// // // //       _stopLocationUpdates();
// // // //     });

// // // //     socket!.on('connect_error', (error) {
// // // //       print('❌ Socket connection error: ${error.toString()}');
// // // //       _reconnectAttempts++;
// // // //       setState(() {
// // // //         _socketStatus = 'Connection Error';
// // // //       });
// // // //     });

// // // //     socket!.on('reconnect', (attemptNumber) {
// // // //       print('🔄 Socket reconnected after $attemptNumber attempts');
// // // //       setState(() {
// // // //         _reconnectAttempts = 0;
// // // //       });
// // // //     });

// // // //     // ==================== DRIVER ONLINE RESPONSE EVENTS ====================

// // // //     // Listen for successful online response
// // // //     socket!.on('user:online_success', (dynamic data) {
// // // //       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
// // // //       _handleOnlineSuccess(data);
// // // //     });

// // // //     // Listen for failed online response
// // // //     socket!.on('user:online_failed', (dynamic data) {
// // // //       print('❌❌❌ DRIVER ONLINE FAILED: $data');
// // // //       _handleOnlineFailure(data);
// // // //     });

// // // //     // Alternative event names that might be used by backend
// // // //     socket!.on('driver:online_success', (dynamic data) {
// // // //       print('✅✅✅ DRIVER ONLINE SUCCESS (alternative event): $data');
// // // //       _handleOnlineSuccess(data);
// // // //     });

// // // //     socket!.on('driver:online_failed', (dynamic data) {
// // // //       print('❌❌❌ DRIVER ONLINE FAILED (alternative event): $data');
// // // //       _handleOnlineFailure(data);
// // // //     });

// // // //     // Generic response handler
// // // //     socket!.on('user:online_response', (dynamic data) {
// // // //       print('📨 GENERIC ONLINE RESPONSE: $data');
// // // //       final response = Map<String, dynamic>.from(data);

// // // //       if (response['status'] == 'success' || response['success'] == true) {
// // // //         print('✅ Online status: Success');
// // // //         _handleOnlineSuccess(data);
// // // //       } else {
// // // //         print('❌ Online status: Failed');
// // // //         _handleOnlineFailure(data);
// // // //       }
// // // //     });

// // // //     // ==================== RIDE REQUEST EVENTS ====================

// // // //     socket!.on('ride:newRide', (dynamic data) {
// // // //       print('🚕 NEW RIDE REQUEST RECEIVED');

// // // //       // Cast data to Map<String, dynamic> first
// // // //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

// // // //       // Map socket data to expected format
// // // //       final Map<String, dynamic> mappedData = {
// // // //         ...rideData,
// // // //         'orderId':
// // // //             rideData['orderId'] ??
// // // //             rideData['rideId'] ??
// // // //             rideData['_id'] ??
// // // //             'unknown',
// // // //         'rider': {
// // // //           'name':
// // // //               rideData['riderName'] ?? rideData['rider']?['name'] ?? 'Customer',
// // // //           'phone': rideData['riderNumber'] ?? rideData['rider']?['phone'] ?? '',
// // // //           '_id': rideData['riderId'] ?? rideData['rider']?['_id'],
// // // //         },
// // // //         'fare': {'total': rideData['totalFare'] ?? rideData['fare'] ?? '0'},
// // // //       };

// // // //       print('Ride Details:');
// // // //       print('- Order ID: ${mappedData['orderId']}');
// // // //       print('- Rider: ${mappedData['rider']['name']}');
// // // //       print('- Distance: ${mappedData['distance']}');
// // // //       print('- Fare: ${mappedData['fare']['total']}');
// // // //       print('- Pickup: ${mappedData['pickup']}');

// // // //       // Show ride request notification
// // // //       _showRideRequestNotification(mappedData);
// // // //     });

// // // //     socket!.on('ride:confirmed', (dynamic data) {
// // // //       print('✅ Ride accepted - Backend confirmed');

// // // //       // Cast data to Map<String, dynamic>
// // // //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
// // // //       final orderId = rideData['orderId'] ?? rideData['_id'] ?? 'unknown';
// // // //       print('- Order ID: $orderId');
// // // //       print(
// // // //         '- Rider: ${rideData['rider']?['name'] ?? rideData['user']?['name']}',
// // // //       );
// // // //       print('- Fare: ${rideData['fare'] ?? rideData['totalFare']}');

// // // //       // Update current ride state
// // // //       _currentRide = {
// // // //         'orderId': orderId,
// // // //         'status': 'confirmed',
// // // //         'rider': rideData['rider'] ?? rideData['user'],
// // // //         'pickup': rideData['pickupLocation'] ?? rideData['startLocation'],
// // // //         'dropoff': rideData['dropoffLocation'] ?? rideData['endLocation'],
// // // //         'fare': rideData['fare'] ?? rideData['totalFare'],
// // // //         'distance': rideData['distance'],
// // // //         'duration': rideData['duration'] ?? rideData['estimatedTime'],
// // // //         'otp': rideData['otp'],
// // // //         'completeData': rideData,
// // // //       };

// // // //       setState(() {
// // // //         _activeRideId = orderId;
// // // //         _isRideInProgress = true;
// // // //         _rideStartTime = DateTime.now();
// // // //       });

// // // //       print('🚗 Ride state updated to CONFIRMED');
// // // //       _showToast(
// // // //         'Ride confirmed with ${rideData['rider']?['name'] ?? 'rider'}',
// // // //       );

// // // //       // Join ride room for real-time updates
// // // //       _joinRideRoom(orderId);
// // // //     });

// // // //     socket!.on('ride:status', (dynamic data) {
// // // //       print('📊 Ride status update: $data');

// // // //       // Cast data to Map<String, dynamic>
// // // //       final Map<String, dynamic> statusData = Map<String, dynamic>.from(data);

// // // //       if (_currentRide != null &&
// // // //           _currentRide!['orderId'] == statusData['orderId']) {
// // // //         _currentRide!['status'] = statusData['status'];

// // // //         // Mark ride as complete
// // // //         if (statusData['status'] == 'completed' ||
// // // //             statusData['status'] == 'finished' ||
// // // //             statusData['status'] == 'ended') {
// // // //           print('✅ Ride completion status received: ${statusData['status']}');
// // // //           _completeRide(statusData['orderId']);
// // // //           _showToast('Ride completed successfully');
// // // //         }
// // // //       }
// // // //     });

// // // //     socket!.on('ride:orderCancelled', (dynamic data) {
// // // //       print('❌ Ride cancelled: $data');

// // // //       // Cast data to Map<String, dynamic>
// // // //       final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
// // // //       _completeRide(cancelData['orderId']);

// // // //       setState(() {
// // // //         _currentRide = null;
// // // //         _isRideInProgress = false;
// // // //       });

// // // //       _showToast('Ride was cancelled');
// // // //     });

// // // //     // ==================== DEBUG ALL EVENTS ====================

// // // //     socket!.onAny((event, data) {
// // // //       if (!['ping', 'pong'].contains(event)) {
// // // //         print(
// // // //           '🔍 [ALL EVENTS] $event: ${data.toString().substring(0, min(100, data.toString().length))}',
// // // //         );
// // // //       }
// // // //     });
// // // //   }

// // // //   // ==================== DRIVER ONLINE/OFFLINE ====================

// // // //   Future<void> _goOnline() async {
// // // //     print('🟢 ============ GOING ONLINE PROCESS ============');

// // // //     if (_isProcessingOnline) {
// // // //       print('⏳ Already processing online request...');
// // // //       return;
// // // //     }

// // // //     setState(() {
// // // //       _isProcessingOnline = true;
// // // //     });

// // // //     // First, ensure socket is connected
// // // //     if (!_isSocketConnected) {
// // // //       print('⚠️ Socket not connected, connecting first...');
// // // //       await connectSocket();

// // // //       // Wait a bit for connection
// // // //       await Future.delayed(const Duration(seconds: 2));

// // // //       if (!_isSocketConnected) {
// // // //         setState(() {
// // // //           _isProcessingOnline = false;
// // // //         });
// // // //         _showToast('Cannot connect to server');
// // // //         return;
// // // //       }
// // // //     }

// // // //     // Now emit driver online with exact backend structure
// // // //     print('🚀 Sending driver online payload...');
// // // //     await _emitDriverOnline();

// // // //     print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
// // // //   }

// // // //   Future<void> _emitDriverOnline() async {
// // // //     try {
// // // //       if (socket == null || !_isSocketConnected) {
// // // //         print('⚠️ Socket not connected, cannot emit driver online');
// // // //         _showToast('Socket not connected');
// // // //         setState(() {
// // // //           _isProcessingOnline = false;
// // // //         });
// // // //         return;
// // // //       }

// // // //       print('📡 Emitting user:online event...');

// // // //       // Get current location
// // // //       await _getCurrentLocation();

// // // //       // ============ EXACT STRUCTURE FROM BACKEND ============
// // // //       final Map<String, dynamic> payload = {
// // // //         'latitude': _currentLatitude ?? 28.6139,
// // // //         'longitude': _currentLongitude ?? 77.2090,
// // // //         'vehicleType': _vehicleType,

// // // //         // Optional fields - only include if not null
// // // //         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
// // // //         if (_fleetId != null) 'fleetId': _fleetId,

// // // //         // Include driverId for identification
// // // //         'driverId': _driverId,
// // // //         'timestamp': DateTime.now().toIso8601String(),
// // // //       };

// // // //       print('📡 Payload structure matches backend:');
// // // //       print('- latitude: ${payload['latitude']}');
// // // //       print('- longitude: ${payload['longitude']}');
// // // //       print('- vehicleType: ${payload['vehicleType']}');
// // // //       print('- vehicleImage: ${payload['vehicleImage'] ?? 'null'}');
// // // //       print('- fleetId: ${payload['fleetId'] ?? 'null'}');
// // // //       print('- driverId: ${payload['driverId']}');
// // // //       print('- timestamp: ${payload['timestamp']}');

// // // //       // Set a timeout for the response
// // // //       Timer(const Duration(seconds: 10), () {
// // // //         if (_isProcessingOnline) {
// // // //           print('⏰ Online request timeout - no response from server');
// // // //           _handleOnlineFailure('Timeout: No response from server');
// // // //         }
// // // //       });

// // // //       // Emit the event
// // // //       print('🎯 Emitting user:online event...');
// // // //       socket!.emit('user:online', payload);

// // // //       print('⏳ Waiting for server response...');
// // // //     } catch (error) {
// // // //       print('❌ Error emitting driver online: $error');
// // // //       _showToast('Error going online: $error');
// // // //       setState(() {
// // // //         _isOnDuty = false;
// // // //         _isProcessingOnline = false;
// // // //       });
// // // //     }
// // // //   }

// // // //   void _handleOnlineSuccess(dynamic data) {
// // // //     if (!_isProcessingOnline) return; // Already handled

// // // //     print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

// // // //     setState(() {
// // // //       _isOnDuty = true;
// // // //       _isProcessingOnline = false;
// // // //     });

// // // //     // Extract and show success message
// // // //     String successMessage = 'Driver is now online';
// // // //     if (data is Map<String, dynamic>) {
// // // //       successMessage = data['message'] ?? successMessage;
// // // //     }

// // // //     _showToast(successMessage);

// // // //     // Start location updates
// // // //     _startLocationUpdates();

// // // //     // Navigate to map screen
// // // //     Future.delayed(const Duration(seconds: 1), () {
// // // //       if (mounted) {
// // // //         Navigator.push(
// // // //           context,
// // // //           MaterialPageRoute(
// // // //             builder: (context) =>
// // // //                 const BottomnavmainScreen(startWithMaps: true),
// // // //           ),
// // // //         );
// // // //       }
// // // //     });
// // // //   }

// // // //   void _handleOnlineFailure(dynamic data) {
// // // //     if (!_isProcessingOnline) return; // Already handled

// // // //     print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

// // // //     setState(() {
// // // //       _isOnDuty = false;
// // // //       _isProcessingOnline = false;
// // // //     });

// // // //     // Extract and show error message
// // // //     String errorMessage = 'Failed to go online';
// // // //     if (data is String) {
// // // //       errorMessage = data;
// // // //     } else if (data is Map<String, dynamic>) {
// // // //       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
// // // //     }

// // // //     _showToast(errorMessage);
// // // //   }

// // // //   Future<void> _goOffline() async {
// // // //     try {
// // // //       if (socket != null && _isSocketConnected) {
// // // //         print('🔴 Going offline...');

// // // //         // Prepare offline payload with same structure
// // // //         final Map<String, dynamic> payload = {
// // // //           'latitude': _currentLatitude ?? 28.6139,
// // // //           'longitude': _currentLongitude ?? 77.2090,
// // // //           'vehicleType': _vehicleType,
// // // //           'driverId': _driverId,
// // // //           'status': 'offline',
// // // //           'timestamp': DateTime.now().toIso8601String(),
// // // //         };

// // // //         // Emit driver offline events
// // // //         socket!.emit('user:offline', payload);
// // // //         socket!.emit('driver:offline', payload);

// // // //         // Some servers might expect offline via user:online
// // // //         socket!.emit('user:online', {...payload, 'status': 'offline'});

// // // //         setState(() {
// // // //           _isOnDuty = false;
// // // //         });

// // // //         // Stop location updates
// // // //         _stopLocationUpdates();

// // // //         print('✅ Driver is now offline');
// // // //         _showToast('Driver is now offline');
// // // //       }
// // // //     } catch (error) {
// // // //       print('❌ Error going offline: $error');
// // // //     }
// // // //   }

// // // //   // ==================== RIDE MANAGEMENT ====================

// // // //   void _joinRideRoom(String orderId) {
// // // //     if (socket != null && _isSocketConnected) {
// // // //       socket!.emit('ride:join', {'orderId': orderId});
// // // //       print('🚗 Joined ride room: $orderId');
// // // //     }
// // // //   }

// // // //   void _completeRide(String orderId) {
// // // //     print('✅ Completing ride: $orderId');
// // // //     setState(() {
// // // //       _currentRide = null;
// // // //       _activeRideId = null;
// // // //       _isRideInProgress = false;
// // // //       _rideStartTime = null;
// // // //     });
// // // //   }

// // // //   // ==================== LOCATION METHODS ====================

// // // //   Future<void> _getCurrentLocation() async {
// // // //     try {
// // // //       // Mock location - implement real location service
// // // //       _currentLatitude = 28.6139; // Delhi latitude
// // // //       _currentLongitude = 77.2090; // Delhi longitude
// // // //       print('📍 Current location: $_currentLatitude, $_currentLongitude');
// // // //     } catch (e) {
// // // //       print('❌ Error getting location: $e');
// // // //       _currentLatitude = 28.6139;
// // // //       _currentLongitude = 77.2090;
// // // //     }
// // // //   }

// // // //   void _startLocationUpdates() {
// // // //     print('📍 Starting location updates...');

// // // //     // Cancel existing timer
// // // //     _stopLocationUpdates();

// // // //     // Send initial location
// // // //     _sendLocationUpdate();

// // // //     // Update location every 30 seconds
// // // //     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
// // // //       if (_isOnDuty && socket != null && _isSocketConnected) {
// // // //         _sendLocationUpdate();
// // // //       } else {
// // // //         // Stop timer if not online or not connected
// // // //         timer.cancel();
// // // //       }
// // // //     });
// // // //   }

// // // //   void _stopLocationUpdates() {
// // // //     if (_locationUpdateTimer != null) {
// // // //       _locationUpdateTimer!.cancel();
// // // //       _locationUpdateTimer = null;
// // // //       print('📍 Stopped location updates');
// // // //     }
// // // //   }

// // // //   Future<void> _sendLocationUpdate() async {
// // // //     try {
// // // //       if (!_isOnDuty || socket == null || !_isSocketConnected) return;

// // // //       await _getCurrentLocation(); // Get fresh location

// // // //       final Map<String, dynamic> locationPayload = {
// // // //         'latitude': _currentLatitude ?? 28.6139,
// // // //         'longitude': _currentLongitude ?? 77.2090,
// // // //         'driverId': _driverId,
// // // //         'timestamp': DateTime.now().toIso8601String(),
// // // //         'vehicleType': _vehicleType,
// // // //       };

// // // //       // Send location update - try different event names
// // // //       socket!.emit('driver:location', locationPayload);
// // // //       socket!.emit('location:update', locationPayload);

// // // //       print(
// // // //         '📍 Location update sent: ${_currentLatitude}, ${_currentLongitude}',
// // // //       );
// // // //     } catch (error) {
// // // //       print('❌ Error sending location update: $error');
// // // //     }
// // // //   }

// // // //   // ==================== NOTIFICATIONS ====================

// // // //   void _showRideRequestNotification(Map<String, dynamic> rideData) {
// // // //     if (!mounted) return;

// // // //     // Extract data with null safety
// // // //     final riderName = rideData['rider']?['name']?.toString() ?? 'Customer';
// // // //     final distance = rideData['distance']?.toString() ?? '0';
// // // //     final fare = rideData['fare']?['total']?.toString() ?? '0';
// // // //     final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
// // // //     final orderId = rideData['orderId']?.toString() ?? '';

// // // //     showDialog(
// // // //       context: context,
// // // //       barrierDismissible: false,
// // // //       builder: (context) => AlertDialog(
// // // //         title: const Text('🚕 New Ride Request'),
// // // //         content: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text('Rider: $riderName'),
// // // //             Text('Distance: $distance km'),
// // // //             Text('Fare: ₹$fare'),
// // // //             const SizedBox(height: 10),
// // // //             Text('Pickup: $pickup'),
// // // //           ],
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               // Reject ride
// // // //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// // // //                 socket!.emit('ride:reject', {'orderId': orderId});
// // // //                 _showToast('Ride rejected');
// // // //               }
// // // //             },
// // // //             child: const Text('Reject'),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(context);
// // // //               // Accept ride
// // // //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// // // //                 socket!.emit('ride:accept', {'orderId': orderId});
// // // //                 print('✅ Ride accepted: $orderId');
// // // //                 _showToast('Ride accepted!');
// // // //               }
// // // //             },
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

// // // //   // ==================== UTILITY METHODS ====================

// // // //   void _toggleConnection() {
// // // //     if (_isSocketConnected) {
// // // //       socket?.disconnect();
// // // //       setState(() {
// // // //         _isSocketConnected = false;
// // // //         _socketStatus = 'Disconnecting...';
// // // //         _isOnDuty = false;
// // // //         _isProcessingOnline = false;
// // // //       });
// // // //       _showToast('Socket disconnected');
// // // //     } else {
// // // //       connectSocket();
// // // //       _showToast('Connecting socket...');
// // // //     }
// // // //   }

// // // //   void _toggleOnlineStatus() {
// // // //     if (_isOnDuty) {
// // // //       _goOffline();
// // // //     } else {
// // // //       _goOnline();
// // // //     }
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     // Stop location updates
// // // //     _stopLocationUpdates();

// // // //     // Disconnect socket
// // // //     if (socket != null) {
// // // //       socket!.disconnect();
// // // //       socket!.dispose();
// // // //     }
// // // //     super.dispose();
// // // //   }

// // // //   // ==================== UI BUILD ====================

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     double w = MediaQuery.of(context).size.width;

// // // //     return Scaffold(
// // // //       backgroundColor: AppColors.white,
// // // //       appBar: PreferredSize(
// // // //         preferredSize: Size.fromHeight(w * .300),
// // // //         child:
// // // //             Container(
// // // //                   height: w * .290,
// // // //                   decoration: BoxDecoration(
// // // //                     color: AppColors.white,
// // // //                     boxShadow: [
// // // //                       BoxShadow(
// // // //                         color: Colors.grey.withOpacity(0.2),
// // // //                         spreadRadius: 1,
// // // //                         blurRadius: 2,
// // // //                         offset: const Offset(0, 3),
// // // //                       ),
// // // //                     ],
// // // //                     borderRadius: BorderRadius.only(
// // // //                       bottomLeft: Radius.circular(w * 0.04),
// // // //                       bottomRight: Radius.circular(w * 0.04),
// // // //                     ),
// // // //                   ),
// // // //                   child: SafeArea(
// // // //                     child: Padding(
// // // //                       padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // // //                       child: Row(
// // // //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                         children: [
// // // //                           Row(
// // // //                             children: [
// // // //                               CircleAvatar(
// // // //                                 radius: w * 0.06,
// // // //                                 backgroundImage: const AssetImage(
// // // //                                   'assets/images/home2.png',
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(width: w * 0.03),
// // // //                               AppFonts.textPoppins(
// // // //                                 context,
// // // //                                 "Ayaan Malviya",
// // // //                                 w * 0.05,
// // // //                                 FontWeight.w600,
// // // //                                 AppColors.black,
// // // //                                 TextAlign.left,
// // // //                                 TextOverflow.visible,
// // // //                               ),
// // // //                             ],
// // // //                           ),

// // // //                           Column(
// // // //                             mainAxisAlignment: MainAxisAlignment.center,
// // // //                             children: [
// // // //                               // Online/Offline status with toggle
// // // //                               GestureDetector(
// // // //                                 onTap: _isProcessingOnline
// // // //                                     ? null
// // // //                                     : _toggleOnlineStatus,
// // // //                                 child: Container(
// // // //                                   width: w * 0.26,
// // // //                                   height: w * 0.10,
// // // //                                   decoration: BoxDecoration(
// // // //                                     color: _isOnDuty
// // // //                                         ? const Color(0xFF34C759)
// // // //                                         : const Color(0xFFF26061),
// // // //                                     borderRadius: BorderRadius.circular(
// // // //                                       w * 0.06,
// // // //                                     ),
// // // //                                   ),
// // // //                                   alignment: Alignment.center,
// // // //                                   child: _isProcessingOnline
// // // //                                       ? SizedBox(
// // // //                                           width: w * 0.04,
// // // //                                           height: w * 0.04,
// // // //                                           child: CircularProgressIndicator(
// // // //                                             strokeWidth: 2,
// // // //                                             color: Colors.white,
// // // //                                           ),
// // // //                                         )
// // // //                                       : Text(
// // // //                                           _isOnDuty ? 'Online' : 'Offline',
// // // //                                           style: TextStyle(
// // // //                                             color: Colors.white,
// // // //                                             fontSize: w * 0.032,
// // // //                                             fontWeight: FontWeight.w600,
// // // //                                           ),
// // // //                                         ),
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(height: w * 0.01),

// // // //                               // Socket status indicator
// // // //                               Container(
// // // //                                 padding: EdgeInsets.symmetric(
// // // //                                   horizontal: w * 0.02,
// // // //                                   vertical: w * 0.005,
// // // //                                 ),
// // // //                                 decoration: BoxDecoration(
// // // //                                   color: _isSocketConnected
// // // //                                       ? Colors.green
// // // //                                       : Colors.red,
// // // //                                   borderRadius: BorderRadius.circular(w * 0.01),
// // // //                                 ),
// // // //                                 child: Row(
// // // //                                   mainAxisSize: MainAxisSize.min,
// // // //                                   children: [
// // // //                                     Container(
// // // //                                       width: w * 0.015,
// // // //                                       height: w * 0.015,
// // // //                                       decoration: BoxDecoration(
// // // //                                         color: Colors.white,
// // // //                                         shape: BoxShape.circle,
// // // //                                       ),
// // // //                                     ),
// // // //                                     SizedBox(width: w * 0.01),
// // // //                                     Text(
// // // //                                       _isSocketConnected
// // // //                                           ? 'Connected'
// // // //                                           : 'Disconnected',
// // // //                                       style: TextStyle(
// // // //                                         color: Colors.white,
// // // //                                         fontSize: w * 0.02,
// // // //                                         fontWeight: FontWeight.w500,
// // // //                                       ),
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 )
// // // //                 .animate()
// // // //                 .fade(duration: 800.ms, curve: Curves.easeInOut)
// // // //                 .scale(
// // // //                   begin: const Offset(0.95, 0.95),
// // // //                   end: const Offset(1, 1),
// // // //                 ),
// // // //       ),

// // // //       body: SingleChildScrollView(
// // // //         child: Padding(
// // // //           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.center,
// // // //             children: [
// // // //               // Status display
// // // //               Container(
// // // //                 margin: EdgeInsets.only(bottom: w * 0.02),
// // // //                 padding: EdgeInsets.all(w * 0.015),
// // // //                 decoration: BoxDecoration(
// // // //                   color: _isOnDuty ? Colors.green[50] : Colors.grey[50],
// // // //                   borderRadius: BorderRadius.circular(w * 0.02),
// // // //                   border: Border.all(
// // // //                     color: _isOnDuty ? Colors.green : Colors.grey[300]!,
// // // //                   ),
// // // //                 ),
// // // //                 child: Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // //                   children: [
// // // //                     Icon(
// // // //                       _isOnDuty ? Icons.check_circle : Icons.error_outline,
// // // //                       color: _isOnDuty ? Colors.green : Colors.orange,
// // // //                       size: w * 0.04,
// // // //                     ),
// // // //                     SizedBox(width: w * 0.02),
// // // //                     Expanded(
// // // //                       child: Text(
// // // //                         _isOnDuty
// // // //                             ? 'Online - Ready for rides'
// // // //                             : _isProcessingOnline
// // // //                             ? 'Processing online request...'
// // // //                             : 'Offline - Tap to go online',
// // // //                         style: TextStyle(
// // // //                           fontSize: w * 0.03,
// // // //                           color: _isOnDuty ? Colors.green : Colors.grey[600],
// // // //                           fontWeight: FontWeight.w500,
// // // //                         ),
// // // //                         textAlign: TextAlign.center,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),

// // // //               // Socket Connection Info Card
// // // //               Container(
// // // //                 margin: EdgeInsets.only(bottom: w * 0.02),
// // // //                 padding: EdgeInsets.all(w * 0.02),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.grey[50],
// // // //                   borderRadius: BorderRadius.circular(w * 0.02),
// // // //                   border: Border.all(color: Colors.grey[300]!),
// // // //                 ),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     Row(
// // // //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                       children: [
// // // //                         Row(
// // // //                           children: [
// // // //                             Icon(
// // // //                               _isSocketConnected ? Icons.wifi : Icons.wifi_off,
// // // //                               color: _isSocketConnected
// // // //                                   ? Colors.green
// // // //                                   : Colors.red,
// // // //                               size: w * 0.04,
// // // //                             ),
// // // //                             SizedBox(width: w * 0.01),
// // // //                             Text(
// // // //                               _isSocketConnected
// // // //                                   ? 'Socket Connected'
// // // //                                   : 'Socket Disconnected',
// // // //                               style: TextStyle(
// // // //                                 fontSize: w * 0.03,
// // // //                                 color: _isSocketConnected
// // // //                                     ? Colors.green
// // // //                                     : Colors.red,
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                         if (_socketId.isNotEmpty)
// // // //                           Text(
// // // //                             'ID: ${_socketId.substring(0, min(_socketId.length, 8))}...',
// // // //                             style: TextStyle(
// // // //                               fontSize: w * 0.025,
// // // //                               color: Colors.grey[600],
// // // //                             ),
// // // //                           ),
// // // //                       ],
// // // //                     ),

// // // //                     SizedBox(height: w * 0.01),

// // // //                     // Connection Test Button
// // // //                     ElevatedButton.icon(
// // // //                       onPressed: _toggleConnection,
// // // //                       icon: Icon(
// // // //                         _isSocketConnected
// // // //                             ? Icons.power_settings_new
// // // //                             : Icons.power,
// // // //                         size: w * 0.03,
// // // //                       ),
// // // //                       label: Text(
// // // //                         _isSocketConnected
// // // //                             ? 'Disconnect Socket'
// // // //                             : 'Connect Socket',
// // // //                         style: TextStyle(fontSize: w * 0.028),
// // // //                       ),
// // // //                       style: ElevatedButton.styleFrom(
// // // //                         backgroundColor: _isSocketConnected
// // // //                             ? Colors.red
// // // //                             : Colors.green,
// // // //                         minimumSize: Size(double.infinity, w * 0.08),
// // // //                       ),
// // // //                     ),

// // // //                     if (_currentRide != null) ...[
// // // //                       SizedBox(height: w * 0.01),
// // // //                       Container(
// // // //                         padding: EdgeInsets.all(w * 0.015),
// // // //                         decoration: BoxDecoration(
// // // //                           color: Colors.blue[50],
// // // //                           borderRadius: BorderRadius.circular(w * 0.01),
// // // //                         ),
// // // //                         child: Row(
// // // //                           children: [
// // // //                             Icon(
// // // //                               Icons.directions_car,
// // // //                               size: w * 0.035,
// // // //                               color: Colors.blue,
// // // //                             ),
// // // //                             SizedBox(width: w * 0.01),
// // // //                             Expanded(
// // // //                               child: Text(
// // // //                                 'Active Ride: ${_currentRide!['rider']?['name'] ?? 'Rider'}',
// // // //                                 style: TextStyle(
// // // //                                   fontSize: w * 0.03,
// // // //                                   color: Colors.blue[800],
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ],
// // // //                 ),
// // // //               ),

// // // //               // Driver status image and text
// // // //               SizedBox(height: w * 0.04),

// // // //               Image.asset("assets/images/offline_image.png"),

// // // //               Text(
// // // //                 _isOnDuty ? "You're Online" : "You're Offline",
// // // //                 style: TextStyle(
// // // //                   fontSize: w * 0.05,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: _isOnDuty ? Colors.green : Colors.black,
// // // //                 ),
// // // //               ),

// // // //               Text(
// // // //                 _isOnDuty
// // // //                     ? "Ready to accept rides!"
// // // //                     : "Go online to start accepting rides.",
// // // //                 style: TextStyle(
// // // //                   color: const Color(0xFF5F6165),
// // // //                   fontWeight: FontWeight.w500,
// // // //                 ),
// // // //               ),

// // // //               SizedBox(height: w * 0.04),
// // // //               ElevatedButton(
// // // //                 onPressed: _isProcessingOnline
// // // //                     ? null
// // // //                     : () {
// // // //                         print("Going online button tapped");
// // // //                         if (_isOnDuty) {
// // // //                           _goOffline();
// // // //                         } else {
// // // //                           _goOnline();
// // // //                         }
// // // //                       },
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: _isOnDuty
// // // //                       ? const Color(0xFFF26061)
// // // //                       : const Color(0xFF34C759),
// // // //                   minimumSize: const Size(double.infinity, 50),
// // // //                 ),
// // // //                 child: _isProcessingOnline
// // // //                     ? SizedBox(
// // // //                         width: w * 0.04,
// // // //                         height: w * 0.04,
// // // //                         child: CircularProgressIndicator(
// // // //                           strokeWidth: 2,
// // // //                           color: Colors.white,
// // // //                         ),
// // // //                       )
// // // //                     : Text(
// // // //                         _isOnDuty ? "Go Offline" : "Go Online",
// // // //                         style: TextStyle(
// // // //                           fontSize: w * 0.04,
// // // //                           color: Colors.white,
// // // //                         ),
// // // //                       ),
// // // //               ),

// // // //               // Test connection button
// // // //               SizedBox(height: w * 0.02),
// // // //               TextButton(
// // // //                 onPressed: () {
// // // //                   print('🧪 Testing socket connection...');
// // // //                   if (socket != null && _isSocketConnected) {
// // // //                     socket!.emit('test:echo', {
// // // //                       'message': 'Hello from Flutter driver',
// // // //                       'driverId': _driverId,
// // // //                       'timestamp': DateTime.now().toIso8601String(),
// // // //                     });
// // // //                     _showToast('Test message sent');
// // // //                   } else {
// // // //                     _showToast('Socket not connected');
// // // //                   }
// // // //                 },
// // // //                 child: Text(
// // // //                   'Test Connection',
// // // //                   style: TextStyle(fontSize: w * 0.03, color: Colors.blue),
// // // //                 ),
// // // //               ),

// // // //               //text todays's update
// // // //               SizedBox(height: w * 0.05),
// // // //               Align(
// // // //                 alignment: Alignment.centerLeft,
// // // //                 child:
// // // //                     AppFonts.textPoppins(
// // // //                           context,
// // // //                           "Today's Update",
// // // //                           w * 0.038,
// // // //                           FontWeight.w600,
// // // //                           AppColors.black,
// // // //                           TextAlign.left,
// // // //                           TextOverflow.visible,
// // // //                         )
// // // //                         .animate()
// // // //                         .fade(duration: 820.ms, curve: Curves.easeInOut)
// // // //                         .scale(
// // // //                           begin: const Offset(0.95, 0.95),
// // // //                           end: const Offset(1, 1),
// // // //                         ),
// // // //               ),

// // // //               //some space
// // // //               SizedBox(height: w * 0.04),

// // // //               Column(
// // // //                 children: [
// // // //                   /// Today's Earnings (Full Width)
// // // //                   _elevatedBox(
// // // //                     shadowColor: const Color(0xFF4CAF50),
// // // //                     width: double.infinity,
// // // //                     child: Column(
// // // //                       children: const [
// // // //                         Text(
// // // //                           "Today's Earnings",
// // // //                           style: TextStyle(
// // // //                             fontSize: 14,
// // // //                             color: Color(0xFF414142),
// // // //                           ),
// // // //                         ),
// // // //                         SizedBox(height: 6),
// // // //                         Text(
// // // //                           "₹1000.00",
// // // //                           style: TextStyle(
// // // //                             fontSize: 22,
// // // //                             fontWeight: FontWeight.bold,
// // // //                           ),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),

// // // //                   const SizedBox(height: 16),

// // // //                   /// Online & Cash
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     children: [
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: _elevatedBox(
// // // //                           shadowColor: const Color(0xFFFEBC2F),
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: const [
// // // //                               Text(
// // // //                                 "Online",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 13,
// // // //                                   color: Color(0xFF414142),
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(height: 4),
// // // //                               Text(
// // // //                                 "₹500 Total",
// // // //                                 style: TextStyle(fontWeight: FontWeight.w600),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: _elevatedBox(
// // // //                           shadowColor: const Color(0xFF7C7C8D),
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: const [
// // // //                               Text(
// // // //                                 "Cash",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 13,
// // // //                                   color: Color(0xFF414142),
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(height: 4),
// // // //                               Text(
// // // //                                 "₹500 On Hand",
// // // //                                 style: TextStyle(fontWeight: FontWeight.w600),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),

// // // //                   SizedBox(height: w * 0.05),

// // // //                   /// Ride Stats
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: _elevatedBox(
// // // //                           shadowColor: const Color(0xFF439AFE),
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text(
// // // //                                 "Total Rides",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 13,
// // // //                                   color: const Color(0xFF414142),
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(height: 4),
// // // //                               RichText(
// // // //                                 text: const TextSpan(
// // // //                                   children: [
// // // //                                     TextSpan(
// // // //                                       text: "50",
// // // //                                       style: TextStyle(
// // // //                                         fontSize: 18,
// // // //                                         fontWeight: FontWeight.bold,
// // // //                                         color: Colors.black,
// // // //                                       ),
// // // //                                     ),
// // // //                                     TextSpan(
// // // //                                       text: " / 45 Completed",
// // // //                                       style: TextStyle(
// // // //                                         fontSize: 14,
// // // //                                         fontWeight: FontWeight.w600,
// // // //                                         color: Colors.black,
// // // //                                       ),
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(width: w * 0.02),
// // // //                       SizedBox(
// // // //                         width: w * 0.45,
// // // //                         child: _elevatedBox(
// // // //                           shadowColor: const Color(0xFFF26061),
// // // //                           child: Column(
// // // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // // //                             children: [
// // // //                               Text(
// // // //                                 "Total Rides",
// // // //                                 style: TextStyle(
// // // //                                   fontSize: 13,
// // // //                                   color: const Color(0xFF414142),
// // // //                                 ),
// // // //                               ),
// // // //                               SizedBox(height: 4),
// // // //                               RichText(
// // // //                                 text: const TextSpan(
// // // //                                   children: [
// // // //                                     TextSpan(
// // // //                                       text: "50",
// // // //                                       style: TextStyle(
// // // //                                         fontSize: 18,
// // // //                                         fontWeight: FontWeight.bold,
// // // //                                         color: Colors.black,
// // // //                                       ),
// // // //                                     ),
// // // //                                     TextSpan(
// // // //                                       text: " / 05 Cancelled",
// // // //                                       style: TextStyle(
// // // //                                         fontSize: 14,
// // // //                                         fontWeight: FontWeight.w600,
// // // //                                         color: Colors.black,
// // // //                                       ),
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
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
// // // //       ),

// // // //       // Floating action buttons for quick actions
// // // //       floatingActionButton: Column(
// // // //         mainAxisAlignment: MainAxisAlignment.end,
// // // //         children: [
// // // //           FloatingActionButton.small(
// // // //             onPressed: _toggleConnection,
// // // //             backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
// // // //             child: Icon(
// // // //               _isSocketConnected ? Icons.link : Icons.link_off,
// // // //               size: w * 0.04,
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: w * 0.01),
// // // //           if (_isRideInProgress)
// // // //             FloatingActionButton.extended(
// // // //               onPressed: () {
// // // //                 // Complete current ride
// // // //                 if (_activeRideId != null) {
// // // //                   _completeRide(_activeRideId!);
// // // //                   _showToast('Ride ended');
// // // //                 }
// // // //               },
// // // //               backgroundColor: Colors.orange,
// // // //               icon: Icon(Icons.directions_car_filled, size: w * 0.04),
// // // //               label: Text('End Ride', style: TextStyle(fontSize: w * 0.03)),
// // // //             ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _elevatedBox({
// // // //     required Widget child,
// // // //     double? height,
// // // //     double? width,
// // // //     Color? shadowColor,
// // // //   }) {
// // // //     final Color shadow = shadowColor ?? Colors.black12;
// // // //     return Container(
// // // //       height: height,
// // // //       width: width,
// // // //       padding: const EdgeInsets.all(12),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         boxShadow: [
// // // //           BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
// // // //         ],
// // // //       ),
// // // //       child: child,
// // // //     );
// // // //   }

// // // //   Widget commonWidget1(
// // // //     double w,
// // // //     Color color,
// // // //     String text1,
// // // //     String text2,
// // // //     String amount1,
// // // //     String amount2,
// // // //   ) {
// // // //     return Container(
// // // //       height: w * .23,
// // // //       width: w * .43,
// // // //       decoration: BoxDecoration(
// // // //         color: color,
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.grey.withOpacity(0.2),
// // // //             spreadRadius: 2,
// // // //             blurRadius: 3,
// // // //           ),
// // // //         ],
// // // //         borderRadius: BorderRadius.circular(w * 0.012),
// // // //       ),
// // // //       child: Align(
// // // //         alignment: Alignment.bottomRight,
// // // //         child: Container(
// // // //           height: w * .23,
// // // //           width: w * .423,
// // // //           decoration: BoxDecoration(
// // // //             color: AppColors.white,
// // // //             borderRadius: BorderRadius.circular(w * 0.012),
// // // //           ),
// // // //           child: Padding(
// // // //             padding: EdgeInsets.symmetric(
// // // //               horizontal: w * 0.03,
// // // //               vertical: w * 0.03,
// // // //             ),
// // // //             child: Column(
// // // //               mainAxisAlignment: MainAxisAlignment.center,
// // // //               children: [
// // // //                 Row(
// // // //                   children: [
// // // //                     AppFonts.textPoppins(
// // // //                       context,
// // // //                       "$amount1 - ",
// // // //                       w * 0.032,
// // // //                       FontWeight.w600,
// // // //                       AppColors.black,
// // // //                       TextAlign.left,
// // // //                       TextOverflow.visible,
// // // //                     ),
// // // //                     AppFonts.textPoppins(
// // // //                       context,
// // // //                       text1,
// // // //                       w * 0.028,
// // // //                       FontWeight.w400,
// // // //                       AppColors.black,
// // // //                       TextAlign.left,
// // // //                       TextOverflow.visible,
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 SizedBox(height: w * 0.02),
// // // //                 Row(
// // // //                   children: [
// // // //                     AppFonts.textPoppins(
// // // //                       context,
// // // //                       "$amount2 - ",
// // // //                       w * 0.028,
// // // //                       FontWeight.w600,
// // // //                       AppColors.black,
// // // //                       TextAlign.left,
// // // //                       TextOverflow.visible,
// // // //                     ),
// // // //                     AppFonts.textPoppins(
// // // //                       context,
// // // //                       text2,
// // // //                       w * 0.028,
// // // //                       FontWeight.w400,
// // // //                       AppColors.black,
// // // //                       TextAlign.left,
// // // //                       TextOverflow.visible,
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // Helper function to get minimum of two values
// // // // int min(int a, int b) => a < b ? a : b;


// // // import 'dart:async';
// // // import 'dart:convert';
// // // import 'dart:math';
// // // import 'package:corezap_driver/controllers/controllers.dart';
// // // import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
// // // import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// // // import 'package:corezap_driver/utilities/colors.dart';
// // // import 'package:corezap_driver/utilities/custom_font.dart';
// // // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_animate/flutter_animate.dart';
// // // import 'package:get/get.dart';
// // // import 'package:socket_io_client/socket_io_client.dart' as IO;

// // // class HomeScreen extends StatefulWidget {
// // //   const HomeScreen({super.key});

// // //   @override
// // //   State<HomeScreen> createState() => _HomeScreenState();
// // // }

// // // class _HomeScreenState extends State<HomeScreen> {
// // //   Controllers controllers = Get.put(Controllers());
// // // final HomeController homeController = Get.find<HomeController>();
// // // final StepperController stepperController = Get.find<StepperController>();

// // //   // Socket variables
// // //   IO.Socket? socket;
// // //   bool _isSocketConnected = false;
// // //   bool _isOnDuty = false;
// // //   String _socketStatus = 'Not Connected';
// // //   String _socketId = '';
// // //   int _reconnectAttempts = 0;
// // //   final int _maxReconnectAttempts = 5;
// // //   Timer? _locationUpdateTimer;
// // //   bool _isProcessingOnline = false;

// // //   // Location update tracking
// // //   int _locationUpdateCount = 0;
// // //   DateTime? _lastLocationUpdateTime;
// // //   final Random _random = Random();

// // //   // Driver data
// // //   final String _driverId = '6968ab566bf2182c63438143';
// // //   final String _token =
// // //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg4ODQ0NjAsImV4cCI6MTc3MTQ3NjQ2MH0.TTHqv0QpsdCG-K0zCYrvDAsqOkoktcaUsHHSOZjasHc';

// // //   // Ride variables
// // //   Map<String, dynamic>? _currentRide;
// // //   String? _activeRideId;
// // //   bool _isRideInProgress = false;
// // //   DateTime? _rideStartTime;

// // //   // Location variables (mock - you'll need to implement real location)
// // //   double? _currentLatitude;
// // //   double? _currentLongitude;
// // //   String _vehicleType = 'Car';
// // //   String? _vehicleImage;
// // //   String? _fleetId;

// // //   @override
// // //   void initState() {
// // //     homeController.home_data_method();
// // //     super.initState();

// // //     // Start socket connection
// // //     connectSocket();
// // //   }

// // //   Future<void> connectSocket() async {
// // //     print("🔄 Starting socket connection...");

// // //     try {
// // //       // Check if already connected
// // //       if (socket != null && _isSocketConnected) {
// // //         print('✅ Socket already connected');
// // //         return;
// // //       }

// // //       // Dispose existing socket
// // //       if (socket != null) {
// // //         socket!.disconnect();
// // //         socket!.dispose();
// // //       }

// // //       print('🔌 Connecting driver socket...');
// // //       print('Driver ID: $_driverId');
// // //       print('Token: ${_token.substring(0, 20)}...');

// // //       // Create socket
// // //       socket = IO.io(
// // //         'https://corezap.smarttechbros.com',
// // //         IO.OptionBuilder()
// // //             .setTransports(['websocket', 'polling'])
// // //             .enableAutoConnect()
// // //             .setReconnectionAttempts(_maxReconnectAttempts)
// // //             .setReconnectionDelay(1000)
// // //             .setTimeout(20000)
// // //             .setAuth({'token': _token})
// // //             .build(),
// // //       );

// // //       // Setup all event listeners
// // //       _setupEventListeners();

// // //       // Connect socket
// // //       socket!.connect();
// // //     } catch (error) {
// // //       print('❌ Socket connection error: $error');
// // //       setState(() {
// // //         _socketStatus = 'Connection Error';
// // //       });
// // //     }
// // //   }

// // //   void _setupEventListeners() {
// // //     if (socket == null) return;

// // //     // ==================== CONNECTION EVENTS ====================

// // //     socket!.onConnect((_) {
// // //       print('✅✅✅ DRIVER SOCKET CONNECTED: ${socket!.id}');
// // //       setState(() {
// // //         _isSocketConnected = true;
// // //         _socketStatus = 'Connected';
// // //         _socketId = socket!.id ?? '';
// // //         _reconnectAttempts = 0;
// // //       });

// // //       print('📡 Socket is ready for communication');
// // //     });

// // //     socket!.on('disconnect', (reason) {
// // //       print('❌ Driver socket disconnected: $reason');
// // //       setState(() {
// // //         _isSocketConnected = false;
// // //         _socketStatus = 'Disconnected';
// // //         _isOnDuty = false;
// // //         _isProcessingOnline = false;
// // //       });

// // //       // Stop location updates when disconnected
// // //       _stopLocationUpdates();
// // //     });

// // //     socket!.on('connect_error', (error) {
// // //       print('❌ Socket connection error: ${error.toString()}');
// // //       _reconnectAttempts++;
// // //       setState(() {
// // //         _socketStatus = 'Connection Error';
// // //       });
// // //     });

// // //     socket!.on('reconnect', (attemptNumber) {
// // //       print('🔄 Socket reconnected after $attemptNumber attempts');
// // //       setState(() {
// // //         _reconnectAttempts = 0;
// // //       });
// // //     });

// // //     // Reconnecting events for better feedback
// // //     socket!.on('reconnecting', (attemptNumber) {
// // //       print('🔄 Socket reconnecting... Attempt $attemptNumber');
// // //       setState(() {
// // //         _socketStatus = 'Reconnecting...';
// // //         _reconnectAttempts = attemptNumber;
// // //       });
// // //     });

// // //     // To this (correct):
// // // socket!.on('reconnect_failed', (data) {
// // //   print('❌ Socket reconnection failed after $_maxReconnectAttempts attempts: $data');
// // //   setState(() {
// // //     _socketStatus = 'Connection Failed';
// // //     _isOnDuty = false;
// // //     _isProcessingOnline = false;
// // //   });
// // //   _showToast('Failed to reconnect. Please check your internet.');
// // // });

// // //     // socket!.on('reconnect_failed', () {
// // //     //   print('❌ Socket reconnection failed after $_maxReconnectAttempts attempts');
// // //     //   setState(() {
// // //     //     _socketStatus = 'Connection Failed';
// // //     //     _isOnDuty = false;
// // //     //     _isProcessingOnline = false;
// // //     //   });
// // //     //   _showToast('Failed to reconnect. Please check your internet.');
// // //     // });

// // //     // ==================== DRIVER ONLINE RESPONSE EVENTS ====================

// // //     // Listen for successful online response
// // //     socket!.on('user:online_success', (dynamic data) {
// // //       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
// // //       _handleOnlineSuccess(data);
// // //     });

// // //     // Listen for failed online response
// // //     socket!.on('user:online_failed', (dynamic data) {
// // //       print('❌❌❌ DRIVER ONLINE FAILED: $data');
// // //       _handleOnlineFailure(data);
// // //     });

// // //     // Alternative event names that might be used by backend
// // //     socket!.on('driver:online_success', (dynamic data) {
// // //       print('✅✅✅ DRIVER ONLINE SUCCESS (alternative event): $data');
// // //       _handleOnlineSuccess(data);
// // //     });

// // //     socket!.on('driver:online_failed', (dynamic data) {
// // //       print('❌❌❌ DRIVER ONLINE FAILED (alternative event): $data');
// // //       _handleOnlineFailure(data);
// // //     });

// // //     // Generic response handler
// // //     socket!.on('user:online_response', (dynamic data) {
// // //       print('📨 GENERIC ONLINE RESPONSE: $data');
// // //       final response = Map<String, dynamic>.from(data);

// // //       if (response['status'] == 'success' || response['success'] == true) {
// // //         print('✅ Online status: Success');
// // //         _handleOnlineSuccess(data);
// // //       } else {
// // //         print('❌ Online status: Failed');
// // //         _handleOnlineFailure(data);
// // //       }
// // //     });

// // //     // ==================== RIDE REQUEST EVENTS ====================

// // //     socket!.on('ride:newRide', (dynamic data) {
// // //       print('🚕 NEW RIDE REQUEST RECEIVED');

// // //       // Cast data to Map<String, dynamic> first
// // //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

// // //       // Map socket data to expected format
// // //       final Map<String, dynamic> mappedData = {
// // //         ...rideData,
// // //         'orderId':
// // //             rideData['orderId'] ??
// // //             rideData['rideId'] ??
// // //             rideData['_id'] ??
// // //             'unknown',
// // //         'rider': {
// // //           'name':
// // //               rideData['riderName'] ?? rideData['rider']?['name'] ?? 'Customer',
// // //           'phone': rideData['riderNumber'] ?? rideData['rider']?['phone'] ?? '',
// // //           '_id': rideData['riderId'] ?? rideData['rider']?['_id'],
// // //         },
// // //         'fare': {'total': rideData['totalFare'] ?? rideData['fare'] ?? '0'},
// // //       };

// // //       print('Ride Details:');
// // //       print('- Order ID: ${mappedData['orderId']}');
// // //       print('- Rider: ${mappedData['rider']['name']}');
// // //       print('- Distance: ${mappedData['distance']}');
// // //       print('- Fare: ${mappedData['fare']['total']}');
// // //       print('- Pickup: ${mappedData['pickup']}');

// // //       // Show ride request notification
// // //       _showRideRequestNotification(mappedData);
// // //     });

// // //     socket!.on('ride:confirmed', (dynamic data) {
// // //       print('✅ Ride accepted - Backend confirmed');

// // //       // Cast data to Map<String, dynamic>
// // //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
// // //       final orderId = rideData['orderId'] ?? rideData['_id'] ?? 'unknown';
// // //       print('- Order ID: $orderId');
// // //       print(
// // //         '- Rider: ${rideData['rider']?['name'] ?? rideData['user']?['name']}',
// // //       );
// // //       print('- Fare: ${rideData['fare'] ?? rideData['totalFare']}');

// // //       // Update current ride state
// // //       _currentRide = {
// // //         'orderId': orderId,
// // //         'status': 'confirmed',
// // //         'rider': rideData['rider'] ?? rideData['user'],
// // //         'pickup': rideData['pickupLocation'] ?? rideData['startLocation'],
// // //         'dropoff': rideData['dropoffLocation'] ?? rideData['endLocation'],
// // //         'fare': rideData['fare'] ?? rideData['totalFare'],
// // //         'distance': rideData['distance'],
// // //         'duration': rideData['duration'] ?? rideData['estimatedTime'],
// // //         'otp': rideData['otp'],
// // //         'completeData': rideData,
// // //       };

// // //       setState(() {
// // //         _activeRideId = orderId;
// // //         _isRideInProgress = true;
// // //         _rideStartTime = DateTime.now();
// // //       });

// // //       print('🚗 Ride state updated to CONFIRMED');
// // //       _showToast(
// // //         'Ride confirmed with ${rideData['rider']?['name'] ?? 'rider'}',
// // //       );

// // //       // Join ride room for real-time updates
// // //       _joinRideRoom(orderId);
// // //     });

// // //     socket!.on('ride:status', (dynamic data) {
// // //       print('📊 Ride status update: $data');

// // //       // Cast data to Map<String, dynamic>
// // //       final Map<String, dynamic> statusData = Map<String, dynamic>.from(data);

// // //       if (_currentRide != null &&
// // //           _currentRide!['orderId'] == statusData['orderId']) {
// // //         _currentRide!['status'] = statusData['status'];

// // //         // Mark ride as complete
// // //         if (statusData['status'] == 'completed' ||
// // //             statusData['status'] == 'finished' ||
// // //             statusData['status'] == 'ended') {
// // //           print('✅ Ride completion status received: ${statusData['status']}');
// // //           _completeRide(statusData['orderId']);
// // //           _showToast('Ride completed successfully');
// // //         }
// // //       }
// // //     });

// // //     socket!.on('ride:orderCancelled', (dynamic data) {
// // //       print('❌ Ride cancelled: $data');

// // //       // Cast data to Map<String, dynamic>
// // //       final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
// // //       _completeRide(cancelData['orderId']);

// // //       setState(() {
// // //         _currentRide = null;
// // //         _isRideInProgress = false;
// // //       });

// // //       _showToast('Ride was cancelled');
// // //     });

// // //     // ==================== DEBUG ALL EVENTS ====================

// // //     socket!.onAny((event, data) {
// // //       if (!['ping', 'pong'].contains(event)) {
// // //         print(
// // //           '🔍 [ALL EVENTS] $event: ${data.toString().substring(0, min(100, data.toString().length))}',
// // //         );
// // //       }
// // //     });
// // //   }

// // //   // ==================== DRIVER ONLINE/OFFLINE ====================

// // //   Future<void> _goOnline() async {
// // //     print('🟢 ============ GOING ONLINE PROCESS ============');

// // //     if (_isProcessingOnline) {
// // //       print('⏳ Already processing online request...');
// // //       return;
// // //     }

// // //     setState(() {
// // //       _isProcessingOnline = true;
// // //     });

// // //     // First, ensure socket is connected
// // //     if (!_isSocketConnected) {
// // //       print('⚠️ Socket not connected, connecting first...');
// // //       await connectSocket();

// // //       // Wait a bit for connection
// // //       await Future.delayed(const Duration(seconds: 2));

// // //       if (!_isSocketConnected) {
// // //         setState(() {
// // //           _isProcessingOnline = false;
// // //         });
// // //         _showToast('Cannot connect to server');
// // //         return;
// // //       }
// // //     }

// // //     // Now emit driver online with exact backend structure
// // //     print('🚀 Sending driver online payload...');
// // //     await _emitDriverOnline();

// // //     print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
// // //   }

// // //   Future<void> _emitDriverOnline() async {
// // //     try {
// // //       if (socket == null || !_isSocketConnected) {
// // //         print('⚠️ Socket not connected, cannot emit driver online');
// // //         _showToast('Socket not connected');
// // //         setState(() {
// // //           _isProcessingOnline = false;
// // //         });
// // //         return;
// // //       }

// // //       print('📡 Emitting user:online event...');

// // //       // Get current location
// // //       await _getCurrentLocation();

// // //       // ============ EXACT STRUCTURE FROM BACKEND ============
// // //       final Map<String, dynamic> payload = {
// // //         'latitude': _currentLatitude ?? 28.6139,
// // //         'longitude': _currentLongitude ?? 77.2090,
// // //         'vehicleType': _vehicleType,

// // //         // Optional fields - only include if not null
// // //         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
// // //         if (_fleetId != null) 'fleetId': _fleetId,

// // //         // Include driverId for identification
// // //         'driverId': _driverId,
// // //         'timestamp': DateTime.now().toIso8601String(),
// // //       };

// // //       print('📡 Payload structure matches backend:');
// // //       print('- latitude: ${payload['latitude']}');
// // //       print('- longitude: ${payload['longitude']}');
// // //       print('- vehicleType: ${payload['vehicleType']}');
// // //       print('- vehicleImage: ${payload['vehicleImage'] ?? 'null'}');
// // //       print('- fleetId: ${payload['fleetId'] ?? 'null'}');
// // //       print('- driverId: ${payload['driverId']}');
// // //       print('- timestamp: ${payload['timestamp']}');

// // //       // Set a timeout for the response
// // //       Timer(const Duration(seconds: 10), () {
// // //         if (_isProcessingOnline) {
// // //           print('⏰ Online request timeout - no response from server');
// // //           _handleOnlineFailure('Timeout: No response from server');
// // //         }
// // //       });

// // //       // Emit the event
// // //       print('🎯 Emitting user:online event...');
// // //       socket!.emit('user:online', payload);

// // //       print('⏳ Waiting for server response...');
// // //     } catch (error) {
// // //       print('❌ Error emitting driver online: $error');
// // //       _showToast('Error going online: $error');
// // //       setState(() {
// // //         _isOnDuty = false;
// // //         _isProcessingOnline = false;
// // //       });
// // //     }
// // //   }

// // //   void _handleOnlineSuccess(dynamic data) {
// // //     if (!_isProcessingOnline) return; // Already handled

// // //     print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

// // //     setState(() {
// // //       _isOnDuty = true;
// // //       _isProcessingOnline = false;
// // //     });

// // //     // Extract and show success message
// // //     String successMessage = 'Driver is now online';
// // //     if (data is Map<String, dynamic>) {
// // //       successMessage = data['message'] ?? successMessage;
// // //     }

// // //     _showToast(successMessage);

// // //     // Start location updates every 4 seconds
// // //     _startLocationUpdates();

// // //     // Navigate to map screen
// // //     Future.delayed(const Duration(seconds: 1), () {
// // //       if (mounted) {
// // //         Navigator.push(
// // //           context,
// // //           MaterialPageRoute(
// // //             builder: (context) =>
// // //                 const BottomnavmainScreen(startWithMaps: true),
// // //           ),
// // //         );
// // //       }
// // //     });
// // //   }

// // //   void _handleOnlineFailure(dynamic data) {
// // //     if (!_isProcessingOnline) return; // Already handled

// // //     print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

// // //     setState(() {
// // //       _isOnDuty = false;
// // //       _isProcessingOnline = false;
// // //     });

// // //     // Extract and show error message
// // //     String errorMessage = 'Failed to go online';
// // //     if (data is String) {
// // //       errorMessage = data;
// // //     } else if (data is Map<String, dynamic>) {
// // //       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
// // //     }

// // //     _showToast(errorMessage);
// // //   }

// // //   Future<void> _goOffline() async {
// // //     try {
// // //       if (socket != null && _isSocketConnected) {
// // //         print('🔴 Going offline...');

// // //         // Prepare offline payload with same structure
// // //         final Map<String, dynamic> payload = {
// // //           'latitude': _currentLatitude ?? 28.6139,
// // //           'longitude': _currentLongitude ?? 77.2090,
// // //           'vehicleType': _vehicleType,
// // //           'driverId': _driverId,
// // //           'status': 'offline',
// // //           'timestamp': DateTime.now().toIso8601String(),
// // //         };

// // //         // Emit driver offline events
// // //         socket!.emit('user:offline', payload);
// // //         socket!.emit('driver:offline', payload);

// // //         // Some servers might expect offline via user:online
// // //         socket!.emit('user:online', {...payload, 'status': 'offline'});

// // //         setState(() {
// // //           _isOnDuty = false;
// // //         });

// // //         // Stop location updates
// // //         _stopLocationUpdates();

// // //         print('✅ Driver is now offline');
// // //         _showToast('Driver is now offline');
// // //       }
// // //     } catch (error) {
// // //       print('❌ Error going offline: $error');
// // //     }
// // //   }

// // //   // ==================== RIDE MANAGEMENT ====================

// // //   void _joinRideRoom(String orderId) {
// // //     if (socket != null && _isSocketConnected) {
// // //       socket!.emit('ride:join', {'orderId': orderId});
// // //       print('🚗 Joined ride room: $orderId');
// // //     }
// // //   }

// // //   void _completeRide(String orderId) {
// // //     print('✅ Completing ride: $orderId');
// // //     setState(() {
// // //       _currentRide = null;
// // //       _activeRideId = null;
// // //       _isRideInProgress = false;
// // //       _rideStartTime = null;
// // //     });
// // //   }

// // //   // ==================== LOCATION METHODS ====================

// // //   Future<void> _getCurrentLocation() async {
// // //     try {
// // //       // For testing: simulate location movement when online
// // //       if (_isOnDuty && _currentLatitude != null && _currentLongitude != null) {
// // //         // Simulate small location changes (for testing)
// // //         _currentLatitude = _currentLatitude! + (_random.nextDouble() * 0.001 - 0.0005);
// // //         _currentLongitude = _currentLongitude! + (_random.nextDouble() * 0.001 - 0.0005);
// // //       } else {
// // //         // Initial location
// // //         _currentLatitude = 28.6139; // Delhi latitude
// // //         _currentLongitude = 77.2090; // Delhi longitude
// // //       }
      
// // //       print('📍 Current location: $_currentLatitude, $_currentLongitude');
      
// // //     } catch (e) {
// // //       print('❌ Error getting location: $e');
// // //       _currentLatitude = 28.6139;
// // //       _currentLongitude = 77.2090;
// // //     }
// // //   }

// // //   void _startLocationUpdates() {
// // //     print('📍 Starting location updates every 4 seconds...');

// // //     // Cancel existing timer
// // //     _stopLocationUpdates();

// // //     // Reset counter
// // //     _locationUpdateCount = 0;
// // //     _lastLocationUpdateTime = null;

// // //     // Send initial location immediately
// // //     _sendLocationUpdate();

// // //     // Update location every 4 seconds (as per backend requirement)
// // //     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
// // //       if (_isOnDuty && socket != null && _isSocketConnected) {
// // //         _sendLocationUpdate();
// // //       } else {
// // //         // Stop timer if not online or not connected
// // //         print('⚠️ Stopping location updates - not online or disconnected');
// // //         timer.cancel();
// // //       }
// // //     });
// // //   }

// // //   void _stopLocationUpdates() {
// // //     if (_locationUpdateTimer != null) {
// // //       _locationUpdateTimer!.cancel();
// // //       _locationUpdateTimer = null;
      
// // //       print('📍 Stopped location updates (total sent: $_locationUpdateCount)');
// // //     }
// // //   }

// // //   Future<void> _sendLocationUpdate() async {
// // //     try {
// // //       if (!_isOnDuty || socket == null || !_isSocketConnected) {
// // //         print('⚠️ Skipping location update - not online or disconnected');
// // //         return;
// // //       }

// // //       _locationUpdateCount++;
// // //       final now = DateTime.now();
      
// // //       // Calculate time since last update
// // //       if (_lastLocationUpdateTime != null) {
// // //         final timeDiff = now.difference(_lastLocationUpdateTime!).inSeconds;
// // //         print('⏱️ Time since last update: ${timeDiff}s');
// // //       }
      
// // //       _lastLocationUpdateTime = now;

// // //       // Get fresh location
// // //       await _getCurrentLocation();

// // //       // ============ EXACT PAYLOAD STRUCTURE FROM BACKEND ============
// // //       final Map<String, dynamic> locationPayload = {
// // //         'latitude': _currentLatitude ?? 28.6139,
// // //         'longitude': _currentLongitude ?? 77.2090,
// // //         'vehicleType': _vehicleType,

// // //         // Optional fields - only include if not null
// // //         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
// // //         if (_fleetId != null) 'fleetId': _fleetId,

// // //         // Include driverId for identification
// // //         'driverId': _driverId,
// // //         'timestamp': now.toIso8601String(),
// // //         'updateCount': _locationUpdateCount, // Track sequence
// // //       };

// // //       // Log summary
// // //       print('📍 [Update #$_locationUpdateCount] Sending location: ${_currentLatitude}, ${_currentLongitude}');

// // //       // Send location update with EXACT event name from backend
// // //       print('🎯 Emitting driver:location:update event...');
// // //       socket!.emit('driver:location:update', locationPayload);

// // //       print('✅ Update #$_locationUpdateCount sent at ${now.toIso8601String()}');

// // //     } catch (error) {
// // //       print('❌ Error sending location update #$_locationUpdateCount: $error');
// // //     }
// // //   }

// // //   // ==================== NOTIFICATIONS ====================

// // //   void _showRideRequestNotification(Map<String, dynamic> rideData) {
// // //     if (!mounted) return;

// // //     // Extract data with null safety
// // //     final riderName = rideData['rider']?['name']?.toString() ?? 'Customer';
// // //     final distance = rideData['distance']?.toString() ?? '0';
// // //     final fare = rideData['fare']?['total']?.toString() ?? '0';
// // //     final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
// // //     final orderId = rideData['orderId']?.toString() ?? '';

// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('🚕 New Ride Request'),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text('Rider: $riderName'),
// // //             Text('Distance: $distance km'),
// // //             Text('Fare: ₹$fare'),
// // //             const SizedBox(height: 10),
// // //             Text('Pickup: $pickup'),
// // //           ],
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               // Reject ride
// // //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// // //                 socket!.emit('ride:reject', {'orderId': orderId});
// // //                 _showToast('Ride rejected');
// // //               }
// // //             },
// // //             child: const Text('Reject'),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               Navigator.pop(context);
// // //               // Accept ride
// // //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// // //                 socket!.emit('ride:accept', {'orderId': orderId});
// // //                 print('✅ Ride accepted: $orderId');
// // //                 _showToast('Ride accepted!');
// // //               }
// // //             },
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

// // //   // ==================== UTILITY METHODS ====================

// // //   void _toggleConnection() {
// // //     if (_isSocketConnected) {
// // //       socket?.disconnect();
// // //       setState(() {
// // //         _isSocketConnected = false;
// // //         _socketStatus = 'Disconnecting...';
// // //         _isOnDuty = false;
// // //         _isProcessingOnline = false;
// // //       });
// // //       _showToast('Socket disconnected');
// // //     } else {
// // //       connectSocket();
// // //       _showToast('Connecting socket...');
// // //     }
// // //   }

// // //   void _toggleOnlineStatus() {
// // //     if (_isOnDuty) {
// // //       _goOffline();
// // //     } else {
// // //       _goOnline();
// // //     }
// // //   }

// // //   @override
// // //   void dispose() {
// // //     // Stop location updates
// // //     _stopLocationUpdates();
    
// // //     // Disconnect socket
// // //     if (socket != null) {
// // //       socket!.disconnect();
// // //       socket!.dispose();
// // //     }
// // //     super.dispose();
// // //   }

// // //   // ==================== UI BUILD ====================

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     double w = MediaQuery.of(context).size.width;

// // //     return Scaffold(
// // //       backgroundColor: AppColors.white,
// // //       appBar: PreferredSize(
// // //         preferredSize: Size.fromHeight(w * .300),
// // //         child:
// // //             Container(
// // //                   height: w * .290,
// // //                   decoration: BoxDecoration(
// // //                     color: AppColors.white,
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                         color: Colors.grey.withOpacity(0.2),
// // //                         spreadRadius: 1,
// // //                         blurRadius: 2,
// // //                         offset: const Offset(0, 3),
// // //                       ),
// // //                     ],
// // //                     borderRadius: BorderRadius.only(
// // //                       bottomLeft: Radius.circular(w * 0.04),
// // //                       bottomRight: Radius.circular(w * 0.04),
// // //                     ),
// // //                   ),
// // //                   child: SafeArea(
// // //                     child: Padding(
// // //                       padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // //                       child: Row(
// // //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                         children: [
// // //                           Row(
// // //                             children: [
// // //                               CircleAvatar(
// // //                                 radius: w * 0.06,
// // //                                 backgroundImage: const AssetImage(
// // //                                   'assets/images/home2.png',
// // //                                 ),
// // //                               ),
// // //                               SizedBox(width: w * 0.03),
// // //                               AppFonts.textPoppins(
// // //                                 context,
// // //                                 "Ayaan Malviya",
// // //                                 w * 0.05,
// // //                                 FontWeight.w600,
// // //                                 AppColors.black,
// // //                                 TextAlign.left,
// // //                                 TextOverflow.visible,
// // //                               ),
// // //                             ],
// // //                           ),

// // //                           Column(
// // //                             mainAxisAlignment: MainAxisAlignment.center,
// // //                             children: [
// // //                               // Online/Offline status with toggle
// // //                               GestureDetector(
// // //                                 onTap: _isProcessingOnline
// // //                                     ? null
// // //                                     : _toggleOnlineStatus,
// // //                                 child: Container(
// // //                                   width: w * 0.26,
// // //                                   height: w * 0.10,
// // //                                   decoration: BoxDecoration(
// // //                                     color: _isOnDuty
// // //                                         ? const Color(0xFF34C759)
// // //                                         : const Color(0xFFF26061),
// // //                                     borderRadius: BorderRadius.circular(
// // //                                       w * 0.06,
// // //                                     ),
// // //                                   ),
// // //                                   alignment: Alignment.center,
// // //                                   child: _isProcessingOnline
// // //                                       ? SizedBox(
// // //                                           width: w * 0.04,
// // //                                           height: w * 0.04,
// // //                                           child: CircularProgressIndicator(
// // //                                             strokeWidth: 2,
// // //                                             color: Colors.white,
// // //                                           ),
// // //                                         )
// // //                                       : Text(
// // //                                           _isOnDuty ? 'Online' : 'Offline',
// // //                                           style: TextStyle(
// // //                                             color: Colors.white,
// // //                                             fontSize: w * 0.032,
// // //                                             fontWeight: FontWeight.w600,
// // //                                           ),
// // //                                         ),
// // //                                 ),
// // //                               ),
// // //                               SizedBox(height: w * 0.01),

// // //                               // // Socket status indicator
// // //                               // Container(
// // //                               //   padding: EdgeInsets.symmetric(
// // //                               //     horizontal: w * 0.02,
// // //                               //     vertical: w * 0.005,
// // //                               //   ),
// // //                               //   decoration: BoxDecoration(
// // //                               //     color: _isSocketConnected
// // //                               //         ? Colors.green
// // //                               //         : Colors.red,
// // //                               //     borderRadius: BorderRadius.circular(w * 0.01),
// // //                               //   ),
// // //                               //   child: Row(
// // //                               //     mainAxisSize: MainAxisSize.min,
// // //                               //     children: [
// // //                               //       Container(
// // //                               //         width: w * 0.015,
// // //                               //         height: w * 0.015,
// // //                               //         decoration: BoxDecoration(
// // //                               //           color: Colors.white,
// // //                               //           shape: BoxShape.circle,
// // //                               //         ),
// // //                               //       ),
// // //                               //       SizedBox(width: w * 0.01),
// // //                               //       Text(
// // //                               //         _isSocketConnected
// // //                               //             ? 'Connected'
// // //                               //             : 'Disconnected',
// // //                               //         style: TextStyle(
// // //                               //           color: Colors.white,
// // //                               //           fontSize: w * 0.02,
// // //                               //           fontWeight: FontWeight.w500,
// // //                               //         ),
// // //                               //       ),
// // //                               //     ],
// // //                               //   ),
// // //                               // ),
                           
                           
// // //                             ],
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 )
// // //                 .animate()
// // //                 .fade(duration: 800.ms, curve: Curves.easeInOut)
// // //                 .scale(
// // //                   begin: const Offset(0.95, 0.95),
// // //                   end: const Offset(1, 1),
// // //                 ),
// // //       ),

// // //       body: SingleChildScrollView(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.center,
// // //             children: [
// // //               // Status display
// // //               // Container(
// // //               //   margin: EdgeInsets.only(bottom: w * 0.02),
// // //               //   padding: EdgeInsets.all(w * 0.015),
// // //               //   decoration: BoxDecoration(
// // //               //     color: _isOnDuty ? Colors.green[50] : Colors.grey[50],
// // //               //     borderRadius: BorderRadius.circular(w * 0.02),
// // //               //     border: Border.all(
// // //               //       color: _isOnDuty ? Colors.green : Colors.grey[300]!,
// // //               //     ),
// // //               //   ),
// // //               //   child: Row(
// // //               //     mainAxisAlignment: MainAxisAlignment.center,
// // //               //     children: [
// // //               //       Icon(
// // //               //         _isOnDuty ? Icons.check_circle : Icons.error_outline,
// // //               //         color: _isOnDuty ? Colors.green : Colors.orange,
// // //               //         size: w * 0.04,
// // //               //       ),
// // //               //       SizedBox(width: w * 0.02),
// // //               //       // Expanded(
// // //               //       //   child: Text(
// // //               //       //     _isOnDuty
// // //               //       //         ? 'Online - Ready for rides'
// // //               //       //         : _isProcessingOnline
// // //               //       //         ? 'Processing online request...'
// // //               //       //         : 'Offline - Tap to go online',
// // //               //       //     style: TextStyle(
// // //               //       //       fontSize: w * 0.03,
// // //               //       //       color: _isOnDuty ? Colors.green : Colors.grey[600],
// // //               //       //       fontWeight: FontWeight.w500,
// // //               //       //     ),
// // //               //       //     textAlign: TextAlign.center,
// // //               //       //   ),
// // //               //       // ),
// // //               //     ],
// // //               //   ),
// // //               // ),

// // //               // Location Update Status (only when online)
// // //               if (_isOnDuty && _locationUpdateTimer != null)
// // //                 Container(
// // //                   margin: EdgeInsets.only(bottom: w * 0.02),
// // //                   padding: EdgeInsets.all(w * 0.015),
// // //                   decoration: BoxDecoration(
// // //                     color: Colors.blue[50],
// // //                     borderRadius: BorderRadius.circular(w * 0.02),
// // //                     border: Border.all(color: Colors.blue),
// // //                   ),
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       Icon(
// // //                         Icons.location_on,
// // //                         size: w * 0.04,
// // //                         color: Colors.blue,
// // //                       ),
// // //                       SizedBox(width: w * 0.02),
// // //                       Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(
// // //                             '📍 Location Updates Active',
// // //                             style: TextStyle(
// // //                               fontSize: w * 0.03,
// // //                               color: Colors.blue[800],
// // //                               fontWeight: FontWeight.w600,
// // //                             ),
// // //                           ),
// // //                           Text(
// // //                             'Sending every 4 seconds',
// // //                             style: TextStyle(
// // //                               fontSize: w * 0.025,
// // //                               color: Colors.blue[600],
// // //                             ),
// // //                           ),
// // //                           if (_locationUpdateCount > 0)
// // //                             Text(
// // //                               'Sent: $_locationUpdateCount updates',
// // //                               style: TextStyle(
// // //                                 fontSize: w * 0.025,
// // //                                 color: Colors.blue[600],
// // //                               ),
// // //                             ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),

// // //               // Socket Connection Info Card
           
// // //               // Driver status image and text
// // //               SizedBox(height: w * 0.04),

// // //               Image.asset("assets/images/offline_image.png"),

// // //               Text(
// // //                 _isOnDuty ? "You're Online" : "You're Offline",
// // //                 style: TextStyle(
// // //                   fontSize: w * 0.05,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: _isOnDuty ? Colors.green : Colors.black,
// // //                 ),
// // //               ),

// // //               Text(
// // //                 _isOnDuty
// // //                     ? "Ready to accept rides!"
// // //                     : "Go online to start accepting rides.",
// // //                 style: TextStyle(
// // //                   color: const Color(0xFF5F6165),
// // //                   fontWeight: FontWeight.w500,
// // //                 ),
// // //               ),

// // //               SizedBox(height: w * 0.04),
// // //               ElevatedButton(
// // //                 onPressed: _isProcessingOnline
// // //                     ? null
// // //                     : () {
// // //                         print("Going online button tapped");
// // //                         if (_isOnDuty) {
// // //                           _goOffline();
// // //                         } else {
// // //                           _goOnline();
// // //                         }
// // //                       },
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: _isOnDuty
// // //                       ? const Color(0xFFF26061)
// // //                       : const Color(0xFF34C759),
// // //                   minimumSize: const Size(double.infinity, 50),
// // //                 ),
// // //                 child: _isProcessingOnline
// // //                     ? SizedBox(
// // //                         width: w * 0.04,
// // //                         height: w * 0.04,
// // //                         child: CircularProgressIndicator(
// // //                           strokeWidth: 2,
// // //                           color: Colors.white,
// // //                         ),
// // //                       )
// // //                     : Text(
// // //                         _isOnDuty ? "Go Offline" : "Go Online",
// // //                         style: TextStyle(
// // //                           fontSize: w * 0.04,
// // //                           color: Colors.white,
// // //                         ),
// // //                       ),
// // //               ),

// // //               // Test buttons
// // //               SizedBox(height: w * 0.02),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //                 children: [
// // //                   // Test connection button
// // //                   // Expanded(
// // //                   //   child: TextButton(
// // //                   //     onPressed: () {
// // //                   //       print('🧪 Testing socket connection...');
// // //                   //       if (socket != null && _isSocketConnected) {
// // //                   //         socket!.emit('test:echo', {
// // //                   //           'message': 'Hello from Flutter driver',
// // //                   //           'driverId': _driverId,
// // //                   //           'timestamp': DateTime.now().toIso8601String(),
// // //                   //         });
// // //                   //         _showToast('Test message sent');
// // //                   //       } else {
// // //                   //         _showToast('Socket not connected');
// // //                   //       }
// // //                   //     },
// // //                   //     child: Text(
// // //                   //       'Test Connection',
// // //                   //       style: TextStyle(
// // //                   //         fontSize: w * 0.03,
// // //                   //         color: Colors.blue,
// // //                   //       ),
// // //                   //     ),
// // //                   //   ),
// // //                   // ),
                  
// // //                   // // Test location update button
// // //                   // Expanded(
// // //                   //   child: TextButton(
// // //                   //     onPressed: () {
// // //                   //       if (_isOnDuty) {
// // //                   //         print('📍 Manual location update test');
// // //                   //         _sendLocationUpdate();
// // //                   //         _showToast('Location update sent');
// // //                   //       } else {
// // //                   //         _showToast('Go online first');
// // //                   //       }
// // //                   //     },
// // //                   //     child: Text(
// // //                   //       'Test Location',
// // //                   //       style: TextStyle(
// // //                   //         fontSize: w * 0.03,
// // //                   //         color: Colors.purple,
// // //                   //       ),
// // //                   //     ),
// // //                   //   ),
// // //                   // ),
               
               
// // //                 ],
// // //               ),

// // //               //text todays's update
// // //               SizedBox(height: w * 0.05),
// // //               Align(
// // //                 alignment: Alignment.centerLeft,
// // //                 child:
// // //                     AppFonts.textPoppins(
// // //                           context,
// // //                           "Today's Update",
// // //                           w * 0.038,
// // //                           FontWeight.w600,
// // //                           AppColors.black,
// // //                           TextAlign.left,
// // //                           TextOverflow.visible,
// // //                         )
// // //                         .animate()
// // //                         .fade(duration: 820.ms, curve: Curves.easeInOut)
// // //                         .scale(
// // //                           begin: const Offset(0.95, 0.95),
// // //                           end: const Offset(1, 1),
// // //                         ),
// // //               ),

// // //               //some space
// // //               SizedBox(height: w * 0.04),

// // //               Column(
// // //                 children: [
// // //                   /// Today's Earnings (Full Width)
// // //                   _elevatedBox(
// // //                     shadowColor: const Color(0xFF4CAF50),
// // //                     width: double.infinity,
// // //                     child: Column(
// // //                       children: const [
// // //                         Text(
// // //                           "Today's Earnings",
// // //                           style: TextStyle(
// // //                             fontSize: 14,
// // //                             color: Color(0xFF414142),
// // //                           ),
// // //                         ),
// // //                         SizedBox(height: 6),
// // //                         Text(
// // //                           "₹1000.00",
// // //                           style: TextStyle(
// // //                             fontSize: 22,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),

// // //                   const SizedBox(height: 16),

// // //                   /// Online & Cash
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       SizedBox(
// // //                         width: w * 0.45,
// // //                         child: _elevatedBox(
// // //                           shadowColor: const Color(0xFFFEBC2F),
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: const [
// // //                               Text(
// // //                                 "Online",
// // //                                 style: TextStyle(
// // //                                   fontSize: 13,
// // //                                   color: Color(0xFF414142),
// // //                                 ),
// // //                               ),
// // //                               SizedBox(height: 4),
// // //                               Text(
// // //                                 "₹500 Total",
// // //                                 style: TextStyle(fontWeight: FontWeight.w600),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: w * 0.02),
// // //                       SizedBox(
// // //                         width: w * 0.45,
// // //                         child: _elevatedBox(
// // //                           shadowColor: const Color(0xFF7C7C8D),
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: const [
// // //                               Text(
// // //                                 "Cash",
// // //                                 style: TextStyle(
// // //                                   fontSize: 13,
// // //                                   color: Color(0xFF414142),
// // //                                 ),
// // //                               ),
// // //                               SizedBox(height: 4),
// // //                               Text(
// // //                                 "₹500 On Hand",
// // //                                 style: TextStyle(fontWeight: FontWeight.w600),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),

// // //                   SizedBox(height: w * 0.05),

// // //                   /// Ride Stats
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       SizedBox(
// // //                         width: w * 0.45,
// // //                         child: _elevatedBox(
// // //                           shadowColor: const Color(0xFF439AFE),
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Text(
// // //                                 "Total Rides",
// // //                                 style: TextStyle(
// // //                                   fontSize: 13,
// // //                                   color: const Color(0xFF414142),
// // //                                 ),
// // //                               ),
// // //                               SizedBox(height: 4),
// // //                               RichText(
// // //                                 text: const TextSpan(
// // //                                   children: [
// // //                                     TextSpan(
// // //                                       text: "50",
// // //                                       style: TextStyle(
// // //                                         fontSize: 18,
// // //                                         fontWeight: FontWeight.bold,
// // //                                         color: Colors.black,
// // //                                       ),
// // //                                     ),
// // //                                     TextSpan(
// // //                                       text: " / 45 Completed",
// // //                                       style: TextStyle(
// // //                                         fontSize: 14,
// // //                                         fontWeight: FontWeight.w600,
// // //                                         color: Colors.black,
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: w * 0.02),
// // //                       SizedBox(
// // //                         width: w * 0.45,
// // //                         child: _elevatedBox(
// // //                           shadowColor: const Color(0xFFF26061),
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.start,
// // //                             children: [
// // //                               Text(
// // //                                 "Total Rides",
// // //                                 style: TextStyle(
// // //                                   fontSize: 13,
// // //                                   color: const Color(0xFF414142),
// // //                                 ),
// // //                               ),
// // //                               SizedBox(height: 4),
// // //                               RichText(
// // //                                 text: const TextSpan(
// // //                                   children: [
// // //                                     TextSpan(
// // //                                       text: "50",
// // //                                       style: TextStyle(
// // //                                         fontSize: 18,
// // //                                         fontWeight: FontWeight.bold,
// // //                                         color: Colors.black,
// // //                                       ),
// // //                                     ),
// // //                                     TextSpan(
// // //                                       text: " / 05 Cancelled",
// // //                                       style: TextStyle(
// // //                                         fontSize: 14,
// // //                                         fontWeight: FontWeight.w600,
// // //                                         color: Colors.black,
// // //                                       ),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),

// // //               SizedBox(height: w * 0.04),
// // //             ],
// // //           ),
// // //         ),
// // //       ),

// // //       // // Floating action buttons for quick actions
// // //       // floatingActionButton: Column(
// // //       //   mainAxisAlignment: MainAxisAlignment.end,
// // //       //   children: [
// // //       //     FloatingActionButton.small(
// // //       //       onPressed: _toggleConnection,
// // //       //       backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
// // //       //       child: Icon(
// // //       //         _isSocketConnected ? Icons.link : Icons.link_off,
// // //       //         size: w * 0.04,
// // //       //       ),
// // //       //     ),
// // //       //     SizedBox(height: w * 0.01),
// // //       //     if (_isRideInProgress)
// // //       //       FloatingActionButton.extended(
// // //       //         onPressed: () {
// // //       //           // Complete current ride
// // //       //           if (_activeRideId != null) {
// // //       //             _completeRide(_activeRideId!);
// // //       //             _showToast('Ride ended');
// // //       //           }
// // //       //         },
// // //       //         backgroundColor: Colors.orange,
// // //       //         icon: Icon(Icons.directions_car_filled, size: w * 0.04),
// // //       //         label: Text('End Ride', style: TextStyle(fontSize: w * 0.03)),
// // //       //       ),
// // //       //   ],
// // //       // ),
    
    
// // //     );
// // //   }

// // //   Widget _elevatedBox({
// // //     required Widget child,
// // //     double? height,
// // //     double? width,
// // //     Color? shadowColor,
// // //   }) {
// // //     final Color shadow = shadowColor ?? Colors.black12;
// // //     return Container(
// // //       height: height,
// // //       width: width,
// // //       padding: const EdgeInsets.all(12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         boxShadow: [
// // //           BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
// // //         ],
// // //       ),
// // //       child: child,
// // //     );
// // //   }

// // //   Widget commonWidget1(
// // //     double w,
// // //     Color color,
// // //     String text1,
// // //     String text2,
// // //     String amount1,
// // //     String amount2,
// // //   ) {
// // //     return Container(
// // //       height: w * .23,
// // //       width: w * .43,
// // //       decoration: BoxDecoration(
// // //         color: color,
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.grey.withOpacity(0.2),
// // //             spreadRadius: 2,
// // //             blurRadius: 3,
// // //           ),
// // //         ],
// // //         borderRadius: BorderRadius.circular(w * 0.012),
// // //       ),
// // //       child: Align(
// // //         alignment: Alignment.bottomRight,
// // //         child: Container(
// // //           height: w * .23,
// // //           width: w * .423,
// // //           decoration: BoxDecoration(
// // //             color: AppColors.white,
// // //             borderRadius: BorderRadius.circular(w * 0.012),
// // //           ),
// // //           child: Padding(
// // //             padding: EdgeInsets.symmetric(
// // //               horizontal: w * 0.03,
// // //               vertical: w * 0.03,
// // //             ),
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 Row(
// // //                   children: [
// // //                     AppFonts.textPoppins(
// // //                       context,
// // //                       "$amount1 - ",
// // //                       w * 0.032,
// // //                       FontWeight.w600,
// // //                       AppColors.black,
// // //                       TextAlign.left,
// // //                       TextOverflow.visible,
// // //                     ),
// // //                     AppFonts.textPoppins(
// // //                       context,
// // //                       text1,
// // //                       w * 0.028,
// // //                       FontWeight.w400,
// // //                       AppColors.black,
// // //                       TextAlign.left,
// // //                       TextOverflow.visible,
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 SizedBox(height: w * 0.02),
// // //                 Row(
// // //                   children: [
// // //                     AppFonts.textPoppins(
// // //                       context,
// // //                       "$amount2 - ",
// // //                       w * 0.028,
// // //                       FontWeight.w600,
// // //                       AppColors.black,
// // //                       TextAlign.left,
// // //                       TextOverflow.visible,
// // //                     ),
// // //                     AppFonts.textPoppins(
// // //                       context,
// // //                       text2,
// // //                       w * 0.028,
// // //                       FontWeight.w400,
// // //                       AppColors.black,
// // //                       TextAlign.left,
// // //                       TextOverflow.visible,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // Helper function to get minimum of two values
// // // int min(int a, int b) => a < b ? a : b;


// // import 'dart:async';
// // import 'dart:convert';
// // import 'dart:math';
// // import 'package:corezap_driver/controllers/controllers.dart';
// // import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
// // import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// // import 'package:corezap_driver/utilities/colors.dart';
// // import 'package:corezap_driver/utilities/custom_font.dart';
// // import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_animate/flutter_animate.dart';
// // import 'package:get/get.dart';
// // import 'package:socket_io_client/socket_io_client.dart' as IO;

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   Controllers controllers = Get.put(Controllers());
// //   final HomeController homeController = Get.find<HomeController>();
// //   final StepperController stepperController = Get.find<StepperController>();

// //   // Socket variables
// //   IO.Socket? socket;
// //   bool _isSocketConnected = false;
// //   bool _isOnDuty = false;
// //   String _socketStatus = 'Not Connected';
// //   String _socketId = '';
// //   int _reconnectAttempts = 0;
// //   final int _maxReconnectAttempts = 5;
// //   Timer? _locationUpdateTimer;
// //   bool _isProcessingOnline = false;

// //   // Location update tracking
// //   int _locationUpdateCount = 0;
// //   DateTime? _lastLocationUpdateTime;
// //   final Random _random = Random();

// //   // Driver data
// //   final String _driverId = '6968ab566bf2182c63438143';
// //   final String _token =
// //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg4ODQ0NjAsImV4cCI6MTc3MTQ3NjQ2MH0.TTHqv0QpsdCG-K0zCYrvDAsqOkoktcaUsHHSOZjasHc';

// //   // Ride variables
// //   Map<String, dynamic>? _currentRide;
// //   String? _activeRideId;
// //   bool _isRideInProgress = false;
// //   DateTime? _rideStartTime;

// //   // Location variables (mock - you'll need to implement real location)
// //   double? _currentLatitude;
// //   double? _currentLongitude;
// //   String _vehicleType = 'Car';
// //   String? _vehicleImage;
// //   String? _fleetId;

// //   // Connection quality monitoring
// //   int _pingCount = 0;
// //   DateTime? _lastPingTime;
// //   double _averageLatency = 0.0;

// //   @override
// //   void initState() {
// //     homeController.home_data_method();
// //     super.initState();

// //     // Start socket connection
// //     connectSocket();
// //   }

// //   Future<void> connectSocket() async {
// //     print("🔄 Starting socket connection...");

// //     try {
// //       // Check if already connected
// //       if (socket != null && _isSocketConnected) {
// //         print('✅ Socket already connected');
// //         return;
// //       }

// //       // Dispose existing socket
// //       if (socket != null) {
// //         socket!.disconnect();
// //         socket!.dispose();
// //       }

// //       print('🔌 Connecting driver socket...');
// //       print('Driver ID: $_driverId');
// //       print('Token: ${_token.substring(0, 20)}...');

// //       // Create socket
// //       socket = IO.io(
// //         'https://corezap.smarttechbros.com',
// //         IO.OptionBuilder()
// //             .setTransports(['websocket', 'polling'])
// //             .enableAutoConnect()
// //             .setReconnectionAttempts(_maxReconnectAttempts)
// //             .setReconnectionDelay(1000)
// //             .setTimeout(20000)
// //             .setAuth({'token': _token})
// //             .build(),
// //       );

// //       // Setup all event listeners
// //       _setupEventListeners();

// //       // Connect socket
// //       socket!.connect();
// //     } catch (error) {
// //       print('❌ Socket connection error: $error');
// //       setState(() {
// //         _socketStatus = 'Connection Error';
// //       });
// //     }
// //   }

// //   void _setupEventListeners() {
// //     if (socket == null) return;

// //     // ==================== CONNECTION EVENTS ====================

// //     socket!.onConnect((_) {
// //       print('✅✅✅ DRIVER SOCKET CONNECTED: ${socket!.id}');
// //       setState(() {
// //         _isSocketConnected = true;
// //         _socketStatus = 'Connected';
// //         _socketId = socket!.id ?? '';
// //         _reconnectAttempts = 0;
// //       });

// //       print('📡 Socket is ready for communication');
// //     });

// //     socket!.on('disconnect', (reason) {
// //       print('❌ Driver socket disconnected: $reason');
// //       setState(() {
// //         _isSocketConnected = false;
// //         _socketStatus = 'Disconnected';
// //         _isOnDuty = false;
// //         _isProcessingOnline = false;
// //       });

// //       // Stop location updates when disconnected
// //       _stopLocationUpdates();
// //     });

// //     socket!.on('connect_error', (error) {
// //       print('❌ Socket connection error: ${error.toString()}');
// //       _reconnectAttempts++;
// //       setState(() {
// //         _socketStatus = 'Connection Error';
// //       });
// //     });

// //     socket!.on('reconnect', (attemptNumber) {
// //       print('🔄 Socket reconnected after $attemptNumber attempts');
// //       setState(() {
// //         _reconnectAttempts = 0;
// //       });
// //     });

// //     // Reconnecting events for better feedback
// //     socket!.on('reconnecting', (attemptNumber) {
// //       print('🔄 Socket reconnecting... Attempt $attemptNumber');
// //       setState(() {
// //         _socketStatus = 'Reconnecting...';
// //         _reconnectAttempts = attemptNumber;
// //       });
// //     });

// //     socket!.on('reconnect_failed', (data) {
// //       print('❌ Socket reconnection failed after $_maxReconnectAttempts attempts: $data');
// //       setState(() {
// //         _socketStatus = 'Connection Failed';
// //         _isOnDuty = false;
// //         _isProcessingOnline = false;
// //       });
// //       _showToast('Failed to reconnect. Please check your internet.');
// //     });

// //     // ==================== PING/PONG FOR LATENCY ====================

// //     socket!.on('ping', (_) {
// //       _lastPingTime = DateTime.now();
// //       _pingCount++;
// //       print('📡 Ping received (#$_pingCount)');
// //     });

// //     socket!.on('pong', (_) {
// //       if (_lastPingTime != null) {
// //         final latency = DateTime.now().difference(_lastPingTime!).inMilliseconds;
// //         _averageLatency = (_averageLatency * 0.8) + (latency * 0.2);
// //         print('📶 Socket latency: ${latency}ms (avg: ${_averageLatency.round()}ms)');
// //       }
// //     });

// //     // ==================== DRIVER ONLINE RESPONSE EVENTS ====================

// //     // Listen for successful online response
// //     socket!.on('user:online_success', (dynamic data) {
// //       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
// //       _handleOnlineSuccess(data);
// //     });

// //     // Listen for failed online response
// //     socket!.on('user:online_failed', (dynamic data) {
// //       print('❌❌❌ DRIVER ONLINE FAILED: $data');
// //       _handleOnlineFailure(data);
// //     });

// //     // Alternative event names that might be used by backend
// //     socket!.on('driver:online_success', (dynamic data) {
// //       print('✅✅✅ DRIVER ONLINE SUCCESS (alternative event): $data');
// //       _handleOnlineSuccess(data);
// //     });

// //     socket!.on('driver:online_failed', (dynamic data) {
// //       print('❌❌❌ DRIVER ONLINE FAILED (alternative event): $data');
// //       _handleOnlineFailure(data);
// //     });

// //     // Generic response handler
// //     socket!.on('user:online_response', (dynamic data) {
// //       print('📨 GENERIC ONLINE RESPONSE: $data');
// //       final response = Map<String, dynamic>.from(data);

// //       if (response['status'] == 'success' || response['success'] == true) {
// //         print('✅ Online status: Success');
// //         _handleOnlineSuccess(data);
// //       } else {
// //         print('❌ Online status: Failed');
// //         _handleOnlineFailure(data);
// //       }
// //     });

// //     // ==================== RIDE REQUEST EVENTS ====================

// //     socket!.on('ride:newRide', (dynamic data) {
// //       print('🚕 NEW RIDE REQUEST RECEIVED');

// //       // Cast data to Map<String, dynamic> first
// //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

// //       // Map socket data to expected format
// //       final Map<String, dynamic> mappedData = {
// //         ...rideData,
// //         'orderId':
// //             rideData['orderId'] ??
// //             rideData['rideId'] ??
// //             rideData['_id'] ??
// //             'unknown',
// //         'rider': {
// //           'name':
// //               rideData['riderName'] ?? rideData['rider']?['name'] ?? 'Customer',
// //           'phone': rideData['riderNumber'] ?? rideData['rider']?['phone'] ?? '',
// //           '_id': rideData['riderId'] ?? rideData['rider']?['_id'],
// //         },
// //         'fare': {'total': rideData['totalFare'] ?? rideData['fare'] ?? '0'},
// //       };

// //       print('Ride Details:');
// //       print('- Order ID: ${mappedData['orderId']}');
// //       print('- Rider: ${mappedData['rider']['name']}');
// //       print('- Distance: ${mappedData['distance']}');
// //       print('- Fare: ${mappedData['fare']['total']}');
// //       print('- Pickup: ${mappedData['pickup']}');

// //       // Show ride request notification
// //       _showRideRequestNotification(mappedData);
// //     });

// //     socket!.on('ride:confirmed', (dynamic data) {
// //       print('✅ Ride accepted - Backend confirmed');

// //       // Cast data to Map<String, dynamic>
// //       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
// //       final orderId = rideData['orderId'] ?? rideData['_id'] ?? 'unknown';
// //       print('- Order ID: $orderId');
// //       print(
// //         '- Rider: ${rideData['rider']?['name'] ?? rideData['user']?['name']}',
// //       );
// //       print('- Fare: ${rideData['fare'] ?? rideData['totalFare']}');

// //       // Update current ride state
// //       _currentRide = {
// //         'orderId': orderId,
// //         'status': 'confirmed',
// //         'rider': rideData['rider'] ?? rideData['user'],
// //         'pickup': rideData['pickupLocation'] ?? rideData['startLocation'],
// //         'dropoff': rideData['dropoffLocation'] ?? rideData['endLocation'],
// //         'fare': rideData['fare'] ?? rideData['totalFare'],
// //         'distance': rideData['distance'],
// //         'duration': rideData['duration'] ?? rideData['estimatedTime'],
// //         'otp': rideData['otp'],
// //         'completeData': rideData,
// //       };

// //       setState(() {
// //         _activeRideId = orderId;
// //         _isRideInProgress = true;
// //         _rideStartTime = DateTime.now();
// //       });

// //       print('🚗 Ride state updated to CONFIRMED');
// //       _showToast(
// //         'Ride confirmed with ${rideData['rider']?['name'] ?? 'rider'}',
// //       );

// //       // Join ride room for real-time updates
// //       _joinRideRoom(orderId);
// //     });

// //     socket!.on('ride:status', (dynamic data) {
// //       print('📊 Ride status update: $data');

// //       // Cast data to Map<String, dynamic>
// //       final Map<String, dynamic> statusData = Map<String, dynamic>.from(data);

// //       if (_currentRide != null &&
// //           _currentRide!['orderId'] == statusData['orderId']) {
// //         _currentRide!['status'] = statusData['status'];

// //         // Mark ride as complete
// //         if (statusData['status'] == 'completed' ||
// //             statusData['status'] == 'finished' ||
// //             statusData['status'] == 'ended') {
// //           print('✅ Ride completion status received: ${statusData['status']}');
// //           _completeRide(statusData['orderId']);
// //           _showToast('Ride completed successfully');
// //         }
// //       }
// //     });

// //     socket!.on('ride:orderCancelled', (dynamic data) {
// //       print('❌ Ride cancelled: $data');

// //       // Cast data to Map<String, dynamic>
// //       final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
// //       _completeRide(cancelData['orderId']);

// //       setState(() {
// //         _currentRide = null;
// //         _isRideInProgress = false;
// //       });

// //       _showToast('Ride was cancelled');
// //     });

// //     // ==================== DEBUG ALL EVENTS ====================

// //   socket!.onAny((event, data) {
// //   // Skip noisy events
// //   if (['ping', 'pong'].contains(event)) {
// //     return;
// //   }
  
// //   String dataStr;
// //   final bool isLargeData;
  
// //   // Safely convert data to string for logging
// //   try {
// //     if (data is Map || data is List) {
// //       dataStr = jsonEncode(data);
// //     } else if (data == null) {
// //       dataStr = 'null';
// //     } else {
// //       dataStr = data.toString();
// //     }
// //   } catch (e) {
// //     dataStr = '[Unserializable data: ${e.toString()}]';
// //   }
  
// //   isLargeData = dataStr.length > 200;
  
// //   // Color-coded logging based on event type
// //   String logPrefix;
// //   switch (event) {
// //     case 'connect':
// //     case 'connect_error':
// //     case 'disconnect':
// //     case 'reconnect':
// //     case 'reconnecting':
// //     case 'reconnect_failed':
// //       logPrefix = '🔗 [SOCKET]';
// //       break;
// //     case 'user:online_success':
// //     case 'driver:online_success':
// //     case 'user:online_response':
// //       logPrefix = '✅ [ONLINE]';
// //       break;
// //     case 'user:online_failed':
// //     case 'driver:online_failed':
// //       logPrefix = '❌ [ONLINE]';
// //       break;
// //     case 'ride:newRide':
// //       logPrefix = '🚕 [RIDE REQUEST]';
// //       break;
// //     case 'ride:confirmed':
// //       logPrefix = '✅ [RIDE CONFIRMED]';
// //       break;
// //     case 'ride:status':
// //       logPrefix = '📊 [RIDE STATUS]';
// //       break;
// //     case 'ride:orderCancelled':
// //       logPrefix = '❌ [RIDE CANCELLED]';
// //       break;
// //     default:
// //       logPrefix = '🔍 [UNKNOWN EVENT]';
// //   }
  
// //   // Log with appropriate detail level
// //   if (isLargeData) {
// //     print('$logPrefix $event');
// //     print('├─ First 200 chars: ${dataStr.substring(0, min(200, dataStr.length))}...');
// //     print('└─ Total length: ${dataStr.length} chars');
    
// //     // For large data, also try to extract key fields
// //     try {
// //       if (data is Map<String, dynamic>) {
// //         final Map<String, dynamic> dataMap = data;
// //         print('📋 Extracted keys: ${dataMap.keys.toList().join(', ')}');
        
// //         // Show important fields if they exist
// //         if (dataMap.containsKey('orderId')) {
// //           print('   ├─ orderId: ${dataMap['orderId']}');
// //         }
// //         if (dataMap.containsKey('status')) {
// //           print('   ├─ status: ${dataMap['status']}');
// //         }
// //         if (dataMap.containsKey('message')) {
// //           print('   ├─ message: ${dataMap['message']}');
// //         }
// //         if (dataMap.containsKey('rider')) {
// //           final rider = dataMap['rider'];
// //           if (rider is Map) {
// //             print('   └─ rider: ${rider['name'] ?? rider['_id']}');
// //           }
// //         }
// //       }
// //     } catch (e) {
// //       // Ignore extraction errors
// //     }
// //   } else {
// //     print('$logPrefix $event: $dataStr');
// //   }
  
// //   // Update socket status for UI if needed
// //   if (event == 'connect_error' || event == 'reconnect_failed') {
// //     if (mounted) {
// //       setState(() {
// //         _socketStatus = 'Error: ${dataStr.substring(0, min(50, dataStr.length))}';
// //       });
// //     }
// //   }
// // });
// //     // socket!.onAny((event, data) {
// //     //   // Skip noisy events
// //     //   if (['ping', 'pong'].contains(event)) {
// //     //     return;
// //     //   }
      
// //     //   final String dataStr;
// //     //   final bool isLargeData;
      
// //     //   // Safely convert data to string for logging
// //     //   try {
// //     //     if (data is Map || data is List) {
// //     //       dataStr = jsonEncode(data);
// //     //     } else if (data == null) {
// //     //       dataStr = 'null';
// //     //     } else {
// //     //       dataStr = data.toString();
// //     //     }
// //     //   } catch (e) {
// //     //     dataStr = '[Unserializable data: ${e.toString()}]';
// //     //   }
      
// //     //   isLargeData = dataStr.length > 200;
      
// //     //   // Color-coded logging based on event type
// //     //   String logPrefix;
// //     //   switch (event) {
// //     //     case 'connect':
// //     //     case 'connect_error':
// //     //     case 'disconnect':
// //     //     case 'reconnect':
// //     //     case 'reconnecting':
// //     //     case 'reconnect_failed':
// //     //       logPrefix = '🔗 [SOCKET]';
// //     //       break;
// //     //     case 'user:online_success':
// //     //     case 'driver:online_success':
// //     //     case 'user:online_response':
// //     //       logPrefix = '✅ [ONLINE]';
// //     //       break;
// //     //     case 'user:online_failed':
// //     //     case 'driver:online_failed':
// //     //       logPrefix = '❌ [ONLINE]';
// //     //       break;
// //     //     case 'ride:newRide':
// //     //       logPrefix = '🚕 [RIDE REQUEST]';
// //     //       break;
// //     //     case 'ride:confirmed':
// //     //       logPrefix = '✅ [RIDE CONFIRMED]';
// //     //       break;
// //     //     case 'ride:status':
// //     //       logPrefix = '📊 [RIDE STATUS]';
// //     //       break;
// //     //     case 'ride:orderCancelled':
// //     //       logPrefix = '❌ [RIDE CANCELLED]';
// //     //       break;
// //     //     default:
// //     //       logPrefix = '🔍 [UNKNOWN EVENT]';
// //     //   }
      
// //     //   // Log with appropriate detail level
// //     //   if (isLargeData) {
// //     //     print('$logPrefix $event');
// //     //     print('├─ First 200 chars: ${dataStr.substring(0, min(200, dataStr.length))}...');
// //     //     print('└─ Total length: ${dataStr.length} chars');
        
// //     //     // For large data, also try to extract key fields
// //     //     try {
// //     //       if (data is Map<String, dynamic>) {
// //     //         final Map<String, dynamic> dataMap = data;
// //     //         print('📋 Extracted keys: ${dataMap.keys.toList().join(', ')}');
            
// //     //         // Show important fields if they exist
// //     //         if (dataMap.containsKey('orderId')) {
// //     //           print('   ├─ orderId: ${dataMap['orderId']}');
// //     //         }
// //     //         if (dataMap.containsKey('status')) {
// //     //           print('   ├─ status: ${dataMap['status']}');
// //     //         }
// //     //         if (dataMap.containsKey('message')) {
// //     //           print('   ├─ message: ${dataMap['message']}');
// //     //         }
// //     //         if (dataMap.containsKey('rider')) {
// //     //           final rider = dataMap['rider'];
// //     //           if (rider is Map) {
// //     //             print('   └─ rider: ${rider['name'] ?? rider['_id']}');
// //     //           }
// //     //         }
// //     //       }
// //     //     } catch (e) {
// //     //       // Ignore extraction errors
// //     //     }
// //     //   } else {
// //     //     print('$logPrefix $event: $dataStr');
// //     //   }
      
// //     //   // Update socket status for UI if needed
// //     //   if (event == 'connect_error' || event == 'reconnect_failed') {
// //     //     if (mounted) {
// //     //       setState(() {
// //     //         _socketStatus = 'Error: ${dataStr.substring(0, min(50, dataStr.length))}';
// //     //       });
// //     //     }
// //     //   }
// //     // });
  
  
// //   }

// //   // ==================== DRIVER ONLINE/OFFLINE ====================

// //   Future<void> _goOnline() async {
// //     print('🟢 ============ GOING ONLINE PROCESS ============');

// //     if (_isProcessingOnline) {
// //       print('⏳ Already processing online request...');
// //       return;
// //     }

// //     setState(() {
// //       _isProcessingOnline = true;
// //     });

// //     // First, ensure socket is connected
// //     if (!_isSocketConnected) {
// //       print('⚠️ Socket not connected, connecting first...');
// //       await connectSocket();

// //       // Wait a bit for connection
// //       await Future.delayed(const Duration(seconds: 2));

// //       if (!_isSocketConnected) {
// //         setState(() {
// //           _isProcessingOnline = false;
// //         });
// //         _showToast('Cannot connect to server');
// //         return;
// //       }
// //     }

// //     // Now emit driver online with exact backend structure
// //     print('🚀 Sending driver online payload...');
// //     await _emitDriverOnline();

// //     print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
// //   }

// //   Future<void> _emitDriverOnline() async {
// //     try {
// //       if (socket == null || !_isSocketConnected) {
// //         print('⚠️ Socket not connected, cannot emit driver online');
// //         _showToast('Socket not connected');
// //         setState(() {
// //           _isProcessingOnline = false;
// //         });
// //         return;
// //       }

// //       print('📡 Emitting user:online event...');

// //       // Get current location
// //       await _getCurrentLocation();

// //       // ============ EXACT STRUCTURE FROM BACKEND ============
// //       final Map<String, dynamic> payload = {
// //         'latitude': _currentLatitude ?? 28.6139,
// //         'longitude': _currentLongitude ?? 77.2090,
// //         'vehicleType': _vehicleType,

// //         // Optional fields - only include if not null
// //         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
// //         if (_fleetId != null) 'fleetId': _fleetId,

// //         // Include driverId for identification
// //         'driverId': _driverId,
// //         'timestamp': DateTime.now().toIso8601String(),
// //       };

// //       print('📡 Payload structure matches backend:');
// //       print('- latitude: ${payload['latitude']}');
// //       print('- longitude: ${payload['longitude']}');
// //       print('- vehicleType: ${payload['vehicleType']}');
// //       print('- vehicleImage: ${payload['vehicleImage'] ?? 'null'}');
// //       print('- fleetId: ${payload['fleetId'] ?? 'null'}');
// //       print('- driverId: ${payload['driverId']}');
// //       print('- timestamp: ${payload['timestamp']}');

// //       // Set a timeout for the response
// //       Timer(const Duration(seconds: 10), () {
// //         if (_isProcessingOnline) {
// //           print('⏰ Online request timeout - no response from server');
// //           _handleOnlineFailure('Timeout: No response from server');
// //         }
// //       });

// //       // Emit the event
// //       print('🎯 Emitting user:online event...');
// //       socket!.emit('user:online', payload);

// //       print('⏳ Waiting for server response...');
// //     } catch (error) {
// //       print('❌ Error emitting driver online: $error');
// //       _showToast('Error going online: $error');
// //       setState(() {
// //         _isOnDuty = false;
// //         _isProcessingOnline = false;
// //       });
// //     }
// //   }

// //   void _handleOnlineSuccess(dynamic data) {
// //     if (!_isProcessingOnline) return; // Already handled

// //     print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

// //     setState(() {
// //       _isOnDuty = true;
// //       _isProcessingOnline = false;
// //     });

// //     // Extract and show success message
// //     String successMessage = 'Driver is now online';
// //     if (data is Map<String, dynamic>) {
// //       successMessage = data['message'] ?? successMessage;
// //     }

// //     _showToast(successMessage);

// //     // Start location updates every 4 seconds
// //     _startLocationUpdates();

// //     // Navigate to map screen
// //     Future.delayed(const Duration(seconds: 1), () {
// //       if (mounted) {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (context) =>
// //                 const BottomnavmainScreen(startWithMaps: true),
// //           ),
// //         );
// //       }
// //     });
// //   }

// //   void _handleOnlineFailure(dynamic data) {
// //     if (!_isProcessingOnline) return; // Already handled

// //     print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

// //     setState(() {
// //       _isOnDuty = false;
// //       _isProcessingOnline = false;
// //     });

// //     // Extract and show error message
// //     String errorMessage = 'Failed to go online';
// //     if (data is String) {
// //       errorMessage = data;
// //     } else if (data is Map<String, dynamic>) {
// //       errorMessage = data['message'] ?? data['error'] ?? errorMessage;
// //     }

// //     _showToast(errorMessage);
// //   }

// //   Future<void> _goOffline() async {
// //     try {
// //       if (socket != null && _isSocketConnected) {
// //         print('🔴 Going offline...');

// //         // Prepare offline payload with same structure
// //         final Map<String, dynamic> payload = {
// //           'latitude': _currentLatitude ?? 28.6139,
// //           'longitude': _currentLongitude ?? 77.2090,
// //           'vehicleType': _vehicleType,
// //           'driverId': _driverId,
// //           'status': 'offline',
// //           'timestamp': DateTime.now().toIso8601String(),
// //         };

// //         // Emit driver offline events
// //         socket!.emit('user:offline', payload);
// //         socket!.emit('driver:offline', payload);

// //         // Some servers might expect offline via user:online
// //         socket!.emit('user:online', {...payload, 'status': 'offline'});

// //         setState(() {
// //           _isOnDuty = false;
// //         });

// //         // Stop location updates
// //         _stopLocationUpdates();

// //         print('✅ Driver is now offline');
// //         _showToast('Driver is now offline');
// //       }
// //     } catch (error) {
// //       print('❌ Error going offline: $error');
// //     }
// //   }

// //   // ==================== RIDE MANAGEMENT ====================

// //   void _joinRideRoom(String orderId) {
// //     if (socket != null && _isSocketConnected) {
// //       socket!.emit('ride:join', {'orderId': orderId});
// //       print('🚗 Joined ride room: $orderId');
// //     }
// //   }

// //   void _completeRide(String orderId) {
// //     print('✅ Completing ride: $orderId');
// //     setState(() {
// //       _currentRide = null;
// //       _activeRideId = null;
// //       _isRideInProgress = false;
// //       _rideStartTime = null;
// //     });
// //   }

// //   // ==================== LOCATION METHODS ====================

// //   Future<void> _getCurrentLocation() async {
// //     try {
// //       // For testing: simulate location movement when online
// //       if (_isOnDuty && _currentLatitude != null && _currentLongitude != null) {
// //         // Simulate small location changes (for testing)
// //         _currentLatitude = _currentLatitude! + (_random.nextDouble() * 0.001 - 0.0005);
// //         _currentLongitude = _currentLongitude! + (_random.nextDouble() * 0.001 - 0.0005);
// //       } else {
// //         // Initial location
// //         _currentLatitude = 28.6139; // Delhi latitude
// //         _currentLongitude = 77.2090; // Delhi longitude
// //       }
      
// //       print('📍 Current location: $_currentLatitude, $_currentLongitude');
      
// //     } catch (e) {
// //       print('❌ Error getting location: $e');
// //       _currentLatitude = 28.6139;
// //       _currentLongitude = 77.2090;
// //     }
// //   }

// //   void _startLocationUpdates() {
// //     print('📍 Starting location updates every 4 seconds...');

// //     // Cancel existing timer
// //     _stopLocationUpdates();

// //     // Reset counter
// //     _locationUpdateCount = 0;
// //     _lastLocationUpdateTime = null;

// //     // Send initial location immediately
// //     _sendLocationUpdate();

// //     // Update location every 4 seconds (as per backend requirement)
// //     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
// //       if (_isOnDuty && socket != null && _isSocketConnected) {
// //         _sendLocationUpdate();
// //       } else {
// //         // Stop timer if not online or not connected
// //         print('⚠️ Stopping location updates - not online or disconnected');
// //         timer.cancel();
// //       }
// //     });
// //   }

// //   void _stopLocationUpdates() {
// //     if (_locationUpdateTimer != null) {
// //       _locationUpdateTimer!.cancel();
// //       _locationUpdateTimer = null;
      
// //       print('📍 Stopped location updates (total sent: $_locationUpdateCount)');
// //     }
// //   }

// //   Future<void> _sendLocationUpdate() async {
// //     try {
// //       if (!_isOnDuty || socket == null || !_isSocketConnected) {
// //         print('⚠️ Skipping location update - not online or disconnected');
// //         return;
// //       }

// //       _locationUpdateCount++;
// //       final now = DateTime.now();
      
// //       // Calculate time since last update
// //       if (_lastLocationUpdateTime != null) {
// //         final timeDiff = now.difference(_lastLocationUpdateTime!).inSeconds;
// //         print('⏱️ Time since last update: ${timeDiff}s');
// //       }
      
// //       _lastLocationUpdateTime = now;

// //       // Get fresh location
// //       await _getCurrentLocation();

// //       // ============ EXACT PAYLOAD STRUCTURE FROM BACKEND ============
// //       final Map<String, dynamic> locationPayload = {
// //         'latitude': _currentLatitude ?? 28.6139,
// //         'longitude': _currentLongitude ?? 77.2090,
// //         'vehicleType': _vehicleType,

// //         // Optional fields - only include if not null
// //         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
// //         if (_fleetId != null) 'fleetId': _fleetId,

// //         // Include driverId for identification
// //         'driverId': _driverId,
// //         'timestamp': now.toIso8601String(),
// //         'updateCount': _locationUpdateCount, // Track sequence
// //       };

// //       // Log summary
// //       print('📍 [Update #$_locationUpdateCount] Sending location: ${_currentLatitude}, ${_currentLongitude}');

// //       // Send location update with EXACT event name from backend
// //       print('🎯 Emitting driver:location:update event...');
// //       socket!.emit('driver:location:update', locationPayload);

// //       print('✅ Update #$_locationUpdateCount sent at ${now.toIso8601String()}');

// //     } catch (error) {
// //       print('❌ Error sending location update #$_locationUpdateCount: $error');
// //     }
// //   }

// //   // ==================== NOTIFICATIONS ====================

// //   void _showRideRequestNotification(Map<String, dynamic> rideData) {
// //     if (!mounted) return;

// //     // Extract data with null safety
// //     final riderName = rideData['rider']?['name']?.toString() ?? 'Customer';
// //     final distance = rideData['distance']?.toString() ?? '0';
// //     final fare = rideData['fare']?['total']?.toString() ?? '0';
// //     final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
// //     final orderId = rideData['orderId']?.toString() ?? '';

// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => AlertDialog(
// //         title: const Text('🚕 New Ride Request'),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Rider: $riderName'),
// //             Text('Distance: $distance km'),
// //             Text('Fare: ₹$fare'),
// //             const SizedBox(height: 10),
// //             Text('Pickup: $pickup'),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // Reject ride
// //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// //                 socket!.emit('ride:reject', {'orderId': orderId});
// //                 _showToast('Ride rejected');
// //               }
// //             },
// //             child: const Text('Reject'),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               Navigator.pop(context);
// //               // Accept ride
// //               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
// //                 socket!.emit('ride:accept', {'orderId': orderId});
// //                 print('✅ Ride accepted: $orderId');
// //                 _showToast('Ride accepted!');
// //               }
// //             },
// //             child: const Text('Accept'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showToast(String message) {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
// //     );
// //   }

// //   // ==================== UTILITY METHODS ====================

// //   void _toggleConnection() {
// //     if (_isSocketConnected) {
// //       socket?.disconnect();
// //       setState(() {
// //         _isSocketConnected = false;
// //         _socketStatus = 'Disconnecting...';
// //         _isOnDuty = false;
// //         _isProcessingOnline = false;
// //       });
// //       _showToast('Socket disconnected');
// //     } else {
// //       connectSocket();
// //       _showToast('Connecting socket...');
// //     }
// //   }

// //   void _toggleOnlineStatus() {
// //     if (_isOnDuty) {
// //       _goOffline();
// //     } else {
// //       _goOnline();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     // Stop location updates
// //     _stopLocationUpdates();
    
// //     // Disconnect socket
// //     if (socket != null) {
// //       socket!.disconnect();
// //       socket!.dispose();
// //     }
// //     super.dispose();
// //   }

// //   // ==================== UI BUILD ====================

// //   @override
// //   Widget build(BuildContext context) {
// //     double w = MediaQuery.of(context).size.width;

// //     return Scaffold(
// //       backgroundColor: AppColors.white,
// //       appBar: PreferredSize(
// //         preferredSize: Size.fromHeight(w * .300),
// //         child:
// //             Container(
// //                   height: w * .290,
// //                   decoration: BoxDecoration(
// //                     color: AppColors.white,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.grey.withOpacity(0.2),
// //                         spreadRadius: 1,
// //                         blurRadius: 2,
// //                         offset: const Offset(0, 3),
// //                       ),
// //                     ],
// //                     borderRadius: BorderRadius.only(
// //                       bottomLeft: Radius.circular(w * 0.04),
// //                       bottomRight: Radius.circular(w * 0.04),
// //                     ),
// //                   ),
// //                   child: SafeArea(
// //                     child: Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Row(
// //                             children: [
// //                               CircleAvatar(
// //                                 radius: w * 0.06,
// //                                 backgroundImage: const AssetImage(
// //                                   'assets/images/home2.png',
// //                                 ),
// //                               ),
// //                               SizedBox(width: w * 0.03),
// //                               AppFonts.textPoppins(
// //                                 context,
// //                                 "Ayaan Malviya",
// //                                 w * 0.05,
// //                                 FontWeight.w600,
// //                                 AppColors.black,
// //                                 TextAlign.left,
// //                                 TextOverflow.visible,
// //                               ),
// //                             ],
// //                           ),

// //                           Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               // Online/Offline status with toggle
// //                               GestureDetector(
// //                                 onTap: _isProcessingOnline
// //                                     ? null
// //                                     : _toggleOnlineStatus,
// //                                 child: Container(
// //                                   width: w * 0.26,
// //                                   height: w * 0.10,
// //                                   decoration: BoxDecoration(
// //                                     color: _isOnDuty
// //                                         ? const Color(0xFF34C759)
// //                                         : const Color(0xFFF26061),
// //                                     borderRadius: BorderRadius.circular(
// //                                       w * 0.06,
// //                                     ),
// //                                   ),
// //                                   alignment: Alignment.center,
// //                                   child: _isProcessingOnline
// //                                       ? SizedBox(
// //                                           width: w * 0.04,
// //                                           height: w * 0.04,
// //                                           child: CircularProgressIndicator(
// //                                             strokeWidth: 2,
// //                                             color: Colors.white,
// //                                           ),
// //                                         )
// //                                       : Text(
// //                                           _isOnDuty ? 'Online' : 'Offline',
// //                                           style: TextStyle(
// //                                             color: Colors.white,
// //                                             fontSize: w * 0.032,
// //                                             fontWeight: FontWeight.w600,
// //                                           ),
// //                                         ),
// //                                 ),
// //                               ),
// //                               SizedBox(height: w * 0.01),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 )
// //                 .animate()
// //                 .fade(duration: 800.ms, curve: Curves.easeInOut)
// //                 .scale(
// //                   begin: const Offset(0.95, 0.95),
// //                   end: const Offset(1, 1),
// //                 ),
// //       ),

// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               // Status display
// //               Container(
// //                 margin: EdgeInsets.only(bottom: w * 0.02),
// //                 padding: EdgeInsets.all(w * 0.015),
// //                 decoration: BoxDecoration(
// //                   color: _isOnDuty ? Colors.green[50] : Colors.grey[50],
// //                   borderRadius: BorderRadius.circular(w * 0.02),
// //                   border: Border.all(
// //                     color: _isOnDuty ? Colors.green : Colors.grey[300]!,
// //                   ),
// //                 ),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(
// //                       _isOnDuty ? Icons.check_circle : Icons.error_outline,
// //                       color: _isOnDuty ? Colors.green : Colors.orange,
// //                       size: w * 0.04,
// //                     ),
// //                     SizedBox(width: w * 0.02),
// //                     Expanded(
// //                       child: Text(
// //                         _isOnDuty
// //                             ? 'Online - Ready for rides'
// //                             : _isProcessingOnline
// //                             ? 'Processing online request...'
// //                             : 'Offline - Tap to go online',
// //                         style: TextStyle(
// //                           fontSize: w * 0.03,
// //                           color: _isOnDuty ? Colors.green : Colors.grey[600],
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Location Update Status (only when online)
// //               if (_isOnDuty && _locationUpdateTimer != null)
// //                 Container(
// //                   margin: EdgeInsets.only(bottom: w * 0.02),
// //                   padding: EdgeInsets.all(w * 0.015),
// //                   decoration: BoxDecoration(
// //                     color: Colors.blue[50],
// //                     borderRadius: BorderRadius.circular(w * 0.02),
// //                     border: Border.all(color: Colors.blue),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.location_on,
// //                         size: w * 0.04,
// //                         color: Colors.blue,
// //                       ),
// //                       SizedBox(width: w * 0.02),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             '📍 Location Updates Active',
// //                             style: TextStyle(
// //                               fontSize: w * 0.03,
// //                               color: Colors.blue[800],
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                           Text(
// //                             'Sending every 4 seconds',
// //                             style: TextStyle(
// //                               fontSize: w * 0.025,
// //                               color: Colors.blue[600],
// //                             ),
// //                           ),
// //                           if (_locationUpdateCount > 0)
// //                             Text(
// //                               'Sent: $_locationUpdateCount updates',
// //                               style: TextStyle(
// //                                 fontSize: w * 0.025,
// //                                 color: Colors.blue[600],
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //               // Socket Connection Info Card
// //               ExpansionTile(
// //                 title: Text('📡 Socket Debug Info', style: TextStyle(fontSize: w * 0.035)),
// //                 initiallyExpanded: false,
// //                 children: [
// //                   ListTile(
// //                     title: Text('Status: $_socketStatus'),
// //                     subtitle: Text('ID: ${_socketId.isEmpty ? "N/A" : _socketId}'),
// //                   ),
// //                   ListTile(
// //                     title: Text('Connected: $_isSocketConnected'),
// //                     subtitle: Text('On Duty: $_isOnDuty'),
// //                   ),
// //                   ListTile(
// //                     title: Text('Reconnect Attempts: $_reconnectAttempts/$_maxReconnectAttempts'),
// //                   ),
// //                   if (_currentRide != null)
// //                     ListTile(
// //                       title: Text('Active Ride: ${_currentRide!['orderId']}'),
// //                       subtitle: Text('Status: ${_currentRide!['status']}'),
// //                     ),
// //                   ListTile(
// //                     title: Text('Location Updates: $_locationUpdateCount'),
// //                   ),
// //                   ListTile(
// //                     title: Text('Average Latency: ${_averageLatency.round()}ms'),
// //                     subtitle: Text('Ping Count: $_pingCount'),
// //                   ),
// //                 ],
// //               ),

// //               // Driver status image and text
// //               SizedBox(height: w * 0.04),

// //               Image.asset("assets/images/offline_image.png"),

// //               Text(
// //                 _isOnDuty ? "You're Online" : "You're Offline",
// //                 style: TextStyle(
// //                   fontSize: w * 0.05,
// //                   fontWeight: FontWeight.bold,
// //                   color: _isOnDuty ? Colors.green : Colors.black,
// //                 ),
// //               ),

// //               Text(
// //                 _isOnDuty
// //                     ? "Ready to accept rides!"
// //                     : "Go online to start accepting rides.",
// //                 style: TextStyle(
// //                   color: const Color(0xFF5F6165),
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),

// //               SizedBox(height: w * 0.04),
// //               ElevatedButton(
// //                 onPressed: _isProcessingOnline
// //                     ? null
// //                     : () {
// //                         print("Going online button tapped");
// //                         if (_isOnDuty) {
// //                           _goOffline();
// //                         } else {
// //                           _goOnline();
// //                         }
// //                       },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: _isOnDuty
// //                       ? const Color(0xFFF26061)
// //                       : const Color(0xFF34C759),
// //                   minimumSize: const Size(double.infinity, 50),
// //                 ),
// //                 child: _isProcessingOnline
// //                     ? SizedBox(
// //                         width: w * 0.04,
// //                         height: w * 0.04,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                     : Text(
// //                         _isOnDuty ? "Go Offline" : "Go Online",
// //                         style: TextStyle(
// //                           fontSize: w * 0.04,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //               ),

// //               // Test buttons
// //               SizedBox(height: w * 0.02),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   // Test connection button
// //                   Expanded(
// //                     child: TextButton(
// //                       onPressed: () {
// //                         print('🧪 Testing socket connection...');
// //                         if (socket != null && _isSocketConnected) {
// //                           socket!.emit('test:echo', {
// //                             'message': 'Hello from Flutter driver',
// //                             'driverId': _driverId,
// //                             'timestamp': DateTime.now().toIso8601String(),
// //                           });
// //                           _showToast('Test message sent');
// //                         } else {
// //                           _showToast('Socket not connected');
// //                         }
// //                       },
// //                       child: Text(
// //                         'Test Connection',
// //                         style: TextStyle(
// //                           fontSize: w * 0.03,
// //                           color: Colors.blue,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
                  
// //                   // Test location update button
// //                   Expanded(
// //                     child: TextButton(
// //                       onPressed: () {
// //                         if (_isOnDuty) {
// //                           print('📍 Manual location update test');
// //                           _sendLocationUpdate();
// //                           _showToast('Location update sent');
// //                         } else {
// //                           _showToast('Go online first');
// //                         }
// //                       },
// //                       child: Text(
// //                         'Test Location',
// //                         style: TextStyle(
// //                           fontSize: w * 0.03,
// //                           color: Colors.purple,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               //text todays's update
// //               SizedBox(height: w * 0.05),
// //               Align(
// //                 alignment: Alignment.centerLeft,
// //                 child:
// //                     AppFonts.textPoppins(
// //                           context,
// //                           "Today's Update",
// //                           w * 0.038,
// //                           FontWeight.w600,
// //                           AppColors.black,
// //                           TextAlign.left,
// //                           TextOverflow.visible,
// //                         )
// //                         .animate()
// //                         .fade(duration: 820.ms, curve: Curves.easeInOut)
// //                         .scale(
// //                           begin: const Offset(0.95, 0.95),
// //                           end: const Offset(1, 1),
// //                         ),
// //               ),

// //               //some space
// //               SizedBox(height: w * 0.04),

// //               Column(
// //                 children: [
// //                   /// Today's Earnings (Full Width)
// //                   _elevatedBox(
// //                     shadowColor: const Color(0xFF4CAF50),
// //                     width: double.infinity,
// //                     child: Column(
// //                       children: const [
// //                         Text(
// //                           "Today's Earnings",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Color(0xFF414142),
// //                           ),
// //                         ),
// //                         SizedBox(height: 6),
// //                         Text(
// //                           "₹1000.00",
// //                           style: TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),

// //                   /// Online & Cash
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       SizedBox(
// //                         width: w * 0.45,
// //                         child: _elevatedBox(
// //                           shadowColor: const Color(0xFFFEBC2F),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: const [
// //                               Text(
// //                                 "Online",
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: Color(0xFF414142),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 4),
// //                               Text(
// //                                 "₹500 Total",
// //                                 style: TextStyle(fontWeight: FontWeight.w600),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: w * 0.02),
// //                       SizedBox(
// //                         width: w * 0.45,
// //                         child: _elevatedBox(
// //                           shadowColor: const Color(0xFF7C7C8D),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: const [
// //                               Text(
// //                                 "Cash",
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: Color(0xFF414142),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 4),
// //                               Text(
// //                                 "₹500 On Hand",
// //                                 style: TextStyle(fontWeight: FontWeight.w600),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),

// //                   SizedBox(height: w * 0.05),

// //                   /// Ride Stats
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       SizedBox(
// //                         width: w * 0.45,
// //                         child: _elevatedBox(
// //                           shadowColor: const Color(0xFF439AFE),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 "Total Rides",
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: const Color(0xFF414142),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 4),
// //                               RichText(
// //                                 text: const TextSpan(
// //                                   children: [
// //                                     TextSpan(
// //                                       text: "50",
// //                                       style: TextStyle(
// //                                         fontSize: 18,
// //                                         fontWeight: FontWeight.bold,
// //                                         color: Colors.black,
// //                                       ),
// //                                     ),
// //                                     TextSpan(
// //                                       text: " / 45 Completed",
// //                                       style: TextStyle(
// //                                         fontSize: 14,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: Colors.black,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       SizedBox(width: w * 0.02),
// //                       SizedBox(
// //                         width: w * 0.45,
// //                         child: _elevatedBox(
// //                           shadowColor: const Color(0xFFF26061),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 "Total Rides",
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: const Color(0xFF414142),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 4),
// //                               RichText(
// //                                 text: const TextSpan(
// //                                   children: [
// //                                     TextSpan(
// //                                       text: "50",
// //                                       style: TextStyle(
// //                                         fontSize: 18,
// //                                         fontWeight: FontWeight.bold,
// //                                         color: Colors.black,
// //                                       ),
// //                                     ),
// //                                     TextSpan(
// //                                       text: " / 05 Cancelled",
// //                                       style: TextStyle(
// //                                         fontSize: 14,
// //                                         fontWeight: FontWeight.w600,
// //                                         color: Colors.black,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),

// //               SizedBox(height: w * 0.04),
// //             ],
// //           ),
// //         ),
// //       ),

// //       // Floating action buttons for quick actions
// //       floatingActionButton: Column(
// //         mainAxisAlignment: MainAxisAlignment.end,
// //         children: [
// //           FloatingActionButton.small(
// //             onPressed: _toggleConnection,
// //             backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
// //             child: Icon(
// //               _isSocketConnected ? Icons.link : Icons.link_off,
// //               size: w * 0.04,
// //             ),
// //           ),
// //           SizedBox(height: w * 0.01),
// //           if (_isRideInProgress)
// //             FloatingActionButton.extended(
// //               onPressed: () {
// //                 // Complete current ride
// //                 if (_activeRideId != null) {
// //                   _completeRide(_activeRideId!);
// //                   _showToast('Ride ended');
// //                 }
// //               },
// //               backgroundColor: Colors.orange,
// //               icon: Icon(Icons.directions_car_filled, size: w * 0.04),
// //               label: Text('End Ride', style: TextStyle(fontSize: w * 0.03)),
// //             ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _elevatedBox({
// //     required Widget child,
// //     double? height,
// //     double? width,
// //     Color? shadowColor,
// //   }) {
// //     final Color shadow = shadowColor ?? Colors.black12;
// //     return Container(
// //       height: height,
// //       width: width,
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
// //         ],
// //       ),
// //       child: child,
// //     );
// //   }

// //   Widget commonWidget1(
// //     double w,
// //     Color color,
// //     String text1,
// //     String text2,
// //     String amount1,
// //     String amount2,
// //   ) {
// //     return Container(
// //       height: w * .23,
// //       width: w * .43,
// //       decoration: BoxDecoration(
// //         color: color,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.2),
// //             spreadRadius: 2,
// //             blurRadius: 3,
// //           ),
// //         ],
// //         borderRadius: BorderRadius.circular(w * 0.012),
// //       ),
// //       child: Align(
// //         alignment: Alignment.bottomRight,
// //         child: Container(
// //           height: w * .23,
// //           width: w * .423,
// //           decoration: BoxDecoration(
// //             color: AppColors.white,
// //             borderRadius: BorderRadius.circular(w * 0.012),
// //           ),
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(
// //               horizontal: w * 0.03,
// //               vertical: w * 0.03,
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Row(
// //                   children: [
// //                     AppFonts.textPoppins(
// //                       context,
// //                       "$amount1 - ",
// //                       w * 0.032,
// //                       FontWeight.w600,
// //                       AppColors.black,
// //                       TextAlign.left,
// //                       TextOverflow.visible,
// //                     ),
// //                     AppFonts.textPoppins(
// //                       context,
// //                       text1,
// //                       w * 0.028,
// //                       FontWeight.w400,
// //                       AppColors.black,
// //                       TextAlign.left,
// //                       TextOverflow.visible,
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(height: w * 0.02),
// //                 Row(
// //                   children: [
// //                     AppFonts.textPoppins(
// //                       context,
// //                       "$amount2 - ",
// //                       w * 0.028,
// //                       FontWeight.w600,
// //                       AppColors.black,
// //                       TextAlign.left,
// //                       TextOverflow.visible,
// //                     ),
// //                     AppFonts.textPoppins(
// //                       context,
// //                       text2,
// //                       w * 0.028,
// //                       FontWeight.w400,
// //                       AppColors.black,
// //                       TextAlign.left,
// //                       TextOverflow.visible,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Helper function to get minimum of two values
// // int min(int a, int b) => a < b ? a : b;




// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:corezap_driver/controllers/controllers.dart';
// import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Controllers controllers = Get.put(Controllers());
//   final HomeController homeController = Get.find<HomeController>();
//   final StepperController stepperController = Get.find<StepperController>();

//   // Socket variables
//   IO.Socket? socket;
//   bool _isSocketConnected = false;
//   bool _isOnDuty = false;
//   String _socketStatus = 'Not Connected';
//   String _socketId = '';
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;
//   Timer? _locationUpdateTimer;
//   bool _isProcessingOnline = false;

//   // Location update tracking
//   int _locationUpdateCount = 0;
//   DateTime? _lastLocationUpdateTime;
//   final Random _random = Random();

//   // Driver data
//   final String _driverId = '6968ab566bf2182c63438143';
//   final String _token =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjhhYjU2NmJmMjE4MmM2MzQzODE0MyIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg4ODQ0NjAsImV4cCI6MTc3MTQ3NjQ2MH0.TTHqv0QpsdCG-K0zCYrvDAsqOkoktcaUsHHSOZjasHc';

//   // Ride variables
//   Map<String, dynamic>? _currentRide;
//   String? _activeRideId;
//   bool _isRideInProgress = false;
//   DateTime? _rideStartTime;

//   // New Ride Request
//   Map<String, dynamic>? _newRideRequest;
//   Timer? _rideRequestTimer;
//   bool _hasPendingRideRequest = false;

//   // Location variables (mock - you'll need to implement real location)
//   double? _currentLatitude;
//   double? _currentLongitude;
//   String _vehicleType = 'Car';
//   String? _vehicleImage;
//   String? _fleetId;

//   // Connection quality monitoring
//   int _pingCount = 0;
//   DateTime? _lastPingTime;
//   double _averageLatency = 0.0;

//   @override
//   void initState() {
//     homeController.home_data_method();
//     super.initState();

//     // Start socket connection
//     connectSocket();
//   }

//   Future<void> connectSocket() async {
//     print("🔄 Starting socket connection...");

//     try {
//       // Check if already connected
//       if (socket != null && _isSocketConnected) {
//         print('✅ Socket already connected');
//         return;
//       }

//       // Dispose existing socket
//       if (socket != null) {
//         socket!.disconnect();
//         socket!.dispose();
//       }

//       print('🔌 Connecting driver socket...');
//       print('Driver ID: $_driverId');
//       print('Token: ${_token.substring(0, 20)}...');

//       // Create socket
//       socket = IO.io(
//         'https://corezap.smarttechbros.com',
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling'])
//             .enableAutoConnect()
//             .setReconnectionAttempts(_maxReconnectAttempts)
//             .setReconnectionDelay(1000)
//             .setTimeout(20000)
//             .setAuth({'token': _token})
//             .build(),
//       );

//       // Setup all event listeners
//       _setupEventListeners();

//       // Connect socket
//       socket!.connect();
//     } catch (error) {
//       print('❌ Socket connection error: $error');
//       setState(() {
//         _socketStatus = 'Connection Error';
//       });
//     }
//   }

//   void _setupEventListeners() {
//     if (socket == null) return;

//     // ==================== CONNECTION EVENTS ====================

//     socket!.onConnect((_) {
//       print('✅✅✅ DRIVER SOCKET CONNECTED: ${socket!.id}');
//       setState(() {
//         _isSocketConnected = true;
//         _socketStatus = 'Connected';
//         _socketId = socket!.id ?? '';
//         _reconnectAttempts = 0;
//       });

//       print('📡 Socket is ready for communication');
//     });

//     socket!.on('disconnect', (reason) {
//       print('❌ Driver socket disconnected: $reason');
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnected';
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });

//       // Stop location updates when disconnected
//       _stopLocationUpdates();
//       // Clear any pending ride request
//       _clearPendingRideRequest();
//     });

//     socket!.on('connect_error', (error) {
//       print('❌ Socket connection error: ${error.toString()}');
//       _reconnectAttempts++;
//       setState(() {
//         _socketStatus = 'Connection Error';
//       });
//     });

//     socket!.on('reconnect', (attemptNumber) {
//       print('🔄 Socket reconnected after $attemptNumber attempts');
//       setState(() {
//         _reconnectAttempts = 0;
//       });
//     });

//     // Reconnecting events for better feedback
//     socket!.on('reconnecting', (attemptNumber) {
//       print('🔄 Socket reconnecting... Attempt $attemptNumber');
//       setState(() {
//         _socketStatus = 'Reconnecting...';
//         _reconnectAttempts = attemptNumber;
//       });
//     });

//     socket!.on('reconnect_failed', (data) {
//       print('❌ Socket reconnection failed after $_maxReconnectAttempts attempts: $data');
//       setState(() {
//         _socketStatus = 'Connection Failed';
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });
//       _showToast('Failed to reconnect. Please check your internet.');
//     });

//     // ==================== PING/PONG FOR LATENCY ====================

//     socket!.on('ping', (_) {
//       _lastPingTime = DateTime.now();
//       _pingCount++;
//       print('📡 Ping received (#$_pingCount)');
//     });

//     socket!.on('pong', (_) {
//       if (_lastPingTime != null) {
//         final latency = DateTime.now().difference(_lastPingTime!).inMilliseconds;
//         _averageLatency = (_averageLatency * 0.8) + (latency * 0.2);
//         print('📶 Socket latency: ${latency}ms (avg: ${_averageLatency.round()}ms)');
//       }
//     });

//     // ==================== DRIVER ONLINE RESPONSE EVENTS ====================

//     // Listen for successful online response
//     socket!.on('user:online_success', (dynamic data) {
//       print('✅✅✅ DRIVER ONLINE SUCCESS: $data');
//       _handleOnlineSuccess(data);
//     });

//     // Listen for failed online response
//     socket!.on('user:online_failed', (dynamic data) {
//       print('❌❌❌ DRIVER ONLINE FAILED: $data');
//       _handleOnlineFailure(data);
//     });

//     // Alternative event names that might be used by backend
//     socket!.on('driver:online_success', (dynamic data) {
//       print('✅✅✅ DRIVER ONLINE SUCCESS (alternative event): $data');
//       _handleOnlineSuccess(data);
//     });

//     socket!.on('driver:online_failed', (dynamic data) {
//       print('❌❌❌ DRIVER ONLINE FAILED (alternative event): $data');
//       _handleOnlineFailure(data);
//     });

//     // Generic response handler
//     socket!.on('user:online_response', (dynamic data) {
//       print('📨 GENERIC ONLINE RESPONSE: $data');
//       final response = Map<String, dynamic>.from(data);

//       if (response['status'] == 'success' || response['success'] == true) {
//         print('✅ Online status: Success');
//         _handleOnlineSuccess(data);
//       } else {
//         print('❌ Online status: Failed');
//         _handleOnlineFailure(data);
//       }
//     });

//     // ==================== RIDE REQUEST EVENTS ====================

//     socket!.on('ride:newRide', (dynamic data) {
//       print('🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕');
//       print('🚕 NEW RIDE REQUEST RECEIVED - AUTOMATICALLY TRIGGERED');
//       print('🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕🚕');

//       try {
//         // Cast data to Map<String, dynamic> first
//         final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

//         // Print complete ride data
//         print('📋 COMPLETE RIDE DATA RECEIVED:');
//         print(jsonEncode(rideData));

//         // Extract and print key information based on backend structure
//         print('\n📋 KEY RIDE INFORMATION (From Backend Structure):');
//         print('├─ Ride ID: ${rideData['rideId'] ?? 'N/A'}');
//         print('├─ Order ID: ${rideData['orderId'] ?? rideData['rideId'] ?? 'N/A'}');
//         print('├─ Rider ID: ${rideData['riderId'] ?? 'N/A'}');
//         print('├─ Rider Name: ${rideData['riderName'] ?? 'N/A'}');
//         print('├─ Rider Phone: ${rideData['riderNumber'] ?? 'N/A'}');
//         print('├─ Pickup Address: ${rideData['pickup'] ?? 'N/A'}');
//         print('├─ Destination: ${rideData['destination'] ?? 'N/A'}');
//         print('├─ Ride Type: ${rideData['rideType'] ?? 'N/A'}');
        
//         // Location coordinates
//         if (rideData['startLocation'] != null) {
//           final startLoc = rideData['startLocation'];
//           if (startLoc is Map) {
//             print('├─ Start Location (Coordinates):');
//             print('│  ├─ Latitude: ${startLoc['latitude'] ?? startLoc['lat'] ?? 'N/A'}');
//             print('│  └─ Longitude: ${startLoc['longitude'] ?? startLoc['lng'] ?? 'N/A'}');
//           }
//         }
        
//         if (rideData['endLocation'] != null) {
//           final endLoc = rideData['endLocation'];
//           if (endLoc is Map) {
//             print('├─ End Location (Coordinates):');
//             print('│  ├─ Latitude: ${endLoc['latitude'] ?? endLoc['lat'] ?? 'N/A'}');
//             print('│  └─ Longitude: ${endLoc['longitude'] ?? endLoc['lng'] ?? 'N/A'}');
//           }
//         }
        
//         // Fare information
//         print('├─ Total Fare: ₹${rideData['totalFare'] ?? '0'}');
//         print('├─ Distance: ${rideData['distance'] ?? 'N/A'} km');
//         print('├─ Driver Distance: ${rideData['driverDistance'] ?? 'N/A'} km');
        
//         // Discount information
//         if (rideData['discount'] != null) {
//           print('├─ Discount: ₹${rideData['discount']}');
//         }
        
//         // Timing information
//         print('├─ Timestamp: ${DateTime.fromMillisecondsSinceEpoch(rideData['timestamp'] ?? 0)}');
//         print('└─ Timeout (seconds): ${rideData['timeout'] ?? 'N/A'}');
        
//         // Calculate and show time remaining for response
//         if (rideData['timestamp'] != null && rideData['timeout'] != null) {
//           final requestTime = DateTime.fromMillisecondsSinceEpoch(rideData['timestamp']);
//           final timeoutSeconds = rideData['timeout']?.toDouble() ?? 30.0;
//           final expiryTime = requestTime.add(Duration(seconds: timeoutSeconds.toInt()));
//           final timeRemaining = expiryTime.difference(DateTime.now()).inSeconds;
          
//           print('\n⏰ TIME REMAINING TO RESPOND: ${timeRemaining} seconds');
//           print('⏰ Request expires at: ${expiryTime.toLocal()}');
//         }

//         // Map socket data to expected format for notification
//         final Map<String, dynamic> mappedData = {
//           ...rideData,
//           'orderId': rideData['rideId'] ?? rideData['orderId'] ?? 'unknown',
//           'rider': {
//             'name': rideData['riderName'] ?? 'Customer',
//             'phone': rideData['riderNumber'] ?? '',
//             '_id': rideData['riderId'],
//           },
//           'fare': {'total': rideData['totalFare'] ?? '0'},
//           'pickup': rideData['pickup'] ?? 'Location not specified',
//           'dropoff': rideData['destination'] ?? 'Destination not specified',
//           'distance': rideData['distance'] ?? '0',
//           'startLocation': rideData['startLocation'],
//           'endLocation': rideData['endLocation'],
//           'rideType': rideData['rideType'],
//           'driverDistance': rideData['driverDistance'],
//           'discount': rideData['discount'],
//           'timestamp': rideData['timestamp'],
//           'timeout': rideData['timeout'],
//         };

//         // Store the new ride request
//         setState(() {
//           _newRideRequest = mappedData;
//           _hasPendingRideRequest = true;
//         });

//         // Show ride request notification
//         _showRideRequestNotification(mappedData);

//         // Auto-reject based on backend timeout or default 30 seconds
//         final timeoutSeconds = rideData['timeout']?.toDouble() ?? 30.0;
//         _startRideRequestTimer(mappedData['orderId'], timeoutSeconds);

//         print('✅ New ride request stored and notification shown');
//         print('⏰ Auto-reject timer started (${timeoutSeconds} seconds)');

//       } catch (error) {
//         print('❌ Error processing new ride request: $error');
//         print('Raw data received: $data');
//       }
//     });

//     socket!.on('ride:confirmed', (dynamic data) {
//       print('✅ Ride accepted - Backend confirmed');

//       // Clear any pending ride request
//       _clearPendingRideRequest();

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
//       final orderId = rideData['orderId'] ?? rideData['_id'] ?? 'unknown';
//       print('- Order ID: $orderId');
//       print(
//         '- Rider: ${rideData['rider']?['name'] ?? rideData['user']?['name']}',
//       );
//       print('- Fare: ${rideData['fare'] ?? rideData['totalFare']}');

//       // Update current ride state
//       _currentRide = {
//         'orderId': orderId,
//         'status': 'confirmed',
//         'rider': rideData['rider'] ?? rideData['user'],
//         'pickup': rideData['pickupLocation'] ?? rideData['startLocation'],
//         'dropoff': rideData['dropoffLocation'] ?? rideData['endLocation'],
//         'fare': rideData['fare'] ?? rideData['totalFare'],
//         'distance': rideData['distance'],
//         'duration': rideData['duration'] ?? rideData['estimatedTime'],
//         'otp': rideData['otp'],
//         'completeData': rideData,
//       };

//       setState(() {
//         _activeRideId = orderId;
//         _isRideInProgress = true;
//         _rideStartTime = DateTime.now();
//         _newRideRequest = null;
//         _hasPendingRideRequest = false;
//       });

//       print('🚗 Ride state updated to CONFIRMED');
//       _showToast(
//         'Ride confirmed with ${rideData['rider']?['name'] ?? 'rider'}',
//       );

//       // Join ride room for real-time updates
//       _joinRideRoom(orderId);
//     });

//     socket!.on('ride:status', (dynamic data) {
//       print('📊 Ride status update: $data');

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> statusData = Map<String, dynamic>.from(data);

//       if (_currentRide != null &&
//           _currentRide!['orderId'] == statusData['orderId']) {
//         _currentRide!['status'] = statusData['status'];

//         // Mark ride as complete
//         if (statusData['status'] == 'completed' ||
//             statusData['status'] == 'finished' ||
//             statusData['status'] == 'ended') {
//           print('✅ Ride completion status received: ${statusData['status']}');
//           _completeRide(statusData['orderId']);
//           _showToast('Ride completed successfully');
//         }
//       }
//     });

//     socket!.on('ride:orderCancelled', (dynamic data) {
//       print('❌ Ride cancelled: $data');

//       // Clear any pending ride request
//       _clearPendingRideRequest();

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
//       _completeRide(cancelData['orderId']);

//       setState(() {
//         _currentRide = null;
//         _isRideInProgress = false;
//         _newRideRequest = null;
//         _hasPendingRideRequest = false;
//       });

//       _showToast('Ride was cancelled');
//     });

//     // ==================== DEBUG ALL EVENTS ====================

//     socket!.onAny((event, data) {
//       // Skip noisy events
//       if (['ping', 'pong'].contains(event)) {
//         return;
//       }
      
//       String dataStr;
//       final bool isLargeData;
      
//       // Safely convert data to string for logging
//       try {
//         if (data is Map || data is List) {
//           dataStr = jsonEncode(data);
//         } else if (data == null) {
//           dataStr = 'null';
//         } else {
//           dataStr = data.toString();
//         }
//       } catch (e) {
//         dataStr = '[Unserializable data: ${e.toString()}]';
//       }
      
//       isLargeData = dataStr.length > 200;
      
//       // Color-coded logging based on event type
//       String logPrefix;
//       switch (event) {
//         case 'connect':
//         case 'connect_error':
//         case 'disconnect':
//         case 'reconnect':
//         case 'reconnecting':
//         case 'reconnect_failed':
//           logPrefix = '🔗 [SOCKET]';
//           break;
//         case 'user:online_success':
//         case 'driver:online_success':
//         case 'user:online_response':
//           logPrefix = '✅ [ONLINE]';
//           break;
//         case 'user:online_failed':
//         case 'driver:online_failed':
//           logPrefix = '❌ [ONLINE]';
//           break;
//         case 'ride:newRide':
//           logPrefix = '🚕 [RIDE REQUEST]';
//           break;
//         case 'ride:confirmed':
//           logPrefix = '✅ [RIDE CONFIRMED]';
//           break;
//         case 'ride:status':
//           logPrefix = '📊 [RIDE STATUS]';
//           break;
//         case 'ride:orderCancelled':
//           logPrefix = '❌ [RIDE CANCELLED]';
//           break;
//         default:
//           logPrefix = '🔍 [UNKNOWN EVENT]';
//       }
      
//       // Log with appropriate detail level
//       if (isLargeData) {
//         print('$logPrefix $event');
//         print('├─ First 200 chars: ${dataStr.substring(0, min(200, dataStr.length))}...');
//         print('└─ Total length: ${dataStr.length} chars');
        
//         // For large data, also try to extract key fields
//         try {
//           if (data is Map<String, dynamic>) {
//             final Map<String, dynamic> dataMap = data;
//             print('📋 Extracted keys: ${dataMap.keys.toList().join(', ')}');
            
//             // Show important fields if they exist
//             if (dataMap.containsKey('orderId')) {
//               print('   ├─ orderId: ${dataMap['orderId']}');
//             }
//             if (dataMap.containsKey('status')) {
//               print('   ├─ status: ${dataMap['status']}');
//             }
//             if (dataMap.containsKey('message')) {
//               print('   ├─ message: ${dataMap['message']}');
//             }
//             if (dataMap.containsKey('rider')) {
//               final rider = dataMap['rider'];
//               if (rider is Map) {
//                 print('   └─ rider: ${rider['name'] ?? rider['_id']}');
//               }
//             }
//           }
//         } catch (e) {
//           // Ignore extraction errors
//         }
//       } else {
//         print('$logPrefix $event: $dataStr');
//       }
      
//       // Update socket status for UI if needed
//       if (event == 'connect_error' || event == 'reconnect_failed') {
//         if (mounted) {
//           setState(() {
//             _socketStatus = 'Error: ${dataStr.substring(0, min(50, dataStr.length))}';
//           });
//         }
//       }
//     });
//   }

//   // ==================== RIDE REQUEST TIMER ====================

//   void _startRideRequestTimer(String orderId, double timeoutSeconds) {
//     // Clear existing timer
//     _clearRideRequestTimer();
    
//     // Convert to integer seconds
//     final seconds = timeoutSeconds.toInt();
    
//     // Start new timer
//     _rideRequestTimer = Timer(Duration(seconds: seconds), () {
//       if (_hasPendingRideRequest && _newRideRequest != null) {
//         print('⏰ Auto-rejecting ride request after $seconds seconds: $orderId');
        
//         // Reject the ride
//         if (socket != null && _isSocketConnected) {
//           socket!.emit('ride:reject', {'orderId': orderId});
//           _showToast('Ride request auto-rejected (timeout)');
//         }
        
//         // Clear the pending request
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
//     if (!_isSocketConnected) {
//       print('⚠️ Socket not connected, connecting first...');
//       await connectSocket();

//       // Wait a bit for connection
//       await Future.delayed(const Duration(seconds: 2));

//       if (!_isSocketConnected) {
//         setState(() {
//           _isProcessingOnline = false;
//         });
//         _showToast('Cannot connect to server');
//         return;
//       }
//     }

//     // Now emit driver online with exact backend structure
//     print('🚀 Sending driver online payload...');
//     await _emitDriverOnline();

//     print('✅ ============ GO ONLINE PROCESS COMPLETE ============');
//   }

//   Future<void> _emitDriverOnline() async {
//     try {
//       if (socket == null || !_isSocketConnected) {
//         print('⚠️ Socket not connected, cannot emit driver online');
//         _showToast('Socket not connected');
//         setState(() {
//           _isProcessingOnline = false;
//         });
//         return;
//       }

//       print('📡 Emitting user:online event...');

//       // Get current location
//       await _getCurrentLocation();

//       // ============ EXACT STRUCTURE FROM BACKEND ============
//       final Map<String, dynamic> payload = {
//         'latitude': _currentLatitude ?? 28.6139,
//         'longitude': _currentLongitude ?? 77.2090,
//         'vehicleType': _vehicleType,

//         // Optional fields - only include if not null
//         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
//         if (_fleetId != null) 'fleetId': _fleetId,

//         // Include driverId for identification
//         'driverId': _driverId,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       print('📡 Payload structure matches backend:');
//       print('- latitude: ${payload['latitude']}');
//       print('- longitude: ${payload['longitude']}');
//       print('- vehicleType: ${payload['vehicleType']}');
//       print('- vehicleImage: ${payload['vehicleImage'] ?? 'null'}');
//       print('- fleetId: ${payload['fleetId'] ?? 'null'}');
//       print('- driverId: ${payload['driverId']}');
//       print('- timestamp: ${payload['timestamp']}');

//       // Set a timeout for the response
//       Timer(const Duration(seconds: 10), () {
//         if (_isProcessingOnline) {
//           print('⏰ Online request timeout - no response from server');
//           _handleOnlineFailure('Timeout: No response from server');
//         }
//       });

//       // Emit the event
//       print('🎯 Emitting user:online event...');
//       socket!.emit('user:online', payload);

//       print('⏳ Waiting for server response...');
//     } catch (error) {
//       print('❌ Error emitting driver online: $error');
//       _showToast('Error going online: $error');
//       setState(() {
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });
//     }
//   }

//   void _handleOnlineSuccess(dynamic data) {
//     if (!_isProcessingOnline) return; // Already handled

//     print('✅✅✅ DRIVER ONLINE SUCCESS HANDLED');

//     setState(() {
//       _isOnDuty = true;
//       _isProcessingOnline = false;
//     });

//     // Extract and show success message
//     String successMessage = 'Driver is now online';
//     if (data is Map<String, dynamic>) {
//       successMessage = data['message'] ?? successMessage;
//     }

//     _showToast(successMessage);

//     // Start location updates every 4 seconds
//     _startLocationUpdates();

//     // Navigate to map screen
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 const BottomnavmainScreen(startWithMaps: true),
//           ),
//         );
//       }
//     });
//   }

//   void _handleOnlineFailure(dynamic data) {
//     if (!_isProcessingOnline) return; // Already handled

//     print('❌❌❌ DRIVER ONLINE FAILED HANDLED');

//     setState(() {
//       _isOnDuty = false;
//       _isProcessingOnline = false;
//     });

//     // Extract and show error message
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
//       if (socket != null && _isSocketConnected) {
//         print('🔴 Going offline...');

//         // Clear any pending ride request
//         _clearPendingRideRequest();

//         // Prepare offline payload with same structure
//         final Map<String, dynamic> payload = {
//           'latitude': _currentLatitude ?? 28.6139,
//           'longitude': _currentLongitude ?? 77.2090,
//           'vehicleType': _vehicleType,
//           'driverId': _driverId,
//           'status': 'offline',
//           'timestamp': DateTime.now().toIso8601String(),
//         };

//         // Emit driver offline events
//         socket!.emit('user:offline', payload);
//         socket!.emit('driver:offline', payload);

//         // Some servers might expect offline via user:online
//         socket!.emit('user:online', {...payload, 'status': 'offline'});

//         setState(() {
//           _isOnDuty = false;
//         });

//         // Stop location updates
//         _stopLocationUpdates();

//         print('✅ Driver is now offline');
//         _showToast('Driver is now offline');
//       }
//     } catch (error) {
//       print('❌ Error going offline: $error');
//     }
//   }

//   // ==================== RIDE MANAGEMENT ====================

//   void _joinRideRoom(String orderId) {
//     if (socket != null && _isSocketConnected) {
//       socket!.emit('ride:join', {'orderId': orderId});
//       print('🚗 Joined ride room: $orderId');
//     }
//   }

//   void _completeRide(String orderId) {
//     print('✅ Completing ride: $orderId');
//     setState(() {
//       _currentRide = null;
//       _activeRideId = null;
//       _isRideInProgress = false;
//       _rideStartTime = null;
//     });
//   }

//   // ==================== LOCATION METHODS ====================

//   Future<void> _getCurrentLocation() async {
//     try {
//       // For testing: simulate location movement when online
//       if (_isOnDuty && _currentLatitude != null && _currentLongitude != null) {
//         // Simulate small location changes (for testing)
//         _currentLatitude = _currentLatitude! + (_random.nextDouble() * 0.001 - 0.0005);
//         _currentLongitude = _currentLongitude! + (_random.nextDouble() * 0.001 - 0.0005);
//       } else {
//         // Initial location
//         _currentLatitude = 28.6139; // Delhi latitude
//         _currentLongitude = 77.2090; // Delhi longitude
//       }
      
//       print('📍 Current location: $_currentLatitude, $_currentLongitude');
      
//     } catch (e) {
//       print('❌ Error getting location: $e');
//       _currentLatitude = 28.6139;
//       _currentLongitude = 77.2090;
//     }
//   }

//   void _startLocationUpdates() {
//     print('📍 Starting location updates every 4 seconds...');

//     // Cancel existing timer
//     _stopLocationUpdates();

//     // Reset counter
//     _locationUpdateCount = 0;
//     _lastLocationUpdateTime = null;

//     // Send initial location immediately
//     _sendLocationUpdate();

//     // Update location every 4 seconds (as per backend requirement)
//     _locationUpdateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       if (_isOnDuty && socket != null && _isSocketConnected) {
//         _sendLocationUpdate();
//       } else {
//         // Stop timer if not online or not connected
//         print('⚠️ Stopping location updates - not online or disconnected');
//         timer.cancel();
//       }
//     });
//   }

//   void _stopLocationUpdates() {
//     if (_locationUpdateTimer != null) {
//       _locationUpdateTimer!.cancel();
//       _locationUpdateTimer = null;
      
//       print('📍 Stopped location updates (total sent: $_locationUpdateCount)');
//     }
//   }

//   Future<void> _sendLocationUpdate() async {
//     try {
//       if (!_isOnDuty || socket == null || !_isSocketConnected) {
//         print('⚠️ Skipping location update - not online or disconnected');
//         return;
//       }

//       _locationUpdateCount++;
//       final now = DateTime.now();
      
//       // Calculate time since last update
//       if (_lastLocationUpdateTime != null) {
//         final timeDiff = now.difference(_lastLocationUpdateTime!).inSeconds;
//         print('⏱️ Time since last update: ${timeDiff}s');
//       }
      
//       _lastLocationUpdateTime = now;

//       // Get fresh location
//       await _getCurrentLocation();

//       // ============ EXACT PAYLOAD STRUCTURE FROM BACKEND ============
//       final Map<String, dynamic> locationPayload = {
//         'latitude': _currentLatitude ?? 28.6139,
//         'longitude': _currentLongitude ?? 77.2090,
//         'vehicleType': _vehicleType,

//         // Optional fields - only include if not null
//         if (_vehicleImage != null) 'vehicleImage': _vehicleImage,
//         if (_fleetId != null) 'fleetId': _fleetId,

//         // Include driverId for identification
//         'driverId': _driverId,
//         'timestamp': now.toIso8601String(),
//         'updateCount': _locationUpdateCount, // Track sequence
//       };

//       // Log summary
//       print('📍 [Update #$_locationUpdateCount] Sending location: ${_currentLatitude}, ${_currentLongitude}');

//       // Send location update with EXACT event name from backend
//       print('🎯 Emitting driver:location:update event...');
//       socket!.emit('driver:location:update', locationPayload);

//       print('✅ Update #$_locationUpdateCount sent at ${now.toIso8601String()}');

//     } catch (error) {
//       print('❌ Error sending location update #$_locationUpdateCount: $error');
//     }
//   }

//   // ==================== NOTIFICATIONS ====================

//   void _showRideRequestNotification(Map<String, dynamic> rideData) {
//     if (!mounted) return;

//     // Extract data with null safety based on backend structure
//     final riderName = rideData['riderName']?.toString() ?? rideData['rider']?['name']?.toString() ?? 'Customer';
//     final riderPhone = rideData['riderNumber']?.toString() ?? rideData['rider']?['phone']?.toString() ?? '';
//     final distance = rideData['distance']?.toString() ?? '0';
//     final driverDistance = rideData['driverDistance']?.toString() ?? '0';
//     final fare = rideData['totalFare']?.toString() ?? rideData['fare']?['total']?.toString() ?? '0';
//     final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
//     final destination = rideData['destination']?.toString() ?? rideData['dropoff']?.toString() ?? 'Destination not specified';
//     final orderId = rideData['rideId']?.toString() ?? rideData['orderId']?.toString() ?? '';
//     final rideType = rideData['rideType']?.toString() ?? 'Standard';
//     final discount = rideData['discount']?.toString() ?? '0';
    
//     // Calculate time remaining
//     String timeRemaining = '30s';
//     if (rideData['timestamp'] != null && rideData['timeout'] != null) {
//       final requestTime = DateTime.fromMillisecondsSinceEpoch(rideData['timestamp']);
//       final timeoutSeconds = rideData['timeout']?.toDouble() ?? 30.0;
//       final expiryTime = requestTime.add(Duration(seconds: timeoutSeconds.toInt()));
//       final remaining = expiryTime.difference(DateTime.now()).inSeconds;
//       timeRemaining = '${remaining}s';
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.local_taxi, color: Colors.green),
//             SizedBox(width: 10),
//             Text('🚕 New Ride Request'),
//             Spacer(),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.orange,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 timeRemaining,
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Rider Information
//               ListTile(
//                 leading: CircleAvatar(
//                   child: Text(riderName.substring(0, 1).toUpperCase()),
//                 ),
//                 title: Text(riderName, style: TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Text(riderPhone),
//               ),
              
//               Divider(),
              
//               // Fare Information
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Fare', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       Text('₹$fare', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Distance', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       Text('$distance km', style: TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Ride Type', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                       Text(rideType, style: TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 16),
              
//               // Pickup Location
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.location_on, color: Colors.green, size: 20),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Pickup', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                         Text(pickup, style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 8),
              
//               // Destination
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.location_on, color: Colors.red, size: 20),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Destination', style: TextStyle(fontSize: 12, color: Colors.grey)),
//                         Text(destination, style: TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
              
//               SizedBox(height: 8),
              
//               // Additional Info
//               if (driverDistance != '0')
//                 Text('You are $driverDistance km away', style: TextStyle(fontSize: 12, color: Colors.blue)),
              
//               if (discount != '0')
//                 Text('Discount: ₹$discount applied', style: TextStyle(fontSize: 12, color: Colors.green)),
              
//               SizedBox(height: 16),
              
//               // Order ID
//               Text(
//                 'Order ID: $orderId',
//                 style: TextStyle(fontSize: 10, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Reject ride
//               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
//                 socket!.emit('ride:reject', {'orderId': orderId});
//                 _showToast('Ride rejected');
//                 _clearPendingRideRequest();
//               }
//             },
//             child: Text('Reject', style: TextStyle(color: Colors.red)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Accept ride
//               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
//                 socket!.emit('ride:accept', {'orderId': orderId});
//                 print('✅ Ride accepted: $orderId');
//                 _showToast('Ride accepted!');
//                 _clearPendingRideRequest();
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: Text('Accept'),
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
//     if (_isSocketConnected) {
//       socket?.disconnect();
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnecting...';
//         _isOnDuty = false;
//         _isProcessingOnline = false;
//       });
//       _showToast('Socket disconnected');
//     } else {
//       connectSocket();
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

//   @override
//   void dispose() {
//     // Stop location updates
//     _stopLocationUpdates();
    
//     // Clear ride request timer
//     _clearRideRequestTimer();
    
//     // Disconnect socket
//     if (socket != null) {
//       socket!.disconnect();
//       socket!.dispose();
//     }
//     super.dispose();
//   }

//   // ==================== UI BUILD ====================

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(w * .300),
//         child:
//             Container(
//                   height: w * .290,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 1,
//                         blurRadius: 2,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(w * 0.04),
//                       bottomRight: Radius.circular(w * 0.04),
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: w * 0.06,
//                                 backgroundImage: const AssetImage(
//                                   'assets/images/home2.png',
//                                 ),
//                               ),
//                               SizedBox(width: w * 0.03),
//                               AppFonts.textPoppins(
//                                 context,
//                                 "Ayaan Malviya",
//                                 w * 0.05,
//                                 FontWeight.w600,
//                                 AppColors.black,
//                                 TextAlign.left,
//                                 TextOverflow.visible,
//                               ),
//                             ],
//                           ),

//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Online/Offline status with toggle
//                               GestureDetector(
//                                 onTap: _isProcessingOnline
//                                     ? null
//                                     : _toggleOnlineStatus,
//                                 child: Container(
//                                   width: w * 0.26,
//                                   height: w * 0.10,
//                                   decoration: BoxDecoration(
//                                     color: _isOnDuty
//                                         ? const Color(0xFF34C759)
//                                         : const Color(0xFFF26061),
//                                     borderRadius: BorderRadius.circular(
//                                       w * 0.06,
//                                     ),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: _isProcessingOnline
//                                       ? SizedBox(
//                                           width: w * 0.04,
//                                           height: w * 0.04,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       : Text(
//                                           _isOnDuty ? 'Online' : 'Offline',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: w * 0.032,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                               SizedBox(height: w * 0.01),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//                 .animate()
//                 .fade(duration: 800.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//       ),

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Status display
//               Container(
//                 margin: EdgeInsets.only(bottom: w * 0.02),
//                 padding: EdgeInsets.all(w * 0.015),
//                 decoration: BoxDecoration(
//                   color: _isOnDuty ? Colors.green[50] : Colors.grey[50],
//                   borderRadius: BorderRadius.circular(w * 0.02),
//                   border: Border.all(
//                     color: _isOnDuty ? Colors.green : Colors.grey[300]!,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _isOnDuty ? Icons.check_circle : Icons.error_outline,
//                       color: _isOnDuty ? Colors.green : Colors.orange,
//                       size: w * 0.04,
//                     ),
//                     SizedBox(width: w * 0.02),
//                     Expanded(
//                       child: Text(
//                         _isOnDuty
//                             ? 'Online - Ready for rides'
//                             : _isProcessingOnline
//                             ? 'Processing online request...'
//                             : 'Offline - Tap to go online',
//                         style: TextStyle(
//                           fontSize: w * 0.03,
//                           color: _isOnDuty ? Colors.green : Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Pending Ride Request Indicator
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
//                       Icon(
//                         Icons.local_taxi,
//                         color: Colors.orange,
//                         size: w * 0.04,
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '🚕 Pending Ride Request',
//                               style: TextStyle(
//                                 fontSize: w * 0.03,
//                                 color: Colors.orange[800],
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               'Tap to view details',
//                               style: TextStyle(
//                                 fontSize: w * 0.025,
//                                 color: Colors.orange[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.visibility, size: w * 0.04),
//                         onPressed: () {
//                           _showRideRequestNotification(_newRideRequest!);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//               // Location Update Status (only when online)
//               if (_isOnDuty && _locationUpdateTimer != null)
//                 Container(
//                   margin: EdgeInsets.only(bottom: w * 0.02),
//                   padding: EdgeInsets.all(w * 0.015),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     borderRadius: BorderRadius.circular(w * 0.02),
//                     border: Border.all(color: Colors.blue),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: w * 0.04,
//                         color: Colors.blue,
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '📍 Location Updates Active',
//                             style: TextStyle(
//                               fontSize: w * 0.03,
//                               color: Colors.blue[800],
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             'Sending every 4 seconds',
//                             style: TextStyle(
//                               fontSize: w * 0.025,
//                               color: Colors.blue[600],
//                             ),
//                           ),
//                           if (_locationUpdateCount > 0)
//                             Text(
//                               'Sent: $_locationUpdateCount updates',
//                               style: TextStyle(
//                                 fontSize: w * 0.025,
//                                 color: Colors.blue[600],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//               // Socket Connection Info Card
//               ExpansionTile(
//                 title: Text('📡 Socket Debug Info', style: TextStyle(fontSize: w * 0.035)),
//                 initiallyExpanded: false,
//                 children: [
//                   ListTile(
//                     title: Text('Status: $_socketStatus'),
//                     subtitle: Text('ID: ${_socketId.isEmpty ? "N/A" : _socketId}'),
//                   ),
//                   ListTile(
//                     title: Text('Connected: $_isSocketConnected'),
//                     subtitle: Text('On Duty: $_isOnDuty'),
//                   ),
//                   ListTile(
//                     title: Text('Reconnect Attempts: $_reconnectAttempts/$_maxReconnectAttempts'),
//                   ),
//                   if (_currentRide != null)
//                     ListTile(
//                       title: Text('Active Ride: ${_currentRide!['orderId']}'),
//                       subtitle: Text('Status: ${_currentRide!['status']}'),
//                     ),
//                   ListTile(
//                     title: Text('Location Updates: $_locationUpdateCount'),
//                   ),
//                   ListTile(
//                     title: Text('Average Latency: ${_averageLatency.round()}ms'),
//                     subtitle: Text('Ping Count: $_pingCount'),
//                   ),
//                   if (_hasPendingRideRequest)
//                     ListTile(
//                       title: Text('Pending Ride Request', style: TextStyle(color: Colors.orange)),
//                       subtitle: Text('Order ID: ${_newRideRequest?['orderId']}'),
//                     ),
//                 ],
//               ),

//               // Driver status image and text
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
//                 _isOnDuty
//                     ? "Ready to accept rides!"
//                     : "Go online to start accepting rides.",
//                 style: TextStyle(
//                   color: const Color(0xFF5F6165),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(height: w * 0.04),
//               ElevatedButton(
//                 onPressed: _isProcessingOnline
//                     ? null
//                     : () {
//                         print("Going online button tapped");
//                         if (_isOnDuty) {
//                           _goOffline();
//                         } else {
//                           _goOnline();
//                         }
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _isOnDuty
//                       ? const Color(0xFFF26061)
//                       : const Color(0xFF34C759),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: _isProcessingOnline
//                     ? SizedBox(
//                         width: w * 0.04,
//                         height: w * 0.04,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Text(
//                         _isOnDuty ? "Go Offline" : "Go Online",
//                         style: TextStyle(
//                           fontSize: w * 0.04,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),

//               // Test buttons
//               SizedBox(height: w * 0.02),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Test connection button
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         print('🧪 Testing socket connection...');
//                         if (socket != null && _isSocketConnected) {
//                           socket!.emit('test:echo', {
//                             'message': 'Hello from Flutter driver',
//                             'driverId': _driverId,
//                             'timestamp': DateTime.now().toIso8601String(),
//                           });
//                           _showToast('Test message sent');
//                         } else {
//                           _showToast('Socket not connected');
//                         }
//                       },
//                       child: Text(
//                         'Test Connection',
//                         style: TextStyle(
//                           fontSize: w * 0.03,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ),
                  
//                   // Test location update button
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         if (_isOnDuty) {
//                           print('📍 Manual location update test');
//                           _sendLocationUpdate();
//                           _showToast('Location update sent');
//                         } else {
//                           _showToast('Go online first');
//                         }
//                       },
//                       child: Text(
//                         'Test Location',
//                         style: TextStyle(
//                           fontSize: w * 0.03,
//                           color: Colors.purple,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               //text todays's update
//               SizedBox(height: w * 0.05),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child:
//                     AppFonts.textPoppins(
//                           context,
//                           "Today's Update",
//                           w * 0.038,
//                           FontWeight.w600,
//                           AppColors.black,
//                           TextAlign.left,
//                           TextOverflow.visible,
//                         )
//                         .animate()
//                         .fade(duration: 820.ms, curve: Curves.easeInOut)
//                         .scale(
//                           begin: const Offset(0.95, 0.95),
//                           end: const Offset(1, 1),
//                         ),
//               ),

//               //some space
//               SizedBox(height: w * 0.04),

//               Column(
//                 children: [
//                   /// Today's Earnings (Full Width)
//                   _elevatedBox(
//                     shadowColor: const Color(0xFF4CAF50),
//                     width: double.infinity,
//                     child: Column(
//                       children: const [
//                         Text(
//                           "Today's Earnings",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Color(0xFF414142),
//                           ),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           "₹1000.00",
//                           style: TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   /// Online & Cash
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFFEBC2F),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Online",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "₹500 Total",
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF7C7C8D),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Cash",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "₹500 On Hand",
//                                 style: TextStyle(fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: w * 0.05),

//                   /// Ride Stats
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFF439AFE),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Total Rides",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: const Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               RichText(
//                                 text: const TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: "50",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: " / 45 Completed",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       SizedBox(
//                         width: w * 0.45,
//                         child: _elevatedBox(
//                           shadowColor: const Color(0xFFF26061),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Total Rides",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: const Color(0xFF414142),
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               RichText(
//                                 text: const TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: "50",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: " / 05 Cancelled",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
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

//       // Floating action buttons for quick actions
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton.small(
//             onPressed: _toggleConnection,
//             backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
//             child: Icon(
//               _isSocketConnected ? Icons.link : Icons.link_off,
//               size: w * 0.04,
//             ),
//           ),
//           SizedBox(height: w * 0.01),
//           if (_hasPendingRideRequest)
//             FloatingActionButton.extended(
//               onPressed: () {
//                 if (_newRideRequest != null) {
//                   _showRideRequestNotification(_newRideRequest!);
//                 }
//               },
//               backgroundColor: Colors.orange,
//               icon: Icon(Icons.local_taxi, size: w * 0.04),
//               label: Text('View Ride', style: TextStyle(fontSize: w * 0.03)),
//             ),
//           SizedBox(height: w * 0.01),
//           if (_isRideInProgress)
//             FloatingActionButton.extended(
//               onPressed: () {
//                 // Complete current ride
//                 if (_activeRideId != null) {
//                   _completeRide(_activeRideId!);
//                   _showToast('Ride ended');
//                 }
//               },
//               backgroundColor: Colors.orange,
//               icon: Icon(Icons.directions_car_filled, size: w * 0.04),
//               label: Text('End Ride', style: TextStyle(fontSize: w * 0.03)),
//             ),
//         ],
//       ),
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
//         boxShadow: [
//           BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget commonWidget1(
//     double w,
//     Color color,
//     String text1,
//     String text2,
//     String amount1,
//     String amount2,
//   ) {
//     return Container(
//       height: w * .23,
//       width: w * .43,
//       decoration: BoxDecoration(
//         color: color,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 3,
//           ),
//         ],
//         borderRadius: BorderRadius.circular(w * 0.012),
//       ),
//       child: Align(
//         alignment: Alignment.bottomRight,
//         child: Container(
//           height: w * .23,
//           width: w * .423,
//           decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(w * 0.012),
//           ),
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: w * 0.03,
//               vertical: w * 0.03,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "$amount1 - ",
//                       w * 0.032,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                     AppFonts.textPoppins(
//                       context,
//                       text1,
//                       w * 0.028,
//                       FontWeight.w400,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: w * 0.02),
//                 Row(
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       "$amount2 - ",
//                       w * 0.028,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                     AppFonts.textPoppins(
//                       context,
//                       text2,
//                       w * 0.028,
//                       FontWeight.w400,
//                       AppColors.black,
//                       TextAlign.left,
//                       TextOverflow.visible,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Helper function to get minimum of two values
// int min(int a, int b) => a < b ? a : b;