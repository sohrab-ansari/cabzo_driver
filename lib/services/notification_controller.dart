


import 'package:get/get.dart';
import 'package:nzcu_driver/services/notification_service.dart';

class NotificationController extends GetxController {
  // ============================================================================
  // OBSERVABLES
  // ============================================================================

  final fcmToken = RxnString();
  final deviceId = RxnString();
  final isPermissionGranted = false.obs;
  final isInitialized = false.obs;
  final isLoading = false.obs;

  // ============================================================================
  // LIFECYCLE
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    print('📱 [NotificationController] Initializing...');
    _initializeNotifications();
  }

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  Future<void> _initializeNotifications() async {
    isLoading.value = true;

    try {
      // Initialize the notification service
      await NotificationService.instance.initialize();

      // Load stored token and device ID
      await _loadStoredData();

      // Check and handle initial message (app opened from terminated state)
      await _checkInitialMessage();

      isInitialized.value = true;
      isPermissionGranted.value = fcmToken.value != null;

      print('✅ [NotificationController] Initialization complete');
      print('   FCM Token: ${fcmToken.value}');
      print('   Device ID: ${deviceId.value}');
    } catch (e) {
      print('❌ [NotificationController] Initialization failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStoredData() async {
    fcmToken.value = await NotificationService.instance.getStoredFcmToken();
    deviceId.value = await NotificationService.instance.getStoredDeviceId();

    // Also sync with live token
    final liveToken = NotificationService.instance.fcmToken;
    if (liveToken != null && liveToken != fcmToken.value) {
      fcmToken.value = liveToken;
    }
  }

  Future<void> _checkInitialMessage() async {
    final message = await NotificationService.instance.getInitialMessage();
    if (message != null) {
      print('🚀 [NotificationController] App opened from notification');
      _handleNotificationData(message.data);
    }
  }

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  Future<void> refreshToken() async {
    try {
      isLoading.value = true;

      // Delete old token
      await NotificationService.instance.deleteToken();

      // Re-initialize to get new token
      await NotificationService.instance.initialize();

      // Load new token
      await _loadStoredData();

      print('🔄 [NotificationController] Token refreshed: ${fcmToken.value}');
    } catch (e) {
      print('❌ [NotificationController] Token refresh failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getToken() async {
    if (fcmToken.value != null) {
      return fcmToken.value;
    }

    // Try to load from storage
    await _loadStoredData();
    return fcmToken.value;
  }

  Future<void> subscribeToTopic(String topic) async {
    await NotificationService.instance.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await NotificationService.instance.unsubscribeFromTopic(topic);
  }

  Future<void> clearNotificationData() async {
    await NotificationService.instance.deleteToken();
    fcmToken.value = null;
    isInitialized.value = false;
    print('🗑️ [NotificationController] Notification data cleared');
  }

  // ============================================================================
  // NAVIGATION HANDLING
  // ============================================================================

  void _handleNotificationData(Map<String, dynamic> data) {
    final String? screen = data['screen']?.toString();
    final String? orderId =
        data['orderId']?.toString() ?? data['order_id']?.toString();

    print('🧭 [NotificationController] Handling notification navigation');
    print('   Screen: $screen');
    print('   OrderId: $orderId');

    // TODO: Implement your navigation logic
  }

  // ============================================================================
  // UTILITY GETTERS
  // ============================================================================

  bool get isNotificationReady => isInitialized.value && fcmToken.value != null;
  String? get currentToken => fcmToken.value;
  String? get currentDeviceId => deviceId.value;
}