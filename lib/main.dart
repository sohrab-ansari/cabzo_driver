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
import 'package:nzcu_driver/utilities/widgets/location_guard.dart';
import 'package:nzcu_driver/views/splash/splash_screen.dart';

// @pragma('vm:entry-point')
// void headlessTask(bg.HeadlessEvent event) async {
//   print('[HeadlessTask] Event: ${event.name}');
//   if (event.name == bg.Event.LOCATION) {
//     bg.Location location = event.event;
//     print(
//       '[HeadlessTask] Location: ${location.coords.latitude}, ${location.coords.longitude}',
//     );
//     // Note: We could emit socket here, but BackgroundService should already be doing it if running.
//     // Headless tasks are for when the app is completely terminated and BackgroundService isolate might be resting.
//   }
// }

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  // IMPORTANT: Firebase must be initialized in background isolate
  // Background handlers run in a separate Dart isolate where Firebase is NOT initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print('>>>>>> [Background] Message received: ${message.messageId}');

  // Use the singleton instance------
  await NotificationService.instance.showNotificationInBackground(message);
}

void main() async {
  // Ensure Flutter widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Register HeadlessTask for flutter_background_geolocation
  // bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);

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
    // print('5️⃣ Initializing Notification Service...');
    // await NotificationService.instance.initialize();
    // print('   ✅ Notification service initialized');

    // ========================================================================
    // 6. PRINT SUCCESS MESSAGE
    // ========================================================================
    print('🎉 All services initialized successfully!');
    print('=' * 60);
    print('');

    // ========================================================================
    // 8. RIDE NOTIFICATION SERVICE (heads-up ride request alerts)
    // ========================================================================
    print(
      '8️⃣ Using SocketForegroundService for killed-state native notifications.',
    );

    // Background socket is now handled natively by SocketForegroundService.kt
    print('9️⃣ Native socket service configured (starts on go-online)');
  } catch (e, stackTrace) {
    print('');
    print('❌ ERROR DURING INITIALIZATION ❌');
    print('Error: $e');
    print('Stack trace: $stackTrace');
    print('');
  }

  Get.put(NetworkController(), permanent: true);
  Get.put(ChatNotificationController(), permanent: true);
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
      print('[MyApp] Overlay tap received: $message');
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
