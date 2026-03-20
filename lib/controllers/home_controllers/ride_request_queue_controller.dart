import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideRequestItem {
  RideRequestItem({
    required this.orderId,
    required this.rideData,
    required this.totalSeconds,
  }) {
    remainingSeconds.value = totalSeconds;
    progress.value = totalSeconds > 0 ? 1.0 : 0.0;
  }

  final String orderId;
  final RxMap<String, dynamic> rideData;

  final int totalSeconds;
  final RxInt remainingSeconds = 0.obs;
  final RxDouble progress = 1.0.obs;

  Timer? _timer;

  void start({
    required VoidCallback onExpired,
  }) {
    _timer?.cancel();

    if (totalSeconds <= 0) {
      remainingSeconds.value = 0;
      progress.value = 0.0;
      onExpired();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = remainingSeconds.value - 1;
      remainingSeconds.value = next.clamp(0, totalSeconds);
      progress.value = totalSeconds == 0 ? 0.0 : remainingSeconds.value / totalSeconds;

      if (remainingSeconds.value <= 0) {
        t.cancel();
        onExpired();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

class RideRequestQueueController extends GetxController {
  /// Pending ride requests (newest first).
  final RxList<RideRequestItem> rideRequests = <RideRequestItem>[].obs;

  /// Tracks whether the queue screen is currently visible.
  final RxBool isQueueScreenOpen = false.obs;

  /// When non-empty, UI can disable other cards to prevent double actions.
  final RxString acceptingOrderId = ''.obs;

  bool get hasRides => rideRequests.isNotEmpty;

  static String? _extractOrderId(Map<String, dynamic> rideData) {
    final orderId =
        rideData['orderId'] ??
        rideData['_id'] ??
        rideData['id'] ??
        rideData['rideId'];
    return orderId?.toString();
  }

  static int _extractTimeoutSeconds(Map<String, dynamic> rideData) {
    final raw = rideData['timeout'] ?? rideData['timeOut'] ?? rideData['ttl'];
    if (raw is int) return raw;
    if (raw is double) return raw.toInt();
    if (raw is String) return int.tryParse(raw) ?? 25;
    return 25;
  }

  RideRequestItem? findByOrderId(String orderId) {
    try {
      return rideRequests.firstWhere((e) => e.orderId == orderId);
    } catch (_) {
      return null;
    }
  }

  /// Add or update an incoming ride request.
  void addOrUpdateRide(Map<String, dynamic> rideData) {
    final orderId = _extractOrderId(rideData);
    if (orderId == null || orderId.isEmpty) {
      AppLogger.w('🧾 [RideQueue] Ignoring ride without orderId: $rideData');
      return;
    }

    // If driver is currently accepting something, we still queue for visibility.
    final existingIndex = rideRequests.indexWhere((e) => e.orderId == orderId);
    final timeoutSeconds = _extractTimeoutSeconds(rideData);

    if (existingIndex >= 0) {
      final existing = rideRequests[existingIndex];
      existing.rideData.assignAll(rideData);
      AppLogger.i('🧾 [RideQueue] Updated existing ride card orderId=$orderId timeout=$timeoutSeconds');
      return;
    }

    final item = RideRequestItem(
      orderId: orderId,
      rideData: RxMap<String, dynamic>.from(rideData),
      totalSeconds: timeoutSeconds,
    );

    // Newest first.
    rideRequests.insert(0, item);

    AppLogger.i(
      '🧾 [RideQueue] Added ride card orderId=$orderId timeout=$timeoutSeconds (queue=${rideRequests.length})',
    );

    item.start(onExpired: () async {
      AppLogger.w('⏱️ [RideQueue] Timeout expired orderId=$orderId. Auto-declining (best effort).');
      NotificationService.instance.cancelRideNotification();
      await _declineOrderApi(orderId);
      removeRide(orderId, reason: 'timeout');
    });
  }

  void markAccepting(String orderId) {
    acceptingOrderId.value = orderId;
    AppLogger.d('✅ [RideQueue] Mark accepting orderId=$orderId');
  }

  void clearAccepting() {
    if (acceptingOrderId.value.isNotEmpty) {
      AppLogger.d('✅ [RideQueue] Clear accepting orderId=${acceptingOrderId.value}');
    }
    acceptingOrderId.value = '';
  }

  void removeRide(String orderId, {String reason = 'manual'}) {
    final idx = rideRequests.indexWhere((e) => e.orderId == orderId);
    if (idx < 0) return;

    final item = rideRequests.removeAt(idx);
    item.stop();
    AppLogger.i('🧾 [RideQueue] Removed ride card orderId=$orderId reason=$reason (queue=${rideRequests.length})');

    if (acceptingOrderId.value == orderId) {
      clearAccepting();
    }
  }

  Future<void> declineRideNow(String orderId, {String reason = 'decline'}) async {
    AppLogger.i('❌ [RideQueue] Decline now orderId=$orderId reason=$reason');
    await _declineOrderApi(orderId);
    removeRide(orderId, reason: reason);
  }

  void clearAll({String reason = 'clear_all'}) {
    for (final r in rideRequests) {
      r.stop();
    }
    rideRequests.clear();
    clearAccepting();
    AppLogger.i('🧾 [RideQueue] Cleared all ride cards reason=$reason');
  }

  Future<void> _declineOrderApi(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final url = Uri.parse('${ApiPath.baseUri}/order/decline/$orderId');

      AppLogger.d('❌ [RideQueue] Decline API PATCH $url');

      final res = await http
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      AppLogger.d('❌ [RideQueue] Decline API status=${res.statusCode} body=${res.body}');

      if (res.statusCode < 200 || res.statusCode >= 300) return;

      try {
        final decoded = jsonDecode(res.body);
        AppLogger.i('❌ [RideQueue] Decline API ok orderId=$orderId message=${decoded is Map ? decoded['message'] : decoded}');
      } catch (_) {
        // Non-JSON body; ignore.
      }
    } catch (e, st) {
      AppLogger.w('❌ [RideQueue] Decline API failed orderId=$orderId error=$e', stackTrace: st);
    }
  }

  @override
  void onClose() {
    clearAll(reason: 'controller_close');
    super.onClose();
  }
}

