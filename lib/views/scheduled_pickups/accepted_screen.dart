// import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:corezap_driver/utilities/colors/colors_list.dart';
// import 'package:corezap_driver/utilities/custom_images.dart';
// import 'package:corezap_driver/utilities/custom_text.dart';
// import 'package:corezap_driver/utilities/location_input_textfield.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/newwwwwwwwwwz.dart';
// import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:math';

// class ArrivingClient extends StatefulWidget {
//   final bool? typeCheck;
//   final Map<String, dynamic>? rideData;

//   ArrivingClient({super.key, this.typeCheck, this.rideData});

//   @override
//   State<ArrivingClient> createState() => _ArrivingClientState();
// }

// class _ArrivingClientState extends State<ArrivingClient> {
//   final StepperController stepperController = Get.find<StepperController>();
//   final OrderUpdateController orderUpdateController =
//       Get.find<OrderUpdateController>();

//   // Google API Key for Directions
//   static const String GOOGLE_API_KEY =
//       'AIzaSyCtM1jo8qzhEn2XZ8SVCoboULcondCjZio';

//   // Map & Location
//   GoogleMapController? _mapController;
//   LatLng? _driverLocation;
//   double _driverHeading = 0;
//   double _distanceToPickup = 0;
//   bool _locationError = false;
//   bool _isScreenActive = true;
//   bool _isInitialized = false;
//   StreamSubscription<Position>? _positionStreamSubscription;

//   // Map Elements
//   Set<Marker> markers = {};
//   Set<Circle> circles = {};
//   Set<Polyline> _polylines = {};

//   // Ride Data
//   Map<String, dynamic>? _rideData;
//   List<LatLng> _routeCoordinates = [];
//   List<LatLng> _pickupToDropCoordinates = [];

//   // Custom Marker Icons
//   BitmapDescriptor? _bikeMarkerIcon;
//   BitmapDescriptor? _pickupMarkerIcon;
//   BitmapDescriptor? _dropMarkerIcon;

//   @override
//   void initState() {
//     super.initState();
//     _isScreenActive = true;
//     print('🚗 ArrivingClient initState called');

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _initializeAll();
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     print('🔄 ArrivingClient didChangeDependencies called');

//     // Refresh map if coming back from another screen
//     if (_isScreenActive && !_isInitialized) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await _refreshOnReturn();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     print('🗑️ ArrivingClient dispose called');
//     _isScreenActive = false;
//     _cleanupResources();
//     super.dispose();
//   }

//   void _cleanupResources() {
//     _positionStreamSubscription?.pause();
//     _positionStreamSubscription?.cancel();
//     _positionStreamSubscription = null;

//     _mapController?.dispose();
//     _mapController = null;

//     markers.clear();
//     circles.clear();
//     _polylines.clear();

//     _isInitialized = false;
//   }

//   Future<void> _pauseLocationTracking() async {
//     print('⏸️ Pausing location tracking');
//     _positionStreamSubscription?.pause();
//   }

//   Future<void> _resumeLocationTracking() async {
//     print('▶️ Resuming location tracking');
//     if (_positionStreamSubscription != null && _isScreenActive) {
//       _positionStreamSubscription?.resume();
//     } else if (_isScreenActive) {
//       await _startLocationTracking();
//     }
//   }

//   Future<void> _initializeAll() async {
//     if (_isInitialized) {
//       print('✅ Already initialized, skipping...');
//       return;
//     }

//     try {
//       print('🔄 Initializing ArrivingClient...');

//       // Extract ride data
//       _extractAndStoreRideData();

//       // Load custom marker icons
//       await _loadCustomMarkers();

//       // Start location tracking
//       await _startLocationTracking();

//       // Get directions
//       await _getDirections();

//       // Set markers
//       _setMarkers();

//       _isInitialized = true;
//       print('✅ ArrivingClient initialized successfully');
//     } catch (e) {
//       print('❌ Error initializing: $e');
//       if (mounted) {
//         setState(() {
//           _locationError = true;
//         });
//       }
//     }
//   }

//   Future<void> _refreshOnReturn() async {
//     print('🔄 Refreshing on return...');
//     if (!mounted || !_isScreenActive) return;

//     setState(() {
//       markers.clear();
//       circles.clear();
//       _polylines.clear();
//     });

//     await Future.delayed(const Duration(milliseconds: 300));

//     if (mounted && _isScreenActive) {
//       await _startLocationTracking();
//       _setMarkers();
//       _updatePolylines();
//       _fitMapToAllMarkers();
//     }
//   }

//   void _extractAndStoreRideData() {
//     print("📦 Ride Data Received: ${widget.rideData}");

//     // Store all data locally
//     _rideData = {
//       'orderId': widget.rideData?['orderId']?.toString() ?? 'N/A',
//       'riderId': widget.rideData?['riderId'],
//       'riderName': widget.rideData?['riderName']?.toString() ?? 'Customer',
//       'riderPhone': widget.rideData?['riderNumber']?.toString() ?? 'N/A',
//       'pickupLocation':
//           widget.rideData?['startLocation']?['address']?.toString() ??
//           widget.rideData?['pickup']?['address']?.toString() ??
//           'Pickup location',
//       'dropLocation':
//           widget.rideData?['endLocation']?['address']?.toString() ??
//           widget.rideData?['destination']?['address']?.toString() ??
//           widget.rideData?['dropoff']?['address']?.toString() ??
//           'Drop location',
//       'fare': widget.rideData?['totalFare']?.toString() ?? '100',
//       'distance': widget.rideData?['distance']?.toString() ?? '0',
//     };

//     // Extract coordinates
//     _extractCoordinates();

//     print('✅ Ride data extracted successfully');
//   }

//   void _extractCoordinates() {
//     try {
//       // Extract pickup coordinates
//       if (widget.rideData?['pickup'] != null) {
//         final pickup = widget.rideData!['pickup'];
//         _rideData!['pickupCoordinates'] = LatLng(
//           pickup['latitude']?.toDouble() ?? 23.2599,
//           pickup['longitude']?.toDouble() ?? 77.4126,
//         );
//       } else if (widget.rideData?['startLocation'] != null) {
//         final startLocation = widget.rideData!['startLocation'];
//         if (startLocation['coordinates'] != null &&
//             startLocation['coordinates'].length >= 2) {
//           _rideData!['pickupCoordinates'] = LatLng(
//             startLocation['coordinates'][1]?.toDouble() ?? 23.2599,
//             startLocation['coordinates'][0]?.toDouble() ?? 77.4126,
//           );
//         }
//       }

//       // Extract drop coordinates
//       if (widget.rideData?['destination'] != null) {
//         final destination = widget.rideData!['destination'];
//         _rideData!['dropoffCoordinates'] = LatLng(
//           destination['latitude']?.toDouble() ?? 18.5204,
//           destination['longitude']?.toDouble() ?? 73.8567,
//         );
//       } else if (widget.rideData?['endLocation'] != null) {
//         final endLocation = widget.rideData!['endLocation'];
//         if (endLocation['coordinates'] != null &&
//             endLocation['coordinates'].length >= 2) {
//           _rideData!['dropoffCoordinates'] = LatLng(
//             endLocation['coordinates'][1]?.toDouble() ?? 18.5204,
//             endLocation['coordinates'][0]?.toDouble() ?? 73.8567,
//           );
//         }
//       }

