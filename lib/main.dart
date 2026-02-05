import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/core/dependency_injection.dart';
import 'package:nzcu_driver/firebase_options.dart';
import 'package:nzcu_driver/services/notification_service.dart';
import 'package:nzcu_driver/utilities/colors.dart';
import 'package:nzcu_driver/views/splash/splash_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  print('📩 [Background] Message received: ${message.messageId}');

  // Use the singleton instance
  await NotificationService.instance.showNotificationInBackground(message);
}

void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  print('');
  print('=' * 60);
  print('🚀 NZCU DRIVER APP INITIALIZATION');
  print('=' * 60);

  try {
    print('1️⃣ Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('   ✅ Firebase Core initialized');

    print('2️⃣ Registering background message handler...');
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
    print('   ✅ Background handler registered');

    print('3️⃣ Configuring System UI...');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    print('   ✅ System UI configured');

    // ========================================================================
    // 4. DEPENDENCY INJECTION
    // ========================================================================
    print('4️⃣ Setting up Dependency Injection...');
    DependencyInjection.init();
    print('   ✅ Dependency Injection initialized');

    // ========================================================================
    // 5. NOTIFICATION SERVICE INITIALIZATION
    // ========================================================================
    print('5️⃣ Initializing Notification Service...');
    await NotificationService.instance.initialize();
    print('   ✅ Notification service initialized');

    // ========================================================================
    // 6. PRINT SUCCESS MESSAGE
    // ========================================================================
    print('');
    print('🎉 All services initialized successfully!');
    print('=' * 60);
    print('');
  } catch (e, stackTrace) {
    print('');
    print('❌ ERROR DURING INITIALIZATION ❌');
    print('Error: $e');
    print('Stack trace: $stackTrace');
    print('');
  }

  // ========================================================================
  // RUN THE APP
  // ========================================================================
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
        title: 'NZCU Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
