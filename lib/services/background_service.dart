// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class BackgroundService {
//   // ✅ CORRECT URL - matches socket_manager.dart
//   static const String SOCKET_URL = 'https://api.nzcu.framekarts.com';
//   static const String NOTIFICATION_CHANNEL_ID = 'high_importance_channel';
//   static const int NOTIFICATION_ID = 888;

//   static Future<void> initializeService() async {
//     print("🛠️ [Background] Initializing Service configuration...");
//     final service = FlutterBackgroundService();

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       NOTIFICATION_CHANNEL_ID,
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart:
//             true, // ✅ AUTO-START ON LAUNCH TO AVOID BACKGROUND START CRASH
//         isForegroundMode: true,
//         notificationChannelId: NOTIFICATION_CHANNEL_ID,
//         initialNotificationTitle: 'NZCU Driver Service',
//         initialNotificationContent: 'Initializing...',
//         foregroundServiceNotificationId: NOTIFICATION_ID,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//       ),
//     );
//   }

//   @pragma('vm:entry-point')
//   static Future<bool> onIosBackground(ServiceInstance service) async {
//     return true;
//   }

//   @pragma('vm:entry-point')
//   static void onStart(ServiceInstance service) async {
//     print("🎬 [Background Isolate] ISOLATE_STEP_1: entered onStart");
//     try {
//       DartPluginRegistrant.ensureInitialized();
//       final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//           FlutterLocalNotificationsPlugin();
//       print(
//         "🎬 [Background Isolate] ISOLATE_STEP_2: DartPluginRegistrant done",
//       );

//       print("✅ [Background Isolate] Notifications initialized");

//       // Load Driver Data from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("auth_token");
//       final driverId = prefs.getString("driver_userid");

//       if (token == null || driverId == null) {
//         print("❌ [Background Isolate] Error: Missing token or driverId");
//         service.stopSelf();
//         return;
//       }

//       // Load vehicle data for payloads
//       final vehicleType = prefs.getString("vehicle_type_id");
//       final vehicleType2 = prefs.getString("vehicle_SubType");
//       final vehicleNumber = prefs.getString("vehicle_id");
//       final vehicleImage = prefs.getString("vehicle_image");
//       final fleetId = prefs.getString("fleet_id");

//       print("🎬 [Background Isolate] Driver data loaded:");
//       print("   - driverId: $driverId");
//       print("   - vehicleType: $vehicleType");
//       print("   - vehicleNumber: $vehicleNumber");

//       // --- Connect Socket ---
//       IO.Socket? socket;
//       Timer? locationTimer;

//       print(
//         "🎬 [Background Isolate] ISOLATE_STEP_5: Connecting to Socket: $SOCKET_URL",
//       );
//       try {
//         socket = IO.io(
//           SOCKET_URL,
//           IO.OptionBuilder()
//               .setTransports(['websocket', 'polling'])
//               .enableAutoConnect()
//               .setReconnectionAttempts(
//                 999,
//               ) // Infinite reconnections in background
//               .setReconnectionDelay(2000)
//               .setReconnectionDelayMax(10000)
//               .setAuth({'token': token})
//               .setQuery({
//                 'userRole': 'Driver',
//                 'platform': 'flutter',
//                 'driverId': driverId,
//                 'isBackground': 'true',
//               })
//               .build(),
//         );

//         // ==================== CONNECTION EVENTS ====================
//         socket.onConnect((_) {
//           print(
//             '✅ [Background Isolate] Socket Connected Successfully! ID: ${socket?.id}',
//           );

//           // Re-emit user:online so server knows driver is still online after background reconnect
//           final onlinePayload = {
//             'latitude': 0.0,
//             'longitude': 0.0,
//             'vehicleType': vehicleType,
//             'vehicleSubType': vehicleType2,
//             'vehicleId': vehicleNumber,
//             'vehicleImage': vehicleImage,
//             'fleetId': fleetId,
//             'timestamp': DateTime.now().toIso8601String(),
//           };
//           print('📡 [Background Isolate] Re-emitting user:online on reconnect');
//           socket?.emit('user:online', onlinePayload);
//         });