//       // Fallback coordinates if none found
//       if (_rideData!['pickupCoordinates'] == null) {
//         _rideData!['pickupCoordinates'] = const LatLng(
//           23.2599,
//           77.4126,
//         ); // Bhopal
//       }

//       if (_rideData!['dropoffCoordinates'] == null) {
//         _rideData!['dropoffCoordinates'] = const LatLng(
//           18.5204,
//           73.8567,
//         ); // Pune
//       }

//       print('📍 Pickup coordinates: ${_rideData!['pickupCoordinates']}');
//       print('📍 Drop coordinates: ${_rideData!['dropoffCoordinates']}');
//     } catch (e) {
//       print("❌ Error extracting coordinates: $e");
//       _rideData!['pickupCoordinates'] = const LatLng(
//         23.2599,
//         77.4126,
//       ); // Bhopal
//       _rideData!['dropoffCoordinates'] = const LatLng(18.5204, 73.8567); // Pune
//     }
//   }

//   Future<bool> _requestLocationPermission() async {
//     try {
//       final status = await Permission.location.request();

//       if (status.isGranted) {
//         return true;
//       } else {
//         if (mounted) {
//           setState(() => _locationError = true);
//         }
//         return false;
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _locationError = true);
//       }
//       return false;
//     }
//   }

//   Future<void> _loadCustomMarkers() async {
//     try {
//       // Load bike marker
//       final ByteData bikeData = await rootBundle.load(
//         'assets/images/bike2.png',
//       );
//       final ui.Codec bikeCodec = await ui.instantiateImageCodec(
//         bikeData.buffer.asUint8List(),
//         targetWidth: 120,
//         targetHeight: 120,
//       );
//       final ui.FrameInfo bikeFi = await bikeCodec.getNextFrame();
//       final ByteData? bikeBytes = await bikeFi.image.toByteData(
//         format: ui.ImageByteFormat.png,
//       );

//       if (bikeBytes != null) {
//         _bikeMarkerIcon = BitmapDescriptor.fromBytes(
//           bikeBytes.buffer.asUint8List(),
//         );
//         print('✅ Bike marker icon loaded');
//       }

//       // Create pickup marker (blue)
//       _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueBlue,
//       );

//       // Create drop marker (red)
//       _dropMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRed,
//       );
//     } catch (e) {
//       print('❌ Error loading markers: $e');
//       _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueBlue,
//       );
//       _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueBlue,
//       );
//       _dropMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueRed,
//       );
//     }
//   }

//   Future<void> _startLocationTracking() async {
//     if (!await _requestLocationPermission()) {
//       print('❌ Location permission denied');
//       return;
//     }

//     // Cancel existing subscription if any
//     _positionStreamSubscription?.cancel();

//     // Get initial position
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 10,
//         ),
//       );

//       if (!_isScreenActive || !mounted) return;

//       setState(() {
//         _driverLocation = LatLng(position.latitude, position.longitude);
//         if (position.heading.isFinite && position.heading >= 0) {
//           _driverHeading = position.heading;
//         }
//         _locationError = false;
//       });

//       print('📍 Initial location: ${position.latitude}, ${position.longitude}');

//       // Calculate distance to pickup
//       if (_rideData?['pickupCoordinates'] != null) {
//         final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
//         _distanceToPickup = _calculateDistance(
//           position.latitude,
//           position.longitude,
//           pickupCoords.latitude,
//           pickupCoords.longitude,
//         );
//       }
//     } catch (e) {
//       print('❌ Error getting initial position: $e');
//       if (_isScreenActive && mounted) {
//         setState(() => _locationError = true);
//       }
//     }

//     // Start position stream for continuous updates
//     const locationSettings = LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 10,
//     );

//     _positionStreamSubscription =
//         Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//           (Position position) {
//             if (!_isScreenActive || !mounted) return;

//             setState(() {
//               _driverLocation = LatLng(position.latitude, position.longitude);

//               if (position.heading.isFinite && position.heading >= 0) {
//                 _driverHeading = position.heading;
//               }

//               _locationError = false;
//             });

//             // Recalculate distance to pickup
//             if (_rideData?['pickupCoordinates'] != null) {
//               final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
//               _distanceToPickup = _calculateDistance(
//                 position.latitude,
//                 position.longitude,
//                 pickupCoords.latitude,
//                 pickupCoords.longitude,
//               );
//             }

//             // Update markers
//             _setMarkers();
//           },
//           onError: (error) {
//             print('❌ Location stream error: $error');
//             if (_isScreenActive && mounted) {
//               setState(() => _locationError = true);
//             }
//           },
//           cancelOnError: true,
//         );
//   }

//   double _calculateDistance(
//     double lat1,
//     double lon1,
//     double lat2,
//     double lon2,
//   ) {
//     const R = 6371;
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

//   void _setMarkers() {
//     if (!_isScreenActive || !mounted) return;

//     final newMarkers = <Marker>{};
//     final newCircles = <Circle>{};

//     // 1. Driver marker (blue bike icon)
//     if (_driverLocation != null && _bikeMarkerIcon != null) {
//       newMarkers.add(
//         Marker(
//           markerId: const MarkerId("driver"),
//           position: _driverLocation!,
//           icon: _bikeMarkerIcon!,
//           anchor: const Offset(0.5, 0.5),
//           rotation: _driverHeading,
//           flat: true,
//           infoWindow: const InfoWindow(title: "Your Location"),
//           zIndex: 2,
//         ),
//       );

//       // Driver accuracy circles
//       newCircles.add(
//         Circle(
//           circleId: const CircleId('outer_shadow'),
//           center: _driverLocation!,
//           radius: 140,
//           fillColor: Colors.grey.withOpacity(0.25),
//           strokeColor: Colors.transparent,
//         ),
//       );

//       newCircles.add(
//         Circle(
//           circleId: const CircleId('inner_green'),
//           center: _driverLocation!,
//           radius: 60,
//           fillColor: Colors.green.withOpacity(0.35),
//           strokeColor: Colors.green,
//           strokeWidth: 1,
//         ),
//       );
//     }

//     // 2. Pickup marker
//     if (_rideData?['pickupCoordinates'] != null && _pickupMarkerIcon != null) {
//       newMarkers.add(
//         Marker(
//           markerId: const MarkerId("pickup"),
//           position: _rideData!['pickupCoordinates'],
//           infoWindow: InfoWindow(
//             title: "Pickup",
//             snippet: _rideData!['pickupLocation'],
//           ),
//           icon: _pickupMarkerIcon!,
//           zIndex: 1,
//         ),
//       );

//       // Pickup zone circle
//       newCircles.add(
//         Circle(
//           circleId: const CircleId('pickup_zone'),
//           center: _rideData!['pickupCoordinates'],
//           radius: 500,
//           fillColor: Colors.blue.withOpacity(0.15),
//           strokeColor: Colors.blue.withOpacity(0.5),
//           strokeWidth: 2,
//         ),
//       );
//     }

