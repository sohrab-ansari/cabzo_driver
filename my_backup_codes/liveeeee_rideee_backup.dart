// import 'dart:ui';

// import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_font.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RideRequestScreen extends StatefulWidget {
//   final Map<String, dynamic> rideData;

//   const RideRequestScreen({super.key, required this.rideData});

//   @override
//   _RideRequestScreenState createState() => _RideRequestScreenState();
// }

// class _RideRequestScreenState extends State<RideRequestScreen> {
//   // Google API Key for Directions
//   static const String GOOGLE_API_KEY =
//       'AIzaSyCtM1jo8qzhEn2XZ8SVCoboULcondCjZio';

//   // Timer - 1 minute = 60 seconds
//   static const int TOTAL_TIME = 60;
//   int _timer = TOTAL_TIME;
//   double _progress = 1.0;
//   Timer? _countdownTimer;

//   // Map & Location
//   GoogleMapController? _mapController;
//   LatLng? _driverLocation;
//   double _driverHeading =
//       0; // Track driver's compass heading for marker rotation
//   double _distanceToPickup = 0;
//   bool _locationError = false;
//   StreamSubscription<Position>?
//   _positionStreamSubscription; // For real-time location updates

//   // Route Information
//   Map<String, String> _routeInfo = {'distance': '', 'duration': ''};


  

//   final OrderUpdateController transactionController = Get.find<OrderUpdateController>();


//   // Ride Data
//   Map<String, dynamic>? _rideData;
//   bool _isLoading = true;
//   List<LatLng> _routeCoordinates = [];
//   List<LatLng> _pickupToDropCoordinates = [];

//   // Map Elements
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   Set<Circle> _circles = {};

//   // Custom markers
//   BitmapDescriptor? _carIcon;
//   BitmapDescriptor? _pickupIcon;
//   BitmapDescriptor? _dropIcon;

//   // State Flags
//   bool _hasAccepted = false;
//   bool _hasDeclined = false;
//   bool _isCancelSheetOpen = false;
//   bool _isAccepting = false;
//   bool _isDeclining = false;

//   bool _isTimerRunning = true;

//    Timer? _autoCancelTimer;

//    final StepperController stepperController = Get.find();

//      final OrderUpdateController orderUpdateController = Get.find<OrderUpdateController>();

// //  bool _hasAccepted = false;
//   bool _hasCancelled = false;
//   // Cancel Reasons
//   final List<Map<String, dynamic>> _cancelReasons = [
//     {'id': 1, 'label': 'Too many rides', 'icon': Icons.directions_bike},
//     {'id': 2, 'label': 'Wrong pickup location', 'icon': Icons.location_on},
//     {'id': 3, 'label': 'Waiting too long at pickup', 'icon': Icons.timer},
//     {'id': 4, 'label': "Bad weather / can't travel now", 'icon': Icons.cloud},
//     {'id': 5, 'label': 'Traffic jam near pickup point', 'icon': Icons.traffic},
//     {'id': 6, 'label': 'Other', 'icon': Icons.edit},
//   ];
//   int? _selectedReasonIndex;

//   // Cancel Sheet
//   bool _showCancelSheet = false;

//   @override
//   void initState() {
//     super.initState();
//     _extractAndStoreRideData();
//     _loadCustomMarkers();
//     _initializeRideData();
//     _startTimer();

//     // transactionController.update_order_method(orderid: ,orderstatus: "Accepted");
//   }
//  late String _riderName;
//   late String _riderPhone;
//   late String _totalFare;
//   late String _distance;
//   late String _pickupAddress;
//   late String _dropAddress;
//   late String _formattedDate;
//   late String _rideId;
//   late String _orderId;

//    LatLng? dropLatLng;

//    LatLng? pickupLatLng;

// int _secondsRemaining = 60;

//   String _formatDateFromTimestamp(int timestamp) {
//     try {
//       final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
//       return "${date.day} ${_getMonthName(date.month)}, ${date.year}";
//     } catch (e) {
//       return "30 August, 2025"; // Default fallback
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return months[month - 1];
//   }

// //  void _extractAndStoreRideData() {

// //   print("my_rideeee_datatatt ${widget.rideData}");
// //     try {



// //       // Store all data locally
// //       _riderName = widget.rideData['riderName']?.toString() ?? 'Customer';
// //       _riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
// //       _totalFare = widget.rideData['totalFare']?.toString() ?? '0';
// //       _distance = widget.rideData['distance']?.toString() ?? '0';
// //       _rideId = widget.rideData['rideId']?.toString() ?? widget.rideData['orderId']?.toString() ?? 'N/A';
// //       _orderId = widget.rideData['orderId']?.toString() ?? 'N/A';
      
// //       // Extract addresses with multiple fallbacks
// //       _pickupAddress = widget.rideData['startLocation']?['address']?.toString() ??
// //                       widget.rideData['pickup']?['address']?.toString() ??
// //                       'Manikonda Jagir, Hyderabad, Telangana';
      
// //       _dropAddress = widget.rideData['endLocation']?['address']?.toString() ??
// //                     widget.rideData['destination']?['address']?.toString() ??
// //                     widget.rideData['dropoff']?['address']?.toString() ??
// //                     'Manikonda Jagir, Hyderabad, Telangana';
      
// //       // Format date from timestamp
// //       final timestamp = widget.rideData['timestamp'];
// //       _formattedDate = timestamp != null 
// //           ? _formatDateFromTimestamp(timestamp is String ? int.parse(timestamp) : timestamp)
// //           : "30 August, 2025";

// //       // Extract coordinates
// //       _extractCoordinates();

// //     } catch (e) {
// //       print("❌ Error extracting ride data: $e");
// //       // Set default values if extraction fails
// //       _riderName = 'Customer';
// //       _riderPhone = 'N/A';
// //       _totalFare = '0';
// //       _distance = '0';
// //       _pickupAddress = 'Manikonda Jagir, Hyderabad, Telangana';
// //       _dropAddress = 'Manikonda Jagir, Hyderabad, Telangana';
// //       _formattedDate = "30 August, 2025";
// //       _rideId = 'N/A';
// //       _orderId = 'N/A';
// //       pickupLatLng = const LatLng(17.4065, 78.4772);
// //       dropLatLng = const LatLng(17.4120, 78.4850);
// //     }
// //   }
  
  
//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     _positionStreamSubscription?.cancel(); // Clean up location stream
//     _mapController?.dispose();
//     super.dispose();
//   }


//   Future<void> _cancelRide() async {
//     if (_hasCancelled || _hasAccepted) return;
    
//     _hasCancelled = true;
//     _isTimerRunning = false;
//     _autoCancelTimer?.cancel();
    
//     await OrderService.declineOrder(orderId: _orderId);
    
//     Get.back(); // Navigate back
//     Get.snackbar(
//       'Ride Cancelled',
//       'You have cancelled the ride',
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }
//   void _startTimer() {
//     _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_hasAccepted || _hasDeclined) {
//         timer.cancel();
//         return;
//       }