//         socket.onConnectError(
//           (err) => print('⚠️ [Background Isolate] Socket Connect Error: $err'),
//         );
//         socket.on(
//           'connect_timeout',
//           (err) =>
//               print('⚠️ [Background Isolate] Socket Connect Timeout: $err'),
//         );
//         socket.onDisconnect(
//           (_) => print('❌ [Background Isolate] Socket Disconnected'),
//         );
//         socket.onError(
//           (err) => print('🚨 [Background Isolate] Socket ERROR: $err'),
//         );
//         socket.onReconnect((data) {
//           print(
//             '🔄 [Background Isolate] Socket reconnected after $data attempts',
//           );
//         });

//         // ==================== DRIVER STATUS EVENTS ====================
//         socket.on('driver:online_success', (data) {
//           print('✅ [Background Isolate] Driver online confirmed: $data');
//         });

//         socket.on('driver:online_failed', (data) {
//           print('❌ [Background Isolate] Driver online failed: $data');
//         });

//         // ==================== RIDE REQUEST EVENTS ====================
//         socket.on('ride:newRide', (data) {
//           print('🚕 [Background Isolate] New ride request received: $data');

//           // Map data using the same logic as SocketManager
//           final rideData = _mapRideData(data);
//           print(
//             '📦 [Background Isolate] Mapped ride data: ${jsonEncode(rideData)}',
//           );

//           final String orderId = rideData['orderId']?.toString() ?? 'unknown';
//           final String riderName =
//               rideData['riderName']?.toString() ?? 'New Rider';
//           final String pickup =
//               rideData['startLocation']?['address']?.toString() ??
//               'Pickup Location';

//           // Persist for cross-isolate access (foreground can pick it up)
//           SharedPreferences.getInstance().then((prefs) {
//             prefs.setString('last_ride_request', jsonEncode(data));
//           });

//           // Show interactive notification with Accept/Decline
//           flutterLocalNotificationsPlugin.show(
//             888,
//             'New Ride Request!',
//             'Rider: $riderName\nPickup: $pickup',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 NOTIFICATION_CHANNEL_ID,
//                 'High Importance Notifications',
//                 importance: Importance.max,
//                 priority: Priority.max,
//                 icon: '@mipmap/ic_launcher',
//                 fullScreenIntent: true,
//                 category: AndroidNotificationCategory.call,
//                 actions: <AndroidNotificationAction>[
//                   AndroidNotificationAction(
//                     'accept_ride',
//                     'Accept',
//                     cancelNotification: true,
//                     contextual: false,
//                     icon: DrawableResourceAndroidBitmap('ic_launcher'),
//                   ),
//                   AndroidNotificationAction(
//                     'decline_ride',
//                     'Decline',
//                     cancelNotification: true,
//                     contextual: false,
//                     icon: DrawableResourceAndroidBitmap('ic_launcher'),
//                   ),
//                 ],
//               ),
//             ),
//             payload: jsonEncode({'orderId': orderId, 'type': 'ride_request'}),
//           );
//         });

//         // ==================== RIDE CONFIRMED ====================
//         socket!.on('ride:confirmed', (data) async {
//           print("🚗 [Background Isolate] Ride Confirmed!");
//           print("📦 [Background Isolate] Full Ride Data: ${jsonEncode(data)}");

//           final orderId = data['orderId'] ?? data['_id'];

//           // Persist full ride data for foreground
//           try {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('active_ride_full_data', jsonEncode(data));
//             await prefs.setString('active_order_id', orderId.toString());
//             await prefs.setBool("is_ride_in_progress", true);
//             await prefs.setString("active_ride_id", orderId.toString());
//             print(
//               '💾 [Background Isolate] Ride confirmed data saved to SharedPreferences',
//             );
//           } catch (e) {
//             print(
//               '⚠️ [Background Isolate] Error saving ride confirmed data: $e',
//             );
//           }

