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
  
//   IO.Socket? socket;
//   bool _isSocketConnected = false;
//   String _socketStatus = 'Not Connected';
//   List<String> _receivedMessages = [];
//   final String _driverId = '695217e9257d2163ca119fa4';
//   final String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NTIxN2U5MjU3ZDIxNjNjYTExOWZhNCIsInJvbGUiOiJEcml2ZXIiLCJpYXQiOjE3Njg1NDUzMDksImV4cCI6MTc3MTEzNzMwOX0.wEFxUzeInhgmej3RT3w-8_dpPVJZd0QeHBHsWVTbRGg';

//   @override
//   void initState() {
//     homeController.home_data_method();
//     super.initState();
//     // Add delay to ensure init is complete
//     Future.delayed(const Duration(milliseconds: 500), () {
//       connectSocket();
//     });
//   }

//   void connectSocket() {
//     print("🔄 Starting socket connection...");
//     print("Driver ID: $_driverId");
    
//     try {
//       // Dispose existing socket
//       if (socket != null) {
//         socket!.disconnect();
//         socket!.dispose();
//       }

//       // Create socket EXACTLY like your React Native app
//       socket = IO.io(
//         'https://corezap.smarttechbros.com',
//         IO.OptionBuilder()
//           .setTransports(['websocket', 'polling'])
//           .enableAutoConnect()
//           .setReconnectionAttempts(5)
//           .setReconnectionDelay(1000)
//           .setTimeout(20000)
//           // Use auth object like React Native - This is KEY
//           .setAuth({
//             'token': _token,
//           })
//           // Set query parameters like React Native
//           .setQuery({
//             'userRole': 'Driver',
//             'platform': 'flutter',
//             'driverId': _driverId
//           })
//           .build(),
//       );

//       // ==================== SOCKET EVENT LISTENERS ====================
      
//       // Connection established
//       socket!.onConnect((_) {
//         print('✅✅✅ SOCKET CONNECTED SUCCESSFULLY!');
//         print('📡 Socket ID: ${socket!.id}');
        
//         setState(() {
//           _isSocketConnected = true;
//           _socketStatus = 'Connected ✓';
//         });
        
//         _addMessage('✅ Connected to server');
//         _addMessage('ID: ${socket!.id}');
        
//         // Emit driver join event
//         socket!.emit('driver-join', {
//           'driverId': _driverId,
//           'status': 'offline'
//         });
//       });

//       // Connection error - FIXED: Use proper event name
//       socket!.on('connect_error', (data) {
//         print('❌❌❌ CONNECTION ERROR: $data');
//         print('Error type: ${data.runtimeType}');
        
//         setState(() {
//           _isSocketConnected = false;
//           _socketStatus = 'Connection Error';
//         });
        
//         _addMessage('❌ Connection error: $data');
        
//         // Check if it's authentication error
//         if (data.toString().contains('Authentication') || 
//             data.toString().contains('auth') ||
//             data.toString().contains('jwt')) {
//           _addMessage('⚠️ Authentication error - check token');
          
//           // Test without auth to debug
//           Future.delayed(const Duration(seconds: 2), () {
//             _testWithoutAuth();
//           });
//         }
//       });

//       // FIXED: Use 'disconnect' instead of onDisconnect
//       socket!.on('disconnect', (reason) {
//         print('🔌 Socket Disconnected. Reason: $reason');
//         setState(() {
//           _isSocketConnected = false;
//           _socketStatus = 'Disconnected';
//         });
//         _addMessage('🔌 Disconnected: $reason');
//       });

//       // Error event
//       socket!.on('error', (data) {
//         print('🔥 Socket Error: $data');
//         _addMessage('🔥 Error: $data');
//       });

//       // ===== MESSAGE HANDLERS =====
      
//       // Authentication success
//       socket!.on('authenticated', (data) {
//         print('🔓 Authenticated: $data');
//         _addMessage('🔓 Authenticated successfully');
//       });