//       if (_timer <= 1) {
//         timer.cancel();
//         _handleAutoDecline();
//       } else {
//         setState(() {
//           _timer--;
//           _progress = _timer / TOTAL_TIME;
//         });
//       }
//     });
//   }

//   /// Load car icon for driver
//   Future<void> _loadCarMarker() async {
//     try {
//       // Create a simple car icon using canvas
//       final PictureRecorder recorder = PictureRecorder();
//       final Canvas canvas = Canvas(recorder);
//       final Size size = Size(50, 50);

//       // Draw car body (blue)
//       final carPaint = Paint()..color = Colors.blue;
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(10, 15, 30, 20),
//           Radius.circular(5),
//         ),
//         carPaint,
//       );

//       // Draw car top (blue)
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(15, 5, 20, 15),
//           Radius.circular(3),
//         ),
//         carPaint,
//       );

//       // Draw wheels (black)
//       final wheelPaint = Paint()..color = Colors.black;
//       canvas.drawCircle(Offset(15, 35), 4, wheelPaint);
//       canvas.drawCircle(Offset(35, 35), 4, wheelPaint);

//       final picture = recorder.endRecording();
//       final image = await picture.toImage(
//         size.width.toInt(),
//         size.height.toInt(),
//       );
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       final Uint8List carIconBytes = byteData!.buffer.asUint8List();

//       _carIcon = BitmapDescriptor.fromBytes(carIconBytes);
//     } catch (e) {
//       print('Error loading car marker: $e');
//       _carIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueBlue,
//       );
//     }
//   }

//   /// Load pickup icon (green pin)
//   Future<void> _loadPickupIcon() async {
//     try {
//       final PictureRecorder recorder = PictureRecorder();
//       final Canvas canvas = Canvas(recorder);
//       final Size size = Size(40, 50);

//       // Draw pin stem (green)
//       final stemPaint = Paint()..color = Colors.green;
//       canvas.drawRect(Rect.fromLTWH(19, 0, 2, 30), stemPaint);

//       // Draw pin head (green circle)
//       final headPaint = Paint()..color = Colors.green;
//       canvas.drawCircle(Offset(20, 35), 12, headPaint);

//       // Draw white dot in center
//       final dotPaint = Paint()..color = Colors.white;
//       canvas.drawCircle(Offset(20, 35), 5, dotPaint);

//       final picture = recorder.endRecording();
//       final image = await picture.toImage(
//         size.width.toInt(),
//         size.height.toInt(),
//       );
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       final Uint8List pickupIconBytes = byteData!.buffer.asUint8List();

//       _pickupIcon = BitmapDescriptor.fromBytes(pickupIconBytes);
//     } catch (e) {
//       print('Error loading pickup icon: $e');
//       _pickupIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueGreen,
//       );
//     }
//   }

//   /// Load drop icon (red pin)
//   Future<void> _loadDropIcon() async {
//     try {
//       final PictureRecorder recorder = PictureRecorder();
//       final Canvas canvas = Canvas(recorder);
//       final Size size = Size(40, 50);

//       // Draw pin stem (red)
//       final stemPaint = Paint()..color = Colors.red;
//       canvas.drawRect(Rect.fromLTWH(19, 0, 2, 30), stemPaint);

//       // Draw pin head (red circle)
//       final headPaint = Paint()..color = Colors.red;
//       canvas.drawCircle(Offset(20, 35), 12, headPaint);

//       // Draw white "X" in center
//       final xPaint = Paint()
//         ..color = Colors.white
//         ..strokeWidth = 2
//         ..strokeCap = StrokeCap.round;

//       canvas.drawLine(Offset(14, 30), Offset(26, 40), xPaint);
//       canvas.drawLine(Offset(26, 30), Offset(14, 40), xPaint);

//       final picture = recorder.endRecording();
//       final image = await picture.toImage(
//         size.width.toInt(),
//         size.height.toInt(),
//       );
//       final ByteData? byteData = await image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );
//       final Uint8List dropIconBytes = byteData!.buffer.asUint8List();

//       _dropIcon = BitmapDescriptor.fromBytes(dropIconBytes);
//     } catch (e) {
//       print('Error loading drop icon: $e');
//       _dropIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRed,
//       );
//     }
//   }

//   /// Load all custom markers
//   Future<void> _loadCustomMarkers() async {
//     await _loadCarMarker();
//     await _loadPickupIcon();
//     await _loadDropIcon();
//   }

//   Future<void> _initializeRideData() async {
//     setState(() => _isLoading = true);

//     // Extract ride data
//     _extractAndStoreRideData();

//     // Start real-time location tracking with heading
//     await _startLocationTracking();

//     // Get directions
//     await _getDirections();

//     // Set markers
//     _setMarkers();

//     setState(() => _isLoading = false);
//   }

//   void _extractAndStoreRideData() {
//     try {
//       // Store all data locally
//       _rideData = {
//         'orderId': widget.rideData['orderId']?.toString() ?? 'N/A',
//         'riderId': widget.rideData['riderId'],
//         'riderName': widget.rideData['riderName']?.toString() ?? 'Customer',
//         'riderPhone': widget.rideData['riderNumber']?.toString() ?? 'N/A',
//         'riderImage': 'https://i.pravatar.cc/100',
//         'pickupLocation':
//             widget.rideData['startLocation']?['address']?.toString() ??
//             widget.rideData['pickup']?['address']?.toString() ??
//             'Manikonda Jagir, Hyderabad, Telangana',
//         'dropLocation':
//             widget.rideData['endLocation']?['address']?.toString() ??
//             widget.rideData['destination']?['address']?.toString() ??
//             widget.rideData['dropoff']?['address']?.toString() ??
//             'Hitech City, Hyderabad, Telangana',
//         'fare': widget.rideData['totalFare']?.toString() ?? '180',
//         'distance': widget.rideData['distance']?.toString() ?? '6.5',
//         'estimatedTime': '15',
//         'vehicleType': widget.rideData['vehicleType'] ?? 'sedan',
//         'rideOtp': widget.rideData['otp'],
//         'status': 'pending',
//       };

//       // Extract coordinates
//       _extractCoordinates();

//       // Initialize driver location
//       _initializeDriverLocation();