//           // Join ride room
//           socket?.emit('join:room', {'roomName': 'ride:$orderId'});

//           // Show notification
//           flutterLocalNotificationsPlugin.show(
//             889,
//             'Ride Confirmed! 🚗',
//             'Your ride has been confirmed. Open the app to navigate.',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 NOTIFICATION_CHANNEL_ID,
//                 'High Importance Notifications',
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ),
//           );
//         });

//         // ==================== RIDE STATUS ====================
//         socket!.on('ride:status', (data) async {
//           print('📊 [Background Isolate] Ride status update: $data');

//           final status = data['status']?.toString().toLowerCase();
//           if (status == 'completed' ||
//               status == 'finished' ||
//               status == 'ended' ||
//               status == 'cancelled') {
//             print('✅ [Background Isolate] Ride end status received: $status');
//             // Clear ride state in prefs
//             try {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setBool("is_ride_in_progress", false);
//               await prefs.setString("active_ride_id", "");
//               await prefs.remove('active_ride_full_data');
//               await prefs.remove('active_order_id');
//               print('💾 [Background Isolate] Ride state cleared from prefs');
//             } catch (e) {
//               print('⚠️ [Background Isolate] Error clearing ride state: $e');
//             }
//           }
//         });

//         // ==================== RIDE CANCELLED ====================
//         socket!.on('ride:orderCancelled', (data) async {
//           print('❌ [Background Isolate] Ride cancelled: $data');

//           // Clear ride state
//           try {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setBool("is_ride_in_progress", false);
//             await prefs.setString("active_ride_id", "");
//             await prefs.remove('active_ride_full_data');
//             await prefs.remove('active_order_id');
//             await prefs.remove('activeRide');
//             print('💾 [Background Isolate] Ride cancelled - state cleared');
//           } catch (e) {
//             print('⚠️ [Background Isolate] Error clearing cancelled ride: $e');
//           }

//           // Show notification
//           flutterLocalNotificationsPlugin.show(
//             890,
//             'Ride Cancelled',
//             'The ride has been cancelled by the rider.',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 NOTIFICATION_CHANNEL_ID,
//                 'High Importance Notifications',
//                 importance: Importance.high,
//                 priority: Priority.high,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ),
//           );
//         });

//         // ==================== RIDE RECONNECTED ====================
//         socket.on('ride:reconnected', (data) async {
//           print('🔄 [Background Isolate] Reconnected to active ride: $data');

//           final orderId = data['orderId']?.toString();
//           if (orderId != null) {
//             try {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setString('active_ride_full_data', jsonEncode(data));
//               await prefs.setString('active_order_id', orderId);
//               await prefs.setBool("is_ride_in_progress", true);
//               await prefs.setString("active_ride_id", orderId);
//               print('💾 [Background Isolate] Reconnected ride data saved');
//             } catch (e) {
//               print(
//                 '⚠️ [Background Isolate] Error saving reconnected ride: $e',
//               );
//             }

//             // Re-join ride room
//             socket?.emit('join:room', {'roomName': 'ride:$orderId'});
//           }
//         });

//         // ==================== RIDE LOCATION (from rider) ====================
//         socket.on('ride:location', (data) {
//           // Just log - no action needed in background
//           // print('📍 [Background Isolate] Rider location: $data');
//         });

//         // ==================== CHAT EVENTS ====================
//         socket.on('chat:receiveMessage', (data) {
//           print('💬 [Background Isolate] Chat message received: $data');

//           final String senderName = data['senderName']?.toString() ?? 'Rider';
//           final String message = data['message']?.toString() ?? 'New message';

