// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:nzcu_driver/apiervices/services/driver_socket_service.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class DriverMapScreen extends StatefulWidget {
//   final bool showFullScreen;
//   final double? initialLatitude;
//   final double? initialLongitude;

//   const DriverMapScreen({
//     Key? key,
//     this.showFullScreen = false,
//     this.initialLatitude,
//     this.initialLongitude,
//   }) : super(key: key);

//   @override
//   State<DriverMapScreen> createState() => _DriverMapScreenState();
// }

// class _DriverMapScreenState extends State<DriverMapScreen> {
//   final DriverSocketService _socketService = DriverSocketService();
  
//   late GoogleMapController _mapController;
//   double? _currentLat;
//   double? _currentLng;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   StreamSubscription<Position>? _locationSubscription;
//   bool _isMapReady = false;
//   BitmapDescriptor? _bikeIcon;

//   // Camera position
//   late final CameraPosition _initialCameraPosition;

//   @override
//   void initState() {
//     super.initState();
    
//     _currentLat = widget.initialLatitude ?? 19.0176;
//     _currentLng = widget.initialLongitude ?? 72.8562;
    
//     _initialCameraPosition = CameraPosition(
//       target: LatLng(_currentLat!, _currentLng!),
//       zoom: 15,
//     );

//     _initializeMap();
//   }

//   Future<void> _initializeMap() async {
//     try {
//       // Load custom bike icon
//       await _loadBikeIcon();
      
//       // Request location permission
//       await _requestLocationPermission();
      
//       // Get initial location
//       await _getCurrentLocation();
      
//       // Setup location tracking
//       _startLocationTracking();
      
//       // Listen to socket location updates
//       _socketService.addEventListener('driver:location:update', _onLocationUpdate);
//     } catch (error) {
//       print('❌ Error initializing map: $error');
//     }
//   }

//   Future<void> _loadBikeIcon() async {
//     try {
//       // Create a custom bike marker from SVG or image
//       _bikeIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(size: Size(48, 48)),
//         'assets/icons/bike_marker.png',
//       );
//     } catch (error) {
//       print('⚠️ Could not load bike icon: $error, using default');
//       _bikeIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//     }
//   }

//   Future<bool> _requestLocationPermission() async {
//     try {
//       final status = await Permission.location.request();
//       return status.isGranted;
//     } catch (error) {
//       print('❌ Location permission error: $error');
//       return false;
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
      
//       setState(() {
//         _currentLat = position.latitude;
//         _currentLng = position.longitude;
//       });

//       _addDriverMarker();
//       _animateCamera();
      
//       print('✅ Got current location: $_currentLat, $_currentLng');
//     } catch (error) {
//       print('❌ Error getting location: $error');
//       _addDriverMarker();
//     }
//   }

//   void _startLocationTracking() {
//     _locationSubscription = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 10, // Update every 10 meters
//       ),
//     ).listen((position) {
//       _updateDriverLocation(position.latitude, position.longitude);
//     }, onError: (error) {
//       print('⚠️ Location tracking error: $error');
//     });
//   }

//   void _updateDriverLocation(double lat, double lng) {
//     if (!mounted) return;
    
//     setState(() {
//       _currentLat = lat;
//       _currentLng = lng;
//     });

//     if (_isMapReady) {
//       _addDriverMarker();
      
//       // Smooth animation to new location
//       _mapController.animateCamera(
//         CameraUpdate.newLatLng(LatLng(lat, lng)),
//       );
//     }
//   }

//   void _onLocationUpdate(dynamic data) {
//     if (data is Map<String, dynamic>) {
//       final lat = data['latitude'] as double?;
//       final lng = data['longitude'] as double?;

//       if (lat != null && lng != null) {
//         _updateDriverLocation(lat, lng);
//       }
//     }
//   }

//   void _addDriverMarker() {
//     if (_currentLat == null || _currentLng == null) return;

//     _markers.clear();
    
//     // Add driver position marker
//     _markers.add(
//       Marker(
//         markerId: const MarkerId('driver_location'),
//         position: LatLng(_currentLat!, _currentLng!),
//         icon: _bikeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         infoWindow: const InfoWindow(
//           title: 'Your Location',
//           snippet: 'Driver Position',
//         ),
//       ),
//     );

//     setState(() {});
//   }

//   void _animateCamera() {
//     if (!_isMapReady || _currentLat == null || _currentLng == null) return;

//     _mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(_currentLat!, _currentLng!),
//           zoom: 15,
//         ),
//       ),
//     );
//   }

//   void _recenterMap() {
//     _animateCamera();
//   }

//   @override
//   void dispose() {
//     _locationSubscription?.cancel();
//     _socketService.removeEventListener('driver:location:update', _onLocationUpdate);
//     if (widget.showFullScreen) {
//       _mapController.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.showFullScreen
//           ? AppBar(
//               title: const Text('Your Location'),
//               backgroundColor: const Color.fromARGB(255, 2, 120, 166),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             )
//           : null,
//       body: Stack(
//         children: [
//           // Google Map
//           GoogleMap(
//             initialCameraPosition: _initialCameraPosition,
//             onMapCreated: (controller) {
//               _mapController = controller;
//               _isMapReady = true;
//               _addDriverMarker();
//               _animateCamera();
//             },
//             markers: _markers,
//             polylines: _polylines,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: false,
//             zoomControlsEnabled: false,
//             compassEnabled: true,
//             mapToolbarEnabled: true,
//             cameraTargetBounds: CameraTargetBounds.unbounded,
//           ),

//           // Recenter Button
//           Positioned(
//             bottom: 80,
//             right: 16,
//             child: FloatingActionButton(
//               mini: true,
//               backgroundColor: const Color.fromARGB(255, 2, 120, 166),
//               onPressed: _recenterMap,
//               child: const Icon(Icons.my_location, color: Colors.white),
//             ),
//           ),

//           // Driver Info Card
//           if (!widget.showFullScreen)
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Location Info
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           color: Color.fromARGB(255, 2, 120, 166),
//                           size: 20,
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Current Location',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               Text(
//                                 _currentLat != null && _currentLng != null
//                                     ? '${_currentLat!.toStringAsFixed(4)}, ${_currentLng!.toStringAsFixed(4)}'
//                                     : 'Loading...',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (widget.showFullScreen)
//                           IconButton(
//                             icon: const Icon(Icons.share, color: Color.fromARGB(255, 2, 120, 166)),
//                             onPressed: () {
//                               // Share location functionality
//                             },
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