//       // Calculate distance to pickup
//       if (_driverLocation != null && _rideData!['pickupCoordinates'] != null) {
//         _distanceToPickup = _calculateDistance(
//           _driverLocation!.latitude,
//           _driverLocation!.longitude,
//           _rideData!['pickupCoordinates'].latitude,
//           _rideData!['pickupCoordinates'].longitude,
//         );
//       }
//     } catch (e) {
//       print("❌ Error extracting ride data: $e");
//       // Set default values if extraction fails
//       _rideData = {
//         'orderId': 'N/A',
//         'riderId': 'rider_123',
//         'riderName': 'John Rider',
//         'riderPhone': '+1234567890',
//         'riderImage': 'https://i.pravatar.cc/100',
//         'pickupLocation': 'Manikonda Jagir, Hyderabad, Telangana',
//         'dropLocation': 'Hitech City, Hyderabad, Telangana',
//         'fare': '180',
//         'distance': '6.5',
//         'estimatedTime': '15',
//         'vehicleType': 'sedan',
//         'rideOtp': '1234',
//         'status': 'pending',
//       };
//       _rideData!['pickupCoordinates'] = LatLng(17.4065, 78.4772);
//       _rideData!['dropoffCoordinates'] = LatLng(17.4454, 78.3817);
//       _driverLocation = LatLng(17.4000, 78.4700);
//     }
//   }

//   void _extractCoordinates() {
//     try {
//       // Extract pickup coordinates
//       if (widget.rideData['pickup'] != null) {
//         final pickup = widget.rideData['pickup'];
//         _rideData!['pickupCoordinates'] = LatLng(
//           pickup['latitude']?.toDouble() ?? 17.4065,
//           pickup['longitude']?.toDouble() ?? 78.4772,
//         );
//       } else if (widget.rideData['startLocation'] != null) {
//         final startLocation = widget.rideData['startLocation'];
//         if (startLocation['coordinates'] != null &&
//             startLocation['coordinates'].length >= 2) {
//           _rideData!['pickupCoordinates'] = LatLng(
//             startLocation['coordinates'][1]?.toDouble() ?? 17.4065,
//             startLocation['coordinates'][0]?.toDouble() ?? 78.4772,
//           );
//         }
//       }

//       // Extract drop coordinates
//       if (widget.rideData['destination'] != null) {
//         final destination = widget.rideData['destination'];
//         _rideData!['dropoffCoordinates'] = LatLng(
//           destination['latitude']?.toDouble() ?? 17.4454,
//           destination['longitude']?.toDouble() ?? 78.3817,
//         );
//       } else if (widget.rideData['endLocation'] != null) {
//         final endLocation = widget.rideData['endLocation'];
//         if (endLocation['coordinates'] != null &&
//             endLocation['coordinates'].length >= 2) {
//           _rideData!['dropoffCoordinates'] = LatLng(
//             endLocation['coordinates'][1]?.toDouble() ?? 17.4454,
//             endLocation['coordinates'][0]?.toDouble() ?? 78.3817,
//           );
//         }
//       }

//       // Fallback coordinates if none found
//       if (_rideData!['pickupCoordinates'] == null) {
//         _rideData!['pickupCoordinates'] = LatLng(17.4065, 78.4772);
//       }

//       if (_rideData!['dropoffCoordinates'] == null) {
//         _rideData!['dropoffCoordinates'] = LatLng(17.4454, 78.3817);
//       }
//     } catch (e) {
//       print("❌ Error extracting coordinates: $e");
//       _rideData!['pickupCoordinates'] = LatLng(17.4065, 78.4772);
//       _rideData!['dropoffCoordinates'] = LatLng(17.4454, 78.3817);
//     }
//   }

//   /// Initialize driver location
//   void _initializeDriverLocation() {
//     // For Ride Request screen, driver is not at pickup yet
//     // Simulate driver location slightly away from pickup
//     if (_rideData!['pickupCoordinates'] != null) {
//       _driverLocation = LatLng(
//         _rideData!['pickupCoordinates'].latitude - 0.01,
//         _rideData!['pickupCoordinates'].longitude - 0.01,
//       );
//     } else {
//       _driverLocation = LatLng(17.4000, 78.4700);
//     }
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2,
//   ) {
//     const R = 6371; // Earth radius in km
//     final dLat = _toRadians(lat2 - lat1);
//     final dLon = _toRadians(lon2 - lon1);
//     final a =
//         sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) *
//             cos(_toRadians(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   Future<bool> _requestLocationPermission() async {
//     try {
//       final status = await Permission.location.request();

//       if (status.isGranted) {
//         return true;
//       } else {
//         setState(() => _locationError = true);
//         return false;
//       }
//     } catch (e) {
//       setState(() => _locationError = true);
//       return false;
//     }
//   }

//   /// Enhanced coordinate extraction supporting multiple backend formats
//   /// Matches React Native ArrivingClientScreen's extractCoordinates logic
//   LatLng? _extractCoordinatesHelper(
//     dynamic locationData,
//     LatLng? fallbackCoords,
//   ) {
//     if (locationData == null) return fallbackCoords;

//     // Handle string input (address only, no coords)
//     if (locationData is String) {
//       return fallbackCoords;
//     }

//     try {
//       // Strategy 1: Direct latitude/longitude fields
//       if (locationData['latitude'] != null &&
//           locationData['longitude'] != null) {
//         return LatLng(
//           locationData['latitude'].toDouble(),
//           locationData['longitude'].toDouble(),
//         );
//       }

//       // Strategy 2: lat/lng naming
//       if (locationData['lat'] != null && locationData['lng'] != null) {
//         return LatLng(
//           locationData['lat'].toDouble(),
//           locationData['lng'].toDouble(),
//         );
//       }

//       // Strategy 3: Nested coordinates object with latitude/longitude
//       if (locationData['coordinates'] != null) {
//         final coords = locationData['coordinates'];

//         if (coords is Map) {
//           if (coords['latitude'] != null && coords['longitude'] != null) {
//             return LatLng(
//               coords['latitude'].toDouble(),
//               coords['longitude'].toDouble(),
//             );
//           }
//           if (coords['lat'] != null && coords['lng'] != null) {
//             return LatLng(coords['lat'].toDouble(), coords['lng'].toDouble());
//           }
//         }

//         // Strategy 4: coordinates array (GeoJSON format [lng, lat] or [lat, lng])
//         if (coords is List && coords.length >= 2) {
//           final first = coords[0].toDouble();
//           final second = coords[1].toDouble();

//           // Heuristic: if first value is in latitude range (-90 to 90), assume [lat, lng]
//           // Otherwise assume GeoJSON format [lng, lat]
//           if (first >= -90 && first <= 90) {
//             return LatLng(first, second); // [lat, lng]
//           } else {
//             return LatLng(second, first); // [lng, lat] -> [lat, lng]
//           }
//         }
//       }

//       // Strategy 5: Direct array format
//       if (locationData is List && locationData.length >= 2) {
//         final first = locationData[0].toDouble();
//         final second = locationData[1].toDouble();

//         if (first >= -90 && first <= 90) {
//           return LatLng(first, second);
//         } else {
//           return LatLng(second, first);
//         }
//       }
//     } catch (e) {
//       print('⚠️ Error extracting coordinates: $e');
//     }

//     return fallbackCoords;
//   }

