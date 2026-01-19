// import 'dart:convert';
// import 'package:corezap_driver/controller/controllers.dart';
// import 'package:corezap_driver/controller/home_controller.dart';
// import 'package:corezap_driver/controller/stepper_controller.dart';
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
//   final HomeController homeController = Get.put(HomeController());
//   StepperController stepperController = Get.put(StepperController());

//   // Socket variables
//   IO.Socket? socket;
//   bool _isSocketConnected = false;
//   bool _isOnDuty = false;
//   String _socketStatus = 'Not Connected';
//   String _socketId = '';
//   int _reconnectAttempts = 0;
//   final int _maxReconnectAttempts = 5;

//   // Driver data
//   final String _driverId = '695217e9257d2163ca119fa4';
//   final String _token =
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NTIxN2U5MjU3ZDIxNjNjYTExOWZhNCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg1NDUzMDksImV4cCI6MTc3MTEzNzMwOX0.wEFxUzeInhgmej3RT3w-8_dpPVJZd0QeHBHsWVTbRGg';

//   // Ride variables
//   Map<String, dynamic>? _currentRide;
//   String? _activeRideId;
//   bool _isRideInProgress = false;
//   DateTime? _rideStartTime;

//   // Location variables (mock - you'll need to implement real location)
//   double? _currentLatitude;
//   double? _currentLongitude;
//   String _vehicleType = 'Car';
//   String? _vehicleImage;
//   String? _fleetId;

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

//       // Create socket EXACTLY like React Native
//       socket = IO.io(
//         'https://corezap.smarttechbros.com',
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling'])
//             .enableAutoConnect()
//             .setReconnectionAttempts(_maxReconnectAttempts)
//             .setReconnectionDelay(1000)
//             .setTimeout(20000)
//             .setAuth({'token': _token})
//             .setQuery({
//               'userRole': 'Driver',
//               'platform': 'flutter',
//               'driverId': _driverId,
//             })
//             .build(),
//       );

//       // Setup all event listeners
//       _setupEventListeners();

//       // Connect socket
//       socket!.connect();

//       // Wait for connection with timeout
//       await Future.delayed(const Duration(seconds: 10), () {
//         if (!_isSocketConnected) {
//           print('❌ Connection timeout');
//           setState(() {
//             _socketStatus = 'Timeout';
//           });
//         }
//       });
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

//       // Auto go online if driver is on duty
//       if (_isOnDuty) {
//         Future.delayed(const Duration(seconds: 1), () {
//           _emitDriverOnline();
//         });
//       }
//     });

//     socket!.on('disconnect', (reason) {
//       print('❌ Driver socket disconnected: $reason');
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnected';
//       });
//       // Stop location updates here
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

//     // ==================== DRIVER STATUS EVENTS ====================

//     socket!.on('driver:online_success', (data) {
//       print('✅ Driver online confirmed: $data');
//       setState(() {
//         _isOnDuty = true;
//       });
//       // Start location tracking here
//     });

//     socket!.on('driver:online_failed', (data) {
//       print('❌ Driver online failed: $data');
//       setState(() {
//         _isOnDuty = false;
//       });
//     });

//     // ==================== RIDE REQUEST EVENTS ====================

//     socket!.on('ride:newRide', (dynamic data) {
//       print('🚕 NEW RIDE REQUEST RECEIVED');

//       // Cast data to Map<String, dynamic> first
//       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

//       // Map socket data to expected format
//       final Map<String, dynamic> mappedData = {
//         ...rideData,
//         'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
//         'rider': {
//           'name':
//               rideData['riderName'] ?? rideData['rider']?['name'] ?? 'Customer',
//           'phone': rideData['riderNumber'] ?? rideData['rider']?['phone'] ?? '',
//           '_id': rideData['riderId'] ?? rideData['rider']?['_id'],
//         },
//         'fare': {'total': rideData['totalFare'] ?? rideData['fare'] ?? '0'},
//       };

//       print('Ride Details:');
//       print('- Order ID: ${mappedData['orderId']}');
//       print('- Rider: ${mappedData['rider']['name']}');
//       print('- Distance: ${mappedData['distance']}');
//       print('- Fare: ${mappedData['fare']['total']}');
//       print('- Pickup: ${mappedData['pickup']}');

