import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/network_controller.dart';
import 'package:nzcu_driver/core/dependency_injection.dart';
import 'package:nzcu_driver/firebase_options.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/services/overlay_service.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';
import 'package:nzcu_driver/ui/screens/overlay_bubble.dart';

import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:nzcu_driver/controllers/chart_id_controller/chat_notification_controller.dart';
import 'package:nzcu_driver/utilities/widgets/network_status_overlay.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';
import 'package:nzcu_driver/utilities/widgets/location_guard.dart';
import 'package:nzcu_driver/views/splash/splash_screen.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  // IMPORTANT: Firebase must be initialized in background isolate
  // Background handlers run in a separate Dart isolate where Firebase is NOT initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLogger.d('>>>>>> [Background] Message received: ${message.messageId}');

  // Use the singleton instance------
  await NotificationService.instance.showNotificationInBackground(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.d('=' * 60);
  AppLogger.d('🚀 NZCU DRIVER APP INITIALIZATION');
  AppLogger.d('=' * 60);

  try {
    AppLogger.d('1️⃣ Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.d('   ✅ Firebase Core initialized');

    AppLogger.d('2️⃣ Registering background message handler...');
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
    AppLogger.d('   ✅ Background handler registered');

    AppLogger.d('3️⃣ Configuring System UI...');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
    AppLogger.d('   ✅ System UI configured');

    // ========================================================================
    // 4. DEPENDENCY INJECTION
    // ========================================================================
    AppLogger.d('4️⃣ Setting up Dependency Injection...');
    DependencyInjection.init();
    AppLogger.d('   ✅ Dependency Injection initialized');

    // ========================================================================
    // 5. NOTIFICATION SERVICE INITIALIZATION
    // ========================================================================
    // AppLogger.d('5️⃣ Initializing Notification Service...');
    // await NotificationService.instance.initialize();
    // AppLogger.d('   ✅ Notification service initialized');

    // ========================================================================
    // 6. PRINT SUCCESS MESSAGE
    // ========================================================================
    AppLogger.d('🎉 All services initialized successfully!');
    AppLogger.d('=' * 60);
    AppLogger.d('');

    // ========================================================================
    // 8. RIDE NOTIFICATION SERVICE (heads-up ride request alerts)
    // ========================================================================
    AppLogger.d(
      '8️⃣ Using SocketForegroundService for killed-state native notifications.',
    );

    // Background socket is now handled natively by SocketForegroundService.kt
    AppLogger.d('9️⃣ Native socket service configured (starts on go-online)');
  } catch (e, stackTrace) {
    AppLogger.d('');
    AppLogger.d('❌ ERROR DURING INITIALIZATION ❌');
    AppLogger.d('Error: $e');
    AppLogger.d('Stack trace: $stackTrace');
    AppLogger.d('');
  }

  Get.put(NetworkController(), permanent: true);
  Get.put(ChatNotificationController(), permanent: true);
  Get.put(GetCityByLocationController(), permanent: true);
  // ========================================================================
  // RUN THE APP
  // ========================================================================
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    OverlayService.instance.initOverlayListener((message) {
      AppLogger.d('[MyApp] Overlay tap received: $message');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    OverlayService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      if (SocketManager().isOnDuty) {
        OverlayService.instance.showOverlay();
      }
    } else if (state == AppLifecycleState.resumed) {
      OverlayService.instance.hideOverlay();
      if (SocketManager().isOnDuty) {
        AppLogger.d('📱 App resumed - forcing socket reconnect check');
        try {
          SocketManager().forceReconnect();
        } catch (e) {
          AppLogger.d('⚠️ Error during forceReconnect on resume: $e');
        }
      }
    }
  }

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
        builder: (context, child) {
          return LocationGuard(
            child: Stack(
              children: [
                if (child != null) child,
                const NetworkStatusOverlay(), // Shows automatically when offline
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================================
// OVERLAY ENTRY POINT (required by flutter_overlay_window)
// ==========================================================================

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayBubble()),
  );
}
