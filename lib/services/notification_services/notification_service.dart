import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/views/ride_screens/accepted_screen.dart';

class NotificationService {
  // Private constructor - Singleton pattern
  NotificationService._internal();

  /// Singleton instance
  static final NotificationService instance = NotificationService._internal();

  // ============================================================================
  // CONSTANTS
  // ============================================================================

  /// Notification channel ID - must match AndroidManifest.xml meta-data
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important notifications';

  // ============================================================================
  // INSTANCES
  // ============================================================================

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ============================================================================
  // STATE
  // ============================================================================

  bool _isInitialized = false;
  String? _fcmToken;

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) {
      print('📱 [NotificationService] Already initialized, skipping...');
      return;
    }

    try {
      print('📱 [NotificationService] Initializing...');

      // Step 1: Initialize local notifications plugin
      await _initializeLocalNotifications();

      // Step 2: Create notification channel (Android)
      await _createNotificationChannel();

      // Step 3: Request permission
      final permissionGranted = await _requestPermission();
      if (!permissionGranted) {
        print(
          '⚠️ [NotificationService] Permission not granted, some features may not work',
        );
      }

      // Step 4: Get and persist FCM token
      await _getFcmToken();

      // Step 5: Listen for token refresh
      _listenForTokenRefresh();

      // Step 6: Setup foreground message handler
      _setupForegroundMessageHandler();

      // Step 7: Setup notification tap handler (when app is in background and opened via notification)
      _setupMessageOpenedAppHandler();

      _isInitialized = true;
      print('✅ [NotificationService] Initialization complete');
    } catch (e, stackTrace) {
      print('❌ [NotificationService] Initialization failed: $e');
      print('📍 StackTrace: $stackTrace');
    }
  }

  /// Show notification from background handler (without GetX dependencies)
  Future<void> showNotificationInBackground(RemoteMessage message) async {
    try {
      // Initialize local notifications plugin in background
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(initSettings);

      // Create channel if needed
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );
        await androidPlugin.createNotificationChannel(channel);
      }

      // Show notification
      await showNotification(message);

      print('✅ [Background] Notification displayed');
    } catch (e) {
      print('❌ [Background] Failed to show notification: $e');
    }
  }

  // ============================================================================
  // LOCAL NOTIFICATIONS SETUP
  // ============================================================================

  Future<void> _initializeLocalNotifications() async {
    // Android settings - uses app icon
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    print('✅ [NotificationService] Local notifications initialized');
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    // Handle background notification tap/action
    print(
      '👆 [NotificationService] Background notification action: ${notificationResponse.actionId}',
    );
    // We can't use GetX or non-static members here.
    // Usually we'd use a BackgroundService or similar to signal the accept/decline.
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print('✅ [NotificationService] Notification channel created: $channelId');
    }
  }

  // ============================================================================
  // PERMISSION HANDLING
  // ============================================================================

  Future<bool> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final status = settings.authorizationStatus;

      switch (status) {
        case AuthorizationStatus.authorized:
          print('✅ [NotificationService] Permission granted: authorized');
          return true;
        case AuthorizationStatus.provisional:
          print('✅ [NotificationService] Permission granted: provisional');
          return true;
        case AuthorizationStatus.denied:
          print('❌ [NotificationService] Permission denied');
          return false;
        case AuthorizationStatus.notDetermined:
          print('⚠️ [NotificationService] Permission not determined');
          return false;
      }
    } catch (e) {
      print('❌ [NotificationService] Permission request failed: $e');
      return false;
    }
  }

  // ============================================================================
  // TOKEN MANAGEMENT
  // ============================================================================

  Future<void> _getFcmToken() async {
    try {
      _fcmToken = await _messaging.getToken();

      if (_fcmToken == null) {
        print('⚠️ [NotificationService] FCM token is null');
        return;
      }

      print('>>>>>>>>>>>>>> [NotificationService] FCM Token: $_fcmToken');

      // Persist token and device info
      await _persistTokenAndDeviceInfo();
    } catch (e) {
      print('❌ [NotificationService] Failed to get FCM token: $e');
    }
  }

  void _listenForTokenRefresh() {
    _messaging.onTokenRefresh
        .listen((newToken) async {
          print('🔄 [NotificationService] FCM Token refreshed: $newToken');
          _fcmToken = newToken;
          await _persistTokenAndDeviceInfo();
        })
        .onError((error) {
          print('❌ [NotificationService] Token refresh error: $error');
        });
  }

  Future<void> _persistTokenAndDeviceInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save FCM token
      if (_fcmToken != null) {
        await prefs.setString('fcmToken', _fcmToken!);
        print('💾 [NotificationService] FCM token saved to SharedPreferences');
      }

      // Save device ID if not already saved
      if (!prefs.containsKey('deviceId')) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        final deviceId = androidInfo.id;
        await prefs.setString('deviceId', deviceId);
        print('💾 [NotificationService] Device ID saved: $deviceId');
      }
    } catch (e) {
      print('❌ [NotificationService] Failed to persist token/device info: $e');
    }
  }

  /// Get stored FCM token from SharedPreferences
  Future<String?> getStoredFcmToken() async {
    final prefs = await SharedPreferences.getInstance();

    print("get_my_fcm_token ${prefs.getString('fcmToken')}");
    return prefs.getString('fcmToken');
  }

  /// Get stored device ID from SharedPreferences
  Future<String?> getStoredDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId');
  }

  // ============================================================================
  // MESSAGE HANDLERS
  // ============================================================================

  void _setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage
        .listen((RemoteMessage message) async {
          print('📩 [NotificationService] Foreground message received');
          print('   Title: ${message.notification?.title}');
          print('   Body: ${message.notification?.body}');
          print('   Data: ${message.data}');

          // Check if notification should be suppressed
          if (message.data['suppressPush'] == '1' ||
              message.data['suppressPush'] == 'true') {
            print(
              '🔕 [NotificationService] Notification suppressed by data flag',
            );
            return;
          }

          // Show local notification
          await showNotification(message);
        })
        .onError((error) {
          print('❌ [NotificationService] Foreground message error: $error');
        });

    print('✅ [NotificationService] Foreground message handler setup');
  }

  void _setupMessageOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) {
          print(
            '📲 [NotificationService] App opened from notification (background state)',
          );
          print('   Title: ${message.notification?.title}');
          print('   Data: ${message.data}');

          // Handle navigation based on notification data
          _handleNotificationNavigation(message.data);
        })
        .onError((error) {
          print('❌ [NotificationService] Message opened app error: $error');
        });

    print('✅ [NotificationService] Message opened app handler setup');
  }

  // ============================================================================
  // NOTIFICATION DISPLAY
  // ============================================================================

  /// Show a notification for a ride request with Accept/Decline buttons
  Future<void> showRideRequestNotification(
    Map<String, dynamic> rideData,
  ) async {
    try {
      final String orderId = rideData['orderId']?.toString() ?? 'unknown';
      final String riderName = rideData['riderName']?.toString() ?? 'New Rider';
      final String pickup =
          rideData['pickupAddress']?.toString() ?? 'Pickup Location';

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
        actions: <AndroidNotificationAction>[
          const AndroidNotificationAction(
            'accept_ride',
            'Accept',
            cancelNotification: true,
            contextual: false,
            icon: DrawableResourceAndroidBitmap('ic_launcher'),
          ),
          const AndroidNotificationAction(
            'decline_ride',
            'Decline',
            cancelNotification: true,
            contextual: false,
            icon: DrawableResourceAndroidBitmap('ic_launcher'),
          ),
        ],
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        888, // Constant ID for ride requests
        'New Ride Request!',
        'Rider: $riderName\nPickup: $pickup',
        notificationDetails,
        payload: jsonEncode(rideData),
      );

      print(
        '✅ [NotificationService] Ride request notification shown for $orderId',
      );
    } catch (e) {
      print('❌ [NotificationService] Failed to show ride notification: $e');
    }
  }

  /// Show a local notification with custom title and body
  Future<void> showNotificationDirectly({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = Random().nextInt(100000);

      await _localNotifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: payload != null ? jsonEncode(payload) : null,
      );

      print('✅ [NotificationService] Direct notification displayed: $title');
    } catch (e) {
      print('❌ [NotificationService] Failed to show direct notification: $e');
    }
  }

  /// Show a local notification from a RemoteMessage
  Future<void> showNotification(RemoteMessage message) async {
    try {
      // Extract title - check notification object first, then data
      final String title =
          message.notification?.title ??
          message.data['title']?.toString() ??
          'New Notification';

      // Extract body
      final String body =
          message.notification?.body ??
          message.data['body']?.toString() ??
          message.data['message']?.toString() ??
          '';

      // Android notification details
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: title,
          summaryText: 'NZCU Driver',
        ),
      );

      // iOS notification details
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Generate random ID for notification
      final notificationId = Random().nextInt(100000);

      await _localNotifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: message.data.toString(),
      );

      print('✅ [NotificationService] Notification displayed: $title');
    } catch (e) {
      print('❌ [NotificationService] Failed to show notification: $e');
    }
  }

  // ============================================================================
  // TAP HANDLERS
  // ============================================================================

  /// Handle notification tap when app is in foreground
  void _onNotificationTap(NotificationResponse response) {
    print('👆 [NotificationService] Notification tapped (foreground)');
    print('   ActionId: ${response.actionId}');
    print('   Payload: ${response.payload}');

    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);

        if (response.actionId == 'accept_ride') {
          print('✅ User clicked ACCEPT from notification');
          final String? orderId =
              data['orderId']?.toString() ??
              data['rideId']?.toString() ??
              data['_id']?.toString();

          if (orderId != null) {
            // Trigger API Call via Controller
            final orderUpdateController = Get.find<OrderUpdateController>();

            // Use overlay context or Get.context
            final context = Get.overlayContext ?? Get.context;

            if (context != null) {
              orderUpdateController.updateOrder(
                context: context,
                buttonId: 'accept_button',
                orderStatus: "Accepted",
                orderId: orderId,
                rideData: data, // Pass full ride data from payload
                stepControl: "Accepted",
                successMessage: 'Ride accepted successfully!',
                shouldTriggerNavigation: true, // As requested by user
              );

              // Navigate to Arriving Client Screen
              print('🚕 Navigating to ArrivingClient...');
              Get.to(
                () => ArrivingClient(typeCheck: false, rideData: data),
                transition: Transition.fadeIn,
              );
            } else {
              print(
                '❌ [NotificationService] No context available for API call',
              );
            }
          }
        } else if (response.actionId == 'decline_ride') {
          print('❌ User clicked DECLINE from notification');
          final String? orderId =
              data['orderId']?.toString() ??
              data['rideId']?.toString() ??
              data['_id']?.toString();

          if (orderId != null) {
            SocketManager().declineRide(
              orderId,
              reason: 'Declined via notification',
            );
          }
        } else {
          _handleNotificationNavigationFromPayload(response.payload!);
        }
      } catch (e) {
        print('❌ [NotificationService] Error in _onNotificationTap: $e');
      }
    }
  }

  /// Handle navigation based on notification data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final String? screen = data['screen']?.toString();
    final String? orderId =
        data['orderId']?.toString() ?? data['order_id']?.toString();

    print('🧭 [NotificationService] Navigation requested');
    print('   Screen: $screen');
    print('   OrderId: $orderId');

    // TODO: Implement your navigation logic
  }

  void _handleNotificationNavigationFromPayload(String payload) {
    try {
      // Parse payload (simple implementation)
      if (payload.contains('orderId')) {
        // TODO: Parse and navigate
      }
    } catch (e) {
      print('❌ [NotificationService] Failed to parse payload: $e');
    }
  }

  // ============================================================================
  // TERMINATED STATE
  // ============================================================================

  /// Get the initial message if app was opened from terminated state via notification
  Future<RemoteMessage?> getInitialMessage() async {
    try {
      final message = await _messaging.getInitialMessage();
      if (message != null) {
        print(
          '🚀 [NotificationService] App opened from terminated state via notification',
        );
        print('   Title: ${message.notification?.title}');
        print('   Data: ${message.data}');
      }
      return message;
    } catch (e) {
      print('❌ [NotificationService] Failed to get initial message: $e');
      return null;
    }
  }

  /// Check if app was opened from notification and handle navigation
  Future<void> handleInitialMessage() async {
    final message = await getInitialMessage();
    if (message != null) {
      _handleNotificationNavigation(message.data);
    }
  }

  // ============================================================================
  // UTILITIES
  // ============================================================================

  /// Delete FCM token (useful for logout scenarios)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcmToken');

      print('🗑️ [NotificationService] FCM token deleted');
    } catch (e) {
      print('❌ [NotificationService] Failed to delete token: $e');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ [NotificationService] Subscribed to topic: $topic');
    } catch (e) {
      print('❌ [NotificationService] Failed to subscribe to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ [NotificationService] Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ [NotificationService] Failed to unsubscribe from topic: $e');
    }
  }
}
