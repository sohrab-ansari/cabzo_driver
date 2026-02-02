import 'dart:ui' as ui;
import 'dart:convert';
import 'package:corezap_driver/controllers/controllers.dart';
import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/utilities/custom_font.dart';
import 'package:corezap_driver/utilities/map_helper.dart';
import 'package:corezap_driver/views/book_ride/book_ride.dart';
import 'package:corezap_driver/views/bottomNavigation/Agreement_screen.dart';
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
   final bool? isOnDuty;
   final bool isFirstLaunch;
   HomeScreen({super.key, this.isOnDuty = false, this.isFirstLaunch = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Controllers controllers = Get.put(Controllers());
  final HomeController homeController = Get.find<HomeController>();
  final StepperController stepperController = Get.find<StepperController>();

    final DriveridController driveridController = Get.put(DriveridController());

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

String? driverName;
  @override
  void initState() {
    super.initState(); // Call super first
    
    // handleonline();
    homeController.home_data_method();
    driveridController.driverid_mdethod();

    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
    sharedpreferences();
    
    // Ensure build is called after state is set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Future<void> sharedpreferences() async {
    final prefs = await SharedPreferences.getInstance();
    

     setState(() {
        driverName = prefs.getString("driver_name");
     });
    print("Driver Name from SharedPreferences: $driverName");
  }


  void handleonline () {
    print("online status in home screen is ::::::::::::::::::::::::::: ${widget.isOnDuty}");
    
    // Set socketManager status based on widget parameter
    if(widget.isOnDuty == true){
      socketManager.isOnDuty = true;
      print("✅ Driver set to ONLINE");
    } else {
      socketManager.isOnDuty = false;
      print("🔴 Driver set to OFFLINE");
    }
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
      
      // ✅ FIX: Restore online status after app restart
      _restoreOnlineStatusAfterResume();
    }
  }

  /// Restore online status if driver was online before app was paused/restarted
  Future<void> _restoreOnlineStatusAfterResume() async {
    print('🔄 Checking if driver was online before pause...');
    
    try {
      // Wait a moment for socket to stabilize
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Try to restore online status
      // await socketManager.restoreOnlineStatus();
    } catch (error) {
      print('❌ Error restoring online status after resume: $error');
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

    // Show loading screen only while restoration is in progress (app startup)
    if (socketManager.isRestorationInProgress) {
      return _buildLoadingScreen();
    }

    return socketManager.isOnDuty == false
        ? _buildOfflineScreen(w)
        : _buildOnlineScreen(w);
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
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3,
            ),
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
                              CircleAvatar(
                                radius: w * 0.06,
                                backgroundImage: const AssetImage(
                                  'assets/images/home2.png',
                                ),
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

                                AppFonts.textPoppins(
                                context,
                                "${driverName}",
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
      body:
      
       SingleChildScrollView(
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            color: Colors.grey[50],
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){


Navigator.push(context, MaterialPageRoute(builder: (context) => AgreementScreen()));
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
              //   print("Continue Pressed");

                
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
                                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                                  style: const TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildOnlineScreen(double w) {
    return Scaffold(
      body:
      
       SafeArea(
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
    return Obx(() {
      final homeData = homeController.homemodalresponse.value;
      final earnings = homeData?.todayStats?.earnings;
      final rides = homeData?.todayStats?.rides;


   print("myyyy_dattatt  ${earnings?.total}");
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
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                // Text Content
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Driver Agreement Required',
                //         style: TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.grey[800],
                //         ),
                //       ),
                //       const SizedBox(height: 4.0),
                //       Text(
                //         'Please upload and e-sign your driver agreement to continue accepting rides.',
                //         style: TextStyle(
                //           fontSize: 14.0,
                //           color: Colors.grey[600],
                //           height: 1.4,
                //         ),
                //       ),
                //     ],
                //   ),

                //     Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Driver Agreement View',
                //         style: TextStyle(
                //           fontSize: 16.0,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.grey[800],
                //         ),
                //       ),
                //       const SizedBox(height: 4.0),
                //       Text(
                //         'Please View your driver driver agreement to continue accepting rides.',
                //         style: TextStyle(
                //           fontSize: 14.0,
                //           color: Colors.grey[600],
                //           height: 1.4,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          
          // Button Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
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

    return 
    
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
                        'Driver Agreement Required',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
      ),
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