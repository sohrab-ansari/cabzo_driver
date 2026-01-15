

// import 'dart:async';
// import 'dart:convert';

// import 'package:corezap_driver/AppPreferences/apiUrl.dart';
// import 'package:corezap_driver/AppPreferences/shared_pref_service.dart';
// import 'package:corezap_driver/modals/Otp_verify_res.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class AuthApi extends GetxService {
//   // loaders
//   RxBool sendOtpLoader = false.obs;
//   RxBool verifyOtpLoader = false.obs;
//   RxBool updateProfileLoading = false.obs;

//   // otp
//   RxString receivedOtp = ''.obs;
//   RxInt otpTimer = 30.obs;

//   // user data
//   RxString userPhone = ''.obs;
//   RxString userName = 'User'.obs;
//   RxString userEmail = 'user@gmail.com'.obs;
//   RxString userImage = ''.obs;

//   // auth
//   RxString authToken = ''.obs;
//   final Rx<Driver?> driver = Rx<Driver?>(null);

//   late SharedPrefService _sharedPrefService;

//   @override
//   void onInit() async {
//     super.onInit();
//     _sharedPrefService = await SharedPrefService.getInstance();
//     await _loadSavedData();
//   }

//   // ================= LOAD SAVED DATA =================

//   Future<void> _loadSavedData() async {
//     try {
//       final savedToken = _sharedPrefService.getToken();
//       if (savedToken != null) {
//         authToken.value = savedToken;
//       }

//       final savedDriver = _sharedPrefService.getDriver();
//       if (savedDriver != null) {
//         driver.value = savedDriver;
//         userPhone.value = savedDriver.phone ?? '';
//         userName.value = savedDriver.name ?? 'User';
//         userEmail.value = savedDriver.email ?? '';
//       }
//     } catch (e) {
//       debugPrint("Load saved data error: $e");
//     }
//   }

//   // ================= SEND OTP =================

//   Future<Map<String, dynamic>> sendOtpApi(String mobile) async {
//     sendOtpLoader.value = true;

//     try {
//       final body = {"mobile": mobile};

//       final request = http.Request(
//         'POST',
//         Uri.parse(ApiUrl.registerLogin),
//       );

//       request.headers.addAll({
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       request.body = jsonEncode(body);

//       /// 🔥 REQUEST LOG
//       print("====== SEND OTP REQUEST ======");
//       print("URL: ${ApiUrl.registerLogin}");
//       print("Headers: ${request.headers}");
//       print("Body: ${jsonEncode(body)}");
//       print("================================");

//       final response = await request.send();
//       final result = await response.stream.bytesToString();

//       /// 🔥 RESPONSE LOG
//       print("====== SEND OTP RESPONSE ======");
//       print("Status Code: ${response.statusCode}");
//       print("Body: $result");
//       print("================================");

//       final finalResponse = jsonDecode(result);

//       if (finalResponse['success'] == true) {
//         receivedOtp.value = finalResponse['otp'].toString();
//         userPhone.value = mobile;

//         return {
//           'success': true,
//           'message': finalResponse['message'],
//           'otp': finalResponse['otp'].toString(),
//         };
//       } else {
//         return {
//           'success': false,
//           'message':
//               finalResponse['error'] ?? finalResponse['message'] ?? 'Failed',
//           'otp': '',
//         };
//       }
//     } catch (e) {
//       debugPrint("Send OTP Error: $e");
//       return {
//         'success': false,
//         'message': 'Connection error',
//         'otp': '',
//       };
//     } finally {
//       sendOtpLoader.value = false;
//     }
//   }

//   // ================= OTP TIMER =================

//   void startOtpTimer() {
//     otpTimer.value = 30;
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (otpTimer.value > 0) {
//         otpTimer.value--;
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   // ================= VERIFY OTP =================

//   Future<OtpverifyRes?> verifyOtpApi(
//     String mobile,
//     String otp,
//     String fcmToken,
//     String deviceId,
//   ) async {
//     verifyOtpLoader.value = true;

//     try {
//       final body = {
//         "mobile": "9908479624",
//         "otp": "1234",
//         "fcmToken": "fcm-a6e6fd4f-7e86-48e2-a306-9865f6c3ea3a",
//         "deviceId": "299258e0-75e5-4e43-be09-7ae53e626480",
//       };

//       final request = http.Request(
//         'POST',
//         Uri.parse(ApiUrl.verifyOtp),
//       );

//       request.headers.addAll({
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       });

//       request.body = jsonEncode(body);

//       /// 🔥 REQUEST LOG
//       print("====== VERIFY OTP REQUEST ======");
//       print("URL: ${ApiUrl.verifyOtp}");
//       print("Headers: ${request.headers}");
//       print("Body: ${jsonEncode(body)}");
//       print("================================");

//       final response = await request.send();
//       final result = await response.stream.bytesToString();

//       /// 🔥 RESPONSE LOG
//       print("====== VERIFY OTP RESPONSE ======");
//       print("Status Code: ${response.statusCode}");
//       print("Reason: ${response.reasonPhrase}");
//       print("Raw Body: $result");
//       print("================================");

//       final otpResponse = otpverifyResFromJson(result);

//       print("====== PARSED RESPONSE ======");
//       print("Success: ${otpResponse.success}");
//       print("Message: ${otpResponse.message}");
//       print("Token: ${otpResponse.token}");
//       print("Driver: ${otpResponse.driver}");
//       print("================================");

//       if (otpResponse.success == true) {
//         await _sharedPrefService.saveAuthData(otpResponse);

//         authToken.value = otpResponse.token ?? '';
//         driver.value = otpResponse.driver;

//         if (otpResponse.driver != null) {
//           userPhone.value = otpResponse.driver!.phone ?? mobile;
//           userName.value = otpResponse.driver!.name ?? 'User';
//           userEmail.value = otpResponse.driver!.email ?? '';
//         }
//       }

//       return otpResponse;
//     } catch (e) {
//       debugPrint("Verify OTP Error: $e");
//       return null;
//     } finally {
//       verifyOtpLoader.value = false;
//     }
//   }

//   // ================= AUTH HELPERS =================

//   bool isLoggedIn() {
//     return _sharedPrefService.isLoggedIn();
//   }

//   bool isProfileCompleted() {
//     return _sharedPrefService.isProfileCompleted();
//   }

//   Future<void> logout() async {
//     await _sharedPrefService.clearAll();
//     authToken.value = '';
//     driver.value = null;
//     userPhone.value = '';
//     userName.value = 'User';
//     userEmail.value = '';
//     userImage.value = '';
//   }
// }
