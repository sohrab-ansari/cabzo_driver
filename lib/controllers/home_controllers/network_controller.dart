import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';

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
    bool previousConnection = isOnline.value;
    isOnline.value = hasConnection;
    print(
      '🌐 NetworkController: Connection status changed. Online: $hasConnection ($results)',
    );

    // If we just regained connection and driver is supposed to be online
    if (!previousConnection && hasConnection) {
      print('🌐 NetworkController: Internet restored. Forcing socket reconnect if on duty.');
      
      // Delay slightly to ensure network is fully stable
      Future.delayed(const Duration(seconds: 2), () {
        try {
          // Import SocketManager if it isn't already, but we need to ensure it's available.
          // Since it's a singleton, we can just call it if it's imported.
          SocketManager().forceReconnect();
        } catch (e) {
          print('Error triggering reconnect: $e');
        }
      });
    }
  }
}