//           // Show notification for chat message
//           flutterLocalNotificationsPlugin.show(
//             891,
//             'New Message from $senderName',
//             message,
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 NOTIFICATION_CHANNEL_ID,
//                 'High Importance Notifications',
//                 importance: Importance.high,
//                 priority: Priority.high,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ),
//           );
//         });

//         socket.on('chat:message', (data) {
//           print('💬 [Background Isolate] Chat message (alt event): $data');
//         });

//         // Debug: log all events
//         socket.onAny((event, data) {
//           print('[Background Socket] Event: $event');
//         });

//         socket.connect();
//       } catch (e) {
//         print('❌ [Background Isolate] Socket creation failed: $e');
//       }

//       // ==================== PERIODIC LOCATION TIMER ====================
//       // Send location updates every 3 seconds (matching foreground behavior)
//       double lastLat = 0.0;
//       double lastLng = 0.0;

//       locationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
//         if (socket == null || !socket.connected) return;
//         if (lastLat == 0.0 && lastLng == 0.0) return;

//         try {
//           final currentPrefs = await SharedPreferences.getInstance();
//           final isRideInProgress =
//               currentPrefs.getBool("is_ride_in_progress") ?? false;
//           final rideId = currentPrefs.getString("active_ride_id");

//           if (isRideInProgress && rideId != null && rideId.isNotEmpty) {
//             // Send ride-specific location update
//             print(
//               '📍 [Background Timer] Sending RIDE location ($lastLat, $lastLng) for: $rideId',
//             );
//             socket.emit('ride:location:update', {
//               'rideId': rideId,
//               'location': {
//                 'latitude': lastLat,
//                 'longitude': lastLng,
//                 'lat': lastLat,
//                 'lng': lastLng,
//                 'timestamp': DateTime.now().toIso8601String(),
//                 'accuracy': 0.0,
//                 'speed': 0.0,
//               },
//             });
//           } else {
//             // Send general driver location update (matching foreground payload)
//             print(
//               '📍 [Background Timer] Sending GENERAL driver location ($lastLat, $lastLng)',
//             );
//             socket.emit('driver:location:update', {
//               'latitude': lastLat,
//               'longitude': lastLng,
//               'role': 'Driver',
//               'vehicleType': vehicleType,
//               'vehicleImage': vehicleImage,
//               'fleetId': fleetId,
//               'timestamp': DateTime.now().toIso8601String(),
//             });
//           }
//         } catch (e) {
//           print('⚠️ [Background Isolate] Error in periodic location: $e');
//         }
//       });

//       // --- Start Advanced Geolocation ---
//       print("🎬 [Background Isolate] ISOLATE_STEP_4: Starting Geolocation...");

//       bg.BackgroundGeolocation.onLocation((bg.Location location) async {
//         print(
//           '📍 [Background Geolocation] ${location.coords.latitude}, ${location.coords.longitude}',
//         );

//         // Update cached lat/lng for periodic timer
//         lastLat = location.coords.latitude;
//         lastLng = location.coords.longitude;

//         // Also emit immediately on location change
//         if (socket != null && socket.connected) {
//           final currentPrefs = await SharedPreferences.getInstance();
//           final isRideInProgress =
//               currentPrefs.getBool("is_ride_in_progress") ?? false;
//           final rideId = currentPrefs.getString("active_ride_id");

//           if (isRideInProgress && rideId != null && rideId.isNotEmpty) {
//             print('📍 [Background Isolate] Sending RIDE location for: $rideId');
//             socket.emit('ride:location:update', {
//               'rideId': rideId,
//               'location': {
//                 'latitude': location.coords.latitude,
//                 'longitude': location.coords.longitude,
//                 'lat': location.coords.latitude,
//                 'lng': location.coords.longitude,
//                 'timestamp': DateTime.now().toIso8601String(),
//                 'accuracy': location.coords.accuracy,
//                 'speed': location.coords.speed,
//                 'heading': location.coords.heading,
//               },
//             });
//           } else {
//             print('📍 [Background Isolate] Sending GENERAL driver location');
//             socket.emit('driver:location:update', {
//               'latitude': location.coords.latitude,
//               'longitude': location.coords.longitude,
//               'role': 'Driver',
//               'vehicleType': vehicleType,
//               'vehicleImage': vehicleImage,
//               'fleetId': fleetId,
//               'timestamp': DateTime.now().toIso8601String(),
//             });
//           }
//         }
//       });