//     // 3. Drop marker
//     if (_rideData?['dropoffCoordinates'] != null && _dropMarkerIcon != null) {
//       newMarkers.add(
//         Marker(
//           markerId: const MarkerId("drop"),
//           position: _rideData!['dropoffCoordinates'],
//           infoWindow: InfoWindow(
//             title: "Drop",
//             snippet: _rideData!['dropLocation'],
//           ),
//           icon: _dropMarkerIcon!,
//           zIndex: 1,
//         ),
//       );
//     }

//     if (mounted) {
//       setState(() {
//         markers = newMarkers;
//         circles = newCircles;
//       });
//     }

//     // Fit map to show all markers
//     _fitMapToAllMarkers();
//   }

//   void _fitMapToAllMarkers() {
//     if (_mapController == null || !_isScreenActive) return;

//     final List<LatLng> allPoints = [];

//     if (_driverLocation != null) allPoints.add(_driverLocation!);
//     if (_rideData?['pickupCoordinates'] != null)
//       allPoints.add(_rideData!['pickupCoordinates']);
//     if (_rideData?['dropoffCoordinates'] != null)
//       allPoints.add(_rideData!['dropoffCoordinates']);

//     if (allPoints.isEmpty) return;

//     final bounds = _boundsFromLatLngList(allPoints);

//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_mapController != null && _isScreenActive && mounted) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLngBounds(bounds, 150),
//         );
//       }
//     });
//   }

//   LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
//     double? x0, x1, y0, y1;

//     for (LatLng latLng in list) {
//       if (x0 == null) {
//         x0 = x1 = latLng.latitude;
//         y0 = y1 = latLng.longitude;
//       } else {
//         if (latLng.latitude > x1!) x1 = latLng.latitude;
//         if (latLng.latitude < x0) x0 = latLng.latitude;
//         if (latLng.longitude > y1!) y1 = latLng.longitude;
//         if (latLng.longitude < y0!) y0 = latLng.longitude;
//       }
//     }

//     return LatLngBounds(
//       southwest: LatLng(x0!, y0!),
//       northeast: LatLng(x1!, y1!),
//     );
//   }

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

//   Future<void> _getDirections() async {
//     if (_rideData?['pickupCoordinates'] == null ||
//         _rideData?['dropoffCoordinates'] == null) {
//       print('⚠️ Cannot get directions: coordinates missing');
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

//         print('🛣️ Fetching route from driver to pickup...');
//         final response = await http.get(url);

//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);

//           if (data['routes'] != null && data['routes'].isNotEmpty) {
//             final route = data['routes'][0];
//             final polylineEncoded = route['overview_polyline']['points'];
//             _routeCoordinates = _decodePolyline(polylineEncoded);
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

//         print('🛣️ Fetching route from pickup to drop...');
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
//     } catch (e) {
//       print('❌ Error fetching directions: $e');
//     }
//   }

//   void _updatePolylines() {
//     if (!_isScreenActive || !mounted) return;

//     final polylines = <Polyline>{};

//     // Route polylines (driver→pickup) - Blue solid line
//     if (_routeCoordinates.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: const PolylineId('driver_to_pickup'),
//           points: _routeCoordinates,
//           color: Colors.blue,
//           width: 4,
//         ),
//       );
//     }

//     // Route polylines (pickup→drop) - Green dashed line
//     if (_pickupToDropCoordinates.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: const PolylineId('pickup_to_drop'),
//           points: _pickupToDropCoordinates,
//           color: Colors.green,
//           width: 4,
//           patterns: [PatternItem.dash(10), PatternItem.gap(10)],
//         ),
//       );
//     }

//     if (mounted) {
//       setState(() {
//         _polylines = polylines;
//       });
//     }
//   }

//   Widget _buildMap() {
//     final initialLocation = _driverLocation != null
//         ? _driverLocation!
//         : (_rideData?['pickupCoordinates'] ?? const LatLng(23.2599, 77.4126));

