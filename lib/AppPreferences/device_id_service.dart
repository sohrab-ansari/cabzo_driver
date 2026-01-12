// services/device_id_service.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService extends GetxService {
  final Uuid uuid = const Uuid();
  
  // Get or create unique device ID
  Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if we already have a device ID saved
      String? savedDeviceId = prefs.getString('device_id');
      if (savedDeviceId != null && savedDeviceId.isNotEmpty) {
        return savedDeviceId;
      }
      
      // Generate a new UUID
      final newDeviceId = uuid.v4();
      
      // Save for future use
      await prefs.setString('device_id', newDeviceId);
      
      return newDeviceId;
    } catch (e) {
      debugPrint('Error getting device ID: $e');
      // Generate a random UUID as fallback
      return 'fallback-${uuid.v4()}';
    }
  }
}