//   /// Start real-time location tracking with heading
//   /// Matches React Native ArrivingClientScreen's location tracking
//   Future<void> _startLocationTracking() async {
//     if (!await _requestLocationPermission()) {
//       print('❌ Location permission denied');
//       return;
//     }

//     // Get initial position
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 5,
//         ),
//       );

//       setState(() {
//         _driverLocation = LatLng(position.latitude, position.longitude);
//         if (position.heading.isFinite && position.heading >= 0) {
//           _driverHeading = position.heading;
//         }
//         _locationError = false;
//       });

//       print('📍 Initial location: ${position.latitude}, ${position.longitude}');
//     } catch (e) {
//       print('❌ Error getting initial position: $e');
//       setState(() => _locationError = true);
//     }

//     // Start position stream for continuous updates
//     const locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 5, // Update every 5 meters
//     );

//     _positionStreamSubscription =
//         Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//           (Position position) {
//             if (!mounted) return;

//             setState(() {
//               _driverLocation = LatLng(position.latitude, position.longitude);

//               // Update heading if available (only when device is moving)
//               if (position.heading.isFinite && position.heading >= 0) {
//                 _driverHeading = position.heading;
//               }

//               _locationError = false;
//             });

//             // Recalculate distance to pickup
//             if (_rideData!['pickupCoordinates'] != null) {
//               final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
//               _distanceToPickup = _calculateDistance(
//                 position.latitude,
//                 position.longitude,
//                 pickupCoords.latitude,
//                 pickupCoords.longitude,
//               );
//             }

//             // Update markers and route
//             _setMarkers();
//             _getDirections();
//           },
//           onError: (error) {
//             print('❌ Location stream error: $error');
//             setState(() => _locationError = true);
//           },
//         );
//   }

//   void _setMarkers() {
//     if (!mounted) return;

//     final markers = <Marker>{};

//     // Add driver marker with custom car icon and rotation
//     if (_driverLocation != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("driver"),
//           position: _driverLocation!,
//           icon:
//               _carIcon ??
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           anchor: const Offset(0.5, 0.5),
//           rotation: _driverHeading, // ✅ Rotate marker based on compass heading
//           flat: true, // ✅ Keep marker flat on map for rotation to work properly
//           infoWindow: const InfoWindow(
//             title: "Your Location",
//             snippet: "You are here",
//           ),
//           zIndex: 2,
//         ),
//       );
//     }

//     // Add pickup marker with custom green pin
//     if (_rideData?['pickupCoordinates'] != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("pickup"),
//           position: _rideData!['pickupCoordinates'],
//           infoWindow: InfoWindow(title: _rideData!['pickupLocation']),
//           icon:
//               _pickupIcon ??
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//           anchor: Offset(0.5, 1.0),
//           zIndex: 1,
//         ),
//       );
//     }

//     // Add drop marker with custom red pin
//     if (_rideData?['dropoffCoordinates'] != null) {
//       markers.add(
//         Marker(
//           markerId: const MarkerId("drop"),
//           position: _rideData!['dropoffCoordinates'],
//           infoWindow: InfoWindow(title: _rideData!['dropLocation']),
//           icon:
//               _dropIcon ??
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           anchor: Offset(0.5, 1.0),
//           zIndex: 1,
//         ),
//       );
//     }

//     // Add circle around pickup
//     if (_rideData?['pickupCoordinates'] != null) {
//       _circles = {
//         Circle(
//           circleId: CircleId('pickup_circle'),
//           center: _rideData!['pickupCoordinates'],
//           radius: 500,
//           fillColor: Colors.green.withOpacity(0.15),
//           strokeColor: Colors.green.withOpacity(0.3),
//           strokeWidth: 1,
//         ),
//       };
//     }

//     setState(() {
//       _markers = markers;
//     });
//   }

//   /// Decode polyline from Google Directions API
//   /// Matches React Native ArrivingClientScreen's decodePolyline function
//   List<LatLng> _decodePolyline(String encoded) {
//     if (encoded.isEmpty) return [];

//     List<LatLng> points = [];
//     int index = 0;
//     int len = encoded.length;
//     int lat = 0;
//     int lng = 0;

//     while (index < len) {
//       int b;
//       int shift = 0;
//       int result = 0;

//       do {
//         b = encoded.codeUnitAt(index) - 63;
//         index++;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);

//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;

//       shift = 0;
//       result = 0;

//       do {
//         b = encoded.codeUnitAt(index) - 63;
//         index++;
//         result |= (b & 0x1F) << shift;
//         shift += 5;
//       } while (b >= 0x20);

//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;

//       points.add(LatLng(lat / 1e5, lng / 1e5));
//     }

//     return points;
//   }

//   /// Fetch directions from Google Directions API
//   /// Matches React Native ArrivingClientScreen's approach
//   Future<void> _getDirections() async {
//     if (_rideData?['pickupCoordinates'] == null ||
//         _rideData?['dropoffCoordinates'] == null) {
//       return;
//     }

//     try {
//       // 1. Fetch route from Driver to Pickup
//       if (_driverLocation != null && _rideData!['pickupCoordinates'] != null) {
//         final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
//         final url = Uri.parse(
//           'https://maps.googleapis.com/maps/api/directions/json'
//           '?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}'
//           '&destination=${pickupCoords.latitude},${pickupCoords.longitude}'
//           '&key=$GOOGLE_API_KEY',
//         );

//         final response = await http.get(url);

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);

//           if (data['routes'] != null && data['routes'].isNotEmpty) {
//             final route = data['routes'][0];
//             final polylineEncoded = route['overview_polyline']['points'];
//             _routeCoordinates = _decodePolyline(polylineEncoded);

//             // Extract distance and duration
//             if (route['legs'] != null && route['legs'].isNotEmpty) {
//               final leg = route['legs'][0];
//               setState(() {
//                 _routeInfo = {
//                   'distance': leg['distance']['text'] ?? '',
//                   'duration': leg['duration']['text'] ?? '',
//                 };
//               });
//             }

//             print('🛣️ Route Driver → Pickup calculated');
//           }
//         }
//       }

//       // 2. Fetch route from Pickup to Drop
//       if (_rideData!['pickupCoordinates'] != null &&
//           _rideData!['dropoffCoordinates'] != null) {
//         final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
//         final dropoffCoords = _rideData!['dropoffCoordinates'] as LatLng;

//         final url = Uri.parse(
//           'https://maps.googleapis.com/maps/api/directions/json'
//           '?origin=${pickupCoords.latitude},${pickupCoords.longitude}'
//           '&destination=${dropoffCoords.latitude},${dropoffCoords.longitude}'
//           '&key=$GOOGLE_API_KEY',
//         );

//         final response = await http.get(url);

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);

//           if (data['routes'] != null && data['routes'].isNotEmpty) {
//             final route = data['routes'][0];
//             final polylineEncoded = route['overview_polyline']['points'];
//             _pickupToDropCoordinates = _decodePolyline(polylineEncoded);

