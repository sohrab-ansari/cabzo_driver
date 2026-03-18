import 'dart:async';
import 'package:nzcu_driver/controllers/home_controllers/controllers.dart';
import 'package:nzcu_driver/controllers/home_controllers/driver_toggle_duty_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/map_helper.dart';
import 'package:nzcu_driver/views/ride_screens/book_ride.dart';
import 'package:nzcu_driver/views/Homeviewscreens/Agreement_screen.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';
import 'package:nzcu_driver/utilities/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the SocketManager
import 'package:nzcu_driver/services/apiservices/socket_manager.dart'
    hide LatLng;
import 'package:nzcu_driver/services/background_service.dart';
import 'package:nzcu_driver/services/overlay_service.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';

class HomeScreen extends StatefulWidget {
  final bool? isOnDuty;
  final bool isFirstLaunch;
  HomeScreen({super.key, this.isOnDuty = false, this.isFirstLaunch = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.find<HomeController>();

  final DriverToggleDutyController driverToggleDutyController =
      Get.find<DriverToggleDutyController>();

  final StepperController stepperController = Get.find<StepperController>();

  final DriveridController driveridController = Get.put(DriveridController());

  // Socket Manager instance
  final SocketManager socketManager = SocketManager();

  // Keep references so we can safely unregister on dispose.
  Function(Map<String, dynamic>)? _onNewRideCb;
  Function(Map<String, dynamic>)? _onRideConfirmedCb;
  Function(Map<String, dynamic>)? _onRideCancelledCb;
  Function(bool)? _onConnectionStatusCb;
  Function(bool)? _onDriverStatusCb;

  // Ride request
  Map<String, dynamic>? _newRideRequest;
  bool _hasPendingRideRequest = false;

  // App lifecycle
  Timer? _heartbeatTimer;

  // UI State
  String _selectedTab = "Driver";
  bool _isEffectiveFirstLaunch = false;

  // Map variables
  CameraPosition get _initialCameraPosition {
    // 1. Try SocketManager (most recent)
    if (socketManager.currentLatitude != 0.0 &&
        socketManager.currentLongitude != 0.0) {
      return CameraPosition(
        target: LatLng(
          socketManager.currentLatitude - 0.0015,
          socketManager.currentLongitude,
        ),
        zoom: 17,
      );
    }
    // 2. Default fallback
    return const CameraPosition(
      target: LatLng(23.2508131, 77.4647936),
      zoom: 17,
    );
  }

  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  BitmapDescriptor? _bikeMarkerIcon;

  // Nearby riders/drivers
  List<Map<String, dynamic>> _nearbyRiders = [];
  Map<String, BitmapDescriptor> _vehicleIcons = {};

  String? driverName;

  dynamic profileimage;
  @override
  void initState() {
    super.initState(); // Call super first

    _isEffectiveFirstLaunch = widget.isFirstLaunch;

    handleonline();
    homeController.home_data_method();
    driveridController.driverid_mdethod();
    // driverToggleDutyController.driver_toggle_method();

    WidgetsBinding.instance.addObserver(
      this,
    ); // Lifecycle observer for background sync
    _initializeApp();
    sharedpreferences();

    // Start heartbeat timer — tells BG isolate the main app is alive
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      BackgroundService.sendHeartbeat();
    });
    // Notify background service we are in foreground
    BackgroundService.notifyAppState('Foreground');

    // Ensure build is called after state is set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> sharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      driverName = prefs.getString("driver_name");

      profileimage = prefs.getString("driver_image");
    });
  }

  void handleonline() {
    // If SocketManager already has a connected/restored state, we should NOT
    // overwrite it with `widget.isOnDuty` because `widget.isOnDuty` might be
    // stale from BottomNavMainScreen when switching tabs.
    // We only use `widget.isOnDuty` if it's true and we need to force it,
    // or if we're completely uninitialized.
    if (widget.isOnDuty == true && !socketManager.isOnDuty) {
      socketManager.isOnDuty = true;
    } else if (widget.isOnDuty == false && socketManager.isOnDuty) {
      // Avoid forcing offline if user manually went online and switched tabs
    }

    if (socketManager.isOnDuty) {
      _updateDriverMarker();
    }
  }

  Future<void> _initializeApp() async {
    // Redundant permission request removed - handled by LocationGuard globally

    // Load custom icons
    await _loadCustomBikeMarker();
    await _loadVehicleIcons();

    // Start socket callbacks
    _setupSocketCallbacks();

    // End loading state early to show the UI as soon as icons/basic data are ready
    if (mounted) {
      setState(() {
        _isEffectiveFirstLaunch = false;
      });
    }

    // Initialize socket manager in background (don't await to unblock UI)
    socketManager.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _updateDriverMarker();
      }
      // Check if there's a pending ride request from killed state
      // (native Kotlin service received ride while app was dead)
      socketManager.checkPendingRideFromKilledState();
    });

    // Start location listener
    _startLocationListener();
  }

  void _setupSocketCallbacks() {
    _onNewRideCb = (rideData) {
      AppLogger.d(
        "hellooooooooooooooooooo>>>>>>>>>>>>>>>>  11111111111111111111",
      );

      _processRideRequest(rideData);
    };
    socketManager.onNewRide = _onNewRideCb;

    _onRideConfirmedCb = (rideData) {
      _navigateToRideScreen(rideData);
    };
    socketManager.onRideConfirmed = _onRideConfirmedCb;

    _onRideCancelledCb = (data) {
      CustomToast.showError('Ride cancelled');
      _clearPendingRideRequest();
    };
    socketManager.onRideCancelled = _onRideCancelledCb;

    _onConnectionStatusCb = (isConnected) {
      if (mounted) {
        setState(() {
          if (isConnected) {
            _isEffectiveFirstLaunch = false;
          }
        });
      }
    };
    socketManager.onConnectionStatusChange = _onConnectionStatusCb;

    _onDriverStatusCb = (isOnline) {
      if (mounted) {
        setState(() {});

        if (isOnline) {
          _updateDriverMarker();
        } else {
          _removeBikeMarkerAndCircle();
        }
      }
    };
    socketManager.onDriverStatusChange = _onDriverStatusCb;
  }

  void _startLocationListener() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen(
      (position) {
        // Update socket manager with new location
        socketManager.updateLocation(position.latitude, position.longitude);

        // Fetch city polygon
        Get.find<GetCityByLocationController>().getCityByLocation(
          lat: position.latitude.toString(),
          lng: position.longitude.toString(),
        );

        // Fetch city polygon
        Get.find<GetCityByLocationController>().getCityByLocation(
          lat: position.latitude.toString(),
          lng: position.longitude.toString(),
        );

        // Update marker on map
        if (mounted && socketManager.isOnDuty) {
          _updateMarkerOnly(
            LatLng(position.latitude, position.longitude),
            position.accuracy,
          );
        }
      },
      onError: (error) {
        AppLogger.d('⚠️ HomeScreen location error: $error');
      },
    );
  }

  void _updateMarkerOnly(LatLng location, double accuracy) {
    if (!mounted) return;

    setState(() {
      markers.clear();
      circles.clear();

      // Bike marker
      markers.add(
        Marker(
          markerId: const MarkerId('driver_location'),
          position: location,
          icon:
              _bikeMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
          zIndex: 2,
        ),
      );

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

  void _updateDriverMarker() {
    if (socketManager.currentLatitude != 0.0 &&
        socketManager.currentLongitude != 0.0) {
      _updateMarkerOnly(
        LatLng(socketManager.currentLatitude, socketManager.currentLongitude),
        50.0,
      );
    }
  }

  void _removeBikeMarkerAndCircle() {
    setState(() {
      markers.clear();
      circles.clear();
    });
  }

  void _processRideRequest(Map<String, dynamic> rideData) {
    if (!mounted) return;
    AppLogger.d('🚕 Processing ride request... in home screen..');

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => RideRequestScreen(rideData: rideData),
    //   ),
    // );
  }

  void _navigateToRideScreen(Map<String, dynamic> rideData) {
    // Clear pending request
    _clearPendingRideRequest();

    // Navigate to ArrivingClient screen
    Get.to(() => ArrivingClient(rideData: rideData, typeCheck: false));
  }

  void _clearPendingRideRequest() {
    if (!mounted) return;
    setState(() {
      _newRideRequest = null;
      _hasPendingRideRequest = false;
    });
  }

  void _toggleOnlineStatus() async {
    if (socketManager.isOnDuty) {
      OverlayService.instance.hideOverlay();
      socketManager.goOffline();
    } else {
      // Request overlay permission before going online (one-time prompt)
      final hasOverlayPermission = await OverlayService.instance
          .hasPermission();
      if (!hasOverlayPermission) {
        await OverlayService.instance.requestPermission();
      }

      socketManager.goOnline();
    }
  }

  // ==================== APP LIFECYCLE (Background Sync) ====================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is going to background (minimized)
      AppLogger.d('⏸️ [HomeScreen] App moved to BACKGROUND');
      BackgroundService.notifyAppState('Background');

      // If driver is online, ensure background service is running
      if (socketManager.isOnDuty) {
        _ensureBackgroundServiceRunning();
      }
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground
      AppLogger.d('▶️ [HomeScreen] App moved to FOREGROUND');
      BackgroundService.notifyAppState('Foreground');
      BackgroundService.sendHeartbeat();

      // Re-sync state from SharedPreferences (background may have changed things)
      _syncStateFromBackground();

      // Process any Accept/Decline tapped on notification while app was in background
      // Pending actions are now handled uniformly inside SocketManager
    }
  }

  /// Ensure foreground task is running when app goes to background
  Future<void> _ensureBackgroundServiceRunning() async {
    if (socketManager.isOnDuty) {
      AppLogger.d(
        '🚀 [HomeScreen] Ensuring online status (Native Service handled by SocketManager)...',
      );
      // socketManager.goOnline(); // Optional: idempotent call
    }
  }

  /// Re-sync SocketManager state when app comes back to foreground
  Future<void> _syncStateFromBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if ride state changed while in background
      final bgRideInProgress = prefs.getBool("is_ride_in_progress") ?? false;
      final bgActiveRideId = prefs.getString("active_ride_id") ?? "";

      AppLogger.d('🔄 [HomeScreen] Syncing from background:');
      AppLogger.d('   - Ride in progress: $bgRideInProgress');
      AppLogger.d('   - Active ride ID: $bgActiveRideId');

      // Refresh vehicle data (may have been updated)
      await socketManager.refreshVehicleData();

      if (socketManager.isOnDuty) {
        // Ensure foreground task is handled by SocketManager
        // if (!socketManager.isNativeServiceRunning) { ... } // internal logic

        // Restart location watch if it was killed by the OS
        socketManager.startLocationWatch();

        // Ensure socket is still connected (reconnect if needed)
        if (!socketManager.isSocketConnected) {
          AppLogger.d(
            '🔌 [HomeScreen] Socket disconnected while in bg, reconnecting...',
          );
          await socketManager.connectSocket();

          // Re-emit online status after reconnect
          if (socketManager.isSocketConnected) {
            await socketManager.goOnline();
          }
        }
      }

      // Refresh UI
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      AppLogger.d('⚠️ [HomeScreen] Error syncing from background: $e');
    }
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    // IMPORTANT: HomeScreen is not always the active screen.
    // If we keep these callbacks set after disposal, SocketManager will retain
    // a reference to this State and can call setState after dispose().
    if (socketManager.onNewRide == _onNewRideCb) socketManager.onNewRide = null;
    if (socketManager.onRideConfirmed == _onRideConfirmedCb) {
      socketManager.onRideConfirmed = null;
    }
    if (socketManager.onRideCancelled == _onRideCancelledCb) {
      socketManager.onRideCancelled = null;
    }
    if (socketManager.onConnectionStatusChange == _onConnectionStatusCb) {
      socketManager.onConnectionStatusChange = null;
    }
    if (socketManager.onDriverStatusChange == _onDriverStatusCb) {
      socketManager.onDriverStatusChange = null;
    }

    // ❌ DON'T dispose SocketManager here - it's a singleton used across the app
    // Only remove the observer and cleanup local resources
    // socketManager.dispose() should only be called on app logout
    super.dispose();
  }

  Future<void> _loadCustomBikeMarker() async {
    try {
      _bikeMarkerIcon = await MapHelper.loadCustomIcon(
        assetPath: 'assets/images/bike2.png',
        width: 150,
        height: 150,
      );
      AppLogger.d('✅ Custom bike marker icon loaded');
    } catch (e) {
      AppLogger.d('❌ Error loading custom bike marker: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }
  }

  Future<void> _loadVehicleIcons() async {
    try {
      _vehicleIcons = await MapHelper.loadVehicleIcons(iconSize: 70);
      AppLogger.d('✅ Vehicle icons loaded');
    } catch (e) {
      AppLogger.d('❌ Error loading vehicle icons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    AppLogger.d("hellllllll discoonect22 ${socketManager.isSocketConnected}");
    AppLogger.d("hellllllll discoonect33333 ${widget.isFirstLaunch}");
    // Show loading screen only while basic initialization (icons/permissions) is happening
    if (_isEffectiveFirstLaunch) {
      return _buildLoadingScreen();
    }

    // We removed the socketManager.isRestorationInProgress condition here
    // to prevent the loading screen from hanging if the network is slow/socket fails.
    // The UI will update automatically once restoration finishes and status changes.

    return socketManager.isOnDuty == false
        ? _buildOfflineScreen(w)
        : _buildOnlineScreen(w, widget.isFirstLaunch);
  }

  /// Loading screen shown during app startup while restoring online status
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Loading spinner
            // const CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            //   strokeWidth: 3,
            // ),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineScreen(double w) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w * .300),
        child:
            Container(
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
                              // CircleAvatar(
                              //   radius: w * 0.06,
                              //   backgroundImage: const AssetImage(
                              //     'assets/images/home2.png',
                              //   ),
                              // ),
                              CircleAvatar(
                                radius: w * 0.06,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: profileimage != null
                                    ? NetworkImage(
                                        ApiPath.imagebaseUrl + profileimage,
                                      )
                                    : null,
                                child: profileimage == null
                                    ? Icon(Icons.person, size: w * .08)
                                    : null,
                              ),
                              SizedBox(width: w * 0.03),

                              // AppFonts.textPoppins(
                              //   context,
                              //   "Ayaan Malviya ${driverName}",
                              //   w * 0.05,
                              //   FontWeight.w600,
                              //   AppColors.black,
                              //   TextAlign.left,
                              //   TextOverflow.visible,
                              // ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppFonts.textPoppins(
                                    context,
                                    driverName ?? "",
                                    w * 0.05,
                                    FontWeight.w600,
                                    AppColors.black,
                                    TextAlign.left,
                                    TextOverflow.visible,
                                  ),

                                  AppFonts.textPoppins(
                                    context,
                                    "Driver",
                                    w * 0.03,
                                    FontWeight.w600,
                                    AppColors.darkGray,
                                    TextAlign.left,
                                    TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: w * 0.01),
                              GestureDetector(
                                onTap: socketManager.isProcessingOnline
                                    ? null
                                    : _toggleOnlineStatus,
                                child: Container(
                                  width: w * 0.26,
                                  height: w * 0.10,
                                  decoration: BoxDecoration(
                                    color: socketManager.isOnDuty
                                        ? const Color(0xFF34C759)
                                        : const Color(0xFFF26061),
                                    borderRadius: BorderRadius.circular(
                                      w * 0.06,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: socketManager.isProcessingOnline
                                      ? SizedBox(
                                          width: w * 0.04,
                                          height: w * 0.04,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Text(
                                          socketManager.isOnDuty
                                              ? 'Online'
                                              : 'Offline',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.032,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
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
              SizedBox(height: w * 0.04),
              Image.asset("assets/images/offline_image.png", height: w * 0.5),
              Text(
                socketManager.isOnDuty ? "You're Online" : "You're Offline",
                style: TextStyle(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.bold,
                  color: socketManager.isOnDuty ? Colors.green : Colors.black,
                ),
              ),
              Text(
                socketManager.isOnDuty
                    ? "Ready to accept rides!"
                    : "Go online to start accepting rides.",
                style: const TextStyle(
                  color: Color(0xFF5F6165),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: w * 0.04),
              ElevatedButton(
                onPressed: socketManager.isProcessingOnline
                    ? null
                    : _toggleOnlineStatus,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: socketManager.isOnDuty
                      ? const Color(0xFFF26061)
                      : const Color(0xFF34C759),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: socketManager.isProcessingOnline
                    ? SizedBox(
                        width: w * 0.04,
                        height: w * 0.04,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        socketManager.isOnDuty ? "Go Offline" : "Go Online",
                        style: TextStyle(
                          fontSize: w * 0.04,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(height: w * 0.03),

              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                            size: 24.0,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Driver Agreement View',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Please View your driver driver agreement to continue accepting rides.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      color: Colors.grey[50],
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AgreementScreen(),
                                  ),
                                );
                              },
                              child: const Text('Continue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Text("dhjshafj"),

              //  KYCNoticeCardWidget(isKycCompleted: true,

              // onContinuePressed: (){
              //   AppLogger.d("Continue Pressed");

              // },
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child:
                    AppFonts.textPoppins(
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
              SizedBox(height: w * 0.04),

              Obx(() {
                final homeData = homeController.homemodalresponse.value;
                final earnings = homeData?.todayStats?.earnings;
                final rides = homeData?.todayStats?.rides;

                String formatCurrency(double? amount) {
                  return '₹${(amount ?? 0).toStringAsFixed(0)}';
                }

                return Column(
                  children: [
                    HomeScreenWidgets.elevatedBox(
                      shadowColor: const Color(0xFF4CAF50),
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text(
                            "Today's Earnings",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF414142),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatCurrency(earnings?.total),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: w * 0.45,
                          child: HomeScreenWidgets.elevatedBox(
                            shadowColor: const Color(0xFFFEBC2F),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Online",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF414142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${formatCurrency(earnings?.online)} Total",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        SizedBox(
                          width: w * 0.45,
                          child: HomeScreenWidgets.elevatedBox(
                            shadowColor: const Color(0xFF7C7C8D),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Cash",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF414142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${formatCurrency(earnings?.cash)} On Hand",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: w * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: w * 0.45,
                          child: HomeScreenWidgets.elevatedBox(
                            shadowColor: const Color(0xFF439AFE),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total Rides",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF414142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${rides?.total ?? 0} / ${rides?.completed ?? 0} Completed",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.02),
                        SizedBox(
                          width: w * 0.45,
                          child: HomeScreenWidgets.elevatedBox(
                            shadowColor: const Color(0xFFF26061),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Cancelled",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF414142),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${rides?.total ?? 0} / ${rides?.cancelled ?? 0} Cancelled",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: w * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineScreen(double w, isFirstLaunc) {
    return Scaffold(
      body: SafeArea(
        top: false,
        top: false,
        child: Stack(
          children: [
            /// 1️⃣ Google Map (BOTTOM)
            Obx(
              () => GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                polygons: Get.find<GetCityByLocationController>().cityPolygons
                    .toSet(),
                onMapCreated: (controller) {
                  _mapController = controller;
            Obx(
              () => GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                polygons: Get.find<GetCityByLocationController>().cityPolygons
                    .toSet(),
                onMapCreated: (controller) {
                  _mapController = controller;

                  // Immediately move camera if we have location
                  if (socketManager.currentLatitude != 0.0 &&
                      socketManager.currentLongitude != 0.0) {
                    controller.moveCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          socketManager.currentLatitude - 0.0015,
                          socketManager.currentLongitude,
                        ),
                      ),
                    );
                  }
                },
                markers: markers,
                circles: circles,
              ),
                  // Immediately move camera if we have location
                  if (socketManager.currentLatitude != 0.0 &&
                      socketManager.currentLongitude != 0.0) {
                    controller.moveCamera(
                      CameraUpdate.newLatLng(
                        LatLng(
                          socketManager.currentLatitude - 0.0015,
                          socketManager.currentLongitude,
                        ),
                      ),
                    );
                  }
                },
                markers: markers,
                circles: circles,
              ),
            ),

            /// 2️⃣ Book Ride Button (Top Right)
            Positioned(
              top: 32,
              top: 32,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const BookRide());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  elevation: 4,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Book Ride",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            /// 3️⃣ Bottom Offline Card (FIRST)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _bottomOfflineCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomOfflineCard() {
    double w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 200),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Driver & Earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeScreenWidgets.topAction(
                icon: _selectedTab == "Driver"
                    ? "assets/icons/drive.png"
                    : "assets/icons/driveoff.svg",
                label: "Driver",
                onTap: () {
                  setState(() {
                    _selectedTab = "Driver";
                  });
                },
                isSelected: _selectedTab == "Driver",
              ),
              SizedBox(width: w * 0.25),
              HomeScreenWidgets.topAction(
                icon: _selectedTab == "Earnings"
                    ? "assets/icons/mynaui_rupee_grey.png"
                    : "assets/icons/mynaui_rupee_bold.png",
                label: "Earnings",
                onTap: () {
                  setState(() {
                    _selectedTab = "Earnings";
                  });
                },
                isSelected: _selectedTab == "Earnings",
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Conditional Content
          if (_selectedTab == "Driver")
            _driverContent()
          else
            _earningsContent(),
        ],
      ),
    );
  }

  Widget _driverContent() {
    return Column(
      children: [
        /// Offline Image
        Image.asset("assets/images/onlinee.png", height: 120),

        const SizedBox(height: 12),

        const Text(
          "You're Online",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        const Text(
          "Go offline to stop accepting rides.",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        /// Go Online Button (Bottom)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              socketManager.goOffline();

              // driverToggleDutyController.driver_toggle_method();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Go Offline",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Earnings Content
  Widget _earningsContent() {
    double w = MediaQuery.of(context).size.width;
    return Obx(() {
      final homeData = homeController.homemodalresponse.value;
      final earnings = homeData?.todayStats?.earnings;
      final rides = homeData?.todayStats?.rides;

      AppLogger.d("myyyy_dattatt  ${earnings?.total}");
      // Format currency
      String formatCurrency(double? amount) {
        return '₹${(amount ?? 0).toStringAsFixed(0)}';
      }

      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child:
                AppFonts.textPoppins(
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
          SizedBox(height: w * 0.02),

          Column(
            children: [
              /// Today's Earnings (Full Width)
              HomeScreenWidgets.elevatedBox(
                width: double.infinity,
                shadowColor: const Color(0xFF4CAF50),
                child: Column(
                  children: [
                    const Text(
                      "Today's Earnings",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      formatCurrency(earnings?.total),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: w * 0.02),

              /// Online & Cash
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: w * 0.4,
                    child: HomeScreenWidgets.elevatedBox(
                      shadowColor: const Color(0xFFFEBC2F),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Online",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "${formatCurrency(earnings?.online)} Total",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.01),
                  SizedBox(
                    width: w * 0.45,
                    child: HomeScreenWidgets.elevatedBox(
                      shadowColor: const Color(0xFF7C7C8D),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cash",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            "${formatCurrency(earnings?.cash)} On Hand",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: w * 0.02),

              /// Ride Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: w * 0.4,
                    child: HomeScreenWidgets.elevatedBox(
                      shadowColor: const Color(0xFF439AFE),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Rides",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 1),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${rides?.total ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " / ${rides?.completed ?? 0} Completed",
                                  style: const TextStyle(
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
                    child: HomeScreenWidgets.elevatedBox(
                      shadowColor: const Color(0xFFF26061),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cancelled",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 1),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${rides?.total ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: " / ${rides?.cancelled ?? 0} Cancelled",
                                  style: const TextStyle(
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
        ],
      );
    });
  }
}

class KYCNoticeWidget extends StatelessWidget {
  final bool isKycCompleted;
  final VoidCallback onContinuePressed;

  const KYCNoticeWidget({
    Key? key,
    required this.isKycCompleted,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isKycCompleted) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Agreement Box
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Icon
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
          ),

          // Button Section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinuePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button background color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative version using a Card widget
class KYCNoticeCardWidget extends StatelessWidget {
  final bool isKycCompleted;
  final VoidCallback onContinuePressed;

  const KYCNoticeCardWidget({
    Key? key,
    required this.isKycCompleted,
    required this.onContinuePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isKycCompleted) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 24.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver Agreement Required',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Please upload and e-sign your driver agreement to continue accepting rides.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinuePressed,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Usage example
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Dashboard')),
      body: Column(
        children: [
          // Other widgets here...
          KYCNoticeWidget(
            isKycCompleted: false, // This would come from your state
            onContinuePressed: () {
              // Navigate to Agreement screen
              Navigator.pushNamed(context, '/agreement');
            },
          ),

          // More widgets...
        ],
      ),
    );
  }
}