//       // Authentication failed
//       socket!.on('unauthorized', (data) {
//         print('🔐 Unauthorized: $data');
//         _addMessage('❌ Unauthorized: $data');
//       });

//       // General messages
//       socket!.on('message', (data) {
//         print('📨 Message: $data');
//         _addMessage('Message: $data');
//       });

//       // Driver specific events
//       socket!.on('driver-event', (data) {
//         print('🚗 Driver Event: $data');
//         _addMessage('🚗 Event: $data');
//       });

//       // Ride requests
//       socket!.on('new-ride', (data) {
//         print('🚖 NEW RIDE: $data');
//         _addMessage('🚖 NEW RIDE REQUEST!');
//       });

//       socket!.on('ride-request', (data) {
//         print('🚖 Ride Request: $data');
//         _addMessage('🚖 Ride Request');
//       });

//       // Listen to all events for debugging
//       socket!.onAny((event, data) {
//         print('🔍 [DEBUG] Event "$event": $data');
//         // Don't log ping/pong events to avoid spam
//         if (!['ping', 'pong', 'connect', 'disconnect'].contains(event)) {
//           final message = data.toString();
//           _addMessage('[$event]: ${message.length > 30 ? message.substring(0, 30) + '...' : message}');
//         }
//       });

//       // Ping/Pong
//       socket!.on('ping', (data) {
//         print('🏓 Ping');
//       });

//       socket!.on('pong', (data) {
//         print('🏓 Pong: $data');
//       });

//       // Connect the socket
//       print('Attempting to connect...');
//       socket!.connect();

//     } catch (e) {
//       print('💥💥💥 SOCKET INIT ERROR: $e');
//       print('Stack trace: ${e.toString()}');
//       setState(() {
//         _socketStatus = 'Init Error';
//       });
//       _addMessage('💥 Init error: $e');
//     }
//   }

//   void _testWithoutAuth() {
//     print('🔄 Testing connection without auth...');
    
//     try {
//       final testSocket = IO.io(
//         'https://corezap.smarttechbros.com',
//         IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .disableAutoConnect()
//           .build(),
//       );

//       testSocket.onConnect((_) {
//         print('✅ Can connect without auth!');
//         _addMessage('✅ Server reachable');
//         testSocket.disconnect();
//         testSocket.dispose();
//       });

//       testSocket.on('connect_error', (data) {
//         print('❌ Cannot connect: $data');
//         _addMessage('❌ Cannot reach server');
//         testSocket.dispose();
//       });

//       testSocket.connect();
//     } catch (e) {
//       print('Test error: $e');
//     }
//   }

//   void _addMessage(String message) {
//     if (!mounted) return;
    
//     setState(() {
//       _receivedMessages.insert(0, '${DateTime.now().toString().substring(11, 19)}: $message');
//       if (_receivedMessages.length > 12) {
//         _receivedMessages = _receivedMessages.sublist(0, 12);
//       }
//     });
//   }

//   void _sendTestMessage() {
//     if (socket != null && socket!.connected) {
//       final testMsg = {
//         'message': 'Hello from Flutter driver',
//         'driverId': _driverId,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'platform': 'flutter'
//       };
      
//       socket!.emit('driver-message', testMsg);
//       socket!.emit('test-event', testMsg);
      
//       _addMessage('📤 Sent test message');
//       print('📤 Sent test message');
//     } else {
//       _addMessage('⚠️ Not connected');
//     }
//   }

//   void _toggleConnection() {
//     if (_isSocketConnected) {
//       print('🔌 Disconnecting...');
//       socket?.disconnect();
//       setState(() {
//         _isSocketConnected = false;
//         _socketStatus = 'Disconnecting...';
//       });
//       _addMessage('🔌 Manual disconnect');
//     } else {
//       print('🔄 Connecting...');
//       setState(() {
//         _socketStatus = 'Connecting...';
//       });
//       connectSocket();
//     }
//   }

