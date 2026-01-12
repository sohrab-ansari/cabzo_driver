// services/fcm_token_service.dart
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FcmTokenService extends GetxService {
  final Uuid uuid = const Uuid();
  
  // Get or create FCM token (mock/fallback version)
  Future<String> getOrCreateFcmToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if we already have a token saved
      String? savedToken = prefs.getString('fcm_token');
      if (savedToken != null && savedToken.isNotEmpty) {
        return savedToken;
      }
      
      // Generate a new token (in real app, get from Firebase)
      final newToken = 'fcm-${uuid.v4()}';
      
      // Save for future use
      await prefs.setString('fcm_token', newToken);
      
      return newToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return 'fcm-fallback-${uuid.v4()}';
    }
  }
}