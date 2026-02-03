

// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:get/get_instance/src/extension_instance.dart';
// // import 'package:nzcu_driver/core/dependency_injection.dart';
// // import 'package:nzcu_driver/firebase_options.dart';
// // import 'package:nzcu_driver/services/notification_controller.dart';
// // import 'package:nzcu_driver/services/notification_service.dart';
// // import 'package:nzcu_driver/utilities/colors.dart';
// // import 'package:nzcu_driver/views/splash/splash_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get_navigation/src/root/get_material_app.dart';

// // // ============================================================================
// // // BACKGROUND MESSAGE HANDLER - MUST BE AT TOP LEVEL
// // // ============================================================================
// // @pragma('vm:entry-point')
// // Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
// //   // IMPORTANT: Don't use GetX in background handler as it runs in a separate isolate
// //   print('📩 [Background] Message received: ${message.notification?.title}');
  
// //   // Initialize Firebase in background isolate
// //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
// //   // Use the singleton instance of NotificationService
// //   await NotificationService.instance.showNotificationInBackground(message);
// // }

// // // Function to configure Firebase messaging and get token
// // Future<void> _configureFirebaseMessaging() async {
// //   try {
// //     print('🔧 Configuring Firebase Messaging...');
    
// //     // Request permission (iOS specific)
// //     NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
// //       alert: true,
// //       announcement: false,
// //       badge: true,
// //       carPlay: false,
// //       criticalAlert: false,
// //       provisional: false,
// //       sound: true,
// //     );
    
// //     print('📱 Notification permission status: ${settings.authorizationStatus}');
    
// //     // Get the FCM token
// //     String? token = await FirebaseMessaging.instance.getToken();
    
// //     if (token != null && token.isNotEmpty) {
// //       print('=' * 60);
// //       print('🔥 FIREBASE FCM TOKEN 🔥');
// //       print('=' * 60);
// //       print('fccmmmmm>>>>>> Token: $token');
// //       print('Token Length: ${token.length} characters');
// //       print('First 50 chars: ${token.substring(0, min(token.length, 50))}...');
// //       print('=' * 60);
      
// //       // You can also save this token to your backend server
// //       // Example: await apiService.sendFCMTokenToServer(token);
// //     } else {
// //       print('❌ Failed to get Firebase token - Token is null or empty');
// //     }
    
// //     // Listen for token refresh
// //     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
// //       print('🔄 Token refreshed! New token: $newToken');
// //       print('📱 Token length: ${newToken.length} characters');
      
// //       // Send the new token to your backend server
// //       // Example: await apiService.updateFCMToken(newToken);
// //     });
    
// //     // Get initial message if app was opened from terminated state
// //     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
// //     if (initialMessage != null) {
// //       print('🚀 App opened from terminated state via notification');
// //       print('   Title: ${initialMessage.notification?.title}');
// //       print('   Body: ${initialMessage.notification?.body}');
// //       print('   Data: ${initialMessage.data}');
// //     }
    
// //     // Listen for foreground messages
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       print('📩 [Foreground] New notification received!');
// //       print('   Title: ${message.notification?.title}');
// //       print('   Body: ${message.notification?.body}');
// //       print('   Data: ${message.data}');
// //       print('   Message ID: ${message.messageId}');
// //       print('   Sent Time: ${message.sentTime}');
// //       print('   From: ${message.from}');
// //     });
    
// //     // Listen for message when app is in background
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       print('📱 App opened from background notification');
// //       print('   Title: ${message.notification?.title}');
// //       print('   Body: ${message.notification?.body}');
// //       print('   Data: ${message.data}');
// //     });
    
// //     // Get current FCM token settings
// //     final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
// //     if (apnsToken != null) {
// //       print('🍎 APNS Token: $apnsToken');
// //     }
    
// //     print('✅ Firebase Messaging configured successfully');
    
// //   } catch (e) {
// //     print('❌ Error configuring Firebase messaging: $e');
// //     print('Stack trace: ${e.toString()}');
// //   }
// // }

// // // Helper function to get minimum of two numbers
// // int min(int a, int b) => a < b ? a : b;

// // // Function to print app initialization banner
// // void _printAppBanner() {
// //   print('');
// //   print('=' * 60);
// //   print('🚀 NZCU DRIVER APP INITIALIZATION');
// //   print('=' * 60);
// // }

// // void main() async {
// //   // Ensure Flutter widgets are initialized
// //   WidgetsFlutterBinding.ensureInitialized();
  
// //   // Print app banner
// //   _printAppBanner();
// //   print('📱 App Initialization Starting...');
  
// //   try {
// //     // ========================================================================
// //     // 1. INITIALIZE FIREBASE
// //     // ========================================================================
// //     print('1️⃣ Initializing Firebase...');
// //     await Firebase.initializeApp(
// //       options: DefaultFirebaseOptions.currentPlatform,
// //     );
// //     print('   ✅ Firebase Core initialized');
    
// //     // ========================================================================
// //     // 2. REGISTER BACKGROUND MESSAGE HANDLER
// //     // ========================================================================
// //     print('2️⃣ Registering background message handler...');
// //     FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
// //     print('   ✅ Background message handler registered');
    
// //     // ========================================================================
// //     // 3. CONFIGURE FIREBASE MESSAGING & GET TOKEN
// //     // ========================================================================
// //     print('3️⃣ Configuring Firebase Messaging...');
// //     await _configureFirebaseMessaging();
    