//   void _clearMessages() {
//     setState(() {
//       _receivedMessages.clear();
//     });
//   }

//   @override
//   void dispose() {
//     if (socket != null) {
//       print('♻️ Disposing socket...');
//       socket?.disconnect();
//       socket?.dispose();
//     }
//     super.dispose();
//   }

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
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             radius: w * 0.06,
//                             backgroundImage: const AssetImage('assets/images/home2.png'),
//                           ),
//                           SizedBox(width: w * 0.03),
//                           AppFonts.textPoppins(
//                             context,
//                             "Ayaan Malviya",
//                             w * 0.05,
//                             FontWeight.w600,
//                             AppColors.black,
//                             TextAlign.left,
//                             TextOverflow.visible,
//                           ),
//                         ],
//                       ),
//                       Container(
//                         width: w * 0.26,
//                         height: w * 0.10,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF26061),
//                           borderRadius: BorderRadius.circular(w * 0.06),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           'Offline',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: w * 0.032,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   SizedBox(height: w * 0.02),
                  
//                   // Socket Status
//                   Container(
//                     padding: EdgeInsets.all(w * 0.02),
//                     decoration: BoxDecoration(
//                       color: _isSocketConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(w * 0.02),
//                       border: Border.all(
//                         color: _isSocketConnected ? Colors.green : Colors.red,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: w * 0.03,
//                               height: w * 0.03,
//                               decoration: BoxDecoration(
//                                 color: _isSocketConnected ? Colors.green : Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             SizedBox(width: w * 0.02),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _socketStatus,
//                                   style: TextStyle(
//                                     color: _isSocketConnected ? Colors.green : Colors.red,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: w * 0.035,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Messages: ${_receivedMessages.length}',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: w * 0.025,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(
//                                 Icons.send,
//                                 color: _isSocketConnected ? Colors.blue : Colors.grey,
//                                 size: w * 0.05,
//                               ),
//                               onPressed: _sendTestMessage,
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 _isSocketConnected ? Icons.power_settings_new : Icons.power,
//                                 color: _isSocketConnected ? Colors.red : Colors.green,
//                                 size: w * 0.05,
//                               ),
//                               onPressed: _toggleConnection,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ).animate()
//         .fade(duration: 800.ms, curve: Curves.easeInOut)
//         .scale(
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
//               // Socket Debug Panel
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(w * 0.03),
//                 margin: EdgeInsets.only(bottom: w * 0.03),
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
//                         Text(
//                           '📡 Socket Connection',
//                           style: TextStyle(
//                             fontSize: w * 0.04,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.blue[800],
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: _clearMessages,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey[300],
//                             padding: EdgeInsets.symmetric(
//                               horizontal: w * 0.03,
//                               vertical: w * 0.015,
//                             ),
//                           ),
//                           child: Text(
//                             'Clear',
//                             style: TextStyle(
//                               fontSize: w * 0.03,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     SizedBox(height: w * 0.02),
                    
//                     // Connection Info
//                     Container(
//                       padding: EdgeInsets.all(w * 0.02),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(w * 0.02),
//                         border: Border.all(color: Colors.blue[100]!),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Driver ID: $_driverId',
//                             style: TextStyle(fontSize: w * 0.03, color: Colors.grey[700]),
//                           ),
//                           SizedBox(height: w * 0.01),
//                           Text(
//                             'Using auth object with token',
//                             style: TextStyle(fontSize: w * 0.03, color: Colors.grey[700]),
//                           ),
//                         ],
//                       ),
//                     ),
                    
//                     SizedBox(height: w * 0.02),
                    
