import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:nzcu_driver/controllers/chart_id_controller/chatid_controller.dart';
import 'package:nzcu_driver/controllers/chart_id_controller/chat_notification_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/location_input_textfield.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/utilities/utils/button_state_manager.dart';
import 'package:nzcu_driver/utilities/utils/navigation_command.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/ride_screens/arrived_otp_screen.dart';
import 'package:nzcu_driver/views/ride_screens/chat_screen.dart';
import 'package:nzcu_driver/views/ride_screens/receive_payment_modes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

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

  final ChatidController chartidController = Get.find<ChatidController>();
  final ChatNotificationController chatNotificationController =
      Get.find<ChatNotificationController>();

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
  List<LatLng> _driverToDropCoordinates = [];

  // Dynamic polyline management
  Timer? _polylineRefreshTimer;
  DateTime _lastPolylineRefresh = DateTime.now();
  bool _isFetchingDirections = false;
  bool _initialFitDone = false;

  // Custom Marker Icons
  BitmapDescriptor? _bikeMarkerIcon;
  BitmapDescriptor? _pickupMarkerIcon;
  BitmapDescriptor? _dropMarkerIcon;

  // Navigation listener subscription
  Worker? _navigationWorker;
  Worker? _stepperWorker;

  @override
  void initState() {
    super.initState();

    image_get_from_shared();
    myridedataprint();
    image_get_from_shared();

    _isScreenActive = true;
    print('🚗 ArrivingClient initState called');

    // Set up navigation listener
    _setupNavigationListener();
    _setupStepperListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeAll();
    });

    print("hellooooo_stepss_screen  ${stepperController.activeStep}");
  }

  dynamic profileImage = "";

  void image_get_from_shared() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        profileImage = prefs.getString('active_ride_profile_image') ?? "";
      });
    }
    print("profileImage>>>> : $profileImage");
  }

  void _setupNavigationListener() {
    _navigationWorker = ever(orderUpdateController.shouldNavigate$, (
      bool shouldNavigate,
    ) {
      if (shouldNavigate && mounted && _isScreenActive) {
        final command = NavigationCommand(
          route: orderUpdateController.navigationRoute,
          arguments: orderUpdateController.navigationArgs,
          clearAll: orderUpdateController.clearAll,
        );

        print("Navigation command: ${command}");
        _handleNavigation(command);
        orderUpdateController.clearNavigation();
      }
    });
  }

  void _setupStepperListener() {
    _stepperWorker = ever(stepperController.activeStep, (int step) {
      if (mounted && _isScreenActive) {
        _onStepChanged(step);
      }
    });
  }

  void myridedataprint() {
    print("my_datat_print ${widget.rideData}");
  }

  void _onStepChanged(int step) {
    print('🔄 Stepper step changed to: $step');
    if (step == 2) {
      // Trip started - switch to driver → drop polyline
      _routeCoordinates.clear();
      _initialFitDone = false;
      if (_driverLocation != null && _rideData?['dropoffCoordinates'] != null) {
        _fetchRouteFromDriverTo(
          _rideData!['dropoffCoordinates'] as LatLng,
        ).then((_) {
          _setMarkers();
          _updatePolylines();
          _fitMapToAllMarkers();
        });
      }
    }
  }

  Future<void> _getchartidmethod() async {
    final orderId = widget.rideData?['orderId']?.toString();
    if (orderId != null) {
      try {
        await chartidController.getchartidmethod(orderid: orderId);
        print('✅ Chart ID method called for order: $orderId');
      } catch (e) {
        print('❌ Error getting chart ID: $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('🔄 ArrivingClient didChangeDependencies called');

    if (_isScreenActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!_isInitialized) {
          print('📍 First time initialization');
          await _initializeAll();
        } else {
          print('🔄 Refreshing screen on return');
          await _refreshOnReturn();
        }
      });
    }
  }

  @override
  void dispose() {
    print('🗑️ ArrivingClient dispose called');
    _isScreenActive = false;

    // Cancel all timers and subscriptions first
    _positionStreamSubscription?.cancel();
    _polylineRefreshTimer?.cancel();

    // Clean up workers
    _navigationWorker?.dispose();
    _stepperWorker?.dispose();

    // Call super.dispose first
    super.dispose();

    // Clean up button states safely after disposal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ButtonStateManager.clearState('arrive_button');
        ButtonStateManager.clearState('cancel_button');
        ButtonStateManager.clearState('start_trip_button');
        ButtonStateManager.clearState('complete_button');
      } catch (e) {
        // Silently catch errors during disposal
        print('⚠️ Error clearing button states: $e');
      }
    });

    _cleanupResources();
  }

  void _cleanupResources() {
    _positionStreamSubscription?.pause();
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _polylineRefreshTimer?.cancel();
    _polylineRefreshTimer = null;

    _mapController?.dispose();
    _mapController = null;

    markers.clear();
    circles.clear();
    _polylines.clear();
    _driverToDropCoordinates.clear();

    _isInitialized = false;
    _initialFitDone = false;
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

    // Hide keyboard if visible
    FocusScope.of(context).unfocus();

    // Clear previous data
    setState(() {
      markers.clear();
      circles.clear();
      _polylines.clear();
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted && _isScreenActive) {
      // Restart location tracking
      _positionStreamSubscription?.cancel();
      await _startLocationTracking();

      // Recalculate directions
      await _getDirections();

      // Update markers and polylines
      _setMarkers();
      _updatePolylines();
      _fitMapToAllMarkers();

      print('✅ Screen refresh complete');
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

    // Extract rider data - handle both nested 'rider' object and flat structure
    final riderData = widget.rideData?['rider'];
    final userId = widget.rideData?['userId'];

    _rideData = {
      'orderId':
          widget.rideData?['orderId']?.toString() ??
          widget.rideData?['_id']?.toString() ??
          'N/A',
      'riderId':
          riderData?['id']?.toString() ??
          widget.rideData?['riderId']?.toString() ??
          userId?['_id']?.toString() ??
          'N/A',
      'riderName':
          riderData?['name']?.toString() ??
          widget.rideData?['riderName']?.toString() ??
          userId?['name']?.toString() ??
          'Customer',
      'riderPhone':
          riderData?['phone']?.toString() ??
          widget.rideData?['riderNumber']?.toString() ??
          widget.rideData?['riderPhone']?.toString() ??
          userId?['phone']?.toString() ??
          'N/A',
      'riderEmail':
          riderData?['email']?.toString() ??
          widget.rideData?['riderEmail']?.toString() ??
          userId?['email']?.toString() ??
          '',
      'riderImage':
          riderData?['profileImage']?.toString() ??
          riderData?['image']?.toString() ??
          widget.rideData?['riderImage']?.toString() ??
          '',
      'pickupLocation':
          widget.rideData?['startLocation']?['address']?.toString() ??
          widget.rideData?['pickup']?['address']?.toString() ??
          'Pickup location',
      'dropLocation':
          widget.rideData?['endLocation']?['address']?.toString() ??
          widget.rideData?['destination']?['address']?.toString() ??
          widget.rideData?['dropoff']?['address']?.toString() ??
          'Drop location',
      'fare':
          widget.rideData?['totalFare']?.toString() ??
          widget.rideData?['fare']?.toString() ??
          '100',
      'distance': widget.rideData?['distance']?.toString() ?? '0',
      'otpVerified': widget.rideData?['otpVerified'] ?? false,
      'orderStatus': widget.rideData?['orderStatus']?.toString() ?? 'Pending',
      'vehicleType': widget.rideData?['vehicleType']?.toString() ?? '',
      'orderType': widget.rideData?['orderType']?.toString() ?? '',
    };

    _extractCoordinates();
    print('✅ Ride data extracted successfully');
    print('📋 Final extracted data: $_rideData');
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
          // Backend sends coordinates as [latitude, longitude]
          // First check if it looks like [lat, lng] format (lat is typically smaller for India region)
          final coord0 = startLocation['coordinates'][0]?.toDouble() ?? 0;
          final coord1 = startLocation['coordinates'][1]?.toDouble() ?? 0;

          // Determine if coordinates are in [lat, lng] or [lng, lat] format
          // Latitude for India: 8-37, Longitude for India: 68-97
          // If coord0 is in latitude range and coord1 is in longitude range, it's [lat, lng]
          final bool isLatLngFormat =
              (coord0 >= 8 && coord0 <= 37) && (coord1 >= 68 && coord1 <= 97);

          if (isLatLngFormat) {
            // Backend format: [latitude, longitude]
            _rideData!['pickupCoordinates'] = LatLng(coord0, coord1);
            print('📍 Pickup: Using [lat, lng] format: $coord0, $coord1');
          } else {
            // GeoJSON format: [longitude, latitude]
            _rideData!['pickupCoordinates'] = LatLng(coord1, coord0);
            print(
              '📍 Pickup: Using GeoJSON [lng, lat] format: $coord1, $coord0',
            );
          }
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
          // Backend sends coordinates as [latitude, longitude]
          final coord0 = endLocation['coordinates'][0]?.toDouble() ?? 0;
          final coord1 = endLocation['coordinates'][1]?.toDouble() ?? 0;

          // Determine if coordinates are in [lat, lng] or [lng, lat] format
          final bool isLatLngFormat =
              (coord0 >= 8 && coord0 <= 37) && (coord1 >= 68 && coord1 <= 97);

          if (isLatLngFormat) {
            // Backend format: [latitude, longitude]
            _rideData!['dropoffCoordinates'] = LatLng(coord0, coord1);
            print('📍 Drop: Using [lat, lng] format: $coord0, $coord1');
          } else {
            // GeoJSON format: [longitude, latitude]
            _rideData!['dropoffCoordinates'] = LatLng(coord1, coord0);
            print('📍 Drop: Using GeoJSON [lng, lat] format: $coord1, $coord0');
          }
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

            // Update markers and dynamically trim/re-fetch polyline
            _setMarkers();
            _updateDynamicPolyline();
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

  // ==================== Dynamic Polyline Methods ====================

  /// Called on every location update to trim the polyline and conditionally re-fetch
  void _updateDynamicPolyline() {
    if (!_isScreenActive || !mounted || _driverLocation == null) return;

    final step = stepperController.activeStep.value;

    if (step < 2) {
      // State 1: Going to pickup
      if (_routeCoordinates.isNotEmpty) {
        _routeCoordinates = _trimPolylineToDriverPosition(
          _routeCoordinates,
          _driverLocation!,
        );
      }

      // Check if driver deviated from route - re-fetch if needed
      if (_routeCoordinates.isEmpty ||
          _isDriverOffRoute(_routeCoordinates, _driverLocation!)) {
        _throttledRefetchRoute(
          _rideData?['pickupCoordinates'] as LatLng?,
          isPickup: true,
        );
      }
    } else if (step == 2) {
      // State 2: Going to drop
      if (_driverToDropCoordinates.isNotEmpty) {
        _driverToDropCoordinates = _trimPolylineToDriverPosition(
          _driverToDropCoordinates,
          _driverLocation!,
        );
      }

      // Check if driver deviated from route - re-fetch if needed
      if (_driverToDropCoordinates.isEmpty ||
          _isDriverOffRoute(_driverToDropCoordinates, _driverLocation!)) {
        _throttledRefetchRoute(
          _rideData?['dropoffCoordinates'] as LatLng?,
          isPickup: false,
        );
      }
    }

    _updatePolylines();

    // Follow driver on map after initial fit
    if (_initialFitDone && _mapController != null) {
      try {
        _mapController!.animateCamera(CameraUpdate.newLatLng(_driverLocation!));
      } catch (e) {
        print('❌ Error animating camera: $e');
      }
    }
  }

  /// Trim polyline to the driver's current position by removing passed points
  List<LatLng> _trimPolylineToDriverPosition(
    List<LatLng> polyline,
    LatLng driverPos,
  ) {
    if (polyline.isEmpty) return polyline;

    int closestIndex = _findClosestPointIndex(polyline, driverPos);

    // Remove all points before the closest point
    if (closestIndex > 0) {
      final trimmed = polyline.sublist(closestIndex);
      // Insert driver's current position at the start for smooth visual
      return [driverPos, ...trimmed];
    }

    // Replace the first point with driver position for smooth visual
    return [driverPos, ...polyline.sublist(1)];
  }

  /// Find the index of the closest point on the polyline to the driver
  int _findClosestPointIndex(List<LatLng> polyline, LatLng driverPos) {
    double minDist = double.infinity;
    int minIndex = 0;

    for (int i = 0; i < polyline.length; i++) {
      final dist = _calculateDistance(
        driverPos.latitude,
        driverPos.longitude,
        polyline[i].latitude,
        polyline[i].longitude,
      );
      if (dist < minDist) {
        minDist = dist;
        minIndex = i;
      }
    }

    return minIndex;
  }

  /// Check if driver has deviated more than 100m from the route
  bool _isDriverOffRoute(List<LatLng> polyline, LatLng driverPos) {
    if (polyline.isEmpty) return true;

    int closestIndex = _findClosestPointIndex(polyline, driverPos);
    double distToRoute = _calculateDistance(
      driverPos.latitude,
      driverPos.longitude,
      polyline[closestIndex].latitude,
      polyline[closestIndex].longitude,
    );

    // 0.1 km = 100 meters
    return distToRoute > 0.1;
  }

  /// Throttled re-fetch of route from driver's current position to destination
  void _throttledRefetchRoute(LatLng? destination, {required bool isPickup}) {
    if (destination == null || _isFetchingDirections) return;

    final now = DateTime.now();
    if (now.difference(_lastPolylineRefresh).inSeconds < 15) {
      return; // Too soon since last fetch
    }

    _lastPolylineRefresh = now;
    _fetchRouteFromDriverTo(destination, isPickup: isPickup);
  }

  /// Fetch directions from driver's current location to a destination
  Future<void> _fetchRouteFromDriverTo(
    LatLng destination, {
    bool isPickup = false,
  }) async {
    if (_driverLocation == null || _isFetchingDirections) return;

    _isFetchingDirections = true;

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$GOOGLE_API_KEY',
      );

      print(
        '🛣️ Re-fetching route from driver to ${isPickup ? "pickup" : "drop"}...',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final newCoordinates = _getDetailedPolylineFromSteps(route);

          if (mounted && _isScreenActive) {
            setState(() {
              if (isPickup) {
                _routeCoordinates = newCoordinates;
              } else {
                _driverToDropCoordinates = newCoordinates;
              }
            });
            _updatePolylines();
            print('✅ Route re-fetched (${newCoordinates.length} points)');
          }
        }
      }
    } catch (e) {
      print('❌ Error re-fetching route: $e');
    } finally {
      _isFetchingDirections = false;
    }
  }

  // ==================== Markers (State-Aware) ====================

  void _setMarkers() {
    if (!_isScreenActive || !mounted) return;

    final step = stepperController.activeStep.value;
    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};

    // Always show driver marker
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

    if (step < 2) {
      // State 1: Show pickup marker
      if (_rideData?['pickupCoordinates'] != null &&
          _pickupMarkerIcon != null) {
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
    } else {
      // State 2: Show drop marker
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
    }

    if (mounted) {
      setState(() {
        markers = newMarkers;
        circles = newCircles;
      });
    }

    if (!_initialFitDone) {
      _fitMapToAllMarkers();
    }
  }

  void _fitMapToAllMarkers() {
    if (_mapController == null || !_isScreenActive) return;

    final step = stepperController.activeStep.value;
    final List<LatLng> allPoints = [];

    if (_driverLocation != null) allPoints.add(_driverLocation!);

    if (step < 2) {
      if (_rideData?['pickupCoordinates'] != null)
        allPoints.add(_rideData!['pickupCoordinates']);
    } else {
      if (_rideData?['dropoffCoordinates'] != null)
        allPoints.add(_rideData!['dropoffCoordinates']);
    }

    if (allPoints.isEmpty) return;

    final bounds = _boundsFromLatLngList(allPoints);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_mapController != null && _isScreenActive && mounted) {
        try {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 150),
          );
          _initialFitDone = true;
        } catch (e) {
          print('❌ Error animating camera: $e');
        }
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

  /// Extract all polyline points from route steps for maximum detail
  /// This provides many more points than overview_polyline alone
  /// Perfect for long distances (100km+) to follow roads accurately
  List<LatLng> _getDetailedPolylineFromSteps(Map<String, dynamic> route) {
    final List<LatLng> allPoints = [];

    if (route['legs'] != null && route['legs'].isNotEmpty) {
      for (var leg in route['legs']) {
        if (leg['steps'] != null && leg['steps'].isNotEmpty) {
          for (var step in leg['steps']) {
            if (step['polyline'] != null &&
                step['polyline']['points'] != null) {
              final stepPoints = _decodePolyline(step['polyline']['points']);
              allPoints.addAll(stepPoints);
            }
          }
        }
      }
    }

    // If no steps polyline available, fall back to overview polyline
    if (allPoints.isEmpty && route['overview_polyline'] != null) {
      return _decodePolyline(route['overview_polyline']['points']);
    }

    print('📍 Detailed polyline has ${allPoints.length} points');
    return allPoints;
  }

  Future<void> _getDirections() async {
    if (_rideData?['pickupCoordinates'] == null) {
      print('⚠️ Cannot get directions: pickup coordinates missing');
      return;
    }

    try {
      // Fetch route from driver location to pickup
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
            _routeCoordinates = _getDetailedPolylineFromSteps(route);
            print(
              '🛣️ Route Driver → Pickup calculated (${_routeCoordinates.length} points)',
            );
          } else {
            print('⚠️ No routes found from driver to pickup');
          }
        } else {
          print('⚠️ Directions API error: ${response.statusCode}');
        }
      }

      if (mounted) {
        _updatePolylines();
      }
    } catch (e) {
      print('❌ Error fetching directions: $e');
    }
  }

  void _updatePolylines() {
    if (!_isScreenActive || !mounted) return;

    final step = stepperController.activeStep.value;
    final polylines = <Polyline>{};

    if (step < 2) {
      // State 1: Show driver → pickup polyline
      if (_routeCoordinates.isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('driver_to_pickup'),
            points: _routeCoordinates,
            color: Colors.blue,
            width: 5,
          ),
        );
      }
    } else {
      // State 2: Show driver → drop polyline
      if (_driverToDropCoordinates.isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('driver_to_drop'),
            points: _driverToDropCoordinates,
            color: Colors.green,
            width: 5,
          ),
        );
      }
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

    // Check if we have valid ride data
    if (_rideData == null) {
      print('❌ Cannot navigate to OTP: No ride data available');
      _showSnackbar('Cannot navigate: No ride data', isError: true);
      return;
    }

    final orderId = _rideData!['orderId'];
    if (orderId == null || orderId == 'N/A') {
      print('❌ Cannot navigate to OTP: Invalid order ID');
      _showSnackbar('Invalid order ID', isError: true);
      return;
    }

    // Pause location tracking
    await _pauseLocationTracking();

    print("📤 Sending ride data to OTP screen: $_rideData");

    // Navigate to OTP screen using GetX
    try {
      await Get.to(
        () => ArrivedOtpScreen(rideData: _rideData, imagepath: profileImage),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );

      print('↩️ Returned from OTP screen');
    } catch (e) {
      print('❌ Error navigating to OTP screen: $e');
      if (_isScreenActive && mounted) {
        _showSnackbar('Failed to navigate to OTP', isError: true);
        await _resumeLocationTracking(); // Resume tracking on error
      }
    }
  }

  // Helper method to show snackbar
  void _showSnackbar(String message, {bool isError = true}) {
    if (mounted && _isScreenActive) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: isError ? Colors.red : Colors.green,
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP, // 👈 Top position
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _handleNavigation(NavigationCommand command) {
    print("Navigation command: ${command}");
    if (!mounted || !_isScreenActive) return;

    switch (command.route) {
      case 'bottom_nav':
        Get.offAll(() => BottomnavmainScreen(isOnDuty: true));
        break;
      case 'arriving_screen':
        _navigateToOtpScreen();
        break;
      case 'payment_screen':
        Get.offAll(() => ReceivePaymentModes(rideData: widget.rideData));
        break;
      case 'arriving_client': // Already on arriving client screen
        break;
      default:
        print('⚠️ Unknown navigation route: ${command.route}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Fluttertoast.showToast(
          msg: "Please complete the ride verification first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 14,
        );
      },
      child: Scaffold(
        backgroundColor: ColorsList.scaffoldColor,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(w),
        body: Column(
          children: [
            _buildLocationInputs(w),
            Expanded(child: _buildMapSection(w)),
            _buildBottomSheet(w),
          ],
        ),
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
          // GestureDetector(
          //   onTap: () => Navigator.pop(context),
          //   child: CustomImages.images(
          //     "assets/icons/arrowLeftIcon.png",
          //     w * .07,
          //     w * .07,
          //   ),
          // ),
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
    return SingleChildScrollView(
      child: Container(
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
              _buildClientCard(w),
            ] else ...[
              _buildClientCard(w),
            ],

            SizedBox(height: w * .04),

            if (widget.typeCheck == true) ...[
              _buildActionButtons(w), // Implement if needed
            ] else ...[
              _buildActionButtons(w),
            ],
          ],
        ),
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
                child: ClipOval(
                  child:
                      profileImage != null && profileImage.toString().isNotEmpty
                      ? Image.network(
                          ApiPath.imagebaseUrl + profileImage.toString(),
                          width: w * .11,
                          height: w * .11,
                          fit: BoxFit.cover,

                          // ✅ Show loader while loading
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return SizedBox(
                              width: w * .05,
                              height: w * .05,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          },

                          // ✅ If image fails
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: w * .07,
                              color: Colors.grey.shade700,
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          size: w * .07,
                          color: Colors.grey.shade700,
                        ),
                ),
              ),

              // CircleAvatar(
              //   radius: w * .055,
              //   backgroundColor: Colors.grey.shade300,
              //   child: Image.network(
              //     ApiPath.imagebaseUrl + profileImage,
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Icon(
              //         Icons.person,
              //         size: w * .07,
              //         color: Colors.grey.shade700,
              //       );
              //     },
              //   ),
              // ),
              // CircleAvatar(
              //   radius: w * .055,
              //   backgroundColor: Colors.grey.shade300,
              //   child:

              //   Icon(
              //     Icons.person,
              //     size: w * .07,
              //     color: Colors.grey.shade700,
              //   ),
              // ),
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

              // In ArrivingClient.dart, update the chat button:
              Obx(() {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _circleImage("assets/images/mess.png", () async {
                      print(
                        "📱 Chat button tapped with ride data: ${widget.rideData}",
                      );

                      // Reset count when opening chat
                      chatNotificationController.resetCount();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            rideData: widget.rideData,
                            profileImage: profileImage,
                            driverName: riderName,
                          ),
                        ),
                      );
                    }),
                    if (chatNotificationController.unreadCount.value > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${chatNotificationController.unreadCount.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
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

      // Get loading states for buttons
      final isCancelLoading =
          ButtonStateManager.watchLoading('cancel_button')?.value ?? false;
      final isArriveLoading =
          ButtonStateManager.watchLoading('arrive_button')?.value ?? false;
      final isStartTripLoading =
          ButtonStateManager.watchLoading('start_trip_button')?.value ?? false;
      final isCompleteLoading =
          ButtonStateManager.watchLoading('complete_button')?.value ?? false;

      return Row(
        children: [
          Expanded(
            child: _buildLoadingButton(
              text: "Cancel",
              isLoading: isCancelLoading,
              color: const Color(0xFFE0E4E7),
              textColor: Colors.grey,
              buttonId: 'cancel_button',
              onTap: _handleCancelOrder,
            ),
          ),
          SizedBox(width: w * .04),
          Expanded(
            child: _buildStepButton(
              step: step,
              isArriveLoading: isArriveLoading,
              isStartTripLoading: isStartTripLoading,
              isCompleteLoading: isCompleteLoading,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoadingButton({
    required String text,
    required bool isLoading,
    required Color color,
    required Color textColor,
    required String buttonId,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildStepButton({
    required int step,
    required bool isArriveLoading,
    required bool isStartTripLoading,
    required bool isCompleteLoading,
  }) {
    final orderId = _rideData?['orderId'];

    switch (step) {
      case 0: // "I've Arrived"
        return _buildLoadingButton(
          text: "I've Arrived",
          isLoading: isArriveLoading,
          color: const Color(0xFF26E3DD),
          textColor: Colors.black87,
          buttonId: 'arrive_button',
          onTap: () {
            if (orderId != null && orderId.isNotEmpty) {
              orderUpdateController.updateOrder(
                context: context,
                buttonId: 'arrive_button',
                orderStatus: "Arriving",
                orderId: orderId,
                rideData: _rideData,
                stepControl: "Arriving",
                successMessage: 'Arrival status updated',
                shouldTriggerNavigation: true,
              );
            } else {
              _showSnackbar('Invalid order ID', isError: true);
            }
          },
        );

      case 1: // "Start Trip" - This should trigger OTP screen
        return _buildLoadingButton(
          text: "Start Trip",
          isLoading: isStartTripLoading,
          color: const Color(0xFF26E3DD),
          textColor: Colors.black87,
          buttonId: 'start_trip_button',
          onTap: () {
            if (orderId != null && orderId.isNotEmpty) {
              orderUpdateController.updateOrder(
                context: context,
                buttonId: 'start_trip_button',
                orderStatus: "Progress", // This should trigger OTP navigation
                orderId: orderId,
                rideData: _rideData,
                stepControl: "Progress",
                successMessage: 'Trip started successfully',
                shouldTriggerNavigation: true,
              );
            } else {
              _showSnackbar('Invalid order ID', isError: true);
            }
          },
        );

      case 2: // "Complete"
        return _buildLoadingButton(
          text: "Complete",
          isLoading: isCompleteLoading,
          color: const Color(0xFF26E3DD),
          textColor: Colors.black87,
          buttonId: 'complete_button',
          onTap: () {
            if (orderId != null && orderId.isNotEmpty) {
              orderUpdateController.updateOrder(
                context: context,
                buttonId: 'complete_button',
                orderStatus: "Completed",
                orderId: orderId,
                rideData: _rideData,
                stepControl: "Completed",
                successMessage: 'Trip completed successfully',
                shouldTriggerNavigation: true,
              );
            } else {
              _showSnackbar('Invalid order ID', isError: true);
            }
          },
        );

      default:
        return _buildLoadingButton(
          text: "Action",
          isLoading: false,
          color: const Color(0xFF26E3DD),
          textColor: Colors.black87,
          buttonId: 'default_button',
          onTap: () {},
        );
    }
  }

  void _handleCancelOrder() {
    final orderId = _rideData?['orderId'];

    if (orderId != null && orderId.isNotEmpty) {
      orderUpdateController.updateOrder(
        context: context,
        buttonId: 'cancel_button',
        orderStatus: "Cancelled",
        orderId: orderId,
        rideData: _rideData,
        stepControl: "Cancelled",
        successMessage: 'Order cancelled successfully',
      );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Invalid order ID'),
      //     backgroundColor: Colors.red,
      //   ),
      // );

      Fluttertoast.showToast(
        msg: "Invalid order ID",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP, // 👈 Top position
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