//     return GoogleMap(
//       onMapCreated: (GoogleMapController controller) {
//         _mapController = controller;
//         print('✅ Google Map created');

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (_isScreenActive && mounted) {
//             _setMarkers();
//             _fitMapToAllMarkers();
//           }
//         });
//       },
//       initialCameraPosition: CameraPosition(
//         target: initialLocation,
//         zoom: 14.5,
//       ),
//       markers: markers,
//       circles: circles,
//       polylines: _polylines,
//       myLocationEnabled: false,
//       myLocationButtonEnabled: false,
//       zoomControlsEnabled: false,
//       compassEnabled: true,
//       rotateGesturesEnabled: true,
//       tiltGesturesEnabled: false,
//     );
//   }

//   Future<void> _navigateToOtpScreen() async {
//     print('🔄 Navigating to OTP screen...');

//     // Pause location tracking
//     await _pauseLocationTracking();

//     print("myyy_datat_Senddd ${_rideData}");
//     // Navigate and wait for result
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ArrivedOtpScreen(bookridetypecheck: false, rideData: _rideData),
//       ),
//     );

//     // Handle return from OTP screen
//     if (mounted && _isScreenActive) {
//       if (result == true) {
//         // OTP verified successfully
//         print('✅ OTP verified, updating order status...');

//         // Only proceed if API is successful
//         final orderId = _rideData?['orderId'];
//         if (orderId != null && orderId.isNotEmpty) {
//           // Call API
//           await orderUpdateController.updateOrder(
//             orderstatus: "Progress",
//             orderid: orderId,
//             context: context ?? this.context,
//             rideData: _rideData,
//             step_control: "Progress",
//           );

//           // stepperController.nextStep();

//           // await _updateOrderWithValidation(
//           //   orderstatus: "Progress",
//           //   orderid: orderId,
//           //   onSuccess: () {
//           //     // Only update stepper if API is successful
//           //     stepperController.nextStep();
//           //   },
//           // );
//         }
//       }

//       // Resume location tracking
//       await _resumeLocationTracking();

//       // Refresh map
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted && _isScreenActive) {
//           _setMarkers();
//           _fitMapToAllMarkers();
//         }
//       });
//     }
//   }

//   // Helper method to update order with validation
//   // Future<void> _updateOrderWithValidation({
//   //   required String orderstatus,
//   //   required String orderid,
//   //   VoidCallback? onSuccess,
//   //   BuildContext? context,
//   // }) async {
//   //   try {
//   //     // Show loading
//   //     showDialog(
//   //       context: context ?? this.context,
//   //       barrierDismissible: false,
//   //       builder: (context) => const Center(child: CircularProgressIndicator()),
//   //     );

//   //     // Call API
//   //     await orderUpdateController.updateOrder(
//   //       orderstatus: orderstatus,
//   //       orderid: orderid,
//   //       context: context ?? this.context,
//   //       rideData: _rideData,
//   //     );

//   //     // Check if API was successful
//   //     if (orderUpdateController.updateOrderResponse.value?.success == true) {
//   //       // Only execute onSuccess callback if API succeeded
//   //       onSuccess?.call();
//   //       print('✅ Order updated successfully');
//   //     } else {
//   //       // Show error if API failed
//   //       Get.snackbar(
//   //         'Error',
//   //         orderUpdateController.errorMessage.value.isNotEmpty
//   //             ? orderUpdateController.errorMessage.value
//   //             : 'Failed to update order status',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.red,
//   //         colorText: Colors.white,
//   //       );
//   //     }
//   //   } finally {
//   //     // Hide loading
//   //     if (mounted && (context ?? this.context).mounted) {
//   //       Navigator.of(context ?? this.context, rootNavigator: true).pop();
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: ColorsList.scaffoldColor,
//       appBar: _buildAppBar(w),
//       body: Column(
//         children: [
//           // Location Inputs
//           _buildLocationInputs(w),
//           // Map Section
//           Expanded(child: _buildMapSection(w)),
//           // Bottom Sheet
//           _buildBottomSheet(w),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(double w) {
//     return AppBar(
//       backgroundColor: ColorsList.scaffoldColor,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       titleSpacing: w * .03,
//       title: Row(
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: CustomImages.images(
//               "assets/icons/arrowLeftIcon.png",
//               w * .07,
//               w * .07,
//             ),
//           ),
//           SizedBox(width: w * .03),
//           CustomText(
//             text: "Arriving Client",
//             textColor: ColorsList.titleTextColor,
//             textFontSize: w * .055,
//             textFontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLocationInputs(double w) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .01),
//       child: Column(
//         children: [
//           // Pickup Location
//           LocationInputTextfield(
//             onPressed: () {},
//             preffixImage: "assets/icons/greenDot.png",
//             hintText: _rideData?['pickupLocation'] ?? 'Pickup location',
//           ),
//           SizedBox(height: w * .02),
//           // Drop Location
//           LocationInputTextfield(
//             onPressed: () {},
//             preffixImage: "assets/icons/redDot.png",
//             hintText: _rideData?['dropLocation'] ?? 'Drop location',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMapSection(double w) {
//     return Stack(
//       children: [
//         _buildMap(),
//         if (_locationError)
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 "Location access required. Please enable location services.",
//                 style: TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildBottomSheet(double w) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       padding: EdgeInsets.all(w * .04),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Route Information
//           SizedBox(height: w * .03),
//           Text(
//             "to pickup location",
//             style: const TextStyle(color: Colors.black54),
//           ),
//           SizedBox(height: w * .04),

//           if (widget.typeCheck == true) ...[
//             _buildClientCard2(w),
//           ] else ...[
//             _buildClientCard(w),
//           ],

//           SizedBox(height: w * .04),

//           if (widget.typeCheck == true) ...[
//             // _buildActionButtons2(w),
//           ] else ...[
//             _buildActionButtons(w),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildClientCard(double w) {
//     final riderName = _rideData?['riderName'] ?? 'Customer';
//     final riderPhone = _rideData?['riderPhone'] ?? '';
//     final totalFare = _rideData?['fare'] ?? '100';
//     final pickupAddress = _rideData?['pickupLocation'] ?? 'Pickup address';

//     return Container(
//       padding: EdgeInsets.all(w * .04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: w * .055,
//                 backgroundColor: Colors.grey.shade300,
//                 child: Icon(
//                   Icons.person,
//                   size: w * .07,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               SizedBox(width: w * .03),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text: riderName,
//                       textFontSize: w * .046,
//                       textFontWeight: FontWeight.w500,
//                     ),
//                     if (riderPhone.isNotEmpty) ...[
//                       SizedBox(height: w * .01),
//                       Text(
//                         riderPhone,
//                         style: TextStyle(
//                           fontSize: w * .035,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               if (riderPhone.isNotEmpty) ...[
//                 _circleIcon(Icons.call, () {
//                   _makePhoneCall(riderPhone);
//                 }),
//                 SizedBox(width: w * .02),
//               ],
//               _circleImage("assets/images/mess.png", () {
//                 CustomNavigator.push(context, ChatScreen());
//               }),
//             ],
//           ),
//           SizedBox(height: w * .03),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               "Total Fare: ₹$totalFare",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blue,
//                 fontSize: w * .04,
//               ),
//             ),
//           ),
//           SizedBox(height: w * .03),
//           _buildPickupAddress(pickupAddress),
//         ],
//       ),
//     );
//   }

//   Widget _buildClientCard2(double w) {
//     final riderName = _rideData?['riderName'] ?? 'Customer';
//     final totalFare = _rideData?['fare'] ?? '100';

//     return Container(
//       height: w * 0.5,
//       padding: EdgeInsets.all(w * .04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: w * .055,
//                 backgroundColor: Colors.grey.shade300,
//                 child: Image.asset("assets/images/profile3.png"),
//               ),
//               SizedBox(width: w * .03),
//               Expanded(
//                 child: CustomText(
//                   text: riderName,
//                   textFontSize: w * .046,
//                   textFontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: w * .08),
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               "Total Fare: ₹$totalFare",
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.blue,
//                 fontSize: w * .045,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPickupAddress(String address) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             CircleAvatar(radius: 6, backgroundColor: const Color(0xFF08875D)),
//             const SizedBox(width: 8),
//             const Text("Pickup", style: TextStyle(fontWeight: FontWeight.w600)),
//           ],
//         ),
//         const SizedBox(height: 4),
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.8,
//           child: Text(
//             address,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: Colors.black54, fontSize: 13),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(double w) {
//     return Obx(() {
//       final step = stepperController.activeStep.value;

//       return Row(
//         children: [
//           Expanded(
//             child: _actionButton(
//               text: "Cancel",
//               color: const Color(0xFFE0E4E7),
//               textColor: Colors.grey,
//               onTap: () async {
//                 final orderId = _rideData?['orderId'];
//                 if (orderId != null && orderId.isNotEmpty) {
//                   // await

//                   await orderUpdateController.updateOrder(
//                     orderstatus: "Cancelled",
//                     orderid: orderId,
//                     context: context ?? this.context,
//                     rideData: _rideData,
//                     step_control: "Cancelled",
//                   );

//                   // _updateOrderWithValidation(
//                   //   orderstatus: "Cancelled",
//                   //   orderid: orderId,
//                   //   onSuccess: () {
//                   //     // Only navigate if API is successful
//                   //     CustomNavigator.removeUntil(
//                   //       context,
//                   //       BottomnavmainScreen(),
//                   //       transition: TransitionType.fade,
//                   //     );
//                   //   },
//                   // );
//                 }
//               },
//             ),
//           ),
//           SizedBox(width: w * .04),
//           Expanded(
//             child: _actionButton(
//               text: step == 0
//                   ? "I've Arrived"
//                   : step == 1
//                   ? "Start Trip"
//                   : "Complete",
//               color: const Color(0xFF26E3DD),
//               textColor: Colors.black87,
//               onTap: () async {
//                 final orderId = _rideData?['orderId'];
//                 if (orderId == null || orderId.isEmpty) {
//                   Get.snackbar(
//                     'Error',
//                     'Invalid order ID',
//                     snackPosition: SnackPosition.BOTTOM,
//                     backgroundColor: Colors.red,
//                     colorText: Colors.white,
//                   );
//                   return;
//                 }

//                 if (step == 0) {
//                   // await _updateOrderWithValidation(
//                   //   orderstatus: "Arriving",
//                   //   orderid: orderId,
//                   //   onSuccess: () async {
//                   //     // Only navigate to OTP screen if API is successful
//                   //     await _navigateToOtpScreen();
//                   //   },
//                   // );

//                   await orderUpdateController.updateOrder(
//                     orderstatus: "Arriving",
//                     orderid: orderId,
//                     context: context ?? this.context,
//                     rideData: _rideData,
//                     step_control: "Arriving",
//                   );

//                   //   Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) =>
//                   //         ArrivedOtpScreen(bookridetypecheck: false, rideData: _rideData),
//                   //   ),
//                   // );
//                 } else if (step == 1) {
//                   await orderUpdateController.updateOrder(
//                     orderstatus: "Progress",
//                     orderid: orderId,
//                     context: context ?? this.context,
//                     rideData: _rideData,
//                     step_control: "Progress",
//                   );
//                   // await _updateOrderWithValidation(
//                   //   orderstatus: "Progress",
//                   //   orderid: orderId,
//                   //   onSuccess: () {
//                   //     // Only update stepper if API is successful
//                   //     stepperController.nextStep();
//                   //   },
//                   // );
//                 } else if (step == 2) {
//                   // await _updateOrderWithValidation(
//                   //   orderstatus: "Completed",
//                   //   orderid: orderId,
//                   //   onSuccess: () {
//                   //     // Only navigate to payment screen if API is successful
//                   //     CustomNavigator.removeUntil(
//                   //       context,
//                   //       ReceivePaymentModes(),
//                   //       transition: TransitionType.fade,
//                   //     );
//                   //   },
//                   // );

//                   await orderUpdateController.updateOrder(
//                     orderstatus: "Completed",
//                     orderid: orderId,
//                     context: context ?? this.context,
//                     rideData: _rideData,
//                     step_control: "Completed",
//                   );
//                 } else {
//                   _finalizeTrip();
//                 }
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   // Widget _buildActionButtons2(double w) {
//   //   return Obx(() {
//   //     final step = stepperController.activeStep.value;

//   //     return Row(
//   //       children: [
//   //         Expanded(
//   //           child: _actionButton(
//   //             text: "Cancel",
//   //             color: const Color(0xFFE0E4E7),
//   //             textColor: Colors.grey,
//   //             onTap: () async {
//   //               final orderId = _rideData?['orderId'];
//   //               if (orderId != null && orderId.isNotEmpty) {
//   //                 await _updateOrderWithValidation(
//   //                   orderstatus: "Cancelled",
//   //                   orderid: orderId,
//   //                   onSuccess: () {
//   //                     // Only navigate if API is successful
//   //                     CustomNavigator.removeUntil(
//   //                       context,
//   //                       BottomnavmainScreen(),
//   //                       transition: TransitionType.fade,
//   //                     );
//   //                   },
//   //                 );
//   //               }
//   //             },
//   //           ),
//   //         ),
//   //         SizedBox(width: w * .04),
//   //         Expanded(
//   //           child: _actionButton(
//   //             text: step == 0 ? "Start Trip" : "Complete",
//   //             color: const Color(0xFF26E3DD),
//   //             textColor: Colors.black87,
//   //             onTap: () {
//   //               final orderId = _rideData?['orderId'];
//   //               if (orderId == null || orderId.isEmpty) {
//   //                 Get.snackbar(
//   //                   'Error',
//   //                   'Invalid order ID',
//   //                   snackPosition: SnackPosition.BOTTOM,
//   //                   backgroundColor: Colors.red,
//   //                   colorText: Colors.white,
//   //                 );
//   //                 return;
//   //               }

//   //               if (step == 0) {
//   //                 _updateOrderWithValidation(
//   //                   orderstatus: "Progress",
//   //                   orderid: orderId,
//   //                   onSuccess: () {
//   //                     // Only update stepper if API is successful
//   //                     stepperController.nextStep();
//   //                   },
//   //                 );
//   //               } else if (step == 1) {
//   //                 _updateOrderWithValidation(
//   //                   orderstatus: "Completed",
//   //                   orderid: orderId,
//   //                   onSuccess: () {
//   //                     // Only navigate if API is successful
//   //                     CustomNavigator.removeUntil(
//   //                       context,
//   //                       ReceivePaymentModes(),
//   //                       transition: TransitionType.fade,
//   //                     );
//   //                   },
//   //                 );
//   //               } else {
//   //                 _finalizeTrip();
//   //               }
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   });
//   // }

