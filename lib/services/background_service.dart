/// BackgroundService — DEPRECATED
///
/// Background socket is now handled natively by
/// `android/app/src/main/kotlin/com/nzcu_driver/SocketForegroundService.kt`.
///
/// This file is kept only as a stub so existing imports don't break.
/// All methods are no-ops.
class BackgroundService {
  static Future<void> initializeService() async {}
  static Future<void> start() async {}
  static void stop() {}
  static void notifyOnline({
    required String vehicleType,
    required String vehicleId,
    String? vehicleSubType,
    String? vehicleImage,
    String? fleetId,
  }) {}
  static void notifyAppState(String state) {}
  static void sendHeartbeat() {}
}
