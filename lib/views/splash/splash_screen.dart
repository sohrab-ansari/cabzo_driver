import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:nzcu_driver/controllers/profile_controllers/driverid_controller.dart';
import 'package:nzcu_driver/services/socket_manager.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/auth/login_screen.dart';
import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:nzcu_driver/views/bottomNavigation/home_screen.dart';
import 'package:nzcu_driver/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //  final DriveridController driveridController = Get.put(DriveridController());
  @override
  void initState() {
    super.initState();

    //  driveridController.driverid_mdethod();

    // _initializeApp();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      CustomNavigator.removeUntil(
        context,
        const LoginScreen(),
        transition: TransitionType.fade,
      );
    });

    tokenbasednav();
  }
  //   // Socket Manager instance
  // final SocketManager socketManager = SocketManager();

  //   Future<void> _initializeApp() async {
  //   // Request permissions
  //   // await _requestPermissions();

  //   // // Load custom icons
  //   // await _loadCustomBikeMarker();
  //   // await _loadVehicleIcons();

  //   // // Initialize socket manager with callbacks
  //   // _setupSocketCallbacks();

  //   // Start socket connection
  //   // final DriveridController driveridController = Get.put(DriveridController());

  //   await socketManager.initialize();

  //   // Start location listener
  //   // _startLocationListener();
  // }

  Future<void> tokenbasednav() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final bool wasOnline = prefs.getBool("driver_is_online") ?? false;

    print("splashtokennnn ${token}");
    print("splash online status: ${wasOnline}");

    if (token != null) {
      //  final SocketManager socketManager = SocketManager();
      CustomNavigator.removeUntil(
        context,
        BottomnavmainScreen(isOnDuty: wasOnline, isFirstLaunch: true),
        transition: TransitionType.fade,
      );
    } else {
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
                      Image.asset('assets/images/logo3.png', width: w * 0.5),
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
                        fontSize: w * 0.06, // responsive text
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
    );
  }
}
