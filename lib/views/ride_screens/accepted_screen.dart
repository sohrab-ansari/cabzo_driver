import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:nzcu_driver/controllers/chart_id_controller/chatid_controller.dart';
import 'package:nzcu_driver/controllers/chart_id_controller/chat_notification_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/utilities/colors/colors_list.dart';
import 'package:nzcu_driver/utilities/widgets/custom_text.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/location_input_textfield.dart';
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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';

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
  LatLng? _driverLocation;          // raw GPS fix
  LatLng? _animatedDriverLocation;  // interpolated position shown on map
  double _animatedHeading = 0;      // smoothly interpolated bearing (replaces raw GPS heading)
  double _distanceToPickup = 0;
  bool _locationError = false;
  bool _isScreenActive = true;
  bool _isInitialized = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Smooth marker animation
  Timer? _markerAnimationTimer;
  static const int _animTotalFrames = 30; // 30 × 16ms ≈ 480ms
  int _animFrame = 0;
  double _previousTravelBearing = -1; // -1 = uninitialised

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
  Worker? _otpRestoreWorker;

  @override
  void initState() {
    super.initState();

    image_get_from_shared();
    myridedataprint();
    image_get_from_shared();

    _isScreenActive = true;
    AppLogger.d('[RIDE_FLOW] ArrivingClient initState → orderId=${widget.rideData?['orderId']} step=${stepperController.activeStep.value}');

    _setupNavigationListener();
    _setupStepperListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeAll();
    });
  }

  dynamic profileImage = "";

  void image_get_from_shared() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        profileImage = prefs.getString('active_ride_profile_image') ?? "";
      });
    }
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

        AppLogger.d('[RIDE_FLOW] ArrivingClient navigation → route=${command.route} clearAll=${command.clearAll}');
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

    // Listen for OTP restore signal from socket reconnect handler.
    // When the socket reconnects and sees status='arriving' + otpVerified=false,
    // it signals us to re-open the OTP screen. We handle it here because we
    // already have the fully extracted rideData and loaded profileImage.
    _otpRestoreWorker = ever(stepperController.shouldRestoreOtp, (_) {
      if (mounted && _isScreenActive && _isInitialized) {
        AppLogger.d('🔔 OTP restore signal received — re-opening OTP screen');
        _navigateToOtpScreen();
      }
    });

    // Listen for OTP restore signal from socket reconnect handler.
    // When the socket reconnects and sees status='arriving' + otpVerified=false,
    // it signals us to re-open the OTP screen. We handle it here because we
    // already have the fully extracted rideData and loaded profileImage.
    _otpRestoreWorker = ever(stepperController.shouldRestoreOtp, (_) {
      if (mounted && _isScreenActive && _isInitialized) {
        AppLogger.d('🔔 OTP restore signal received — re-opening OTP screen');
        _navigateToOtpScreen();
      }
    });
  }

  void myridedataprint() {
    AppLogger.d('[RIDE_FLOW] ArrivingClient rideData keys: ${widget.rideData?.keys.join(", ")}');
  }

  void _onStepChanged(int step) {
    AppLogger.d('[RIDE_FLOW] ArrivingClient step changed → $step (${stepperController.stepNames[step]})');
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
        AppLogger.d('✅ Chart ID method called for order: $orderId');
      } catch (e) {
        AppLogger.d('❌ Error getting chart ID: $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isScreenActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!_isInitialized) {
          await _initializeAll();
        } else {
          await _refreshOnReturn();
        }
      });
    }
  }

  @override
  void dispose() {
    AppLogger.d('🗑️ ArrivingClient dispose called');
    _isScreenActive = false;

    // Cancel all timers and subscriptions first
    _positionStreamSubscription?.cancel();
    _polylineRefreshTimer?.cancel();
    _markerAnimationTimer?.cancel();

    // Clean up workers
    _navigationWorker?.dispose();
    _stepperWorker?.dispose();
    _otpRestoreWorker?.dispose();
    _otpRestoreWorker?.dispose();

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
        AppLogger.d('⚠️ Error clearing button states: $e');
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
    _markerAnimationTimer?.cancel();
    _markerAnimationTimer = null;

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
    AppLogger.d('⏸️ Pausing location tracking');
    _positionStreamSubscription?.pause();
  }

  Future<void> _resumeLocationTracking() async {
    AppLogger.d('▶️ Resuming location tracking');
    if (_positionStreamSubscription != null && _isScreenActive) {
      _positionStreamSubscription?.resume();
    } else if (_isScreenActive) {
      await _startLocationTracking();
    }
  }

  Future<void> _initializeAll() async {
    if (_isInitialized) {
      AppLogger.d('✅ Already initialized, skipping...');
      return;
    }

    try {
      AppLogger.d('🔄 Initializing ArrivingClient...');

      _extractAndStoreRideData();
      await _loadCustomMarkers();
      await _startLocationTracking();
      await _getDirections();
      _setMarkers();

      _isInitialized = true;
      AppLogger.d('✅ ArrivingClient initialized successfully');

      // ─────────────────────────────────────────────────────────────────────
      // AUTO OTP RECOVERY: If the driver already clicked "I've Arrived" in a
      // previous session/screen, the socket status will already be "arriving"
      // but the OTP screen may have been dismissed (e.g. app was minimized).
      // Since the driver cannot click "I've Arrived" again (socket already
      // updated), we automatically re-show the OTP screen here.
      // ─────────────────────────────────────────────────────────────────────
      _checkAndRestoreOtpScreen();

      // ─────────────────────────────────────────────────────────────────────
      // AUTO OTP RECOVERY: If the driver already clicked "I've Arrived" in a
      // previous session/screen, the socket status will already be "arriving"
      // but the OTP screen may have been dismissed (e.g. app was minimized).
      // Since the driver cannot click "I've Arrived" again (socket already
      // updated), we automatically re-show the OTP screen here.
      // ─────────────────────────────────────────────────────────────────────
      _checkAndRestoreOtpScreen();
    } catch (e) {
      AppLogger.d('❌ Error initializing: $e');
      if (mounted) {
        setState(() {
          _locationError = true;
        });
      }
    }
  }

  /// Checks if the OTP screen should be automatically shown based on ride data.
  /// Called on first initialization after data extraction.
  /// Handles COLD-START resume: the app was killed while on the OTP screen.
  /// The SOCKET RECONNECT case is handled via `_otpRestoreWorker` (shouldRestoreOtp signal).
  void _checkAndRestoreOtpScreen() {
    // Use the already-extracted _rideData (normalized by _extractAndStoreRideData)
    final orderStatus = (_rideData?['orderStatus'] ?? '')
        .toString()
        .toLowerCase()
        .trim();
    final isOtpVerified = _rideData?['otpVerified'] == true;

    AppLogger.d(
      '🔍 Cold-start OTP Check — status: $orderStatus | otpVerified: $isOtpVerified',
    );

    // Only auto-launch if:
    // 1. The ride reports status='arriving'
    // 2. OTP has not been verified yet
    // 3. We are not already on the OTP screen (checked via mounted + _isScreenActive)
    if (orderStatus == 'arriving' && !isOtpVerified) {
      AppLogger.d(
        '🔄 Cold-start: Status is "arriving" but OTP unverified — auto-launching OTP screen',
      );
      // Small delay ensures the map/UI is fully rendered before pushing OTP
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted && _isScreenActive) {
          _navigateToOtpScreen();
        }
      });
    }
  }

  Future<void> _refreshOnReturn() async {
    AppLogger.d('🔄 Refreshing on return...');
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

      AppLogger.d('✅ Screen refresh complete');
    }
  }

  void _forceRefreshMap() {
    if (!mounted || !_isScreenActive) return;

    AppLogger.d('🔄 Force refreshing map...');

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
    AppLogger.d('[RIDE_FLOW] ArrivingClient ride data extracted → orderId=${_rideData?['orderId']}');
  }

  void _extractCoordinates() {
    try {
      // ── Pickup ─────────────────────────────────────────────────────────────
      if (widget.rideData?['pickup'] != null) {
        final pickup = widget.rideData!['pickup'];
        if (pickup is Map) {
          // 1. Try Map with latitude/longitude keys
          final lat = pickup['latitude']?.toDouble();
          final lng = pickup['longitude']?.toDouble();
          if (lat != null && lng != null) {
            _rideData!['pickupCoordinates'] = LatLng(lat, lng);
          } else if (pickup['coordinates'] != null) {
            final coords = pickup['coordinates'];
            if (coords is List && coords.length >= 2) {
              final coord0 = coords[0]?.toDouble() ?? 0;
              final coord1 = coords[1]?.toDouble() ?? 0;
              final bool isLatLngFormat =
                  (coord0 >= 8 && coord0 <= 37) &&
                  (coord1 >= 68 && coord1 <= 97);
              _rideData!['pickupCoordinates'] =
                  isLatLngFormat ? LatLng(coord0, coord1) : LatLng(coord1, coord0);
            }
          }
        }
      }

      if (_rideData!['pickupCoordinates'] == null &&
          widget.rideData?['startLocation'] != null) {
        final startLocation = widget.rideData!['startLocation'];
        final coords = startLocation['coordinates'];
        if (coords is List && coords.length >= 2) {
          final coord0 = coords[0]?.toDouble() ?? 0;
          final coord1 = coords[1]?.toDouble() ?? 0;
          final bool isLatLngFormat =
              (coord0 >= 8 && coord0 <= 37) && (coord1 >= 68 && coord1 <= 97);
          _rideData!['pickupCoordinates'] =
              isLatLngFormat ? LatLng(coord0, coord1) : LatLng(coord1, coord0);
        } else if (coords is Map) {
          final lat = coords['latitude']?.toDouble();
          final lng = coords['longitude']?.toDouble();
          if (lat != null && lng != null) {
            _rideData!['pickupCoordinates'] = LatLng(lat, lng);
          }
        }
      }

      // ── Drop ───────────────────────────────────────────────────────────────
      if (widget.rideData?['destination'] != null ||
          widget.rideData?['dropoff'] != null) {
        final destination =
            widget.rideData?['destination'] ?? widget.rideData?['dropoff'];
        if (destination is Map) {
          final lat = destination['latitude']?.toDouble();
          final lng = destination['longitude']?.toDouble();
          if (lat != null && lng != null) {
            _rideData!['dropoffCoordinates'] = LatLng(lat, lng);
          } else if (destination['coordinates'] != null) {
            final coords = destination['coordinates'];
            if (coords is List && coords.length >= 2) {
              final coord0 = coords[0]?.toDouble() ?? 0;
              final coord1 = coords[1]?.toDouble() ?? 0;
              final bool isLatLngFormat =
                  (coord0 >= 8 && coord0 <= 37) &&
                  (coord1 >= 68 && coord1 <= 97);
              _rideData!['dropoffCoordinates'] =
                  isLatLngFormat ? LatLng(coord0, coord1) : LatLng(coord1, coord0);
            }
          }
        }
      }

      if (_rideData!['dropoffCoordinates'] == null &&
          widget.rideData?['endLocation'] != null) {
        final endLocation = widget.rideData!['endLocation'];
        final coords = endLocation['coordinates'];
        if (coords is List && coords.length >= 2) {
          final coord0 = coords[0]?.toDouble() ?? 0;
          final coord1 = coords[1]?.toDouble() ?? 0;
          final bool isLatLngFormat =
              (coord0 >= 8 && coord0 <= 37) && (coord1 >= 68 && coord1 <= 97);
          _rideData!['dropoffCoordinates'] =
              isLatLngFormat ? LatLng(coord0, coord1) : LatLng(coord1, coord0);
        } else if (coords is Map) {
          final lat = coords['latitude']?.toDouble();
          final lng = coords['longitude']?.toDouble();
          if (lat != null && lng != null) {
            _rideData!['dropoffCoordinates'] = LatLng(lat, lng);
          }
        }
      }

      if (_rideData!['pickupCoordinates'] == null) {
        _rideData!['pickupCoordinates'] = const LatLng(23.2599, 77.4126);
      }
      if (_rideData!['dropoffCoordinates'] == null) {
        _rideData!['dropoffCoordinates'] = const LatLng(18.5204, 73.8567);
      }
    } catch (e) {
      AppLogger.d("❌ Error extracting coordinates: $e");
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
        AppLogger.d('✅ Bike marker icon loaded');
      }

      _pickupMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );

      _dropMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    } catch (e) {
      AppLogger.d('❌ Error loading markers: $e');
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
      AppLogger.d('❌ Location permission denied');
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

      final initialPos = LatLng(position.latitude, position.longitude);
      setState(() {
        _driverLocation = initialPos;
        // Bootstrap animated position so there is no null on first frame
        _animatedDriverLocation ??= initialPos;
        _locationError = false;
      });

      AppLogger.d('📍 Initial location: ${position.latitude}, ${position.longitude}');

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
      AppLogger.d('❌ Error getting initial position: $e');
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
            
            // Fetch city polygon
            Get.find<GetCityByLocationController>().getCityByLocation(
                lat: position.latitude.toString(),
                lng: position.longitude.toString());
            
            // Fetch city polygon
            Get.find<GetCityByLocationController>().getCityByLocation(
                lat: position.latitude.toString(),
                lng: position.longitude.toString());

            final newLocation = LatLng(position.latitude, position.longitude);

            setState(() {
              _driverLocation = newLocation;
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

            // Smoothly animate marker from old → new position (Ola/Rapido style)
            _animateMarkerTo(newLocation);
          },
          onError: (error) {
            AppLogger.d('❌ Location stream error: $error');
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

  // ==================== Smooth Marker Animation ====================

  /// Ola/Rapido/Uber-style smooth glide: interpolates marker from current
  /// animated position → [newPos] over [_animTotalFrames] frames at 16ms each.
  void _animateMarkerTo(LatLng newPos) {
    _markerAnimationTimer?.cancel();

    final LatLng startPos = _animatedDriverLocation ?? newPos;
    // Raw bearing without the image offset — used for U-turn detection
    final double rawBearing = _rawBearing(startPos, newPos);
    final double targetBearing = _calculateBearing(startPos, newPos);
    final double startHeading = _animatedHeading;
    _animFrame = 0;

    // ── U-turn detection ─────────────────────────────────────────────────
    final distMoved = _calculateDistance(
      startPos.latitude, startPos.longitude,
      newPos.latitude, newPos.longitude,
    );
    if (_previousTravelBearing >= 0 && distMoved > 0.005) {
      // Angular difference between previous travel direction and current
      final double angleDiff =
          (((rawBearing - _previousTravelBearing) + 540) % 360) - 180;
      if (angleDiff.abs() > 130) {
        // Driver made a U-turn — clear stale polyline immediately so the
        // V-shape disappears, then re-fetch fresh route.
        AppLogger.d('🔄 U-turn detected (${angleDiff.abs().toStringAsFixed(0)}°) — clearing polyline');
        _immediateReFetchRoute();
      }
    }
    if (distMoved > 0.005) _previousTravelBearing = rawBearing;

    _markerAnimationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        if (!_isScreenActive || !mounted) {
          timer.cancel();
          return;
        }

        _animFrame++;
        final double t = _animFrame / _animTotalFrames;

        final double animLat =
            startPos.latitude + (newPos.latitude - startPos.latitude) * t;
        final double animLng =
            startPos.longitude + (newPos.longitude - startPos.longitude) * t;

        final interpPos = LatLng(animLat, animLng);

        // Compute new heading (only when actually moving >2m)
        final distMoved = _calculateDistance(
          startPos.latitude, startPos.longitude,
          newPos.latitude, newPos.longitude,
        );
        double newHeading = _animatedHeading;
        if (distMoved > 0.002) {
          newHeading = _lerpAngle(startHeading, targetBearing, t);
        }

        setState(() {
          _animatedDriverLocation = interpPos;
          _animatedHeading = newHeading;

          // 🔑 KEY FIX: Directly update the driver Marker inside the Set
          // so GoogleMap re-renders the icon at the interpolated position.
          // Using copyWith avoids rebuilding the entire markers Set.
          markers = markers.map((m) {
            if (m.markerId.value == 'driver') {
              return m.copyWith(
                positionParam: interpPos,
                rotationParam: newHeading,
              );
            }
            return m;
          }).toSet();

          // Keep driver circles centred on the animated position
          circles = circles.map((c) {
            if (c.circleId.value == 'outer_shadow' ||
                c.circleId.value == 'inner_green') {
              return Circle(
                circleId: c.circleId,
                center: interpPos,
                radius: c.radius,
                fillColor: c.fillColor,
                strokeColor: c.strokeColor,
                strokeWidth: c.strokeWidth,
              );
            }
            return c;
          }).toSet();
        });

        // Update polyline origin on every animation frame
        _updateDynamicPolyline();

        if (_animFrame >= _animTotalFrames) {
          timer.cancel();
          // Rebuild full marker set at exact target to stay in sync
          if (mounted && _isScreenActive) {
            _setMarkers();
          }
        }
      },
    );
  }

  /// Bearing (degrees 0–360) without image-offset correction.
  /// Used only for U-turn detection (we need true compass direction).
  double _rawBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final dLng = (to.longitude - from.longitude) * pi / 180;
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    return (atan2(y, x) * 180 / pi + 360) % 360;
  }

  /// Bearing (degrees 0–360) from [from] → [to], corrected for the bike2.png
  /// image orientation (bike nose points upper-right at ~45° in the asset,
  /// so we subtract 45° to align to true travel direction).
  static const double _markerImageOffset = -45.0;

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = from.latitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final dLng = (to.longitude - from.longitude) * pi / 180;
    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    final rawBearing = (atan2(y, x) * 180 / pi + 360) % 360;
    // Apply image offset so the bike's nose aligns with the direction of travel
    return (rawBearing + _markerImageOffset + 360) % 360;
  }

  /// Short-path angle lerp — avoids 359° → 1° backward spin
  double _lerpAngle(double a, double b, double t) {
    final diff = ((b - a + 540) % 360) - 180;
    return (a + diff * t + 360) % 360;
  }

  // ==================== Dynamic Polyline Methods ====================

  /// U-turn response: immediately clears the current route polyline so the
  /// V-shape disappears, then re-fetches a fresh route from driver position
  /// (bypasses the normal 15-second throttle).
  void _immediateReFetchRoute() {
    if (!_isScreenActive || !mounted || _isFetchingDirections) return;
    final step = stepperController.activeStep.value;
    LatLng? dest;
    if (step < 2) {
      dest = _rideData?['pickupCoordinates'] as LatLng?;
    } else {
      dest = _rideData?['dropoffCoordinates'] as LatLng?;
    }
    if (dest == null) return;

    // Clear polyline instantly so V-shape vanishes
    if (mounted) {
      setState(() {
        if (step < 2) {
          _routeCoordinates = [];
        } else {
          _driverToDropCoordinates = [];
        }
        _polylines = {};
      });
    }

    // Reset throttle timer so the re-fetch fires immediately
    _lastPolylineRefresh = DateTime.fromMillisecondsSinceEpoch(0);
    _fetchRouteFromDriverTo(dest, isPickup: step < 2);
  }

  /// Called on every animation frame to trim the polyline from the animated
  /// car position and conditionally re-fetch when driver goes off-route.
  void _updateDynamicPolyline() {
    if (!_isScreenActive || !mounted) return;
    // Use the animated position if available, fall back to raw GPS
    final carPos = _animatedDriverLocation ?? _driverLocation;
    if (carPos == null) return;

    final step = stepperController.activeStep.value;

    if (step < 2) {
      // State 1: Going to pickup
      if (_routeCoordinates.isNotEmpty) {
        _routeCoordinates = _trimPolylineToDriverPosition(
          _routeCoordinates,
          carPos,
        );
      }

      // Check if driver deviated from route - re-fetch if needed
      if (_routeCoordinates.isEmpty ||
          _isDriverOffRoute(_routeCoordinates, carPos)) {
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
          carPos,
        );
      }

      // Check if driver deviated from route - re-fetch if needed
      if (_driverToDropCoordinates.isEmpty ||
          _isDriverOffRoute(_driverToDropCoordinates, carPos)) {
        _throttledRefetchRoute(
          _rideData?['dropoffCoordinates'] as LatLng?,
          isPickup: false,
        );
      }
    }

    _updatePolylines();
    // Camera follow is handled once per GPS update in _animateMarkerTo,
    // NOT on every 16ms animation frame — avoids overriding the bounds fit.
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

      AppLogger.d(
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
            AppLogger.d('✅ Route re-fetched (${newCoordinates.length} points)');
          }
        }
      }
    } catch (e) {
      AppLogger.d('❌ Error re-fetching route: $e');
    } finally {
      _isFetchingDirections = false;
    }
  }

  // ==================== Markers (State-Aware) ====================

  void _setMarkers() {
    if (!_isScreenActive || !mounted) return;

    // Use animated position for the on-map icon; fall back to raw GPS
    final markerPos = _animatedDriverLocation ?? _driverLocation;

    final step = stepperController.activeStep.value;
    final newMarkers = <Marker>{};
    final newCircles = <Circle>{};

    // Always show driver marker at animated (interpolated) position
    if (markerPos != null && _bikeMarkerIcon != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: markerPos,
          icon: _bikeMarkerIcon!,
          anchor: const Offset(0.5, 0.5),
          rotation: _animatedHeading, // smooth interpolated bearing
          flat: true,
          infoWindow: const InfoWindow(title: "Your Location"),
          zIndex: 2,
        ),
      );

      newCircles.add(
        Circle(
          circleId: const CircleId('outer_shadow'),
          center: markerPos,
          radius: 140,
          fillColor: Colors.grey.withOpacity(0.25),
          strokeColor: Colors.transparent,
        ),
      );

      newCircles.add(
        Circle(
          circleId: const CircleId('inner_green'),
          center: markerPos,
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

    // Use animated position if available, else raw GPS
    final driverPos = _animatedDriverLocation ?? _driverLocation;
    if (driverPos != null) allPoints.add(driverPos);

    if (step < 2) {
      if (_rideData?['pickupCoordinates'] != null)
        allPoints.add(_rideData!['pickupCoordinates']);
    } else {
      if (_rideData?['dropoffCoordinates'] != null)
        allPoints.add(_rideData!['dropoffCoordinates']);
    }

    // Need at least 2 distinct points to make a valid bounds rectangle.
    // If GPS isn't ready yet, retry after the first location fix arrives.
    if (allPoints.length < 2) {
      AppLogger.d('⏳ _fitMapToAllMarkers: waiting for GPS — only ${allPoints.length} point(s)');
      return; // _setMarkers() will retry until _initialFitDone is true
    }

    // Safety: if both points are identical (driver AT pickup/drop), expand
    // bounds slightly so Google Maps doesn't crash with a zero-size rect.
    if (allPoints.first == allPoints.last) {
      allPoints.add(LatLng(allPoints.first.latitude + 0.002, allPoints.first.longitude + 0.002));
    }

    final bounds = _boundsFromLatLngList(allPoints);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_mapController != null && _isScreenActive && mounted) {
        try {
          _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 100),
          );
          _initialFitDone = true;
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

    AppLogger.d('📍 Detailed polyline has ${allPoints.length} points');
    return allPoints;
  }

  Future<void> _getDirections() async {
    if (_rideData?['pickupCoordinates'] == null) {
      AppLogger.d('⚠️ Cannot get directions: pickup coordinates missing');
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

        AppLogger.d('🛣️ Fetching route from driver to pickup...');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final route = data['routes'][0];
            _routeCoordinates = _getDetailedPolylineFromSteps(route);
            AppLogger.d(
              '🛣️ Route Driver → Pickup calculated (${_routeCoordinates.length} points)',
            );
          } else {
            AppLogger.d('⚠️ No routes found from driver to pickup');
          }
        } else {
          AppLogger.d('⚠️ Directions API error: ${response.statusCode}');
        }
      }

      if (mounted) {
        _updatePolylines();
      }
    } catch (e) {
      AppLogger.d('❌ Error fetching directions: $e');
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

    return Obx(() {
      // Force observable tracking even if the set is empty by accessing .length
      Get.find<GetCityByLocationController>().cityPolygons.length;

      return GoogleMap(
        polygons: Get.find<GetCityByLocationController>().cityPolygons.toSet(),
        onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        AppLogger.d('✅ Google Map created');

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
    });
  }

  Future<void> _navigateToOtpScreen() async {
    AppLogger.d('🔄 Navigating to OTP screen...');

    // Check if we have valid ride data
    if (_rideData == null) {
      AppLogger.d('❌ Cannot navigate to OTP: No ride data available');
      CustomToast.showError('Cannot navigate: No ride data');
      return;
    }

    final orderId = _rideData!['orderId'];
    if (orderId == null || orderId == 'N/A') {
      AppLogger.d('❌ Cannot navigate to OTP: Invalid order ID');
      CustomToast.showError('Invalid order ID');
      return;
    }

    // Pause location tracking
    await _pauseLocationTracking();

    AppLogger.d("📤 Sending ride data to OTP screen: $_rideData");

    // Navigate to OTP screen using GetX
    try {
      await Get.to(
        () => ArrivedOtpScreen(rideData: _rideData, imagepath: profileImage),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );

      AppLogger.d('↩️ Returned from OTP screen');
    } catch (e) {
      AppLogger.d('❌ Error navigating to OTP screen: $e');
      if (_isScreenActive && mounted) {
        CustomToast.showError('Failed to navigate to OTP');
        await _resumeLocationTracking(); // Resume tracking on error
      } 
    }
  }
  

  void _handleNavigation(NavigationCommand command) {
    if (!mounted || !_isScreenActive) return;

    switch (command.route) {
      case 'bottom_nav':
        AppLogger.d('[RIDE_FLOW] ArrivingClient → bottom_nav (cancel/complete)');
        Get.offAll(() => BottomnavmainScreen(isOnDuty: true));
        break;
      case 'arriving_screen':
        AppLogger.d('[RIDE_FLOW] ArrivingClient → OTP screen');
        _navigateToOtpScreen();
        break;
      case 'payment_screen':
        AppLogger.d('[RIDE_FLOW] ArrivingClient → payment_screen');
        Get.offAll(() => ReceivePaymentModes(
              rideData: command.arguments ?? widget.rideData,
            ));
        break;
      case 'arriving_client': // Already on arriving client screen
      case '': // Empty route meant for no navigation (e.g., Progress status)
        break;
      default:
        AppLogger.d('[RIDE_FLOW] ArrivingClient unknown route: ${command.route}');
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
        CustomToast.showWarning("Please complete the ride verification first");
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
    bool isRental = _rideData?['orderType'] == 'rental' || _rideData?['orderType'] == 'Rental';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * .03, vertical: w * .01),
      child: Column(
        children: [
          LocationInputTextfield(
            onPressed: () {},
            preffixImage: "assets/icons/greenDot.png",
            hintText: _rideData?['pickupLocation'] ?? 'Pickup location',
          ),
          if (!isRental) ...[
            SizedBox(height: w * .02),
            LocationInputTextfield(
              onPressed: () {},
              preffixImage: "assets/icons/redDot.png",
              hintText: _rideData?['dropLocation'] ?? 'Drop location',
            ),
          ],
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
            // SizedBox(height: w * .03),
            // const Text(
            //   "to pickup location",
            //   style: TextStyle(color: Colors.black54),
            // ),
            // SizedBox(height: w * .04),
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
                      AppLogger.d(
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
              AppLogger.d('[RIDE_FLOW] ArrivingClient "I\'ve Arrived" tapped → orderId=$orderId');
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
              CustomToast.showError('Invalid order ID');
            }
          },
        );

      case 1: // "Start Trip"
        return _buildLoadingButton(
          text: "Start Trip",
          isLoading: isStartTripLoading,
          color: const Color(0xFF26E3DD),
          textColor: Colors.black87,
          buttonId: 'start_trip_button',
          onTap: () {
            if (orderId != null && orderId.isNotEmpty) {
              AppLogger.d('[RIDE_FLOW] ArrivingClient "Start Trip" tapped → orderId=$orderId');
              orderUpdateController.updateOrder(
                context: context,
                buttonId: 'start_trip_button',
                orderStatus: "Progress",
                orderId: orderId,
                rideData: _rideData,
                stepControl: "Progress",
                successMessage: 'Trip started successfully',
                shouldTriggerNavigation: true,
              );
            } else {
              CustomToast.showError('Invalid order ID');
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
              AppLogger.d('[RIDE_FLOW] ArrivingClient "Complete" tapped → orderId=$orderId');
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
              CustomToast.showError('Invalid order ID');
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
      AppLogger.d('[RIDE_FLOW] ArrivingClient Cancel tapped → orderId=$orderId');
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
      CustomToast.showError("Invalid order ID");
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