//   void _startTrip() async {
//     stepperController.nextStep();
//     print("Trip started");
//   }

//   void _finalizeTrip() async {
//     stepperController.resetSteps();
//     print("Trip finalized");
//   }

//   Widget _actionButton({
//     required String text,
//     required Color color,
//     required Color textColor,
//     required VoidCallback onTap,
//   }) {
//     return SizedBox(
//       height: 40,
//       child: ElevatedButton(
//         onPressed: onTap,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }

//   Widget _circleIcon(IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: 18,
//         backgroundColor: const Color(0xFFE9FCFC),
//         child: Icon(icon, size: 20, color: ColorsList.mainAppColor),
//       ),
//     );
//   }

//   Widget _circleImage(String path, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CircleAvatar(
//         radius: 18,
//         backgroundColor: const Color(0xFFE9FCFC),
//         child: Image.asset(path, width: 30),
//       ),
//     );
//   }

//   void _makePhoneCall(String phoneNumber) async {
//     final url = 'tel:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

import 'package:corezap_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors/colors_list.dart';
import 'package:corezap_driver/utilities/custom_images.dart';
import 'package:corezap_driver/utilities/custom_text.dart';
import 'package:corezap_driver/utilities/location_input_textfield.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/chat_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

class ArrivingClient extends StatefulWidget {
  final bool? typeCheck;
  final Map<String, dynamic>? rideData;

  const ArrivingClient({super.key, this.typeCheck, this.rideData});

  @override
  State<ArrivingClient> createState() => _ArrivingClientState();
}

class _ArrivingClientState extends State<ArrivingClient> {
  final StepperController stepperController = Get.find<StepperController>();
  final OrderUpdateController orderUpdateController =
      Get.find<OrderUpdateController>();

  // Google API Key for Directions
  static const String GOOGLE_API_KEY =
      'AIzaSyCtM1jo8qzhEn2XZ8SVCoboULcondCjZio';

  // Map & Location
  GoogleMapController? _mapController;
  LatLng? _driverLocation;
  double _driverHeading = 0;
  double _distanceToPickup = 0;
  bool _locationError = false;
  bool _isScreenActive = true;
  bool _isInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Map Elements
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> _polylines = {};

  // Ride Data
  Map<String, dynamic>? _rideData;
  List<LatLng> _routeCoordinates = [];
  List<LatLng> _pickupToDropCoordinates = [];

  // Custom Marker Icons
  BitmapDescriptor? _bikeMarkerIcon;
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _dropMarkerIcon;