//       // Show ride request notification
//       _showRideRequestNotification(mappedData);
//     });

//     socket!.on('ride:confirmed', (dynamic data) {
//       print('✅ Ride accepted - Backend confirmed');

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
//       final orderId = rideData['orderId'] ?? rideData['_id'];
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
//       });

//       print('🚗 Ride state updated to CONFIRMED');

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
//         }
//       }
//     });

//     socket!.on('ride:orderCancelled', (dynamic data) {
//       print('❌ Ride cancelled: $data');

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
//       _completeRide(cancelData['orderId']);

//       setState(() {
//         _currentRide = null;
//         _isRideInProgress = false;
//       });
//     });

//     socket!.on('ride:reconnected', (dynamic data) {
//       print('🔄 Reconnected to active ride: $data');

//       // Cast data to Map<String, dynamic>
//       final Map<String, dynamic> reconnectData = Map<String, dynamic>.from(
//         data,
//       );
//       _currentRide = {
//         'orderId': reconnectData['orderId'],
//         'status': reconnectData['orderStatus'],
//       };
//     });

//     socket!.on('ride:location', (dynamic data) {
//       print('📍 Rider location during ride:');
//       print('- Ride ID: ${data['rideId']}');
//       print('- Location: ${data['location']}');
//       print('- Timestamp: ${data['timestamp']}');
//     });

//     // ==================== CHAT EVENTS ====================

//     socket!.on('chat:join_success', (data) {
//       print('✅ Joined chat room: $data');
//     });

//     socket!.on('chat:join_error', (data) {
//       print('❌ Chat join error: $data');
//     });

//     socket!.on('chat:receiveMessage', (data) {
//       print('💬 New chat message received: $data');
//     });

//     socket!.on('chat:message', (data) {
//       print('💬 New chat message received: $data');
//     });

//     socket!.on('chat:message_sent', (data) {
//       print('✅ Message sent successfully: $data');
//     });

//     socket!.on('chat:typing', (data) {
//       print('✍️ User is typing: $data');
//     });

//     socket!.on('chat:error', (data) {
//       print('❌ Chat error: $data');
//     });

//     // ==================== DEBUG ALL EVENTS ====================

//     socket!.onAny((event, data) {
//       if (!['ping', 'pong'].contains(event)) {
//         print('🔍 [ALL EVENTS] $event: ${data.toString().substring(0, 100)}');
//       }
//     });
//   }

//   // ==================== DRIVER ONLINE/OFFLINE ====================

//   Future<void> _emitDriverOnline() async {
//     try {
//       if (socket == null || !_isSocketConnected) {
//         print('⚠️ Socket not connected, cannot emit driver online');
//         return;
//       }

//       // Get current location (mock - implement real location)
//       await _getCurrentLocation();

//       final Map<String, dynamic> payload = {
//         'latitude': _currentLatitude ?? 0,
//         'longitude': _currentLongitude ?? 0,
//         'vehicleType': _vehicleType,
//         'vehicleImage': _vehicleImage,
//         'fleetId': _fleetId,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       print('📡 Emitting user:online: $payload');
//       socket!.emit('user:online', payload);

//       // Start location tracking
//       // _startLocationUpdates();

//       setState(() {
//         _isOnDuty = true;
//       });

//       print('🟢 Driver is now online and ready for rides');
//     } catch (error) {
//       print('❌ Error emitting driver online: $error');
//       setState(() {
//         _isOnDuty = false;
//       });
//     }
//   }

//   Future<void> _emitDriverOffline() async {
//     try {
//       if (socket != null && _isSocketConnected) {
//         print('🔴 Going offline');
//         // _stopLocationUpdates();

//         setState(() {
//           _isOnDuty = false;
//         });
//       }
//     } catch (error) {
//       print('❌ Error emitting driver offline: $error');
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
//     // Mock location - implement real location service
//     _currentLatitude = 28.6139;
//     _currentLongitude = 77.2090;
//     print('📍 Current location: $_currentLatitude, $_currentLongitude');
//   }

//   // ==================== NOTIFICATIONS ====================

//   void _showRideRequestNotification(Map<String, dynamic> rideData) {
//     if (!mounted) return;