//                     // Messages Log
//                     Container(
//                       height: w * 0.35,
//                       padding: EdgeInsets.all(w * 0.02),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(w * 0.02),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: _receivedMessages.isEmpty
//                           ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     _isSocketConnected ? Icons.wifi : Icons.wifi_off,
//                                     size: w * 0.08,
//                                     color: _isSocketConnected ? Colors.green : Colors.grey,
//                                   ),
//                                   SizedBox(height: w * 0.02),
//                                   Text(
//                                     _isSocketConnected ? 'Waiting for messages...' : 'Not connected',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: w * 0.032,
//                                       color: Colors.grey[500],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : ListView.builder(
//                               reverse: true,
//                               itemCount: _receivedMessages.length,
//                               itemBuilder: (context, index) {
//                                 final message = _receivedMessages[index];
//                                 Color bgColor = Colors.blue[50]!;
//                                 IconData icon = Icons.info;
                                
//                                 if (message.contains('✅') || message.contains('🔓')) {
//                                   bgColor = Colors.green[50]!;
//                                   icon = Icons.check_circle;
//                                 } else if (message.contains('❌') || message.contains('🔥') || message.contains('💥')) {
//                                   bgColor = Colors.red[50]!;
//                                   icon = Icons.error;
//                                 } else if (message.contains('⚠️')) {
//                                   bgColor = Colors.orange[50]!;
//                                   icon = Icons.warning;
//                                 } else if (message.contains('🚖')) {
//                                   bgColor = Colors.purple[50]!;
//                                   icon = Icons.directions_car;
//                                 }
                                
//                                 return Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: w * 0.03,
//                                     vertical: w * 0.015,
//                                   ),
//                                   margin: EdgeInsets.only(bottom: w * 0.01),
//                                   decoration: BoxDecoration(
//                                     color: bgColor,
//                                     borderRadius: BorderRadius.circular(w * 0.01),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(icon, size: w * 0.035, color: Colors.grey[600]),
//                                       SizedBox(width: w * 0.02),
//                                       Expanded(
//                                         child: Text(
//                                           message,
//                                           style: TextStyle(
//                                             fontSize: w * 0.03,
//                                             color: Colors.grey[800],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Your existing offline section
//               Image.asset("assets/images/offline_image.png"),
              
//               SizedBox(height: w * 0.02),
              
//               Text(
//                 "You're Offline",
//                 style: TextStyle(
//                   fontSize: w * 0.05,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
              
//               SizedBox(height: w * 0.01),
              
//               Text(
//                 "Go online to start accepting rides.",
//                 style: TextStyle(
//                   color: const Color(0xFF5F6165),
//                   fontWeight: FontWeight.w500,
//                   fontSize: w * 0.035,
//                 ),
//               ),
              
//               SizedBox(height: w * 0.04),
              
//               ElevatedButton(
//                 onPressed: () {
//                   print("the_taping");
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const BottomnavmainScreen(startWithMaps: true),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF34C759),
//                   minimumSize: Size(double.infinity, w * 0.12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(w * 0.03),
//                   ),
//                 ),
//                 child: Text(
//                   "Go Online",
//                   style: TextStyle(
//                     fontSize: w * 0.04, 
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
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
//                 ).animate()
//                 .fade(duration: 820.ms, curve: Curves.easeInOut)
//                 .scale(
//                   begin: const Offset(0.95, 0.95),
//                   end: const Offset(1, 1),
//                 ),
//               ),
              
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
              
//               SizedBox(height: w * 0.06),
              
//               // Test Buttons
//               Container(
//                 padding: EdgeInsets.all(w * 0.03),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(w * 0.02),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Socket Testing',
//                       style: TextStyle(
//                         fontSize: w * 0.038,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     SizedBox(height: w * 0.02),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _sendTestMessage,
//                           child: Text('Send Test'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: _toggleConnection,
//                           child: Text(_isSocketConnected ? 'Disconnect' : 'Connect'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _isSocketConnected ? Colors.red : Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: w * 0.04),
//             ],
//           ),
//         ),
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