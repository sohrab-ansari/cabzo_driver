import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // 1. IMMEDIATE ISOLATE SETUP
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService(); // ✅ Force foreground immediately
  }

  print("🎬 [Background Isolate] ISOLATE_ENTERED");

  // State variables
  IO.Socket? socket;
  Timer? locationTimer;
  double lastLat = 0.0;
  double lastLng = 0.0;
  bool isDutyActive = false;

  // 2. ERROR RECOVERY WRAPPER
  runZonedGuarded(
    () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      void updateNotification(String title, String content) {
        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(title: title, content: content);
        }
      }

      // 3. HEARTBEAT (Proof of Life)
      Timer.periodic(const Duration(seconds: 15), (timer) {
        final String duty = isDutyActive ? "ONLINE" : "OFFLINE";
        final String sock = (socket != null && socket!.connected)
            ? "CONNECTED"
            : "DISCONNECTED";
        print(
          "🕒 [Background Isolate] HEARTBEAT: $duty | Socket: $sock | Loc: $lastLat,$lastLng",
        );
      });

      Future<void> stopDuty() async {
        print("🛑 [Background Isolate] Stopping Duty...");
        isDutyActive = false;
        locationTimer?.cancel();
        bg.BackgroundGeolocation.stop();
        socket?.disconnect();
        socket?.dispose();
        socket = null;
        updateNotification("NZCU Driver", "Ready to go online");
      }

      Future<void> startDuty() async {
        if (isDutyActive && socket != null && socket!.connected) {
          print(
            "⚠️ [Background Isolate] Duty already running, skipping startRequest",
          );
          return;
        }

        print("🚀 [Background Isolate] Activating Duty Flow...");
        isDutyActive = true;
        updateNotification("NZCU Driver", "Connecting...");

        await prefs.reload();
        final token = prefs.getString("auth_token");
        final driverId = prefs.getString("driver_userid");
        final vehicleType = prefs.getString("vehicle_type_id");
        final vehicleType2 = prefs.getString("vehicle_SubType");
        final vehicleNumber = prefs.getString("vehicle_id");

        String? vehicleImage = prefs.getString("vehicle_image");
        String? fleetId = prefs.getString("fleet_id");

        if (token == null || driverId == null) {
          print(
            "❌ [Background Isolate] Termination: Missing auth data, cannot start",
          );
          isDutyActive = false;
          updateNotification(
            "NZCU Driver",
            "Session Expired - Please re-login",
          );
          return;
        }

        try {
          if (socket != null) socket?.dispose();

          socket = IO.io(
            // 'https://api.nzcu.framekarts.com',
            'https://corezap.smarttechbros.com',
            IO.OptionBuilder()
                .setTransports(['websocket', 'polling'])
                .enableAutoConnect()
                .setReconnectionAttempts(999)
                .setReconnectionDelay(2000)
                .setAuth({'token': token})
                .setQuery({
                  'userRole': 'Driver',
                  'platform': 'flutter',
                  'driverId': driverId,
                  'isBackground': 'true',
                })
                .build(),
          );

          socket?.onConnect((_) {
            print('✅ [Background Isolate] Socket Connected!');
            updateNotification("NZCU Driver", "You are Online");

            socket?.emit('user:online', {
              'latitude': lastLat,
              'longitude': lastLng,
              'vehicleType': vehicleType,
              'vehicleSubType': vehicleType2,
              'vehicleId': vehicleNumber,
              'vehicleImage': vehicleImage,
              'fleetId': fleetId,
              'timestamp': DateTime.now().toIso8601String(),
            });
          });

          socket?.onDisconnect((_) {
            print('❌ [Background Isolate] Socket Disconnected');
            if (isDutyActive)
              updateNotification("NZCU Driver", "Reconnecting...");
          });

          // --- CONTINUOUS LOCATION EMITTER ---
          locationTimer?.cancel();
          locationTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
            if (socket == null || !socket!.connected) return;
            if (lastLat == 0.0 && lastLng == 0.0) return;

            await prefs.reload();
            final bool inRide = prefs.getBool("is_ride_in_progress") ?? false;
            final String? rideId = prefs.getString("active_ride_id");

            if (inRide && rideId != null && rideId.isNotEmpty) {
              socket?.emit('ride:location:update', {
                'rideId': rideId,
                'location': {
                  'latitude': lastLat,
                  'longitude': lastLng,
                  'lat': lastLat,
                  'lng': lastLng,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              });
            } else {
              print('📍 [Background Isolate] Emitting: $lastLat, $lastLng');
              socket?.emit('driver:location:update', {
                'latitude': lastLat,
                'longitude': lastLng,
                'role': 'Driver',
                'vehicleType': vehicleType,
                'vehicleSubType': vehicleType2,
                'vehicleId': vehicleNumber,
                'vehicleImage': vehicleImage,
                'fleetId': fleetId,
                'timestamp': DateTime.now().toIso8601String(),
              });
            }
          });

          // --- NATIVE GEO-TRACKING ---
          bg.BackgroundGeolocation.onLocation((bg.Location location) {
            lastLat = location.coords.latitude;
            lastLng = location.coords.longitude;
          });

          await bg.BackgroundGeolocation.ready(
            bg.Config(
              desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
              distanceFilter: 5.0,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              foregroundService: true,
              notification: bg.Notification(
                title: "NZCU Tracking",
                text: "Location tracking is active",
              ),
            ),
          );
          bg.BackgroundGeolocation.start();
        } catch (e) {
          print('❌ [Background Isolate] Socket Setup Error: $e');
        }
      }

      // 4. COMMAND LISTENERS
      service.on('goOnline').listen((_) async => await startDuty());
      service.on('goOffline').listen((_) async => await stopDuty());
      service.on('stopService').listen((_) => service.stopSelf());

      // 5. TERMINATION RESCUE
      final bool wasOnline = prefs.getBool("driver_is_online") ?? false;
      if (wasOnline) {
        print(
          "🔄 [Background Isolate] Termination detected - Resuming Online state...",
        );
        await startDuty();
      } else {
        updateNotification("NZCU Driver", "Ready to go online");
      }
    },
    (error, stack) {
      print("🚨 [Background Isolate] FATAL ERROR: $error");
      print(stack);
    },
  );
}

class BackgroundService {
  static const String NOTIFICATION_CHANNEL_ID = 'high_importance_channel';
  static const int NOTIFICATION_ID = 999;

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      NOTIFICATION_CHANNEL_ID,
      'Foreground Service Channel',
      importance: Importance.max,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: NOTIFICATION_CHANNEL_ID,
        initialNotificationTitle: 'NZCU Driver Service',
        initialNotificationContent: 'Connecting...',
        foregroundServiceNotificationId: NOTIFICATION_ID,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }
}
