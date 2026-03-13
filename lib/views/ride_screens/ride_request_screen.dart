import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_images.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/map_helper.dart';
import 'package:nzcu_driver/utilities/utils/button_state_manager.dart';
import 'package:nzcu_driver/utilities/utils/navigation_command.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class RideRequestScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;

  const RideRequestScreen({super.key, required this.rideData});

  @override
  _RideRequestScreenState createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  // Google API Key for Directions
  static const String GOOGLE_API_KEY =
      'AIzaSyCtM1jo8qzhEn2XZ8SVCoboULcondCjZio';

  // Timer - 10 seconds
  static const int TOTAL_TIME = 10;
  int _timer = TOTAL_TIME;
  double _progress = 1.0;
  Timer? _countdownTimer;

  // Map & Location
  GoogleMapController? _mapController;
  LatLng? _driverLocation;
  double _driverHeading = 0;
  bool _locationError = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Route Information
  Map<String, String> _routeInfo = {'distance': '', 'duration': ''};

  // Controllers
  final StepperController stepperController = Get.find();
  final OrderUpdateController orderUpdateController =
      Get.find<OrderUpdateController>();

  // Ride Data
  Map<String, dynamic>? _rideData;
  bool _isLoading = true;
  List<LatLng> _routeCoordinates = [];
  List<LatLng> _pickupToDropCoordinates = [];

  // Map Elements
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polyline> _polylines = {};

  // Custom Marker Icons
  BitmapDescriptor? _bikeMarkerIcon;
  BitmapDescriptor? _pickupIcon;
  BitmapDescriptor? _dropIcon;

  // Location tracking
  double? _currentLatitude;
  double? _currentLongitude;
  StreamSubscription<Position>? _positionStream;

  // State Flags
  bool _hasAccepted = false;
  bool _hasDeclined = false;
  bool _isDeclining = false;
  bool _isTimerRunning = true;
  Timer? _autoCancelTimer;
  bool _hasCancelled = false;

  // Navigation listener
  Worker? _navigationWorker;

  // Cancel Reasons
  final List<Map<String, dynamic>> _cancelReasons = [
    {'id': 1, 'label': 'Too many rides', 'icon': Icons.directions_bike},
    {'id': 2, 'label': 'Wrong pickup location', 'icon': Icons.location_on},
    {'id': 3, 'label': 'Waiting too long at pickup', 'icon': Icons.timer},
    {'id': 4, 'label': "Bad weather / can't travel now", 'icon': Icons.cloud},
    {'id': 5, 'label': 'Traffic jam near pickup point', 'icon': Icons.traffic},
    {'id': 6, 'label': 'Other', 'icon': Icons.edit},
  ];
  int? _selectedReasonIndex;

  // Cancel Sheet
  bool _showCancelSheet = false;

  // Ride Data Fields
  String? _riderName;
  String? _riderPhone;
  String? _totalFare;
  String? _distance;
  String? _pickupAddress;
  String? _dropAddress;
  String? _formattedDate;
  String? _rideId;
  String? _orderId;

  LatLng? dropLatLng;
  LatLng? pickupLatLng;

  StepperController _stepperController = Get.put(StepperController());

  @override
  void initState() {
    super.initState();

    // Set up navigation listener
    _setupNavigationListener();

    // Initialize everything
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //clear addedd here
      cleardata();

      await _initializeAll();
    });
  }

  void cleardata() {
    _stepperController.resetSteps();
  }

  void _setupNavigationListener() {
    _navigationWorker = ever(orderUpdateController.shouldNavigate$, (
      bool shouldNavigate,
    ) {
      if (shouldNavigate && mounted) {
        final command = NavigationCommand(
          route: orderUpdateController.navigationRoute,
          arguments: orderUpdateController.navigationArgs,
          clearAll: orderUpdateController.clearAll,
        );
        _handleNavigation(command);
        orderUpdateController.clearNavigation();
      }
    });
  }

  Future<void> _initializeAll() async {
    if (mounted) setState(() => _isLoading = true);

    try {
      // Extract ride data FIRST
      _extractAndStoreRideData();

      // Load bike icon only
      await _loadCustomBikeMarker();

      // Start location tracking and get directions
      await _startLocationTracking();
      await _getDirections();

      // Set initial markers
      _setMarkers();

      // Start timer
      _startTimer();

      // Start location listening
      _listenToLocation();
    } catch (e) {
      AppLogger.d('❌ Error initializing: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    AppLogger.d('🗑️ RideRequestScreen dispose called');

    // Cancel all timers and subscriptions first
    _countdownTimer?.cancel();
    _positionStreamSubscription?.cancel();
    _positionStream?.cancel();
    _autoCancelTimer?.cancel();

    // Clean up workers
    _navigationWorker?.dispose();

    // Call super.dispose first
    super.dispose();

    // Clean up button states safely after disposal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        ButtonStateManager.clearState('accept_button');
        ButtonStateManager.clearState('cancel_button');
        ButtonStateManager.clearState('custom_cancel_button');
      } catch (e) {
        // Silently catch errors during disposal
        AppLogger.d('⚠️ Error clearing button states: $e');
      }
    });

    _mapController?.dispose();
  }

  // Helper method to format date from timestamp
  String _formatDateFromTimestamp(int timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat('dd MMMM, yyyy').format(date);
    } catch (e) {
      return DateFormat('dd MMMM, yyyy').format(DateTime.now());
    }
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_hasAccepted || _hasDeclined) {
        timer.cancel();
        return;
      }

      if (_timer <= 1) {
        timer.cancel();
        _handleAutoDecline();
      } else {
        if (mounted) {
          setState(() {
            _timer--;
            _progress = _timer / TOTAL_TIME;
          });
        }
      }
    });
  }

  Future<void> _loadCustomBikeMarker() async {
    try {
      _bikeMarkerIcon = await MapHelper.loadCustomIcon(
        assetPath: 'assets/images/bike2.png',
        width: 150,
        height: 150,
      );
      AppLogger.d('✅ Bike marker icon loaded');
    } catch (e) {
      AppLogger.d('❌ Error loading bike marker: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }
  }

  void _listenToLocation() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          final LatLng newLocation = LatLng(
            position.latitude,
            position.longitude,
          );
          _updateMarkerOnly(newLocation, position.accuracy);
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
        });
  }

  void _updateMarkerOnly(LatLng location, double accuracy) {
    _currentLatitude = location.latitude;
    _currentLongitude = location.longitude;

    if (!mounted) return;
    setState(() {
      // Update driver marker position
      markers.removeWhere((marker) => marker.markerId.value == 'driver');

      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: location,
          icon:
              _bikeMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          anchor: const Offset(0.5, 0.5),
          rotation: _driverHeading,
          flat: true,
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
          zIndex: 2,
        ),
      );

      // Update circles
      circles.clear();

      // Grey outer circle (accuracy shadow)
      circles.add(
        Circle(
          circleId: const CircleId('outer_shadow'),
          center: location,
          radius: accuracy + 80,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.transparent,
        ),
      );

      // Green inner circle (center)
      circles.add(
        Circle(
          circleId: const CircleId('inner_green'),
          center: location,
          radius: 60,
          fillColor: Colors.green.withOpacity(0.35),
          strokeColor: Colors.green,
          strokeWidth: 1,
        ),
      );
    });
  }

  void _extractAndStoreRideData() {
    AppLogger.d("my_rideeee_datatatt ${widget.rideData}");
    try {
      // Store all data locally
      _rideData = {
        'orderId': widget.rideData['orderId']?.toString() ?? 'N/A',
        'riderId': widget.rideData['riderId'],
        'riderName': widget.rideData['riderName']?.toString() ?? 'Customer',
        'riderPhone': widget.rideData['riderNumber']?.toString() ?? 'N/A',
        'riderImage': 'https://i.pravatar.cc/100',
        'pickupLocation':
            widget.rideData['startLocation']?['address']?.toString() ??
            widget.rideData['pickup']?['address']?.toString() ??
            '56, Apsara Complex, Sector A, Indrapuri, Bhopal, Madhya Pradesh 462022, India',
        'dropLocation':
            widget.rideData['endLocation']?['address']?.toString() ??
            widget.rideData['destination']?['address']?.toString() ??
            widget.rideData['dropoff']?['address']?.toString() ??
            'GVFH+RFR, Agarkar Nagar, Pune, Maharashtra 411001, India',
        'fare': widget.rideData['totalFare']?.toString() ?? '180',
        'distance': widget.rideData['distance']?.toString() ?? '6.5',
        'estimatedTime': '15',
        'vehicleType': widget.rideData['vehicleType'] ?? 'sedan',
        'rideOtp': widget.rideData['otp'],
        'status': 'pending',
        'isScheduled': widget.rideData['isScheduled'] ?? false,
        'scheduledStartTime': widget.rideData['scheduledStartTime'],
      };

      // Also store in local variables for easy access
      _riderName = widget.rideData['riderName']?.toString() ?? 'Customer';
      _riderPhone = widget.rideData['riderNumber']?.toString() ?? 'N/A';
      _totalFare = widget.rideData['totalFare']?.toString() ?? '0';
      _distance = widget.rideData['distance']?.toString() ?? '0';
      _rideId =
          widget.rideData['rideId']?.toString() ??
          widget.rideData['orderId']?.toString() ??
          'N/A';
      _orderId = widget.rideData['orderId']?.toString() ?? 'N/A';

      // Extract addresses with multiple fallbacks
      _pickupAddress =
          widget.rideData['startLocation']?['address']?.toString() ??
          widget.rideData['pickup']?['address']?.toString() ??
          '56, Apsara Complex, Sector A, Indrapuri, Bhopal, Madhya Pradesh 462022, India';

      _dropAddress =
          widget.rideData['endLocation']?['address']?.toString() ??
          widget.rideData['destination']?['address']?.toString() ??
          widget.rideData['dropoff']?['address']?.toString() ??
          'GVFH+RFR, Agarkar Nagar, Pune, Maharashtra 411001, India';

      // Format date from timestamp
      final timestamp = widget.rideData['timestamp'];
      _formattedDate = timestamp != null
          ? _formatDateFromTimestamp(
              timestamp is String ? int.parse(timestamp) : timestamp,
            )
          : DateFormat('dd MMMM, yyyy').format(DateTime.now());

      // Extract coordinates
      _extractCoordinates();

      // Removed simulated driver location logic

      AppLogger.d('✅ Ride data extracted successfully');
      AppLogger.d('📍 Pickup: ${_pickupAddress}');
      AppLogger.d('📍 Drop: ${_dropAddress}');
    } catch (e) {
      AppLogger.d("❌ Error extracting ride data: $e");
      // Set default values if extraction fails
      _rideData = {
        'orderId': 'N/A',
        'riderId': 'rider_123',
        'riderName': 'Bzbsbsb',
        'riderPhone': '+1234567890',
        'riderImage': 'https://i.pravatar.cc/100',
        'pickupLocation':
            '56, Apsara Complex, Sector A, Indrapuri, Bhopal, Madhya Pradesh 462022, India',
        'dropLocation':
            'GVFH+RFR, Agarkar Nagar, Pune, Maharashtra 411001, India',
        'fare': '180',
        'distance': '6.5',
        'estimatedTime': '15',
        'vehicleType': 'sedan',
        'rideOtp': '1234',
        'status': 'pending',
      };

      // Use coordinates from your image (Bhopal to Pune)
      _rideData!['pickupCoordinates'] = LatLng(23.2599, 77.4126); // Bhopal
      _rideData!['dropoffCoordinates'] = LatLng(18.5204, 73.8567); // Pune
      _driverLocation = LatLng(23.2550, 77.4000); // Near Bhopal

      // Set local variables
      _riderName = 'Bzbsbsb';
      _riderPhone = 'N/A';
      _totalFare = '0';
      _distance = '973.217'; // From your image
      _pickupAddress =
          '56, Apsara Complex, Sector A, Indrapuri, Bhopal, Madhya Pradesh 462022, India';
      _dropAddress = 'GVFH+RFR, Agarkar Nagar, Pune, Maharashtra 411001, India';
      _formattedDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());
      _rideId = 'N/A';
      _orderId = 'N/A';
    }
  }

  void _extractCoordinates() {
    try {
      // Extract pickup coordinates
      if (widget.rideData['pickup'] != null) {
        final pickup = widget.rideData['pickup'];
        _rideData!['pickupCoordinates'] = LatLng(
          pickup['latitude']?.toDouble() ?? 23.2599,
          pickup['longitude']?.toDouble() ?? 77.4126,
        );
      } else if (widget.rideData['startLocation'] != null) {
        final startLocation = widget.rideData['startLocation'];
        if (startLocation['coordinates'] != null &&
            startLocation['coordinates'].length >= 2) {
          _rideData!['pickupCoordinates'] = LatLng(
            startLocation['coordinates'][1]?.toDouble() ?? 23.2599,
            startLocation['coordinates'][0]?.toDouble() ?? 77.4126,
          );
        }
      }

      // Extract drop coordinates
      if (widget.rideData['destination'] != null) {
        final destination = widget.rideData['destination'];
        _rideData!['dropoffCoordinates'] = LatLng(
          destination['latitude']?.toDouble() ?? 18.5204,
          destination['longitude']?.toDouble() ?? 73.8567,
        );
      } else if (widget.rideData['endLocation'] != null) {
        final endLocation = widget.rideData['endLocation'];
        if (endLocation['coordinates'] != null &&
            endLocation['coordinates'].length >= 2) {
          _rideData!['dropoffCoordinates'] = LatLng(
            endLocation['coordinates'][1]?.toDouble() ?? 18.5204,
            endLocation['coordinates'][0]?.toDouble() ?? 73.8567,
          );
        }
      }

      // Fallback coordinates if none found
      if (_rideData!['pickupCoordinates'] == null) {
        _rideData!['pickupCoordinates'] = LatLng(23.2599, 77.4126); // Bhopal
      }

      if (_rideData!['dropoffCoordinates'] == null) {
        _rideData!['dropoffCoordinates'] = LatLng(18.5204, 73.8567); // Pune
      }

      AppLogger.d('📍 Pickup coordinates: ${_rideData!['pickupCoordinates']}');
      AppLogger.d('📍 Drop coordinates: ${_rideData!['dropoffCoordinates']}');
    } catch (e) {
      AppLogger.d("❌ Error extracting coordinates: $e");
      _rideData!['pickupCoordinates'] = LatLng(23.2599, 77.4126); // Bhopal
      _rideData!['dropoffCoordinates'] = LatLng(18.5204, 73.8567); // Pune
    }
  }

  Future<bool> _requestLocationPermission() async {
    try {
      final status = await Permission.location.request();

      if (status.isGranted) {
        return true;
      } else {
        if (mounted) setState(() => _locationError = true);
        return false;
      }
    } catch (e) {
      if (mounted) setState(() => _locationError = true);
      return false;
    }
  }

  /// Start real-time location tracking with heading
  Future<void> _startLocationTracking() async {
    if (!await _requestLocationPermission()) {
      AppLogger.d('❌ Location permission denied');
      return;
    }

    // Get initial position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );

      if (mounted) {
        setState(() {
          _driverLocation = LatLng(position.latitude, position.longitude);
          if (position.heading.isFinite && position.heading >= 0) {
            _driverHeading = position.heading;
          }
          _locationError = false;
        });
      }

      AppLogger.d('📍 Initial location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      AppLogger.d('❌ Error getting initial position: $e');
      if (mounted) setState(() => _locationError = true);
    }

    // Start position stream for continuous updates
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (!mounted) return;

            setState(() {
              _driverLocation = LatLng(position.latitude, position.longitude);

              // Update heading if available
              if (position.heading.isFinite && position.heading >= 0) {
                _driverHeading = position.heading;
              }

              _locationError = false;
            });

            // Update markers
            _setMarkers();
          },
          onError: (error) {
            AppLogger.d('❌ Location stream error: $error');
            if (mounted) {
              setState(() => _locationError = true);
            }
          },
        );
  }

  /// SIMPLE MARKER SETUP FUNCTION
  void _setMarkers() {
    if (!mounted) return;

    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};

    AppLogger.d('📍 Setting simple markers...');
    AppLogger.d('📍 Driver location: $_driverLocation');
    AppLogger.d('📍 Pickup coordinates: ${_rideData?['pickupCoordinates']}');
    AppLogger.d('📍 Drop coordinates: ${_rideData?['dropoffCoordinates']}');

    // ✅ 1. Driver marker (blue)
    if (_driverLocation != null) {
      AppLogger.d('📍 Adding driver marker at: $_driverLocation');
      newMarkers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: _driverLocation!,
          icon:
              _bikeMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          anchor: const Offset(0.5, 0.5),
          rotation: _driverHeading,
          flat: true,
          infoWindow: const InfoWindow(
            title: "Your Location",
            snippet: "You are here",
          ),
          zIndex: 2,
        ),
      );

      // Driver accuracy circles
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

    // ✅ 2. Pickup marker (simple blue marker)
    if (_rideData?['pickupCoordinates'] != null) {
      AppLogger.d('📍 Adding pickup marker at: ${_rideData!['pickupCoordinates']}');
      newMarkers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: _rideData!['pickupCoordinates'],
          infoWindow: InfoWindow(
            title: "Pickup",
            snippet: _rideData!['pickupLocation'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          zIndex: 1,
        ),
      );

      // Pickup zone circle
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

    // ✅ 3. Drop marker (simple red marker)
    if (_rideData?['dropoffCoordinates'] != null) {
      AppLogger.d('📍 Adding drop marker at: ${_rideData!['dropoffCoordinates']}');
      newMarkers.add(
        Marker(
          markerId: const MarkerId("drop"),
          position: _rideData!['dropoffCoordinates'],
          infoWindow: InfoWindow(
            title: "Drop",
            snippet: _rideData!['dropLocation'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

    AppLogger.d('✅ Simple markers set: ${newMarkers.length} markers');

    // Fit map to show all markers
    _fitMapToAllMarkers();
  }

  /// Fit map to show all markers
  void _fitMapToAllMarkers() {
    if (_mapController == null) {
      AppLogger.d('⚠️ Map controller not ready yet');
      return;
    }

    final List<LatLng> allPoints = [];

    if (_driverLocation != null) allPoints.add(_driverLocation!);
    if (_rideData?['pickupCoordinates'] != null)
      allPoints.add(_rideData!['pickupCoordinates']);
    if (_rideData?['dropoffCoordinates'] != null)
      allPoints.add(_rideData!['dropoffCoordinates']);

    if (allPoints.isEmpty) {
      AppLogger.d('⚠️ No points to fit map to');
      return;
    }

    final bounds = _boundsFromLatLngList(allPoints);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _mapController != null) {
        try {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 150),
          );
          AppLogger.d('✅ Map fitted to show all markers');
        } catch (e) {
          AppLogger.d('❌ Error animating camera: $e');
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

  /// Decode polyline from Google Directions API
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

  /// Fetch directions from Google Directions API
  Future<void> _getDirections() async {
    if (_rideData?['pickupCoordinates'] == null ||
        _rideData?['dropoffCoordinates'] == null) {
      AppLogger.d('⚠️ Cannot get directions: coordinates missing');
      return;
    }

    try {
      // 1. Fetch route from Driver to Pickup
      if (_driverLocation != null && _rideData!['pickupCoordinates'] != null) {
        final pickupCoords = _rideData!['pickupCoordinates'] as LatLng;
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${_driverLocation!.latitude},${_driverLocation!.longitude}'
          '&destination=${pickupCoords.latitude},${pickupCoords.longitude}'
          '&key=$GOOGLE_API_KEY',
        );

        AppLogger.d('🛣️ Fetching route from driver to pickup...');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final polylineEncoded = route['overview_polyline']['points'];
            _routeCoordinates = _decodePolyline(polylineEncoded);

            // Extract distance and duration
            if (route['legs'] != null && route['legs'].isNotEmpty) {
              final leg = route['legs'][0];
              if (mounted) {
                setState(() {
                  _routeInfo = {
                    'distance': leg['distance']['text'] ?? '',
                    'duration': leg['duration']['text'] ?? '',
                  };
                });
              }
            }

            AppLogger.d('🛣️ Route Driver → Pickup calculated');
          }
        }
      }

      // 2. Fetch route from Pickup to Drop
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

        AppLogger.d('🛣️ Fetching route from pickup to drop...');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            final polylineEncoded = route['overview_polyline']['points'];
            _pickupToDropCoordinates = _decodePolyline(polylineEncoded);

            AppLogger.d('🛣️ Route Pickup → Drop calculated');
          }
        }
      }

      _updatePolylines();
    } catch (e) {
      AppLogger.d('❌ Error fetching directions: $e');
    }
  }

  void _updatePolylines() {
    final polylines = <Polyline>{};

    // Driver to Pickup route (Blue solid line)
    if (_routeCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('driver_to_pickup'),
          points: _routeCoordinates,
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    // Pickup to Drop route (Green dashed line)
    if (_pickupToDropCoordinates.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('pickup_to_drop'),
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

  Future<void> _handleAutoDecline() async {
    if (_hasAccepted || _hasDeclined) return;

    _hasDeclined = true;
    _countdownTimer?.cancel();

    // Stop notification sound
    NotificationService.instance.cancelRideNotification();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Ride auto-cancelled (timeout)'),
    //     backgroundColor: Colors.orange,
    //   ),
    // );

    CustomToast.showError('Ride auto-cancelled (timeout)');

    // Navigate to BottomnavmainScreen after 1 second
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      Get.offAll(() => BottomnavmainScreen(isOnDuty: true));

      // Navigator.pop(context);
    }
  }

  void _handleNavigation(NavigationCommand command) {
    if (!mounted) return;

    switch (command.route) {
      case 'bottom_nav':
        // Go back to home screen on cancellation
        // Get.back();
        Get.offAll(() => BottomnavmainScreen(isOnDuty: true));
        break;
      case 'arriving_screen':
        // Navigate to ArrivingClient screen
        _hasAccepted = true;
        _isTimerRunning = false;
        _autoCancelTimer?.cancel();
        _countdownTimer?.cancel();

        Get.off(
          () => ArrivingClient(
            rideData: widget.rideData,
            typeCheck: _rideData!['isScheduled'] == true,
          ),
          transition: Transition.rightToLeft,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    AppLogger.d("helloooooo_secduleeddd_ride_hererrer2 ${_rideData?['isScheduled']}");

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        CustomToast.showError("Please complete the ride verification first");
      },

      child: Scaffold(
        backgroundColor: Colors.white,
        body: _rideData == null
            ? _buildErrorView()
            : Stack(
                children: [
                  // Main Column Layout - Card first, Map below
                  Column(
                    children: [
                      SizedBox(height: 60),

                      // User Info Card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _buildUserInfoCard(w),
                      ),

                      // Location Error Warning
                      if (_locationError)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: _buildWarningBadge(),
                        ),

                      // Spacing
                      SizedBox(height: 16),

                      // Map - takes remaining space
                      Expanded(child: _buildMap()),

                      // Ride Details Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: _buildRideDetails(w),
                        ),
                      ),
                    ],
                  ),

                  // Cancel Reason Sheet
                  if (_showCancelSheet) _buildCancelReasonSheet(w),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF87D750)),
          SizedBox(height: 16),
          Text(
            'Loading ride details...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'No ride information available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please go back and try again',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text('Go Back', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final initialLocation = _driverLocation != null
        ? _driverLocation!
        : (_rideData!['pickupCoordinates'] ?? LatLng(23.2599, 77.4126));

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        AppLogger.d('✅ Google Map created');

        // Wait a bit then set markers and fit map
        Future.delayed(Duration(milliseconds: 500), () {
          _setMarkers();
          _fitMapToAllMarkers();
        });
      },
      initialCameraPosition: CameraPosition(target: initialLocation, zoom: 16),
      markers: markers,
      circles: circles,
      polylines: _polylines,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }

  Widget _buildWarningBadge() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '⚠️ Location unavailable',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRideDetails(double w) {
    AppLogger.d("helloooooo_secduleeddd_ride_hererrer ${_rideData!['isScheduled']}");
    AppLogger.d(
      "helloooooo_secduleeddd_ride_hererrer2222 ${_rideData!['scheduledStartTime']}",
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Center(
            child: Text(
              DateFormat('dd MMMM, yyyy').format(DateTime.now()),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_rideData!['isScheduled'] == true) ...[
            SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Scheduled Pickup',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_rideData!['scheduledStartTime'] != null)
                      Builder(
                        builder: (context) {
                          final utcTime = DateTime.parse(
                            _rideData!['scheduledStartTime'],
                          );

                          final localTime = utcTime.toLocal(); // ✅ important

                          return Text(
                            DateFormat(
                              'hh:mm a, dd MMM yyyy',
                            ).format(localTime),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                  ],
                ),
                // Column(
                //   children: [
                //     Text(
                //       'Scheduled Pickup',
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Colors.orange[800],
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     if (_rideData!['scheduledStartTime'] != null)
                //       Text(
                //         DateFormat('hh:mm a, dd MMM yyyy').format(
                //           DateTime.parse(_rideData!['scheduledStartTime']),
                //         ),
                //         style: TextStyle(
                //           fontSize: 13,
                //           color: Colors.orange[700],
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //   ],
                // ),
              ),
            ),
          ],
          SizedBox(height: 16),

          Text(
            'Trip Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14),

          _locationInfo(
            context,
            w,
            _rideData!['pickupLocation'],
            _rideData!['dropLocation'],
          ),

          SizedBox(height: 5),
          // Distance Info Cards
          _buildInfoGrid(),
          SizedBox(height: 20),

          // Action Buttons
          _actionButtons(context, w),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(double w) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row(
          //   children: [
          //     CircleAvatar(
          //       radius: 24,
          //       backgroundImage: NetworkImage(_rideData!['riderImage']),
          //     ),
          //     SizedBox(width: 12),
          //     Text(
          //       _rideData!['riderName'],
          //       style: TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ],
          // ),
          Text(
            "Estimated Fare",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(Icons.currency_rupee, color: Color(0xFF22C55E), size: 22),
              Text(
                _rideData!['fare'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(
          child: _routeInfo['distance']?.isNotEmpty == true
              ? _buildInfoCard(label: 'Pick up', value: _routeInfo['distance']!)
              : _buildCalculatingCard('Pick up'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            label: 'Drop',
            value: '${_rideData!['distance']} Km',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatingCard(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: 3),
          duration: const Duration(milliseconds: 1500),
          builder: (context, value, child) {
            String dots = '.' * value;
            return Text(
              'Calculating$dots',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            );
          },
          onEnd: () {
            // Force rebuild to keep animation looping
            if (mounted) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildCancelReasonSheet(double w) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.55,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 48),
                        Text(
                          'Why Do You Want To Cancel?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            if (mounted)
                              setState(() => _showCancelSheet = false);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Reason List
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _cancelReasons.length,
                      itemBuilder: (context, index) {
                        final reason = _cancelReasons[index];
                        final isSelected = _selectedReasonIndex == index;

                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          color: isSelected
                              ? Color(0xFF87D750).withOpacity(0.1)
                              : Color(0xFFF9FAFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected
                                  ? Color(0xFF87D750)
                                  : Color(0xFFE5E7EB),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              reason['icon'],
                              color: isSelected
                                  ? Color(0xFF87D750)
                                  : Colors.grey[700],
                            ),
                            title: Text(
                              reason['label'],
                              style: TextStyle(
                                color: isSelected
                                    ? Color(0xFF87D750)
                                    : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              if (mounted)
                                setState(() => _selectedReasonIndex = index);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Submit Button
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _selectedReasonIndex == null || _isDeclining
                          ? null
                          : () {
                              final reason =
                                  _cancelReasons[_selectedReasonIndex!]['label'];
                              _handleCustomDecline(reason);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF87D750),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: _isDeclining
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleCustomDecline(String reason) async {
    if (_hasAccepted || _hasDeclined) return;

    if (mounted) setState(() => _isDeclining = true);

    try {
      // Stop notification sound
      NotificationService.instance.cancelRideNotification();

      // Use the new updateOrder method for custom decline
      orderUpdateController.updateOrder(
        context: context,
        buttonId: 'custom_cancel_button',
        orderStatus: "Cancelled",
        orderId: _orderId!,
        rideData: widget.rideData,
        stepControl: "Cancelled",
        successMessage: 'Ride declined successfully',
        shouldTriggerNavigation: true,
      );

      // Close the sheet
      if (mounted) {
        setState(() {
          _showCancelSheet = false;
          _selectedReasonIndex = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to decline ride'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isDeclining = false);
    }
  }

  Widget _locationInfo(
    BuildContext context,
    double w,
    String pickupAddress,
    String dropAddress,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: w * 0.04, fontWeight: FontWeight.w500),
            ),
            Text.rich(
              TextSpan(
                text: "Time ",
                style: TextStyle(
                  fontSize: w * 0.029,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7C7C8D),
                ),
                children: [
                  TextSpan(
                    text: "${_rideData!['estimatedTime']} min",
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomImages.images(
                  "assets/icons/greenDot.png",
                  w * 0.05,
                  w * 0.05,
                ),
                SizedBox(
                  height: w * 0.1,
                  child: DottedLine(
                    direction: Axis.vertical,
                    dashLength: 4,
                    dashColor: AppColors.green,
                  ),
                ),
                CustomImages.images(
                  "assets/icons/redDot.png",
                  w * 0.05,
                  w * 0.05,
                ),
              ],
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationText(context, "Pickup", pickupAddress),
                  SizedBox(height: w * 0.05),
                  _locationText(context, "Drop", dropAddress),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationText(BuildContext context, String title, String address) {
    final double w = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFonts.textPoppins(
          context,
          title,
          w * 0.035,
          FontWeight.w500,
          AppColors.mediumGray,
          TextAlign.left,
          TextOverflow.visible,
        ),
        AppFonts.textPoppins(
          context,
          address,
          w * 0.039,
          FontWeight.w500,
          AppColors.black,
          TextAlign.left,
          TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _actionButtons(BuildContext context, double w) {
    // Get loading states for buttons
    final isAcceptLoading =
        ButtonStateManager.watchLoading('accept_button')?.value ?? false;
    final isCancelLoading =
        ButtonStateManager.watchLoading('cancel_button')?.value ?? false;

    return Column(
      children: [
        // Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel Button
            Expanded(
              child: _buildLoadingButton(
                text: "Cancel",
                isLoading: isCancelLoading,
                color: AppColors.lightGray,
                textColor: AppColors.mediumGray,
                buttonId: 'cancel_button',
                onTap: _hasAccepted || _hasCancelled ? null : _cancelRide,
              ),
            ),

            SizedBox(width: w * 0.03),

            // Accept Button
            Expanded(
              child: _buildLoadingButton(
                text: "Accept",
                isLoading: isAcceptLoading,
                color: Color(0xFF00BFA6),
                textColor: Colors.white,
                buttonId: 'accept_button',
                onTap: _hasAccepted || _hasCancelled ? null : _acceptRide,
                showTimer: true,
                timer: _timer,
                progress: _progress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingButton({
    required String text,
    required bool isLoading,
    required Color color,
    required Color textColor,
    required String buttonId,
    required VoidCallback? onTap,
    bool showTimer = false,
    int timer = 0,
    double progress = 1.0,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        shadowColor: color.withOpacity(0.3),
        disabledBackgroundColor: color.withOpacity(0.5),
        disabledForegroundColor: textColor.withOpacity(0.5),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (showTimer && !isLoading) ...[
                  SizedBox(width: 14),
                  _buildTimerCircle(timer, progress),
                ],
              ],
            ),
    );
  }

  Widget _buildTimerCircle(int timer, double progress) {
    const size = 26.0;
    const strokeWidth = 3.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1,
            strokeWidth: strokeWidth,
            backgroundColor: Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE5E7EB)),
          ),

          // Progress circle (changes color based on time)
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _TimerPainter(
                progress: progress,
                strokeWidth: strokeWidth,
                color: timer <= 10
                    ? Colors.red
                    : timer <= 30
                    ? Colors.orange
                    : Color(0xFF16A34A),
              ),
            ),
          ),

          // Timer text
          Center(
            child: Text(
              '$timer',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: timer <= 10
                    ? Colors.red
                    : timer <= 30
                    ? Colors.orange
                    : Color(0xFF87D750),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptRide() async {
    AppLogger.d("myyy_tapp33333");

    if (_orderId == null) {
      AppLogger.d("❌ Order ID is null, cannot accept ride");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot accept ride: Order ID not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Stop notification sound
    NotificationService.instance.cancelRideNotification();

    // Use the new updateOrder method
    orderUpdateController.updateOrder(
      context: context,
      buttonId: 'accept_button',
      orderStatus: "Accepted",
      orderId: _orderId!,
      rideData: widget.rideData,
      stepControl: "Accepted",
      successMessage: 'Ride accepted successfully!',
      shouldTriggerNavigation: true,
    );
  }

  Future<void> _cancelRide() async {
    if (_hasCancelled || _hasAccepted) return;

    if (_orderId == null) {
      AppLogger.d("❌ Order ID is null, cannot cancel ride");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot cancel ride: Order ID not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Stop notification sound
    NotificationService.instance.cancelRideNotification();

    AppLogger.d("declinennnndd_api");
    AppLogger.d("helloooo_tappeddd>>>   ${_orderId}  ");

    final Uri url = Uri.parse("${ApiPath.baseUri}/order/decline/$_orderId");

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final res = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    AppLogger.d("Response Body: ${res.body}");

    final data = jsonDecode(res.body);

    CustomToast.showError(data["message"]);

    if (res.statusCode == 200) {
      Navigator.pop(context);
    }

  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _TimerPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
