import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  // Reactive variable for online status
  final isOnline = true.obs;

  // Connectivity instance
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      print('❌ NetworkController: Error checking connectivity: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // If ANY interface has connection, we are online
    // connectivity_plus 6.0 returns a List<ConnectivityResult>
    bool hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    // Additional check: connectivity_plus says "connected" even if verify fail
    // In a real app we might ping google.com, but for this specific issue
    // just checking network interface is enough to unblock the "No Internet" UI

    isOnline.value = hasConnection;
    print(
      '🌐 NetworkController: Connection status changed. Online: $hasConnection ($results)',
    );
  }
}