//             print('🛣️ Route Pickup → Drop calculated');
//           }
//         }
//       }

//       _updatePolylines();
//       _fitMapToRoute();
//     } catch (e) {
//       print('❌ Error fetching directions: $e');
//     }
//   }

//   void _updatePolylines() {
//     final polylines = <Polyline>{};

//     // Driver to Pickup route (Blue solid line)
//     if (_routeCoordinates.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId('driver_to_pickup'),
//           points: _routeCoordinates,
//           color: Colors.blue,
//           width: 4,
//         ),
//       );
//     }

//     // Pickup to Drop route (Green dashed line)
//     if (_pickupToDropCoordinates.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId('pickup_to_drop'),
//           points: _pickupToDropCoordinates,
//           color: Colors.green,
//           width: 4,
//           patterns: [PatternItem.dash(10), PatternItem.gap(10)],
//         ),
//       );
//     }

//     setState(() {
//       _polylines = polylines;
//     });
//   }

//   void _fitMapToRoute() {
//     if (_mapController == null ||
//         _driverLocation == null ||
//         _rideData?['pickupCoordinates'] == null)
//       return;

//     final bounds = LatLngBounds(
//       southwest: LatLng(
//         min(
//           _driverLocation!.latitude,
//           _rideData!['pickupCoordinates'].latitude,
//         ),
//         min(
//           _driverLocation!.longitude,
//           _rideData!['pickupCoordinates'].longitude,
//         ),
//       ),
//       northeast: LatLng(
//         max(
//           _driverLocation!.latitude,
//           _rideData!['pickupCoordinates'].latitude,
//         ),
//         max(
//           _driverLocation!.longitude,
//           _rideData!['pickupCoordinates'].longitude,
//         ),
//       ),
//     );

//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (_mapController != null) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLngBounds(bounds, 100),
//         );
//       }
//     });
//   }

//   Future<void> _handleAutoDecline() async {
//     if (_hasAccepted || _hasDeclined) return;

//     _hasDeclined = true;
//     _countdownTimer?.cancel();

//     _showSnackbar('Ride auto-cancelled (timeout)');
//     // Navigator.of(context).pop();
//   }

//   Future<void> _handleDeclineRide(String reason) async {
//     if (_hasAccepted || _hasDeclined) return;

//     setState(() => _isDeclining = true);

//     try {
//       // Simulated API call
//       await Future.delayed(Duration(seconds: 1));

