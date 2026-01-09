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
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
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