//     // Extract data with null safety
//     final riderName = rideData['rider']?['name']?.toString() ?? 'Customer';
//     final distance = rideData['distance']?.toString() ?? '0';
//     final fare = rideData['fare']?['total']?.toString() ?? '0';
//     final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
//     final orderId = rideData['orderId']?.toString() ?? '';

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('🚕 New Ride Request'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Rider: $riderName'),
//             Text('Distance: $distance km'),
//             Text('Fare: ₹$fare'),
//             const SizedBox(height: 10),
//             Text('Pickup: $pickup'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Reject ride
//               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
//                 socket!.emit('ride:reject', {'orderId': orderId});
//               }
//             },
//             child: const Text('Reject'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Accept ride
//               if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
//                 socket!.emit('ride:accept', {'orderId': orderId});
//                 print('✅ Ride accepted: $orderId');
//               }
//             },
//             child: const Text('Accept'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==================== UTILITY METHODS ====================

//   void _toggleConnection() {
//     if (_isSocketConnected) {
//       socket?.disconnect();
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnecting...';
//       });
//     } else {
//       connectSocket();
//     }
//   }

//   void _toggleOnlineStatus() {
//     if (_isOnDuty) {
//       _emitDriverOffline();
//     } else {
//       _emitDriverOnline();
//     }
//   }

//   @override
//   void dispose() {
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
//                                 onTap: _toggleOnlineStatus,
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
//                                   child: Text(
//                                     _isOnDuty ? 'Online' : 'Offline',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: w * 0.032,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: w * 0.01),

//                               // Socket status
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: w * 0.02,
//                                   vertical: w * 0.005,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _isSocketConnected
//                                       ? Colors.green
//                                       : Colors.red,
//                                   borderRadius: BorderRadius.circular(w * 0.01),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Container(
//                                       width: w * 0.015,
//                                       height: w * 0.015,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     SizedBox(width: w * 0.01),
//                                     Text(
//                                       _socketStatus,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: w * 0.02,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
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
//               // Socket Info
//               Container(
//                 margin: EdgeInsets.only(bottom: w * 0.02),
//                 padding: EdgeInsets.all(w * 0.02),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(w * 0.02),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               _isSocketConnected ? Icons.wifi : Icons.wifi_off,
//                               color: _isSocketConnected
//                                   ? Colors.green
//                                   : Colors.red,
//                               size: w * 0.04,
//                             ),
//                             SizedBox(width: w * 0.01),
//                             Text(
//                               _isSocketConnected
//                                   ? 'Socket Connected'
//                                   : 'Socket Disconnected',
//                               style: TextStyle(
//                                 fontSize: w * 0.03,
//                                 color: _isSocketConnected
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (_socketId.isNotEmpty)
//                           Text(
//                             'ID: ${_socketId.substring(0, min(_socketId.length, 8))}...',
//                             style: TextStyle(
//                               fontSize: w * 0.025,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                       ],
//                     ),

//                     if (_currentRide != null) ...[
//                       SizedBox(height: w * 0.01),
//                       Container(
//                         padding: EdgeInsets.all(w * 0.015),
//                         decoration: BoxDecoration(
//                           color: Colors.blue[50],
//                           borderRadius: BorderRadius.circular(w * 0.01),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.directions_car,
//                               size: w * 0.035,
//                               color: Colors.blue,
//                             ),
//                             SizedBox(width: w * 0.01),
//                             Expanded(
//                               child: Text(
//                                 'Active Ride: ${_currentRide!['rider']?['name'] ?? 'Rider'}',
//                                 style: TextStyle(
//                                   fontSize: w * 0.03,
//                                   color: Colors.blue[800],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),

//               // driver agreement
//               SizedBox(height: w * 0.04),

//               Image.asset("assets/images/offline_image.png"),

//               Text(
//                 "You're Offline",
//                 style: TextStyle(
//                   fontSize: w * 0.05,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               Text(
//                 "Go online to start accepting rides.",
//                 style: TextStyle(
//                   color: const Color(0xFF5F6165),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(height: w * 0.04),
//               ElevatedButton(
//                 onPressed: () {
//                   print("the_taping");
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           const BottomnavmainScreen(startWithMaps: true),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF34C759),
//                   minimumSize: const Size(double.infinity, 50), // full width
//                 ),
//                 child: Text(
//                   "Go Online",
//                   style: TextStyle(fontSize: w * 0.04, color: Colors.white),
//                 ),
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