//       bg.BackgroundGeolocation.ready(
//         bg.Config(
//           desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//           distanceFilter: 10.0,
//           stopOnTerminate: false,
//           startOnBoot: true,
//           debug: false,
//           logLevel: bg.Config.LOG_LEVEL_OFF,
//           notification: bg.Notification(
//             title: "NZCU Driver Tracking",
//             text: "Tracking location for ride requests",
//           ),
//         ),
//       ).then((bg.State state) {
//         if (!state.enabled) {
//           bg.BackgroundGeolocation.start();
//         }
//       });

//       // --- Listen for foreground commands ---
//       service.on('updateData').listen((event) {
//         if (event != null) {
//           print(
//             '📥 [Background Isolate] Received updateData from foreground: $event',
//           );
//           // Future: could update local state from foreground data
//         }
//       });

//       // --- Stop Listener ---
//       service.on('stopService').listen((event) {
//         print("🛑 [Background Isolate] stopService command received");
//         locationTimer?.cancel();
//         bg.BackgroundGeolocation.stop();
//         socket?.disconnect();
//         socket?.dispose();
//         service.stopSelf();
//       });
//     } catch (e, stack) {
//       print("🚨 [Background Isolate] FATAL CRASH: $e");
//       print(stack);
//     }
//   }

//   // Helper method to map ride data (same logic as SocketManager)
//   static Map<String, dynamic> _mapRideData(dynamic data) {
//     if (data == null) return {};
//     final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);

//     // Extract pickup coordinates
//     Map<String, dynamic>? pickupCoords;
//     if (rideData['pickup'] != null) {
//       final pickup = Map<String, dynamic>.from(rideData['pickup']);
//       if (pickup['latitude'] != null && pickup['longitude'] != null) {
//         pickupCoords = {
//           'latitude': double.tryParse(pickup['latitude'].toString()) ?? 0.0,
//           'longitude': double.tryParse(pickup['longitude'].toString()) ?? 0.0,
//         };
//       }
//     }

//     // Extract dropoff coordinates
//     Map<String, dynamic>? dropoffCoords;
//     if (rideData['destination'] != null) {
//       final destination = Map<String, dynamic>.from(rideData['destination']);
//       if (destination['latitude'] != null && destination['longitude'] != null) {
//         dropoffCoords = {
//           'latitude':
//               double.tryParse(destination['latitude'].toString()) ?? 0.0,
//           'longitude':
//               double.tryParse(destination['longitude'].toString()) ?? 0.0,
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
//       'endLocation': rideData['endLocation'] != null
//           ? {
//               'address': rideData['endLocation']?['address'] ?? 'Drop Location',
//               'coordinates': dropoffCoords,
//             }
//           : null,
//       'riderId':
//           rideData['riderId'] ??
//           rideData['userId']?['_id'] ??
//           rideData['userId'],
//       'riderName':
//           rideData['riderName'] ?? rideData['userId']?['name'] ?? 'Customer',
//       'riderNumber':
//           (rideData['riderNumber'] ?? rideData['userId']?['phone'] ?? '')
//               .toString(),
//       'totalFare':
//           (rideData['totalFare'] ??
//                   rideData['fare']?['total'] ??
//                   rideData['fare'] ??
//                   '0')
//               .toString(),
//       'distance': (rideData['distance'] ?? '0').toString(),
//       'estimatedTime': (rideData['estimatedTime'] ?? '15').toString(),
//       'vehicleType': rideData['vehicleType'] ?? 'sedan',
//       'otp': rideData['otp'],
//     };
//   }
// }