// //     // ========================================================================
// //     // 4. SYSTEM UI CONFIGURATION
// //     // ========================================================================
// //     print('4️⃣ Configuring System UI...');
// //     SystemChrome.setSystemUIOverlayStyle(
// //       const SystemUiOverlayStyle(
// //         statusBarColor: Colors.transparent,
// //         statusBarIconBrightness: Brightness.light,
// //         statusBarBrightness: Brightness.light,
// //       ),
// //     );
// //     print('   ✅ System UI configured');
    
// //     // ========================================================================
// //     // 5. DEPENDENCY INJECTION
// //     // ========================================================================
// //     print('5️⃣ Setting up Dependency Injection...');
// //     DependencyInjection.init();
// //     print('   ✅ Dependency Injection initialized');
    
// //     // ========================================================================
// //     // 6. NOTIFICATION SERVICE
// //     // ========================================================================
// //     print('6️⃣ Initializing Notification Service...');
// //     try {
// //       await NotificationService.instance.initialize();
// //       print('   ✅ Notification service initialized');
// //     } catch (e) {
// //       print('   ⚠️ Notification service initialization error: $e');
// //     }
    
// //     // ========================================================================
// //     // 7. CHECK FOR INITIAL NOTIFICATION
// //     // ========================================================================
// //     print('7️⃣ Checking for initial notification...');
// //     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
// //     if (initialMessage != null) {
// //       print('   📱 App was launched by notification');
// //       print('   Title: ${initialMessage.notification?.title}');
// //     } else {
// //       print('   📱 App launched normally (not from notification)');
// //     }
    
// //     // ========================================================================
// //     // 8. PRINT SUCCESS MESSAGE
// //     // ========================================================================
// //     print('');
// //     print('🎉 All services initialized successfully!');
// //     print('=' * 60);
// //     print('');
    
// //   } catch (e) {
// //     print('');
// //     print('❌ ERROR DURING INITIALIZATION ❌');
// //     print('Error: $e');
// //     print('Stack trace: ${e.toString()}');
// //     print('');
// //   }
  
// //   // ========================================================================
// //   // RUN THE APP
// //   // ========================================================================
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
  
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       top: false,
// //       bottom: true,
// //       child: GetMaterialApp(
// //         title: 'Nzcu Driver',
// //         debugShowCheckedModeBanner: false,
// //         theme: ThemeData(
// //           colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
// //           useMaterial3: true,
// //         ),
// //         home: const SplashScreen(),
// //       ),
// //     );
// //   }
// // }


// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:nzcu_driver/core/dependency_injection.dart';
// import 'package:nzcu_driver/firebase_options.dart';
// import 'package:nzcu_driver/services/notification_service.dart';
// import 'package:nzcu_driver/utilities/colors.dart';
// import 'package:nzcu_driver/views/splash/splash_screen.dart';

// // ============================================================================
// // BACKGROUND MESSAGE HANDLER - MUST BE AT TOP LEVEL
// // ============================================================================
// @pragma('vm:entry-point')
// Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
//   // IMPORTANT: This runs in a separate isolate
//   // Firebase is already initialized in main(), so DON'T initialize here
  
//   print('📩 [Background] Message received: ${message.messageId}');
  
//   // Use the singleton instance
//   await NotificationService.instance.showNotificationInBackground(message);
// }

// void main() async {
//   // Ensure Flutter widgets are initialized
//   WidgetsFlutterBinding.ensureInitialized();
  
//   print('');
//   print('=' * 60);
//   print('🚀 NZCU DRIVER APP INITIALIZATION');
//   print('=' * 60);
  
//   try {
//     // ========================================================================
//     // 1. FIREBASE INITIALIZATION (CRITICAL - MUST BE FIRST)
//     // ========================================================================
//     print('1️⃣ Initializing Firebase...');
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print('   ✅ Firebase Core initialized');
    
//     // ========================================================================
//     // 2. REGISTER BACKGROUND HANDLER
//     // ========================================================================
//     print('2️⃣ Registering background message handler...');
//     FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
//     print('   ✅ Background handler registered');
    
//     // ========================================================================
//     // 3. CONFIGURE SYSTEM UI
//     // ========================================================================
//     print('3️⃣ Configuring System UI...');
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//         statusBarBrightness: Brightness.light,
//       ),
//     );
//     print('   ✅ System UI configured');
    
//     // ========================================================================
//     // 4. DEPENDENCY INJECTION
//     // ========================================================================
//     print('4️⃣ Setting up Dependency Injection...');
//     DependencyInjection.init();
//     print('   ✅ Dependency Injection initialized');
    
//     // ========================================================================
//     // 5. NOTIFICATION SERVICE INITIALIZATION
//     // ========================================================================
//     print('5️⃣ Initializing Notification Service...');
//     await NotificationService.instance.initialize();
//     print('   ✅ Notification service initialized');
    
//     // ========================================================================
//     // 6. PRINT SUCCESS MESSAGE
//     // ========================================================================
//     print('');
//     print('🎉 All services initialized successfully!');
//     print('=' * 60);
//     print('');
    
//   } catch (e, stackTrace) {
//     print('');
//     print('❌ ERROR DURING INITIALIZATION ❌');
//     print('Error: $e');
//     print('Stack trace: $stackTrace');
//     print('');
//   }
  
//   // ========================================================================
//   // RUN THE APP
//   // ========================================================================
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'NZCU Driver',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//     );
//   }
// }


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
    return GetMaterialApp(
      title: 'NZCU Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}