//       // Floating action buttons for socket control
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
//           if (_isRideInProgress)
//             FloatingActionButton.extended(
//               onPressed: () {
//                 // Complete current ride
//                 if (_activeRideId != null) {
//                   _completeRide(_activeRideId!);
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


import 'dart:convert';
import 'package:corezap_driver/controller/controllers.dart';
import 'package:corezap_driver/controller/home_controller.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.put(HomeController());
  StepperController stepperController = Get.put(StepperController());
  
  // Socket variables
  IO.Socket? socket;
  bool _isSocketConnected = false;
  bool _isOnDuty = false;
  String _socketStatus = 'Not Connected';
  String _socketId = '';
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  
  // Driver data
  final String _driverId = '695217e9257d2163ca119fa4';
  final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NTIxN2U5MjU3ZDIxNjNjYTExOWZhNCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg1NDUzMDksImV4cCI6MTc3MTEzNzMwOX0.wEFxUzeInhgmej3RT3w-8_dpPVJZd0QeHBHsWVTbRGg';
  
  // Ride variables
  Map<String, dynamic>? _currentRide;
  String? _activeRideId;
  bool _isRideInProgress = false;
  DateTime? _rideStartTime;
  
  // Location variables (mock - you'll need to implement real location)
  double? _currentLatitude;
  double? _currentLongitude;
  String _vehicleType = 'Car';
  String? _vehicleImage;
  String? _fleetId;

  @override
  void initState() {
    homeController.home_data_method();
    super.initState();
    
    // Start socket connection
    connectSocket();
  }

  Future<void> connectSocket() async {
    print("🔄 Starting socket connection...");
    
    try {
      // Check if already connected
      if (socket != null && _isSocketConnected) {
        print('✅ Socket already connected');
        return;
      }

      // Dispose existing socket
      if (socket != null) {
        socket!.disconnect();
        socket!.dispose();
      }

      print('🔌 Connecting driver socket...');
      print('Driver ID: $_driverId');
      print('Token: ${_token.substring(0, 20)}...');

      // Create socket EXACTLY like React Native
      socket = IO.io(
        'https://corezap.smarttechbros.com',
        IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .setReconnectionAttempts(_maxReconnectAttempts)
          .setReconnectionDelay(1000)
          .setTimeout(20000)
          .setAuth({'token': _token})
          // .setQuery({
          //   'userRole': 'Driver',
          //   'platform': 'flutter',
          //   'driverId': _driverId
          // })
          .build(),
      );

      // Setup all event listeners
      _setupEventListeners();

      // Connect socket
      socket!.connect();

    } catch (error) {
      print('❌ Socket connection error: $error');
      setState(() {
        _socketStatus = 'Connection Error';
      });
    }
  }

  void _setupEventListeners() {
    if (socket == null) return;

    // ==================== CONNECTION EVENTS ====================
    
    socket!.onConnect((_) {
      print('✅✅✅ DRIVER SOCKET CONNECTED: ${socket!.id}');
      setState(() {
        _isSocketConnected = true;
        _socketStatus = 'Connected';
        _socketId = socket!.id ?? '';
        _reconnectAttempts = 0;
      });

      print('📡 Socket is ready for communication');
    });

    socket!.on('disconnect', (reason) {
      print('❌ Driver socket disconnected: $reason');
      setState(() {
        _isSocketConnected = false;
        _socketStatus = 'Disconnected';
      });
    });

    socket!.on('connect_error', (error) {
      print('❌ Socket connection error: ${error.toString()}');
      _reconnectAttempts++;
      setState(() {
        _socketStatus = 'Connection Error';
      });
    });

    socket!.on('reconnect', (attemptNumber) {
      print('🔄 Socket reconnected after $attemptNumber attempts');
      setState(() {
        _reconnectAttempts = 0;
      });
    });

    // ==================== DRIVER STATUS EVENTS ====================
    
    socket!.on('driver:online_success', (dynamic data) {
      print('✅ Driver online confirmed: $data');
      setState(() {
        _isOnDuty = true;
      });
      _showToast('Driver is now online');
    });

    socket!.on('driver:online_failed', (dynamic data) {
      print('❌ Driver online failed: $data');
      setState(() {
        _isOnDuty = false;
      });
      _showToast('Failed to go online: $data');
    });

    // ==================== RIDE REQUEST EVENTS ====================
    
    socket!.on('ride:newRide', (dynamic data) {
      print('🚕 NEW RIDE REQUEST RECEIVED');
      
      // Cast data to Map<String, dynamic> first
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
      
      // Map socket data to expected format
      final Map<String, dynamic> mappedData = {
        ...rideData,
        'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'] ?? 'unknown',
        'rider': {
          'name': rideData['riderName'] ?? rideData['rider']?['name'] ?? 'Customer',
          'phone': rideData['riderNumber'] ?? rideData['rider']?['phone'] ?? '',
          '_id': rideData['riderId'] ?? rideData['rider']?['_id']
        },
        'fare': {
          'total': rideData['totalFare'] ?? rideData['fare'] ?? '0'
        }
      };

      print('Ride Details:');
      print('- Order ID: ${mappedData['orderId']}');
      print('- Rider: ${mappedData['rider']['name']}');
      print('- Distance: ${mappedData['distance']}');
      print('- Fare: ${mappedData['fare']['total']}');
      print('- Pickup: ${mappedData['pickup']}');

      // Show ride request notification
      _showRideRequestNotification(mappedData);
    });

    socket!.on('ride:confirmed', (dynamic data) {
      print('✅ Ride accepted - Backend confirmed');
      
      // Cast data to Map<String, dynamic>
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
      final orderId = rideData['orderId'] ?? rideData['_id'] ?? 'unknown';
      print('- Order ID: $orderId');
      print('- Rider: ${rideData['rider']?['name'] ?? rideData['user']?['name']}');
      print('- Fare: ${rideData['fare'] ?? rideData['totalFare']}');

      // Update current ride state
      _currentRide = {
        'orderId': orderId,
        'status': 'confirmed',
        'rider': rideData['rider'] ?? rideData['user'],
        'pickup': rideData['pickupLocation'] ?? rideData['startLocation'],
        'dropoff': rideData['dropoffLocation'] ?? rideData['endLocation'],
        'fare': rideData['fare'] ?? rideData['totalFare'],
        'distance': rideData['distance'],
        'duration': rideData['duration'] ?? rideData['estimatedTime'],
        'otp': rideData['otp'],
        'completeData': rideData
      };

      setState(() {
        _activeRideId = orderId;
        _isRideInProgress = true;
        _rideStartTime = DateTime.now();
      });

      print('🚗 Ride state updated to CONFIRMED');
      _showToast('Ride confirmed with ${rideData['rider']?['name'] ?? 'rider'}');
      
      // Join ride room for real-time updates
      _joinRideRoom(orderId);
    });

    socket!.on('ride:status', (dynamic data) {
      print('📊 Ride status update: $data');
      
      // Cast data to Map<String, dynamic>
      final Map<String, dynamic> statusData = Map<String, dynamic>.from(data);
      
      if (_currentRide != null && _currentRide!['orderId'] == statusData['orderId']) {
        _currentRide!['status'] = statusData['status'];
        
        // Mark ride as complete
        if (statusData['status'] == 'completed' || 
            statusData['status'] == 'finished' || 
            statusData['status'] == 'ended') {
          print('✅ Ride completion status received: ${statusData['status']}');
          _completeRide(statusData['orderId']);
          _showToast('Ride completed successfully');
        }
      }
    });

    socket!.on('ride:orderCancelled', (dynamic data) {
      print('❌ Ride cancelled: $data');
      
      // Cast data to Map<String, dynamic>
      final Map<String, dynamic> cancelData = Map<String, dynamic>.from(data);
      _completeRide(cancelData['orderId']);
      
      setState(() {
        _currentRide = null;
        _isRideInProgress = false;
      });
      
      _showToast('Ride was cancelled');
    });

    // ==================== DEBUG ALL EVENTS ====================
    
    socket!.onAny((event, data) {
      if (!['ping', 'pong'].contains(event)) {
        print('🔍 [ALL EVENTS] $event: ${data.toString().substring(0, min(100, data.toString().length))}');
      }
    });
  }

  // ==================== DRIVER ONLINE/OFFLINE ====================
  
  Future<void> _goOnline() async {
    print('🟢 Attempting to go online...');
    
    // First, ensure socket is connected
    if (!_isSocketConnected) {
      print('⚠️ Socket not connected, connecting first...');
      await connectSocket();
      
      // Wait a bit for connection
      await Future.delayed(const Duration(seconds: 2));
      
      if (!_isSocketConnected) {
        _showToast('Cannot connect to server');
        return;
      }
          
    }

    // Now emit driver online
    await _emitDriverOnline();
  }

  Future<void> _emitDriverOnline() async {
    try {
      if (socket == null || !_isSocketConnected) {
        print('⚠️ Socket not connected, cannot emit driver online');
        _showToast('Socket not connected');
        return;
      }

      print('📡 Emitting user:online event...');
      
      // Get current location (mock - implement real location)
      await _getCurrentLocation();

      final Map<String, dynamic> payload = {
        'latitude': _currentLatitude ?? 0,
        'longitude': _currentLongitude ?? 0,
        'vehicleType': _vehicleType,
        'vehicleImage': _vehicleImage,
        'fleetId': _fleetId,
        'timestamp': DateTime.now().toIso8601String(),
        'driverId': _driverId,
      };

      print('📡 Payload: $payload');
      
      // Emit the event - try different event names if needed
      socket!.emit('user:online', payload);
      socket!.emit('driver:online', payload);
      socket!.emit('driver-online', payload);
      
      print('✅ Driver online event emitted');
      _showToast('Going online...');


  Future.delayed(const Duration(seconds: 2), () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          const BottomnavmainScreen(startWithMaps: true),
    ),
  );
});

    
      // Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) =>
      //                     const BottomnavmainScreen(startWithMaps: true),
      //               ),
      //             );

    } catch (error) {
      print('❌ Error emitting driver online: $error');
      _showToast('Error going online: $error');
      setState(() {
        _isOnDuty = false;
      });
    }
  }

  Future<void> _goOffline() async {
    try {
      if (socket != null && _isSocketConnected) {
        print('🔴 Going offline...');
        
        // Emit driver offline event
        socket!.emit('user:offline', {'driverId': _driverId});
        socket!.emit('driver:offline', {'driverId': _driverId});
        
        setState(() {
          _isOnDuty = false;
        });
        
        print('✅ Driver is now offline');
        _showToast('Driver is now offline');
      }
    } catch (error) {
      print('❌ Error going offline: $error');
    }
  }

  // ==================== RIDE MANAGEMENT ====================
  
  void _joinRideRoom(String orderId) {
    if (socket != null && _isSocketConnected) {
      socket!.emit('ride:join', {'orderId': orderId});
      print('🚗 Joined ride room: $orderId');
    }
  }

  void _completeRide(String orderId) {
    print('✅ Completing ride: $orderId');
    setState(() {
      _currentRide = null;
      _activeRideId = null;
      _isRideInProgress = false;
      _rideStartTime = null;
    });
  }

  // ==================== LOCATION METHODS ====================
  
  Future<void> _getCurrentLocation() async {
    try {
      // Mock location - implement real location service
      _currentLatitude = 28.6139;
      _currentLongitude = 77.2090;
      print('📍 Current location: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      print('❌ Error getting location: $e');
      _currentLatitude = 0;
      _currentLongitude = 0;
    }
  }

  // ==================== NOTIFICATIONS ====================
  
  void _showRideRequestNotification(Map<String, dynamic> rideData) {
    if (!mounted) return;
    
    // Extract data with null safety
    final riderName = rideData['rider']?['name']?.toString() ?? 'Customer';
    final distance = rideData['distance']?.toString() ?? '0';
    final fare = rideData['fare']?['total']?.toString() ?? '0';
    final pickup = rideData['pickup']?.toString() ?? 'Location not specified';
    final orderId = rideData['orderId']?.toString() ?? '';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🚕 New Ride Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rider: $riderName'),
            Text('Distance: $distance km'),
            Text('Fare: ₹$fare'),
            const SizedBox(height: 10),
            Text('Pickup: $pickup'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Reject ride
              if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
                socket!.emit('ride:reject', {'orderId': orderId});
                _showToast('Ride rejected');
              }
            },
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Accept ride
              if (socket != null && _isSocketConnected && orderId.isNotEmpty) {
                socket!.emit('ride:accept', {'orderId': orderId});
                print('✅ Ride accepted: $orderId');
                _showToast('Ride accepted!');
              }
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==================== UTILITY METHODS ====================
  
  void _toggleConnection() {
    if (_isSocketConnected) {
      socket?.disconnect();
      setState(() {
        _isSocketConnected = false;
        _socketStatus = 'Disconnecting...';
      });
      _showToast('Socket disconnected');
    } else {
      connectSocket();
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

  @override
  void dispose() {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }
    super.dispose();
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
                      // Online/Offline status with toggle
                      GestureDetector(
                        onTap: _toggleOnlineStatus,
                        child: Container(
                          width: w * 0.26,
                          height: w * 0.10,
                          decoration: BoxDecoration(
                            color: _isOnDuty ? const Color(0xFF34C759) : const Color(0xFFF26061),
                            borderRadius: BorderRadius.circular(w * 0.06),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _isOnDuty ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.032,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: w * 0.01),
                      
                      // Socket status
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.005),
                      //   decoration: BoxDecoration(
                      //     color: _isSocketConnected ? Colors.green : Colors.red,
                      //     borderRadius: BorderRadius.circular(w * 0.01),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Container(
                      //         width: w * 0.015,
                      //         height: w * 0.015,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           shape: BoxShape.circle,
                      //         ),
                      //       ),
                      //       SizedBox(width: w * 0.01),
                      //       Text(
                      //         _socketStatus,
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: w * 0.02,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    
                    
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
              // Socket Info
              // Container(
              //   margin: EdgeInsets.only(bottom: w * 0.02),
              //   padding: EdgeInsets.all(w * 0.02),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[50],
              //     borderRadius: BorderRadius.circular(w * 0.02),
              //     border: Border.all(color: Colors.grey[300]!),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Row(
              //             children: [
              //               Icon(
              //                 _isSocketConnected ? Icons.wifi : Icons.wifi_off,
              //                 color: _isSocketConnected ? Colors.green : Colors.red,
              //                 size: w * 0.04,
              //               ),
              //               SizedBox(width: w * 0.01),
              //               Text(
              //                 _isSocketConnected ? 'Socket Connected' : 'Socket Disconnected',
              //                 style: TextStyle(
              //                   fontSize: w * 0.03,
              //                   color: _isSocketConnected ? Colors.green : Colors.red,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           if (_socketId.isNotEmpty)
              //             Text(
              //               'ID: ${_socketId.substring(0, min(_socketId.length, 8))}...',
              //               style: TextStyle(
              //                 fontSize: w * 0.025,
              //                 color: Colors.grey[600],
              //               ),
              //             ),
              //         ],
              //       ),
                    
              //       SizedBox(height: w * 0.01),
                    
              //       // Connection Test Button
              //       ElevatedButton.icon(
              //         onPressed: _toggleConnection,
              //         icon: Icon(
              //           _isSocketConnected ? Icons.power_settings_new : Icons.power,
              //           size: w * 0.03,
              //         ),
              //         label: Text(
              //           _isSocketConnected ? 'Disconnect Socket' : 'Connect Socket',
              //           style: TextStyle(fontSize: w * 0.028),
              //         ),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: _isSocketConnected ? Colors.red : Colors.green,
              //           minimumSize: Size(double.infinity, w * 0.08),
              //         ),
              //       ),
                    
              //       if (_currentRide != null) ...[
              //         SizedBox(height: w * 0.01),
              //         Container(
              //           padding: EdgeInsets.all(w * 0.015),
              //           decoration: BoxDecoration(
              //             color: Colors.blue[50],
              //             borderRadius: BorderRadius.circular(w * 0.01),
              //           ),
              //           child: Row(
              //             children: [
              //               Icon(Icons.directions_car, size: w * 0.035, color: Colors.blue),
              //               SizedBox(width: w * 0.01),
              //               Expanded(
              //                 child: Text(
              //                   'Active Ride: ${_currentRide!['rider']?['name'] ?? 'Rider'}',
              //                   style: TextStyle(
              //                     fontSize: w * 0.03,
              //                     color: Colors.blue[800],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ],
              //   ),
              // ),

              // driver agreement
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
                style: TextStyle(
                  color: const Color(0xFF5F6165),
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: w * 0.04),
              ElevatedButton(
                onPressed: () {
                  print("Going online button tapped");
                  if (_isOnDuty) {
                    _goOffline();
                  } else {
                    _goOnline();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isOnDuty ? const Color(0xFFF26061) : const Color(0xFF34C759),
                  minimumSize: const Size(double.infinity, 50), // full width
                ),
                child: Text(
                  _isOnDuty ? "Go Offline" : "Go Online",
                  style: TextStyle(fontSize: w * 0.04, color: Colors.white),
                ),
              ),

              // Second button for navigation (keep your original functionality)
              SizedBox(height: w * 0.02),
              // ElevatedButton(
              //   onPressed: () {
              //     print("Navigate to map screen");
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             const BottomnavmainScreen(startWithMaps: true),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue,
              //     minimumSize: const Size(double.infinity, 50),
              //   ),
              //   child: Text(
              //     "View Map",
              //     style: TextStyle(fontSize: w * 0.04, color: Colors.white),
              //   ),
              // ),

              //text todays's update
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
                    )
                    .animate()
                    .fade(duration: 820.ms, curve: Curves.easeInOut)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
              ),

              //some space
              SizedBox(height: w * 0.04),

              Column(
                children: [
                  /// Today's Earnings (Full Width)
                  _elevatedBox(
                    shadowColor: const Color(0xFF4CAF50),
                    width: double.infinity,
                    child: Column(
                      children: const [
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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Online & Cash
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFFFEBC2F),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFF7C7C8D),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: w * 0.05),

                  /// Ride Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w * 0.45,
                        child: _elevatedBox(
                          shadowColor: const Color(0xFF439AFE),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
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
                        child: _elevatedBox(
                          shadowColor: const Color(0xFFF26061),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
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
                                      text: " / 05 Cancelled",
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

              SizedBox(height: w * 0.04),
            ],
          ),
        ),
      ),
      
      // Floating action buttons for socket control
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     FloatingActionButton.small(
      //       onPressed: _toggleConnection,
      //       backgroundColor: _isSocketConnected ? Colors.green : Colors.red,
      //       child: Icon(
      //         _isSocketConnected ? Icons.link : Icons.link_off,
      //         size: w * 0.04,
      //       ),
      //     ),
      //     SizedBox(height: w * 0.01),
      //     if (_isRideInProgress)
      //       FloatingActionButton.extended(
      //         onPressed: () {
      //           // Complete current ride
      //           if (_activeRideId != null) {
      //             _completeRide(_activeRideId!);
      //           }
      //         },
      //         backgroundColor: Colors.orange,
      //         icon: Icon(Icons.directions_car_filled, size: w * 0.04),
      //         label: Text('End Ride', style: TextStyle(fontSize: w * 0.03)),
      //       ),
      //   ],
      // ),
    
    
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
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 1, offset: const Offset(0, 0.2)),
        ],
      ),
      child: child,
    );
  }

  Widget commonWidget1(
    double w,
    Color color,
    String text1,
    String text2,
    String amount1,
    String amount2,
  ) {
    return Container(
      height: w * .23,
      width: w * .43,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(w * 0.012),
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: w * .23,
          width: w * .423,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(w * 0.012),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.03,
              vertical: w * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "$amount1 - ",
                      w * 0.032,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                    AppFonts.textPoppins(
                      context,
                      text1,
                      w * 0.028,
                      FontWeight.w400,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                  ],
                ),
                SizedBox(height: w * 0.02),
                Row(
                  children: [
                    AppFonts.textPoppins(
                      context,
                      "$amount2 - ",
                      w * 0.028,
                      FontWeight.w600,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                    AppFonts.textPoppins(
                      context,
                      text2,
                      w * 0.028,
                      FontWeight.w400,
                      AppColors.black,
                      TextAlign.left,
                      TextOverflow.visible,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to get minimum of two values
int min(int a, int b) => a < b ? a : b;