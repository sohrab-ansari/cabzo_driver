// // services/shared_pref_service.dart
// import 'dart:convert';
// import 'package:corezap_driver/modals/Otp_verify_res.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefService {
//   static SharedPrefService? _instance;
//   static SharedPreferences? _preferences;

//   // Private constructor
//   SharedPrefService._internal();

//   // Singleton instance
//   static Future<SharedPrefService> getInstance() async {
//     if (_instance == null) {
//       _instance = SharedPrefService._internal();
//       await _instance!._init();
//     }
//     return _instance!;
//   }

//   // Initialize SharedPreferences
//   Future<void> _init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   // Save auth data
//   Future<void> saveAuthData(OtpverifyRes otpResponse) async {
//     if (_preferences == null) await _init();
    
//     // Save token
//     if (otpResponse.token != null) {
//       await _preferences!.setString('token', otpResponse.token!);
//     }
    
//     // Save driver data
//     if (otpResponse.driver != null) {
//       final driverJson = jsonEncode(otpResponse.driver!.toJson());
//       await _preferences!.setString('driver', driverJson);
//     }
    
//     // Save phone number
//     if (otpResponse.driver?.phone != null) {
//       await _preferences!.setString('phone', otpResponse.driver!.phone!);
//     }
    
//     // Save login status
//     await _preferences!.setBool('isLoggedIn', true);
//   }

//   // Get token
//   String? getToken() {
//     if (_preferences == null) return null;
//     return _preferences!.getString('token');
//   }

//   // Get driver data
//   Driver? getDriver() {
//     if (_preferences == null) return null;
    
//     final driverJson = _preferences!.getString('driver');
//     if (driverJson != null) {
//       try {
//         final driverMap = jsonDecode(driverJson) as Map<String, dynamic>;
//         return Driver.fromJson(driverMap);
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error parsing driver data: $e');
//         }
//         return null;
//       }
//     }
//     return null;
//   }

//   // Get phone number
//   String? getPhoneNumber() {
//     if (_preferences == null) return null;
//     return _preferences!.getString('phone');
//   }

//   // Check if user is logged in
//   bool isLoggedIn() {
//     if (_preferences == null) return false;
//     return _preferences!.getBool('isLoggedIn') ?? false;
//   }

//   // Check if profile is completed
//   bool isProfileCompleted() {
//     final driver = getDriver();
//     return driver?.isProfileCompleted ?? false;
//   }

//   // Save FCM Token
//   Future<void> saveFcmToken(String fcmToken) async {
//     if (_preferences == null) await _init();
//     await _preferences!.setString('fcm_token', fcmToken);
//   }

//   // Get FCM Token
//   String? getFcmToken() {
//     if (_preferences == null) return null;
//     return _preferences!.getString('fcm_token');
//   }

//   // Save Device ID
//   Future<void> saveDeviceId(String deviceId) async {
//     if (_preferences == null) await _init();
//     await _preferences!.setString('device_id', deviceId);
//   }

//   // Get Device ID
//   String? getDeviceId() {
//     if (_preferences == null) return null;
//     return _preferences!.getString('device_id');
//   }

//   // Save any string value
//   Future<void> saveString(String key, String value) async {
//     if (_preferences == null) await _init();
//     await _preferences!.setString(key, value);
//   }

//   // Get any string value
//   String? getString(String key) {
//     if (_preferences == null) return null;
//     return _preferences!.getString(key);
//   }

//   // Save any bool value
//   Future<void> saveBool(String key, bool value) async {
//     if (_preferences == null) await _init();
//     await _preferences!.setBool(key, value);
//   }

//   // Get any bool value
//   bool getBool(String key) {
//     if (_preferences == null) return false;
//     return _preferences!.getBool(key) ?? false;
//   }

//   // Clear all data (logout)
//   Future<void> clearAll() async {
//     if (_preferences == null) await _init();
//     await _preferences!.clear();
//   }

//   // Remove specific key
//   Future<void> remove(String key) async {
//     if (_preferences == null) await _init();
//     await _preferences!.remove(key);
//   }
// }


// services/shared_pref_service.dart
import 'dart:convert';
import 'package:corezap_driver/modals/Otp_verify_res.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:corezap_driver/models/otp_verify_res.dart';

class SharedPrefService {
  static SharedPrefService? _instance;
  static SharedPreferences? _preferences;

  SharedPrefService._internal();

  static Future<SharedPrefService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefService._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save auth data
  Future<void> saveAuthData(OtpverifyRes otpResponse) async {
    if (_preferences == null) await _init();
    
    // Save token
    if (otpResponse.token != null) {
      await _preferences!.setString('token', otpResponse.token!);
    }
    
    // Save driver data
    if (otpResponse.driver != null) {
      final driverJson = jsonEncode(otpResponse.driver!.toJson());
      await _preferences!.setString('driver', driverJson);
    }
    
    // Save phone number
    if (otpResponse.driver?.phone != null) {
      await _preferences!.setString('phone', otpResponse.driver!.phone!);
    }
    
    // Save login status
    await _preferences!.setBool('isLoggedIn', true);
  }

  // Get token
  String? getToken() {
    if (_preferences == null) return null;
    return _preferences!.getString('token');
  }

  // Get driver data
  Driver? getDriver() {
    if (_preferences == null) return null;
    
    final driverJson = _preferences!.getString('driver');
    if (driverJson != null) {
      try {
        final driverMap = jsonDecode(driverJson) as Map<String, dynamic>;
        return Driver.fromJson(driverMap);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing driver data: $e');
        }
        return null;
      }
    }
    return null;
  }

  // Get phone number
  String? getPhoneNumber() {
    if (_preferences == null) return null;
    return _preferences!.getString('phone');
  }

  // Check if user is logged in
  bool isLoggedIn() {
    if (_preferences == null) return false;
    return _preferences!.getBool('isLoggedIn') ?? false;
  }

  // Check if profile is completed
  bool isProfileCompleted() {
    final driver = getDriver();
    return driver?.isProfileCompleted ?? false;
  }

  // Save FCM Token
  Future<void> saveFcmToken(String fcmToken) async {
    if (_preferences == null) await _init();
    await _preferences!.setString('fcm_token', fcmToken);
  }

  // Get FCM Token
  String? getFcmToken() {
    if (_preferences == null) return null;
    return _preferences!.getString('fcm_token');
  }

  // Save Device ID
  Future<void> saveDeviceId(String deviceId) async {
    if (_preferences == null) await _init();
    await _preferences!.setString('device_id', deviceId);
  }

  // Get Device ID
  String? getDeviceId() {
    if (_preferences == null) return null;
    return _preferences!.getString('device_id');
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    if (_preferences == null) await _init();
    await _preferences!.clear();
  }

  // Remove specific key
  Future<void> remove(String key) async {
    if (_preferences == null) await _init();
    await _preferences!.remove(key);
  }
}