//       _showCancelSheet = false;
//       _selectedReasonIndex = null;

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('✅ Ride Declined'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Ride declined successfully.'),
//               SizedBox(height: 16),
//               Text('Message sent to rider:'),
//               SizedBox(height: 8),
//               Text(
//                 '"Sorry, I cannot accept this ride. Reason: $reason"',
//                 style: TextStyle(
//                   fontStyle: FontStyle.italic,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Navigator.of(context).pop();
//                 // Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       _showSnackbar('Failed to decline ride: $e');
//       // Navigator.of(context).pop();
//     } finally {
//       setState(() => _isDeclining = false);
//     }
//   }

//   Future<void> _handleAcceptRide() async {
//     if (_hasAccepted || _hasDeclined) return;

//     setState(() {
//       _isAccepting = true;
//       _hasAccepted = true;
//     });
//     _countdownTimer?.cancel();

//     try {
//       // Simulated API call
//       await Future.delayed(Duration(seconds: 2));

//       // Navigate to arriving screen
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => ArrivingClient(rideData: _rideData!),
//         ),
//       );
//     } catch (e) {
//       _showSnackbar('Failed to accept ride: $e');
//       setState(() {
//         _hasAccepted = false;
//         _isAccepting = false;
//         _timer = TOTAL_TIME;
//         _progress = 1.0;
//       });
//       _startTimer();
//     }
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_showCancelSheet) {
//           setState(() => _showCancelSheet = false);
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: _isLoading
//             ? _buildLoadingView()
//             : _rideData == null
//             ? _buildErrorView()
//             : Stack(
//                 children: [
//                   // Map Background
//                   Positioned.fill(child: _buildMap()),

//                   // // Header Overlay
//                   // Positioned(
//                   //   top: 60,
//                   //   left: 16,
//                   //   right: 16,
//                   //   child: _buildHeader(),
//                   // ),

//  // Header Overlay
//                   Positioned(
//                     top: 60,
//                     left: 16,
//                     right: 16,
//                     child:    _buildUserInfoCard(w),
//                   ),


       

//                   // Distance Badge
//                   // if (_distanceToPickup > 0)
//                   //   Positioned(
//                   //     top: 120,
//                   //     left: 0,
//                   //     right: 0,
//                   //     child: _buildDistanceBadge(),
//                   //   ),

//                   // Location Error Warning
//                   if (_locationError)
//                     Positioned(
//                       top: 120,
//                       left: 0,
//                       right: 0,
//                       child: _buildWarningBadge(),
//                     ),

//                   // Bottom Sheet with Ride Details
//                   DraggableScrollableSheet(
//                     initialChildSize: 0.45,
//                     minChildSize: 0.45,
//                     maxChildSize: 0.85,
//                     builder: (context, scrollController) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(24),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 10,
//                               offset: Offset(0, -2),
//                             ),
//                           ],
//                         ),
//                         child: SingleChildScrollView(
//                           controller: scrollController,
//                           child: _buildRideDetails(w),
//                         ),
//                       );
//                     },
//                   ),

//                   // Cancel Reason Sheet
//                   if (_showCancelSheet) _buildCancelReasonSheet(w),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildLoadingView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF87D750)),
//           SizedBox(height: 16),
//           Text(
//             'Loading ride details...',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red),
//           SizedBox(height: 16),
//           Text(
//             'No ride information available',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Please go back and try again',
//             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           ),
//           SizedBox(height: 24),
//           ElevatedButton(
//             // onPressed: () => Navigator.of(context).pop(),
//             onPressed: (){

//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//             ),
//             child: Text('Go Back', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMap() {
//     final initialLocation = _driverLocation != null
//         ? _driverLocation!
//         : (_rideData!['pickupCoordinates'] ?? LatLng(17.4065, 78.4772));

//     return Stack(
//       children: [
//         GoogleMap(
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//             _fitMapToRoute();
//           },
//           initialCameraPosition: CameraPosition(
//             target: initialLocation,
//             zoom: 14.5,
//           ),
//           markers: _markers,
//           polylines: _polylines,
//           circles: _circles,
//           myLocationEnabled: false,
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//         ),

//         // Legend for markers
//         Positioned(
//           bottom: 10,
//           left: 10,
//           child: Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _legendItem("You (Driver)", Colors.blue),
//                 _legendItem("Pickup", Colors.green),
//                 _legendItem("Drop", Colors.red),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _legendItem(String text, Color color) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Container(
//             width: 16,
//             height: 16,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//           ),
//           SizedBox(width: 8),
//           Text(
//             text,
//             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.black.withOpacity(0.05)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 12,
//             offset: Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF87D750),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'DR',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Driver Name',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     'Driver',
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Color(0xFF87D750),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               'New Ride Request',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDistanceBadge() {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.75),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           '📍 ${_distanceToPickup.toStringAsFixed(2)} km to pickup',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWarningBadge() {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.red.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           '⚠️ Location unavailable',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRideDetails(double w) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Date
//           Center(
//             child: Text(
//               DateFormat('dd MMMM, yyyy').format(DateTime.now()),
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(height: 16),

//           // User Info Card
//           // _buildUserInfoCard(w),
//           SizedBox(height: 16),

//           // Trip Information
//           Text(
//             'Trip Information',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 14),

//           // Pickup Location
//           // _buildLocationRow(
//           //   label: 'Pickup',
//           //   location: _rideData!['pickupLocation'],
//           //   isPickup: true,
//           // ),
//           // SizedBox(height: 6),

//           // // Drop Location
//           // _buildLocationRow(
//           //   label: 'Drop',
//           //   location: _rideData!['dropLocation'],
//           //   isPickup: false,
//           // ),
//           // SizedBox(height: 16),

// _locationInfo(context, w, _rideData!['pickupLocation'], _rideData!['dropLocation'],),

// SizedBox(height: 5,),
//           // Distance Info Cards
//           _buildInfoGrid(),
//           SizedBox(height: 20),

//           // Action Buttons
//           // _buildActionButtons(w),
//             _actionButtons(context, w),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfoCard(double w) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xFFF0F0F0)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: NetworkImage(_rideData!['riderImage']),
//               ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _rideData!['riderName'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     'Customer',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.currency_rupee,
//                     color: Color(0xFF22C55E),
//                     size: 20,
//                   ),
//                   Text(
//                     _rideData!['fare'],
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF22C55E),
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 '${_rideData!['estimatedTime']} min',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationRow({
//     required String label,
//     required String location,
//     required bool isPickup,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isPickup
//                     ? Color(0xFF22C55E).withOpacity(0.15)
//                     : Colors.transparent,
//               ),
//               child: Center(
//                 child: Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isPickup ? Color(0xFF22C55E) : Color(0xFFF97316),
//                     border: Border.all(color: Colors.white, width: 2),
//                   ),
//                 ),
//               ),
//             ),
//             if (isPickup)
//               Container(
//                 width: 1,
//                 height: 24,
//                 margin: EdgeInsets.symmetric(vertical: 3),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     left: BorderSide(
//                       color: Color(0xFF22C55E),
//                       width: 1,
//                       style: BorderStyle.solid,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 location,
//                 style: TextStyle(fontSize: 14, color: Colors.black),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoGrid() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildInfoCard(
//             icon: Icons.map_outlined,
//             iconColor: Color(0xFF3B82F6),
//             backgroundColor: Color(0xFFEFF6FF),
//             label: 'Pick up.',
//             // label: 'Pickup dist.',
//             value: '${_distanceToPickup.toStringAsFixed(2)} Km',
//           ),
//         ),
//         SizedBox(width: 12),
//         Expanded(
//           child: _buildInfoCard(
//             icon: Icons.navigation_outlined,
//             iconColor: Color(0xFF10B981),
//             backgroundColor: Color(0xFFECFDF5),
//             // label: 'Ride dist.',
//             label: 'Drop',
//             value: '${_rideData!['distance']} Km',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required Color iconColor,
//     required Color backgroundColor,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFF0F0F0)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(child: Icon(icon, size: 18, color: iconColor)),
//           ),
//           SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(double w) {
//     return Container(
//       padding: EdgeInsets.only(top: 8),
//       decoration: BoxDecoration(
//         border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
//       ),
//       child: Column(
//         children: [
//           // Timer display above buttons (1-minute timer)
//           // Container(
//           //   margin: EdgeInsets.only(bottom: 12),
//           //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           //   decoration: BoxDecoration(
//           //     color: _timer <= 10
//           //         ? Colors.red.withOpacity(0.1)
//           //         : _timer <= 30
//           //         ? Colors.orange.withOpacity(0.1)
//           //         : Colors.green.withOpacity(0.1),
//           //     borderRadius: BorderRadius.circular(8),
//           //     border: Border.all(
//           //       color: _timer <= 10
//           //           ? Colors.red
//           //           : _timer <= 30
//           //           ? Colors.orange
//           //           : Colors.green,
//           //     ),
//           //   ),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: [
//           //       Icon(
//           //         Icons.timer,
//           //         size: 18,
//           //         color: _timer <= 10
//           //             ? Colors.red
//           //             : _timer <= 30
//           //             ? Colors.orange
//           //             : Colors.green,
//           //       ),
//           //       SizedBox(width: 8),
//           //       Text(
//           //         'Accept within: ${_formatTime(_timer)}',
//           //         style: TextStyle(
//           //           fontSize: 14,
//           //           fontWeight: FontWeight.w600,
//           //           color: _timer <= 10
//           //               ? Colors.red
//           //               : _timer <= 30
//           //               ? Colors.orange
//           //               : Colors.green,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),

//               // _actionButtons(context, w),

              

//           // Buttons Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Cancel Button
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: _hasAccepted || _hasDeclined
//                       ? null
//                       : () => setState(() => _showCancelSheet = true),
//                   style: OutlinedButton.styleFrom(
//                     backgroundColor: Color(0xFFF5F5F5),
//                     side: BorderSide(color: Color(0xFFE0E0E0)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12),

//               // Accept Button with Timer Circle
//               Expanded(
//                 flex: 10,
//                 child: Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _hasAccepted || _hasDeclined || _isAccepting
//                           ? null
//                           : _handleAcceptRide,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _timer <= 10
//                             ? Colors.red
//                             : _timer <= 30
//                             ? Colors.orange
//                             : Color(0xFF87D750),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 16),
//                       ),
//                       child: _isAccepting
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               'Accept',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 16,
//                               ),
//                             ),
//                     ),

//                     // Timer Circle
//                     Positioned(right: 10, child: _buildTimerCircle()),
//                   ],
//                 ),
//               ),
           
           
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatTime(int seconds) {
//     if (seconds >= 60) {
//       final minutes = seconds ~/ 60;
//       final remainingSeconds = seconds % 60;
//       return '${minutes}m ${remainingSeconds}s';
//     }
//     return '${seconds}s';
//   }

//   Widget _buildTimerCircle() {
//     const size = 26.0;
//     const strokeWidth = 3.0;
//     const radius = (size - strokeWidth) / 2;
//     const circumference = 2 * pi * radius;
//     final strokeDashoffset = circumference * (1 - _progress);

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Background circle
//           CircularProgressIndicator(
//             value: 1,
//             strokeWidth: strokeWidth,
//             backgroundColor: Color(0xFFE5E7EB),
//             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE5E7EB)),
//           ),

//           // Progress circle (changes color based on time)
//           SizedBox(
//             width: size,
//             height: size,
//             child: CustomPaint(
//               painter: _TimerPainter(
//                 progress: _progress,
//                 strokeWidth: strokeWidth,
//                 color: _timer <= 10
//                     ? Colors.red
//                     : _timer <= 30
//                     ? Colors.orange
//                     : Color(0xFF16A34A),
//               ),
//             ),
//           ),

//           // Timer text
//           Center(
//             child: Text(
//               '$_timer',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 color: _timer <= 10
//                     ? Colors.red
//                     : _timer <= 30
//                     ? Colors.orange
//                     : Color(0xFF87D750),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCancelReasonSheet(double w) {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.black.withOpacity(0.5),
//         child: DraggableScrollableSheet(
//           initialChildSize: 0.55,
//           minChildSize: 0.55,
//           maxChildSize: 0.7,
//           builder: (context, scrollController) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Column(
//                 children: [
//                   // Header
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(width: 48),
//                         Text(
//                           'Why Do You Want To Cancel?',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close),
//                           onPressed: () =>
//                               setState(() => _showCancelSheet = false),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Reason List
//                   Expanded(
//                     child: ListView.builder(
//                       controller: scrollController,
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _cancelReasons.length,
//                       itemBuilder: (context, index) {
//                         final reason = _cancelReasons[index];
//                         final isSelected = _selectedReasonIndex == index;

//                         return Card(
//                           margin: EdgeInsets.only(bottom: 8),
//                           color: isSelected
//                               ? Color(0xFF87D750).withOpacity(0.1)
//                               : Color(0xFFF9FAFB),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: BorderSide(
//                               color: isSelected
//                                   ? Color(0xFF87D750)
//                                   : Color(0xFFE5E7EB),
//                             ),
//                           ),
//                           child: ListTile(
//                             leading: Icon(
//                               reason['icon'],
//                               color: isSelected
//                                   ? Color(0xFF87D750)
//                                   : Colors.grey[700],
//                             ),
//                             title: Text(
//                               reason['label'],
//                               style: TextStyle(
//                                 color: isSelected
//                                     ? Color(0xFF87D750)
//                                     : Colors.black,
//                                 fontWeight: isSelected
//                                     ? FontWeight.w500
//                                     : FontWeight.normal,
//                               ),
//                             ),
//                             onTap: () =>
//                                 setState(() => _selectedReasonIndex = index),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // Submit Button
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: ElevatedButton(
//                       onPressed: _selectedReasonIndex == null || _isDeclining
//                           ? null
//                           : () {
//                               final reason =
//                                   _cancelReasons[_selectedReasonIndex!]['label'];
//                               _handleDeclineRide(reason);
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF87D750),
//                         minimumSize: Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       child: _isDeclining
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               'Submit',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }


//   Widget _locationInfo(BuildContext context, double w, String pickupAddress, String dropAddress) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Location",
//               style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
//             ),
//             Text.rich(
//               TextSpan(
//                 text: "Time ",
//                 style: TextStyle(
//                   fontSize: w * 0.029,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF7C7C8D),
//                 ),
//                 children: [
//                   // TextSpan(
//                   //   text: "10 min",
//                   //   style: TextStyle(
//                   //     fontSize: w * 0.04,
//                   //     fontWeight: FontWeight.w600,
//                   //     color: AppColors.black,
//                   //   ),
//                   // ),


//  TextSpan(
//                     text: "${_rideData!['estimatedTime']} min",
//                     style: TextStyle(
//                       fontSize: w * 0.04,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.black,
//                     ),
//                   ),

// // 


                  

                  
//                 ],
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: [
//                 CustomImages.images(
//                   "assets/icons/greenDot.png",
//                   w * 0.05,
//                   w * 0.05,
//                 ),
//                 SizedBox(
//                   height: w * 0.1,
//                   child: DottedLine(
//                     direction: Axis.vertical,
//                     dashLength: 4,
//                     dashColor: AppColors.green,
//                   ),
//                 ),
//                 CustomImages.images(
//                   "assets/icons/redDot.png",
//                   w * 0.05,
//                   w * 0.05,
//                 ),
//               ],
//             ),
//             SizedBox(width: w * 0.03),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _locationText(
//                     context,
//                     "Pickup",
//                     pickupAddress,
//                   ),
//                   SizedBox(height: w * 0.05),
//                   _locationText(
//                     context,
//                     "Drop",
//                     dropAddress,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }


//   Widget _fareCard(BuildContext context, double w, String riderName, String totalFare, String riderPhone, String rideId, String orderId) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(w * 0.035),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: AppColors.mediumGray.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Image.asset(
//                 "assets/images/profil.png",
//                 height: w * 0.12,
//                 width: w * 0.12,
//               ),
//               SizedBox(width: w * 0.04),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppFonts.textPoppins(
//                       context,
//                       riderName,
//                       w * 0.048,
//                       FontWeight.w600,
//                       AppColors.black,
//                       TextAlign.start,
//                       TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: w * 0.01),
//                     AppFonts.textPoppins(
//                       context,
//                       riderPhone,
//                       w * 0.035,
//                       FontWeight.w500,
//                       AppColors.mediumGray,
//                       TextAlign.start,
//                       TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.currency_rupee, color: AppColors.green, size: w * 0.065),
//                       AppFonts.textPoppins(
//                         context,
//                         totalFare,
//                         w * 0.055,
//                         FontWeight.w600,
//                         AppColors.green,
//                         TextAlign.center,
//                         TextOverflow.visible,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: w * 0.01),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.01),
//                     decoration: BoxDecoration(
//                       color: AppColors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(w * 0.02),
//                     ),
//                     child: AppFonts.textPoppins(
//                       context,
//                       widget.rideData['rideType']?.toString().toUpperCase() ?? 'IMMEDIATE',
//                       w * 0.03,
//                       FontWeight.w600,
//                       AppColors.green,
//                       TextAlign.center,
//                       TextOverflow.visible,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: w * 0.02),
//           // Additional ride info
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     _rideInfoItem(context, w, "Ride ID", rideId),
//           //     _rideInfoItem(context, w, "Order ID", orderId),
//           //   ],
//           // ),
//         ],
//       ),
//     ).animate().fade(duration: 700.ms).scale();
//   }

//     Widget _locationText(BuildContext context, String title, String address) {
//     final double w = MediaQuery.of(context).size.width;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppFonts.textPoppins(
//           context,
//           title,
//           w * 0.035,
//           FontWeight.w500,
//           AppColors.mediumGray,
//           TextAlign.left,
//           TextOverflow.visible,
//         ),
//         AppFonts.textPoppins(
//           context,
//           address,
//           w * 0.039,
//           FontWeight.w500,
//           AppColors.black,
//           TextAlign.left,
//           TextOverflow.ellipsis,
//           maxLines: 2,
//         ),
//       ],
//     );
//   }


//     Widget _actionButtons(BuildContext context, double w) {
//     return Column(
//       children: [
//         // // Timer display above buttons
//         // Container(
//         //   margin: EdgeInsets.only(bottom: w * 0.03),
//         //   padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
//         //   decoration: BoxDecoration(
//         //     color: _secondsRemaining <= 3 ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//         //     borderRadius: BorderRadius.circular(w * 0.02),
//         //     border: Border.all(
//         //       color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//         //     ),
//         //   ),
//         //   child: Row(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: [
//         //       Icon(
//         //         Icons.timer,
//         //         size: w * 0.05,
//         //         color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//         //       ),
//         //       SizedBox(width: w * 0.02),
//         //       Text(
//         //         'Accept within: $_secondsRemaining seconds',
//         //         style: TextStyle(
//         //           fontSize: w * 0.04,
//         //           fontWeight: FontWeight.w600,
//         //           color: _secondsRemaining <= 3 ? Colors.red : Colors.orange,
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
        
//         // Buttons Row
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Cancel Button
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: _hasAccepted || _hasCancelled ? null : _cancelRide,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.lightGray,
//                   foregroundColor: AppColors.mediumGray,
//                   minimumSize: Size(w * 0.43, w * 0.14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(color: AppColors.mediumGray.withOpacity(0.5)),
//                   ),
//                   elevation: 0,
//                   disabledBackgroundColor: AppColors.lightGray.withOpacity(0.5),
//                   disabledForegroundColor: AppColors.mediumGray.withOpacity(0.5),
//                 ),
//                 child: Text(
//                   "Cancel",
//                   style: TextStyle(
//                     fontSize: w * 0.045,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),

//             SizedBox(width: w * 0.03),

//             // Accept Button with timer integration
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: _secondsRemaining <= 3 
//                       ? Border.all(color: Colors.red, width: 2)
//                       : _secondsRemaining <= 6
//                       ? Border.all(color: Colors.orange, width: 2)
//                       : null,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: _hasAccepted || _hasCancelled ? null : _acceptRide,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _secondsRemaining <= 3 
//                         ? Colors.red 
//                         : _secondsRemaining <= 6
//                         ? Colors.orange
//                         : ColorsList.mainButtonColor,
//                     foregroundColor: Colors.white,
//                     minimumSize: Size(w * 0.43, w * 0.14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     elevation: 2,
//                     shadowColor: ColorsList.mainButtonColor.withOpacity(0.3),
//                     disabledBackgroundColor: ColorsList.mainButtonColor.withOpacity(0.5),
//                     disabledForegroundColor: Colors.white.withOpacity(0.5),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Text(
//                             "Accept",
//                             style: TextStyle(
//                               fontSize: w * 0.045,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           // SizedBox(width: 14,),
//                                                 _buildTimerCircle(),

//                         ],
//                       ),
//                       // SizedBox(height: w * 0.005),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   children: [
//                       //     Icon(
//                       //       Icons.timer,
//                       //       size: w * 0.03,
//                       //       color: Colors.white.withOpacity(0.9),
//                       //     ),
//                       //     SizedBox(width: w * 0.01),
//                       //     Text(
//                       //       "$_secondsRemaining s",
//                       //       style: TextStyle(
//                       //         fontSize: w * 0.03,
//                       //         fontWeight: FontWeight.w500,
//                       //         color: Colors.white.withOpacity(0.9),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
                    
                    
//                     ],
//                   ),
//                 ),
//               ),
//             ),
          
          
//           ],
//         ),
//       ],
//     );

    
//   }

//   Future<void> _acceptRide() async {
//      print("myyy_tapp33333");
//     if (_hasAccepted || _hasCancelled) return;
    

//      print("myyy_tappp244444");
//     _hasAccepted = true;
//     _isTimerRunning = false;
//     _autoCancelTimer?.cancel();
    
//     print("🚗 Accepting ride with ID: $_orderId");

//     stepperController.resetSteps();
    
//     print("myyy_tappp2");
//     await orderUpdateController.update_order_method(orderstatus: "Accepted", orderid: _orderId);
//      print("myyy_tappp255555");
//     CustomNavigator.push(
//       context,
//       ArrivingClient(
//         rideData: widget.rideData,
//       ),
//       transition: TransitionType.slideLeft,
//     );
//   }
// }



// class _TimerPainter extends CustomPainter {
//   final double progress;
//   final double strokeWidth;
//   final Color color;

//   _TimerPainter({
//     required this.progress,
//     required this.strokeWidth,
//     required this.color,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = (size.width - strokeWidth) / 2;
//     final sweepAngle = 2 * pi * progress;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -pi / 2,
//       sweepAngle,
//       false,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant _TimerPainter oldDelegate) {
//     return progress != oldDelegate.progress || color != oldDelegate.color;
//   }
// }





// class OrderService {
//   static Future<void> declineOrder({
//     String? orderId,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("auth_token");
//     final String? order_id = prefs.getString("order_id");

//     print("my___token_here ${token}");
//     print("declineddddd__myyyyy_orderid_iss ${orderId}");

//     final Uri url = Uri.parse(
//       "https://corezap.smarttechbros.com/api/v1/order/decline/$order_id",
//     );

//     print("🔵 DECLINE ORDER API");
//     print("URL : $url");

//     try {
//       final response = await http.patch(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//       );

//       print("✅ Status Code : ${response.statusCode}");
//       print("📦 Raw Response : ${response.body}");

//       final decoded = jsonDecode(response.body);
//       print("🎯 Decoded Response : $decoded");
      
//       Fluttertoast.showToast(
//         msg: decoded['message'] ?? "Ride declined successfully",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );
//     } catch (e) {
//       print("❌ Error declining order : $e");
//     }
//   }


//       static Future<void> VerifyOtpOrder({
//     required String orderId,
//     required String rideOtpEnter,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString("auth_token");

//     final String? order_id = prefs.getString("order_id");

//     print("my___token_here ${token}");
//     print("myyyyy_orderid_iss in verifyOtpppp>>>>> ${order_id}");

//     final Uri url = Uri.parse(
//       "https://corezap.smarttechbros.com/api/v1/order/verifyOtp",
//     );

//     print("🔵 ACCEPT ORDER API");
//     print("URL : $url");

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "orderId": order_id,
//           "rideOtp": rideOtpEnter
//         }),
//       );

//       print("arriivinngggggggggggggggggggggggg");
//       print("✅ Status Code : ${response.statusCode}");
//       print("📦 Raw Response arrivinggggggggg : ${response.body}");
//       print("arriivinngggggggggggggggggggggggg");

//       final decoded = jsonDecode(response.body);
//       print("🎯 Decoded Response : $decoded");
//     } catch (e) {
//       print("❌ Error accepting order : $e");
//     }
//   }
// }