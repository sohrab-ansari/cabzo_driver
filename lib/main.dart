import 'package:corezap_driver/AppPreferences/device_id_service.dart';
import 'package:corezap_driver/AppPreferences/fcm_token_service.dart';
import 'package:corezap_driver/AppPreferences/shared_pref_service.dart';
import 'package:corezap_driver/apis/auth.api.dart';
import 'package:corezap_driver/controller/login.controller.dart';
import 'package:corezap_driver/controller/otp_controller.dart';
import 'package:corezap_driver/controller/signup_controller.dart';
import 'package:corezap_driver/controller/stepper_controller.dart';
import 'package:corezap_driver/utilities/colors.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/home_maps_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/profile_screen.dart';
import 'package:corezap_driver/views/onboarding/onboarding_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/faq_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/faqs_details_screen.dart';
import 'package:corezap_driver/views/profile_related.dart/notification_screen.dart';
import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
import 'package:corezap_driver/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main()   async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

    // await SharedPrefService.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: GetMaterialApp(
        title: 'Nzcu Driver',
        debugShowCheckedModeBanner: false,
        initialBinding: AppBindings(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
        ),
        home: const SplashScreen(),

        // home: BottomnavmainScreen(),

        // home: NotificationScreen(),

            // home: const ArrivedOtpScreen(),
      ),
    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => AuthApi(), fenix: true);
    // Get.lazyPut(() => SignupController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => DriverFormController(), fenix: true);
    // Get.lazyPut(() => OtpController(), fenix: true);
    Get.lazyPut(() => DeviceIdService(), fenix: true);
    Get.lazyPut(() => FcmTokenService(), fenix: true);
  }
}