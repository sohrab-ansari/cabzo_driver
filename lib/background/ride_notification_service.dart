import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification channel & IDs used exclusively for ride request alerts.
const String _kRideChannelKey = 'ride_request_channel';
const int _kRideNotificationId = 900;

/// Service that displays a high-priority heads-up notification when a new ride
/// request arrives. The notification includes Accept / Decline action buttons,
/// wakes the screen, and auto-dismisses after [autoTimeoutSeconds].
///
/// Usage:
/// ```dart
/// await RideNotificationService.init();                // once at startup
/// await RideNotificationService.showRideRequest(data); // on ride:newRide
/// ```
class RideNotificationService {
  RideNotificationService._();

  static bool _isInitialized = false;

  /// Seconds before the notification auto-dismisses.
  static const int autoTimeoutSeconds = 15;

  /// Stored timer so we can cancel if the driver acts before timeout.
  static Timer? _autoDismissTimer;

  // ---------------------------------------------------------------------------
  // Callbacks — set these from the consumer (e.g. SocketManager)
  // ---------------------------------------------------------------------------

  /// Called when the driver taps "Accept" on the notification.
  static void Function(String orderId)? onAccept;

  /// Called when the driver taps "Decline" on the notification.
  static void Function(String orderId)? onDecline;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Call once (e.g. in `main()`) to create the notification channel and
  /// register action listeners.
  static Future<void> init() async {
    if (_isInitialized) return;

    await AwesomeNotifications().initialize(
      // null = use the app's default icon
      null,
      [
        NotificationChannel(
          channelKey: _kRideChannelKey,
          channelName: 'Ride Requests',
          channelDescription: 'Heads-up alerts for new ride requests',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          enableLights: true,
          ledColor: Colors.blue,
          locked: true,
          criticalAlerts: true,
        ),
      ],
    );

    // Listen for button presses
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
    );

    _isInitialized = true;
    print('✅ [RideNotificationService] Initialized');
  }

  /// Request notification permissions (Android 13+).
  static Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return true;
  }

  // ---------------------------------------------------------------------------
  // Show / Dismiss
  // ---------------------------------------------------------------------------

  /// Display a heads-up notification for a new ride request.
  ///
  /// [rideData] must contain at least:
  ///   - `orderId` (String)
  ///   - `riderName` (String)
  ///   - `startLocation.address` (String)
  ///   - `endLocation.address` (String, optional)
  ///   - `totalFare` (String)
  ///   - `distance` (String)
  static Future<void> showRideRequest(Map<String, dynamic> rideData) async {
    if (!_isInitialized) {
      print('⚠️ [RideNotificationService] Not initialized, calling init()');
      await init();
    }

    final String orderId = (rideData['orderId'] ?? rideData['_id'] ?? '')
        .toString();
    final String riderName = (rideData['riderName'] ?? 'Customer').toString();
    final String pickup =
        (rideData['startLocation']?['address'] ?? 'Pickup location').toString();
    final String dropoff = (rideData['endLocation']?['address'] ?? '')
        .toString();
    final String fare = (rideData['totalFare'] ?? '0').toString();
    final String distance = (rideData['distance'] ?? '').toString();

    // Build the body text
    final StringBuffer body = StringBuffer()
      ..writeln('👤 $riderName')
      ..writeln('📍 $pickup');
    if (dropoff.isNotEmpty) {
      body.writeln('📌 $dropoff');
    }
    if (distance.isNotEmpty && distance != '0') {
      body.write('📏 ${distance} km  •  ');
    }
    body.write('💰 ₹$fare');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _kRideNotificationId,
        channelKey: _kRideChannelKey,
        title: '🚕 New Ride Request',
        body: body.toString(),
        payload: {'orderId': orderId},
        category: NotificationCategory.Call,
        notificationLayout: NotificationLayout.BigText,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        locked: true,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'ACCEPT',
          label: '✅ Accept',
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'DECLINE',
          label: '❌ Decline',
          color: Colors.red,
          autoDismissible: true,
          actionType: ActionType.SilentBackgroundAction,
        ),
      ],
    );

    print('🔔 [RideNotificationService] Ride notification shown for $orderId');

    // Auto-dismiss after timeout
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(Duration(seconds: autoTimeoutSeconds), () {
      dismiss();
      print(
        '⏱️ [RideNotificationService] Auto-dismissed after $autoTimeoutSeconds s',
      );
    });
  }

  /// Dismiss the current ride notification (e.g. after accept/decline/timeout).
  static Future<void> dismiss() async {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    await AwesomeNotifications().cancel(_kRideNotificationId);
  }

  // ---------------------------------------------------------------------------
  // Action handler (static — required by awesome_notifications)
  // ---------------------------------------------------------------------------

  /// Handles notification button presses. This is called on a background
  /// isolate for silent actions.
  @pragma("vm:entry-point")
  static Future<void> _onActionReceived(ReceivedAction action) async {
    final String orderId = action.payload?['orderId'] ?? '';
    final String buttonKey = action.buttonKeyPressed;

    print(
      '🔔 [RideNotificationService] Action received: $buttonKey for $orderId',
    );

    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;

    if (buttonKey == 'ACCEPT') {
      if (onAccept != null) {
        onAccept?.call(orderId);
      } else {
        _savePendingAction('accept', orderId);
      }
    } else if (buttonKey == 'DECLINE') {
      if (onDecline != null) {
        onDecline?.call(orderId);
      } else {
        _savePendingAction('decline', orderId);
      }
    } else {
      // Body tap - bring to foreground
      print(
        "🔔 [RideNotificationService] Notification body tapped - opening app",
      );
    }
  }

  static Future<void> _savePendingAction(String action, String orderId) async {
    print(
      '💾 [RideNotificationService] Saving pending action: $action for $orderId',
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_ride_action', '$action:$orderId');
  }

  /// Check and execute any pending actions from notification taps (when app was killed)
  static Future<void> checkPendingAction() async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getString('pending_ride_action');

    if (pending != null) {
      final parts = pending.split(':');
      if (parts.length == 2) {
        final action = parts[0];
        final orderId = parts[1];

        print(
          '🚀 [RideNotificationService] Executing pending action: $action for $orderId',
        );

        if (action == 'accept') {
          onAccept?.call(orderId);
        } else if (action == 'decline') {
          onDecline?.call(orderId);
        }
      }
      await prefs.remove('pending_ride_action');
    }
  }
}
