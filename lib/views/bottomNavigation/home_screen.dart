import 'dart:ui' as ui;
import 'dart:convert';
import 'package:corezap_driver/controllers/controllers.dart';
import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/map_helper.dart';
import 'package:corezap_driver/views/book_ride/book_ride.dart';
import 'package:corezap_driver/views/home_related/live_ride.dart';
import 'package:corezap_driver/views/widgets/home_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// Import the SocketManager
import 'package:corezap_driver/services/socket_manager.dart' hide LatLng;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.find<HomeController>();
  final StepperController stepperController = Get.find<StepperController>();

  // Socket Manager instance
  final SocketManager socketManager = SocketManager();

  // Ride request
  Map<String, dynamic>? _newRideRequest;
  bool _hasPendingRideRequest = false;

  // App lifecycle
  bool _appInBackground = false;

  // UI State
  String _selectedTab = "Driver";

  // Map variables
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(23.2508131, 77.4647936),
    zoom: 17,
  );
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  BitmapDescriptor? _bikeMarkerIcon;

  // Nearby riders/drivers
  List<Map<String, dynamic>> _nearbyRiders = [];
  Map<String, BitmapDescriptor> _vehicleIcons = {};

  @override
  void initState() {
    homeController.home_data_method();
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Request permissions
    await _requestPermissions();

    // Load custom icons
    await _loadCustomBikeMarker();
    await _loadVehicleIcons();

    // Initialize socket manager with callbacks
    _setupSocketCallbacks();

    // Start socket connection
    await socketManager.initialize();

    // Start location listener
    _startLocationListener();
  }

  void _setupSocketCallbacks() {
    socketManager.onNewRide = (rideData) {


           print("hellooooooooooooooooooo>>>>>>>>>>>>>>>>  11111111111111111111");

      _processRideRequest(rideData);
    };

    socketManager.onRideConfirmed = (rideData) {


     print("hellooooooooooooooooooo>>>>>>>>>>>>>>>>  222222222222222");
      _navigateToRideScreen(rideData);


    };

    socketManager.onRideCancelled = (data) {
      _showToast('Ride cancelled');
      _clearPendingRideRequest();
    };

    socketManager.onConnectionStatusChange = (isConnected) {
      if (mounted) {
        setState(() {});
      }
    };

    socketManager.onDriverStatusChange = (isOnline) {
      if (mounted) {
        setState(() {});

        if (isOnline) {
          _updateDriverMarker();
        } else {
          _removeBikeMarkerAndCircle();
        }
      }
    };
  }

  Future<void> _requestPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) return;

      final notificationStatus = await Permission.notification.request();
      if (notificationStatus.isGranted) {
        print('✅ Notification permission granted');
      }
    } catch (error) {
      print('❌ Error requesting permissions: $error');
    }
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

        // Update marker on map
        if (mounted && socketManager.isOnDuty) {
          _updateMarkerOnly(
            LatLng(position.latitude, position.longitude),
            position.accuracy,
          );
        }

        print(
          '📍 Location updated: ${position.latitude}, ${position.longitude}',
        );
      },
      onError: (error) {
        print('⚠️ Location error: $error');
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
    print('🚕 Processing ride request...');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RideRequestScreen(rideData: rideData),
      ),
    );
  }

  void _navigateToRideScreen(Map<String, dynamic> rideData) {
    // Clear pending request
    _clearPendingRideRequest();

    // Navigate to ride screen
    // Get.to(() => RideRequestScreen(rideData: rideData));
  }

  void _clearPendingRideRequest() {
    setState(() {
      _newRideRequest = null;
      _hasPendingRideRequest = false;
    });
  }

  void _toggleOnlineStatus() {
    if (socketManager.isOnDuty) {
      socketManager.goOffline();
    } else {
      socketManager.goOnline();
    }
  }

  void _showToast(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 App lifecycle changed: $state');

    setState(() {
      _appInBackground =
          state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive;
    });

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      default:
        break;
    }
  }

  void _onAppResumed() {
    print('📱 App resumed from background');

    if (_appInBackground) {
      _appInBackground = false;
    }
  }

  void _onAppPaused() {
    print('📱 App going to background');
    _appInBackground = true;
    _clearPendingRideRequest();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    socketManager.dispose();
    super.dispose();
  }

  Future<void> _loadCustomBikeMarker() async {
    try {
      _bikeMarkerIcon = await MapHelper.loadCustomIcon(
        assetPath: 'assets/images/bike2.png',
        width: 150,
        height: 150,
      );
      print('✅ Custom bike marker icon loaded');
    } catch (e) {
      print('❌ Error loading custom bike marker: $e');
      _bikeMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
    }
  }

  Future<void> _loadVehicleIcons() async {
    try {
      _vehicleIcons = await MapHelper.loadVehicleIcons(iconSize: 70);
      print('✅ Vehicle icons loaded');
    } catch (e) {
      print('❌ Error loading vehicle icons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return socketManager.isOnDuty == false
        ? _buildOfflineScreen(w)
        : _buildOnlineScreen(w);
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
                              CircleAvatar(
                                radius: w * 0.06,
                                backgroundImage: const AssetImage(
                                  'assets/images/home2.png',
                                ),
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
              Column(
                children: [
                  HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFF4CAF50),
                    width: double.infinity,
                    child: const Column(
                      children: [
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
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                        child: HomeScreenWidgets.elevatedBox(
                          shadowColor: const Color(0xFF7C7C8D),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w * 0.45,
                        child: HomeScreenWidgets.elevatedBox(
                          shadowColor: const Color(0xFF439AFE),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "50 / 45 Completed",
                                style: TextStyle(
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
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Rides",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF414142),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "50 / 05 Cancelled",
                                style: TextStyle(
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
              ),
              SizedBox(height: w * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineScreen(double w) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// 1️⃣ Google Map (BOTTOM)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: markers,
              circles: circles,
            ),

            /// 2️⃣ Book Ride Button (Top Right)
            Positioned(
              top: 16,
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
                    ? "assets/icons/dolleron.svg"
                    : "assets/icons/doller.png",
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
                children: const [
                  Text(
                    "Today's Earnings",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "₹1000.00",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      children: const [
                        Text(
                          "Online",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "₹500 Total",
                          style: TextStyle(fontWeight: FontWeight.w600),
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
                      children: const [
                        Text(
                          "Cash",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 1),
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
                  child: HomeScreenWidgets.elevatedBox(
                    shadowColor: const Color(0xFFF26061),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Rides",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 1),
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
              ],
            ),
          ],
        ),
      ],
    );
  }
}