  @override
  void initState() {
    super.initState();
    _isScreenActive = true;
    print('🚗 ArrivingClient initState called');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeAll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 ArrivingClient didChangeDependencies called');

    if (_isScreenActive && !_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _refreshOnReturn();
      });
    }
  }

  @override
  void dispose() {
    print('🗑️ ArrivingClient dispose called');
    _isScreenActive = false;
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    _positionStreamSubscription?.pause();
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    _mapController?.dispose();
    _mapController = null;

    markers.clear();
    circles.clear();
    _polylines.clear();

    _isInitialized = false;
  }

  Future<void> _pauseLocationTracking() async {
    print('⏸️ Pausing location tracking');
    _positionStreamSubscription?.pause();
  }

  Future<void> _resumeLocationTracking() async {
    print('▶️ Resuming location tracking');
    if (_positionStreamSubscription != null && _isScreenActive) {
      _positionStreamSubscription?.resume();
    } else if (_isScreenActive) {
      await _startLocationTracking();
    }
  }

  Future<void> _initializeAll() async {
    if (_isInitialized) {
      print('✅ Already initialized, skipping...');
      return;
    }

    try {
      print('🔄 Initializing ArrivingClient...');

      _extractAndStoreRideData();
      await _loadCustomMarkers();
      await _startLocationTracking();
      await _getDirections();
      _setMarkers();

      _isInitialized = true;
      print('✅ ArrivingClient initialized successfully');
    } catch (e) {
      print('❌ Error initializing: $e');
      if (mounted) {
        setState(() {
          _locationError = true;
        });
      }
    }
  }

  Future<void> _refreshOnReturn() async {
    print('🔄 Refreshing on return...');
    if (!mounted || !_isScreenActive) return;

    setState(() {
      markers.clear();
      circles.clear();
      _polylines.clear();
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted && _isScreenActive) {
      await _startLocationTracking();
      _setMarkers();
      _updatePolylines();
      _fitMapToAllMarkers();
    }
  }

  void _forceRefreshMap() {
    if (!mounted || !_isScreenActive) return;

    print('🔄 Force refreshing map...');

    setState(() {
      markers.clear();
      circles.clear();
      _polylines.clear();
      _isInitialized = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && _isScreenActive) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted && _isScreenActive) {
          await _initializeAll();
        }
      }
    });
  }

  void _extractAndStoreRideData() {
    print("📦 Ride Data Received: ${widget.rideData}");

    _rideData = {
      'orderId': widget.rideData?['orderId']?.toString() ?? 'N/A',
      'riderId': widget.rideData?['riderId'],
      'riderName': widget.rideData?['riderName']?.toString() ?? 'Customer',
      'riderPhone': widget.rideData?['riderNumber']?.toString() ?? 'N/A',
      'pickupLocation':
          widget.rideData?['startLocation']?['address']?.toString() ??
          widget.rideData?['pickup']?['address']?.toString() ??
          'Pickup location',
      'dropLocation':
          widget.rideData?['endLocation']?['address']?.toString() ??
          widget.rideData?['destination']?['address']?.toString() ??
          widget.rideData?['dropoff']?['address']?.toString() ??
          'Drop location',
      'fare': widget.rideData?['totalFare']?.toString() ?? '100',
      'distance': widget.rideData?['distance']?.toString() ?? '0',
    };

    _extractCoordinates();
    print('✅ Ride data extracted successfully');
  }

  void _extractCoordinates() {
    try {
      if (widget.rideData?['pickup'] != null) {
        final pickup = widget.rideData!['pickup'];
        _rideData!['pickupCoordinates'] = LatLng(
          pickup['latitude']?.toDouble() ?? 23.2599,
          pickup['longitude']?.toDouble() ?? 77.4126,
        );
      } else if (widget.rideData?['startLocation'] != null) {
        final startLocation = widget.rideData!['startLocation'];
        if (startLocation['coordinates'] != null &&
            startLocation['coordinates'].length >= 2) {
          _rideData!['pickupCoordinates'] = LatLng(
            startLocation['coordinates'][1]?.toDouble() ?? 23.2599,
            startLocation['coordinates'][0]?.toDouble() ?? 77.4126,
          );
        }
      }

      if (widget.rideData?['destination'] != null) {
        final destination = widget.rideData!['destination'];
        _rideData!['dropoffCoordinates'] = LatLng(
          destination['latitude']?.toDouble() ?? 18.5204,
          destination['longitude']?.toDouble() ?? 73.8567,
        );
      } else if (widget.rideData?['endLocation'] != null) {
        final endLocation = widget.rideData!['endLocation'];
        if (endLocation['coordinates'] != null &&
            endLocation['coordinates'].length >= 2) {
          _rideData!['dropoffCoordinates'] = LatLng(
            endLocation['coordinates'][1]?.toDouble() ?? 18.5204,
            endLocation['coordinates'][0]?.toDouble() ?? 73.8567,
          );
        }
      }

      if (_rideData!['pickupCoordinates'] == null) {
        _rideData!['pickupCoordinates'] = const LatLng(23.2599, 77.4126);
      }

      if (_rideData!['dropoffCoordinates'] == null) {
        _rideData!['dropoffCoordinates'] = const LatLng(18.5204, 73.8567);
      }

      print('📍 Pickup coordinates: ${_rideData!['pickupCoordinates']}');
      print('📍 Drop coordinates: ${_rideData!['dropoffCoordinates']}');
    } catch (e) {
      print("❌ Error extracting coordinates: $e");
      _rideData!['pickupCoordinates'] = const LatLng(23.2599, 77.4126);
      _rideData!['dropoffCoordinates'] = const LatLng(18.5204, 73.8567);
    }
  }

  Future<bool> _requestLocationPermission() async {
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        return true;
      } else {
        if (mounted) {
          setState(() => _locationError = true);
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationError = true);
      }
      return false;
    }
  }

  Future<void> _loadCustomMarkers() async {
    try {
      final ByteData bikeData = await rootBundle.load(
        'assets/images/bike2.png',
      );
      final ui.Codec bikeCodec = await ui.instantiateImageCodec(
        bikeData.buffer.asUint8List(),
        targetWidth: 120,
        targetHeight: 120,
      );
      final ui.FrameInfo bikeFi = await bikeCodec.getNextFrame();
      final ByteData? bikeBytes = await bikeFi.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (bikeBytes != null) {
        _bikeMarkerIcon = BitmapDescriptor.fromBytes(
          bikeBytes.buffer.asUint8List(),
        );
        print('✅ Bike marker icon loaded');
      }

      _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );

      _dropMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    } catch (e) {
      print('❌ Error loading markers: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
      _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
      _dropMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    }
  }

  Future<void> _startLocationTracking() async {
    if (!await _requestLocationPermission()) {
      print('❌ Location permission denied');
      return;
    }

    _positionStreamSubscription?.cancel();

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (!_isScreenActive || !mounted) return;

      setState(() {
        _driverLocation = LatLng(position.latitude, position.longitude);
        if (position.heading.isFinite && position.heading >= 0) {
          _driverHeading = position.heading;
        }
        _locationError = false;
      });

      print('📍 Initial location: ${position.latitude}, ${position.longitude}');

      if (_rideData?['pickupCoordinates'] != null) {
        final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
        _distanceToPickup = _calculateDistance(
          position.latitude,
          position.longitude,
          pickupCoords.latitude,
          pickupCoords.longitude,
        );
      }
    } catch (e) {
      print('❌ Error getting initial position: $e');
      if (_isScreenActive && mounted) {
        setState(() => _locationError = true);
      }
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (!_isScreenActive || !mounted) return;

            setState(() {
              _driverLocation = LatLng(position.latitude, position.longitude);

              if (position.heading.isFinite && position.heading >= 0) {
                _driverHeading = position.heading;
              }

              _locationError = false;
            });

            if (_rideData?['pickupCoordinates'] != null) {
              final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
              _distanceToPickup = _calculateDistance(
                position.latitude,
                position.longitude,
                pickupCoords.latitude,
                pickupCoords.longitude,
              );
            }

            _setMarkers();
          },
          onError: (error) {
            print('❌ Location stream error: $error');
            if (_isScreenActive && mounted) {
              setState(() => _locationError = true);
            }
          },
          cancelOnError: true,
        );
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _setMarkers() {
    if (!_isScreenActive || !mounted) return;

    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};

    if (_driverLocation != null && _bikeMarkerIcon != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: _driverLocation!,
          icon: _bikeMarkerIcon!,
          anchor: const Offset(0.5, 0.5),
          rotation: _driverHeading,
          flat: true,
          infoWindow: const InfoWindow(title: "Your Location"),
          zIndex: 2,
        ),
      );

      newCircles.add(
        Circle(
          circleId: const CircleId('outer_shadow'),
          center: _driverLocation!,
          radius: 140,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.transparent,
        ),
      );

      newCircles.add(
        Circle(
          circleId: const CircleId('inner_green'),
          center: _driverLocation!,
          radius: 60,
          fillColor: Colors.green.withOpacity(0.35),
          strokeColor: Colors.green,
          strokeWidth: 1,
        ),
      );
    }

    if (_rideData?['pickupCoordinates'] != null && _pickupMarkerIcon != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: _rideData!['pickupCoordinates'],
          infoWindow: InfoWindow(
            title: "Pickup",
            snippet: _rideData!['pickupLocation'],
          ),
          icon: _pickupMarkerIcon!,
          zIndex: 1,
        ),
      );

      newCircles.add(
        Circle(
          circleId: const CircleId('pickup_zone'),
          center: _rideData!['pickupCoordinates'],
          radius: 500,
          fillColor: Colors.blue.withOpacity(0.15),
          strokeColor: Colors.blue.withOpacity(0.5),
          strokeWidth: 2,
        ),
      );
    }

    if (_rideData?['dropoffCoordinates'] != null && _dropMarkerIcon != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("drop"),
          position: _rideData!['dropoffCoordinates'],
          infoWindow: InfoWindow(
            title: "Drop",
            snippet: _rideData!['dropLocation'],
          ),
          icon: _dropMarkerIcon!,
          zIndex: 1,
        ),
      );
    }

    if (mounted) {
      setState(() {
        markers = newMarkers;
        circles = newCircles;
      });
    }

    _fitMapToAllMarkers();
  }

  void _fitMapToAllMarkers() {
    if (_mapController == null || !_isScreenActive) return;

    final List<LatLng> allPoints = [];

    if (_driverLocation != null) allPoints.add(_driverLocation!);
    if (_rideData?['pickupCoordinates'] != null)
      allPoints.add(_rideData!['pickupCoordinates']);
    if (_rideData?['dropoffCoordinates'] != null)
      allPoints.add(_rideData!['dropoffCoordinates']);

    if (allPoints.isEmpty) return;

    final bounds = _boundsFromLatLngList(allPoints);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_mapController != null && _isScreenActive && mounted) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 150),
        );
      }
    });
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(x0!, y0!),
      northeast: LatLng(x1!, y1!),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    if (encoded.isEmpty) return [];

    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  Future<void> _getDirections() async {
    if (_rideData?['pickupCoordinates'] == null ||
        _rideData?['dropoffCoordinates'] == null) {
      print('⚠️ Cannot get directions: coordinates missing');
      return;
    }

    try {
      if (_driverLocation != null && _rideData!['pickupCoordinates'] != null) {
        final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}'
          '&destination=${pickupCoords.latitude},${pickupCoords.longitude}'
          '&key=$GOOGLE_API_KEY',
        );

        print('🛣️ Fetching route from driver to pickup...');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final polylineEncoded = route['overview_polyline']['points'];
            _routeCoordinates = _decodePolyline(polylineEncoded);
            print('🛣️ Route Driver → Pickup calculated');
          }
        }
      }

      if (_rideData!['pickupCoordinates'] != null &&
          _rideData!['dropoffCoordinates'] != null) {
        final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
        final dropoffCoords = _rideData!['dropoffCoordinates'] as LatLng;

        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${pickupCoords.latitude},${pickupCoords.longitude}'
          '&destination=${dropoffCoords.latitude},${dropoffCoords.longitude}'
          '&key=$GOOGLE_API_KEY',
        );

        print('🛣️ Fetching route from pickup to drop...');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final polylineEncoded = route['overview_polyline']['points'];
            _pickupToDropCoordinates = _decodePolyline(polylineEncoded);
            print('🛣️ Route Pickup → Drop calculated');
          }
        }
      }

      _updatePolylines();
    } catch (e) {
      print('❌ Error fetching directions: $e');
    }
  }

  void _updatePolylines() {
    if (!_isScreenActive || !mounted) return;

    final polylines = <Polyline>{};

    if (_routeCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('driver_to_pickup'),
          points: _routeCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    if (_pickupToDropCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('pickup_to_drop'),
          points: _pickupToDropCoordinates,
          color: Colors.green,
          width: 4,
          patterns: [PatternItem.dash(10), PatternItem.gap(10)],
        ),
      );
    }

    if (mounted) {
      setState(() {
        _polylines = polylines;
      });
    }
  }

  Widget _buildMap() {
    final initialLocation = _driverLocation != null
        ? _driverLocation!
        : (_rideData?['pickupCoordinates'] ?? const LatLng(23.2599, 77.4126));

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        print('✅ Google Map created');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isScreenActive && mounted) {
            _setMarkers();
            _fitMapToAllMarkers();
          }
        });
      },
      initialCameraPosition: CameraPosition(
        target: initialLocation,
        zoom: 14.5,
      ),
      markers: markers,
      circles: circles,
      polylines: _polylines,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: false,
    );
  }

  Future<void> _navigateToOtpScreen() async {
    print('🔄 Navigating to OTP screen...');

    // Pause location tracking
    await _pauseLocationTracking();

    print("📤 Sending ride data to OTP screen: $_rideData");

    // Use Navigator.push with explicit context
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            ArrivedOtpScreen(bookridetypecheck: false, rideData: _rideData),
      ),
    );

    // When returning from OTP screen
    // if (_isScreenActive && mounted) {
    //   print('↩️ Returning from OTP screen');

    //   // Resume location tracking
    //   await _resumeLocationTracking();

    //   // Force refresh the map
    //   _forceRefreshMap();
    // }

    // Handle OTP verification result
    // if (result == true && mounted && _isScreenActive) {
    //   print('✅ OTP verified, updating order status to Progress...');

    //   final orderId = _rideData?['orderId'];
    //   if (orderId != null && orderId.isNotEmpty) {
    //     await _handleProgressStatus(orderId);
    //   }
    // }
  }

  // Handler methods for different order statuses
  Future<void> _handleCancelOrder(String orderId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final result = await orderUpdateController.updateOrder(
        orderStatus: "Cancelled",
        orderId: orderId,
        context: context,
        rideData: _rideData,
        stepControl: "Cancelled",
      );

      Navigator.of(context, rootNavigator: true).pop();

      if (result?.success == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomnavmainScreen()),
          (route) => false,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to cancel order: ${result?.message ?? "Unknown error"}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        'Error',
        'Failed to cancel order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleArrivedStatus(String orderId) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final result = await orderUpdateController.updateOrder(
        orderStatus: "Arriving",
        orderId: orderId,
        context: context,
        rideData: _rideData,
        stepControl: "Arriving",
      );

      // Navigator.of(context, rootNavigator: true).pop();

      if (result?.success == true) {
        print("arrivveeeing>>>");
        await _navigateToOtpScreen();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update arrival status: ${result?.message ?? "Unknown error"}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        'Error',
        'Failed to update arrival status: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleProgressStatus(String orderId) async {
    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(child: CircularProgressIndicator()),
      // );

      final result = await orderUpdateController.updateOrder(
        orderStatus: "Progress",
        orderId: orderId,
        context: context,
        rideData: _rideData,
        stepControl: "Progress",
      );

      // Navigator.of(context, rootNavigator: true).pop();

      if (result?.success == true) {
        // stepperController.nextStep();
        print('✅ Trip started successfully');
      } else {
        Get.snackbar(
          'Error',
          'Failed to start trip: ${result?.message ?? "Unknown error"}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        'Error',
        'Failed to start trip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleCompletedStatus(String orderId) async {
    try {
      final result = await orderUpdateController.updateOrder(
        orderStatus: "Completed",
        orderId: orderId,
        context: context,
        rideData: _rideData,
        stepControl: "Completed",
      );

      // Navigator.of(context, rootNavigator: true).pop();

      if (result?.success == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ReceivePaymentModes()),
          (route) => false,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to complete trip: ${result?.message ?? "Unknown error"}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      Get.snackbar(
        'Error',
        'Failed to complete trip: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsList.scaffoldColor,
      appBar: _buildAppBar(w),
      body: Column(
        children: [
          _buildLocationInputs(w),
          Expanded(child: _buildMapSection(w)),
          _buildBottomSheet(w),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(double w) {
    return AppBar(
      backgroundColor: ColorsList.scaffoldColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: w * .03,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomImages.images(
              "assets/icons/arrowLeftIcon.png",
              w * .07,
              w * .07,
            ),
          ),
          SizedBox(width: w * .03),
          CustomText(
            text: "Arriving Client",
            textColor: ColorsList.titleTextColor,
            textFontSize: w * .055,
            textFontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInputs(double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .01),
      child: Column(
        children: [
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/greenDot.png",
            hintText: _rideData?['pickupLocation'] ?? 'Pickup location',
          ),
          SizedBox(height: w * .02),
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/redDot.png",
            hintText: _rideData?['dropLocation'] ?? 'Drop location',
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(double w) {
    return Stack(
      children: [
        _buildMap(),
        if (_locationError)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Location access required. Please enable location services.",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomSheet(double w) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(w * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: w * .03),
          const Text(
            "to pickup location",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: w * .04),

          if (widget.typeCheck == true) ...[
            _buildClientCard2(w),
          ] else ...[
            _buildClientCard(w),
          ],

          SizedBox(height: w * .04),

          if (widget.typeCheck == true) ...[
            // _buildActionButtons2(w), // Implement if needed
          ] else ...[
            _buildActionButtons(w),
          ],
        ],
      ),
    );
  }

  Widget _buildClientCard(double w) {
    final riderName = _rideData?['riderName'] ?? 'Customer';
    final riderPhone = _rideData?['riderPhone'] ?? '';
    final totalFare = _rideData?['fare'] ?? '100';
    final pickupAddress = _rideData?['pickupLocation'] ?? 'Pickup address';

    return Container(
      padding: EdgeInsets.all(w * .04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * .055,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: w * .07,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: riderName,
                      textFontSize: w * .046,
                      textFontWeight: FontWeight.w500,
                    ),
                    if (riderPhone.isNotEmpty) ...[
                      SizedBox(height: w * .01),
                      Text(
                        riderPhone,
                        style: TextStyle(
                          fontSize: w * .035,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (riderPhone.isNotEmpty) ...[
                _circleIcon(Icons.call, () {
                  _makePhoneCall(riderPhone);
                }),
                SizedBox(width: w * .02),
              ],
              _circleImage("assets/images/mess.png", () {
                CustomNavigator.push(context, ChatScreen());
              }),
            ],
          ),
          SizedBox(height: w * .03),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total Fare: ₹$totalFare",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: w * .04,
              ),
            ),
          ),
          SizedBox(height: w * .03),
          _buildPickupAddress(pickupAddress),
        ],
      ),
    );
  }

  Widget _buildClientCard2(double w) {
    final riderName = _rideData?['riderName'] ?? 'Customer';
    final totalFare = _rideData?['fare'] ?? '100';

    return Container(
      height: w * 0.5,
      padding: EdgeInsets.all(w * .04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * .055,
                backgroundColor: Colors.grey.shade300,
                child: Image.asset("assets/images/profile3.png"),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: CustomText(
                  text: riderName,
                  textFontSize: w * .046,
                  textFontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: w * .08),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Total Fare: ₹$totalFare",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: w * .045,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupAddress(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 6, backgroundColor: const Color(0xFF08875D)),
            const SizedBox(width: 8),
            const Text("Pickup", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(double w) {
    return Obx(() {
      final step = stepperController.activeStep.value;

      return Row(
        children: [
          Expanded(
            child: _actionButton(
              text: "Cancel ${step}",
              color: const Color(0xFFE0E4E7),
              textColor: Colors.grey,
              onTap: () async {
                final orderId = _rideData?['orderId'];
                if (orderId != null && orderId.isNotEmpty) {
                  await _handleCancelOrder(orderId);
                }
              },
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _actionButton(
              text: step == 0
                  ? "I've Arrived"
                  : step == 1
                  ? "Start Trip"
                  : "Complete",
              color: const Color(0xFF26E3DD),
              textColor: Colors.black87,
              onTap: () async {
                final orderId = _rideData?['orderId'];
                if (orderId == null || orderId.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Invalid order ID',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (step == 0) {
                  print(
                    "steppppppp>>>>>>>>>>>>>>>>>>>>  arrvinnggg  000000000000000000000000",
                  );
                  await _handleArrivedStatus(orderId);
                } else if (step == 1) {
                  print(
                    "steppppppp>>>>>>>>>>>>>>>>>>>>  progressssss   1111111111111111111111111111",
                  );

                  await _handleProgressStatus(orderId);
                } else if (step == 2) {
                  print(
                    "steppppppp>>>>>>>>>>>>>>>>>>>> compleeteeee   22222222222222222222222",
                  );

                  await _handleCompletedStatus(orderId);

                  _finalizeTrip();
                } else {
                  print(
                    "steppppppp>>>>>>>>>>>>>>>>>>>>   elseeeeeeeeeeeeeeeeeeee",
                  );

                  _finalizeTrip();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  void _startTrip() async {
    stepperController.nextStep();
    print("Trip started");
  }

  void _finalizeTrip() async {
    stepperController.resetSteps();

    print("Trip finalized");
  }

  Widget _actionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE9FCFC),
        child: Icon(icon, size: 20, color: ColorsList.mainAppColor),
      ),
    );
  }

  Widget _circleImage(String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFE9FCFC),
        child: Image.asset(path, width: 30),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
