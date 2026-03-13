import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/ride_screens/receive_payment_modes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // 1. Show splash screen for at least 2 seconds for better UX
    final splashDelay = Future.delayed(const Duration(seconds: 2));

    // 2. Request permissions and get initial position in parallel
    final locationFuture = _requestLocationAndCache();

    await Future.wait([splashDelay, locationFuture]);

    if (!mounted) return;

    await tokenbasednav();
  }

  Future<void> _requestLocationAndCache() async {
    try {
      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppLogger.d('⚠️ [Splash] Location services are disabled');
        return;
      }

      // 2. Check / request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        AppLogger.d('⚠️ [Splash] Location permission denied');
        return;
      }

      AppLogger.d('✅ [Splash] Location permission granted');

      // 3. Request notification permission (non-blocking)
      try {
        final notificationStatus = await Permission.notification.request();
        if (notificationStatus.isGranted) {
          AppLogger.d('✅ [Splash] Notification permission granted');
        }
      } catch (e) {
        AppLogger.d('⚠️ [Splash] Notification permission error: $e');
      }

      // 4. Get the current position (initial GPS fix)
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      AppLogger.d(
        '📍 [Splash] Got initial position: ${position.latitude}, ${position.longitude}',
      );

      // 5. Cache position in SharedPreferences for instant map loading on home screen
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('cached_latitude', position.latitude);
      await prefs.setDouble('cached_longitude', position.longitude);

      // 6. Also update SocketManager
      final socketManager = SocketManager();
      socketManager.updateLocation(position.latitude, position.longitude);

      AppLogger.d('✅ [Splash] Location cached and SocketManager updated');
    } catch (error) {
      AppLogger.d('❌ [Splash] Error during location initialization: $error');
    }
  }

  Future<void> tokenbasednav() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final bool wasOnline = prefs.getBool("driver_is_online") ?? false;

    AppLogger.d("splashtokennnn ${token}");
    AppLogger.d("splash online status: ${wasOnline}");

    if (!mounted) return;

    if (token != null) {
      final String? pendingPayment = prefs.getString("pending_payment_ride");

      if (pendingPayment != null && pendingPayment.isNotEmpty) {
        // User has a pending payment, navigate directly to payment screen
        final Map<String, dynamic> rideData = jsonDecode(pendingPayment);
        CustomNavigator.removeUntil(
          context,
          ReceivePaymentModes(rideData: rideData),
          transition: TransitionType.fade,
        );
        SocketManager().initialize();
      } else {
        // User is logged in, navigate to main screen
        CustomNavigator.removeUntil(
          context,
          BottomnavmainScreen(isOnDuty: wasOnline, isFirstLaunch: true),
          transition: TransitionType.fade,
        );

        // Check if a ride request arrived while the app was killed (from native socket service).
        // The native SocketForegroundService sets pending_ride_from_killed=true and stores
        // the ride JSON in last_ride_request. checkPendingRideFromKilledState() already
        // has a 1500ms internal delay so the home screen is fully rendered before navigation.
        SocketManager().checkPendingRideFromKilledState();
      }
    } else {
      // User is not logged in, navigate to login screen
      CustomNavigator.removeUntil(
        context,
        const LoginScreen(),
        transition: TransitionType.fade,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.08),

                      /// LOGO STACK
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo3.png',
                              width: w * 0.5,
                            ),
                            Positioned(
                              top: w * 0.13,
                              child: Image.asset(
                                'assets/images/logo4.png',
                                width: w * 0.25,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.02),

                      /// SECOND LOGO
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/logo6.png',
                          width: w * 0.6,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: h * 0.06),

                      /// TEXT SECTION
                      Column(
                        children: [
                          Text(
                            "Every journey made safer,every\n mile made better.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w * 0.06,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: h * 0.02),
                          Text(
                            "We take the wheel for your comfort.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w * 0.038,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Loading indicator at the bottom
            // Padding(
            //   padding: EdgeInsets.only(bottom: h * 0.05),
            //   child: const CircularProgressIndicator(
            //     color: AppColors.primaryblue,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
