import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/modals/auth_modals/Otp_verify_res.dart';
import 'package:nzcu_driver/modals/auth_modals/create_vehicle_res.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_sub_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/auth_modals/register_profile_res.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  static final ApiPath apiPath = Get.put(ApiPath());

  static Future<bool> sendOtp({required String phone}) async {
    final Uri url = Uri.parse("${ApiPath.registerLogin}");

    final Map<String, dynamic> requestBody = {"phone": phone};

    // final Map<String, dynamic> requestBody = {"phone": "9908479999"};

    print("========== SEND OTP API ==========");
    print("URL : $url");
    print("Request Body : ${jsonEncode(requestBody)}");

    try {
      final http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      print("Response Body222 : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);

      Fluttertoast.showToast(
        msg: data['message'] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      //  Fluttertoast.showToast(
      //   msg: data['error'] ?? "Something went wrong",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      // );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print("Parsed Response : $data");

        print(">>>>>>helloooooo2222  ");

        return data["success"] == true;
      } else {
        print(">>>>>>helloooooo  ");
        Fluttertoast.showToast(
          msg: data['error'] ?? "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        print("❌ Server error");
        return false;
      }
    } catch (e) {
      print("❌ Exception in Send OTP : $e");
      return false;
    }
  }

  static Future<OtpverifyRes> verifyOtp({
    required String otp,
    String? phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Save FCM token
    await prefs.getString('fcmToken');

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    print(
      'fcmm___token_from_shared_preferences: ${prefs.getString('fcmToken')}',
    );

    final Uri url = Uri.parse(ApiPath.verifyOtp);

    final Map<String, dynamic> requestBody = {
      "otp": otp,
      "phone": phoneNumber ?? "9908479999",
      "fcmToken": prefs.getString('fcmToken') ?? "test-fcm-token-123",
      "deviceId": androidInfo.id,
    };

    print("otppppp_veriffyyyy___ ${requestBody}");

    try {
      final http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      print("Status Code : ${response.statusCode}");
      print("Response Message : ${data['message']}");
      print("Full Driver Object : ${data['driver']}");

      // Check if the response indicates failure
      if (data['success'] == false) {
        // Extract error message
        String errorMessage = data['message'] ?? 'Failed to verify OTP';
        if (data['error'] != null) {
          errorMessage = data['error'];
        } else if (data['errors'] != null) {
          errorMessage = data['errors'].toString();
        }

        print("Error occurred: $errorMessage");

        // Show red toast at top
        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        return OtpverifyRes(success: false, message: errorMessage);
      }

      final String? driverId = data['driver']?['id']?.toString();
      print("Driver ID : $driverId");

      final OtpverifyRes otpResponse = OtpverifyRes.fromJson(data);

      print(
        "isprofileee_verifyyyyy_check ${otpResponse.driver!.isProfileCompleted}",
      );

      if (otpResponse.driver!.isProfileCompleted == true) {
        print(
          "✅ OTP verified and profile is complete. Saving token and driver ID.",
        );

        /// ✅ SAVE TOKEN & DRIVER ID
        if (otpResponse.token != null &&
            otpResponse.token!.isNotEmpty &&
            driverId != null &&
            driverId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", otpResponse.token!);
          await prefs.setString("driver_userid", driverId);

          if (otpResponse.driver?.name != null &&
              otpResponse.driver!.name!.isNotEmpty) {
            await prefs.setString("driver_name", otpResponse.driver!.name!);
          }
        }

        // Show success toast (optional)
        Fluttertoast.showToast(
          msg: "OTP verified successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } else {
        print("else__data_storedd");
        if (otpResponse.token != null &&
            otpResponse.token!.isNotEmpty &&
            driverId != null &&
            driverId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token2", otpResponse.token!);
          await prefs.setString("driver_userid2", driverId);

          print("getting storeddd token2 ${prefs.getString("auth_token2")}");
          print("getting storeddd token2 ${prefs.getString("driver_userid2")}");

          if (otpResponse.driver?.name != null &&
              otpResponse.driver!.name!.isNotEmpty) {
            await prefs.setString("driver_name2", otpResponse.driver!.name!);
          }
        }
      }
      return otpResponse;
    } catch (e) {
      print("OTP verify API failed");

      final prefs = await SharedPreferences.getInstance();
      String? accountStatus = prefs.getString("account_status");

      if (accountStatus == null || accountStatus.isEmpty) {
        // If nothing stored
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again. $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else if (accountStatus == "pending") {
        // If pending stored
        Fluttertoast.showToast(
          msg: "Please wait, adminnt.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        await prefs.setString("account_status", "Not_pending");
      }

      return OtpverifyRes(success: false, message: "Connection error");

      //   catch (e)  {

      // final prefs = await SharedPreferences.getInstance();

      // // Example: check auth_token
      // String? token = prefs.getString("auth_token");

      // // If token is empty or null → show custom message
      // if (token == null || token.isEmpty) {

      //   Fluttertoast.showToast(
      //     msg: "Please login again.",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.TOP,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 14.0,
      //   );

      // } else {

      //   // Optional: show generic message
      //   Fluttertoast.showToast(
      //     msg: "Something went wrong. Try again.",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.TOP,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 14.0,
      //   );
      // }

      // return OtpverifyRes(success: false, message: "Connection error");
    }

    // catch (e) {
    //   String errorMessage = "Connection error: $e";
    //   print(errorMessage);

    //   // Show red toast at top for connection errors
    //   Fluttertoast.showToast(
    //     msg: errorMessage,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.TOP,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 14.0,
    //   );

    //   return OtpverifyRes(success: false, message: "Connection error");
    // }
  }

  // static Future<OtpverifyRes> verifyOtp({
  //   required String otp,
  //   String? phoneNumber,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // Save FCM token

  //   await prefs.getString('fcmToken');

  //   final deviceInfo = DeviceInfoPlugin();
  //   final androidInfo = await deviceInfo.androidInfo;
  //   print(
  //     'fcmm___token_from_shared_preferences: ${prefs.getString('fcmToken')}',
  //   );

  //   final Uri url = Uri.parse(ApiPath.verifyOtp);

  //   final Map<String, dynamic> requestBody = {
  //     "otp": otp,
  //     "phone": phoneNumber ?? "9908479999",
  //     // "fcmToken": "test-fcm-token-123",
  //     "fcmToken": prefs.getString('fcmToken') ?? "test-fcm-token-123",

  //     //  androidInfo.id;
  //     // "deviceId": "device-001",
  //     "deviceId": androidInfo.id,
  //   };

  //   print("otppppp_veriffyyyy___ ${requestBody}");

  //   try {
  //     final http.Response response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(requestBody),
  //     );

  //     final Map<String, dynamic> data = jsonDecode(response.body);

  //     print("otpppp>>>> ${data}");

  //     print("Status Code : ${response.statusCode}");
  //     print("Response Message : ${data['message']}");
  //     print("Full Driver Object : ${data['driver']}");

  //     final String? driverId = data['driver']?['id']?.toString();
  //     print("Driver ID : $driverId");

  //     final OtpverifyRes otpResponse = OtpverifyRes.fromJson(data);

  //     print(
  //       "isprofileee_verifyyyyy_check ${otpResponse.driver!.isProfileCompleted}",
  //     );

  //     if (otpResponse.driver!.isProfileCompleted == true) {
  //       print(
  //         "✅ OTP verified and profile is complete. Saving token and driver ID.",
  //       );

  //       /// ✅ SAVE TOKEN & DRIVER ID
  //       if (otpResponse.token != null &&
  //           otpResponse.token!.isNotEmpty &&
  //           driverId != null &&
  //           driverId.isNotEmpty) {
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString("auth_token", otpResponse.token!);
  //         await prefs.setString("driver_userid", driverId);

  //         if (otpResponse.driver?.name != null &&
  //             otpResponse.driver!.name!.isNotEmpty) {
  //           await prefs.setString("driver_name", otpResponse.driver!.name!);
  //         }
  //       }
  //     } else {
  //       print("else__data_storedd");
  //       if (otpResponse.token != null &&
  //           otpResponse.token!.isNotEmpty &&
  //           driverId != null &&
  //           driverId.isNotEmpty) {
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString("auth_token2", otpResponse.token!);
  //         await prefs.setString("driver_userid2", driverId);

  //         print("getting storeddd token2 ${prefs.getString("auth_token2")}");
  //         print("getting storeddd token2 ${prefs.getString("driver_userid2")}");

  //         if (otpResponse.driver?.name != null &&
  //             otpResponse.driver!.name!.isNotEmpty) {
  //           await prefs.setString("driver_name2", otpResponse.driver!.name!);
  //         }
  //       }
  //     }
  //     return otpResponse;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Connection error $e");
  //     return OtpverifyRes(success: false, message: "Connection error");
  //   }
  // }

  // static Future<OtpverifyRes> verifyOtp({
  //   required String otp,
  //   String? phoneNumber,
  // }) async {
  //   final Uri url = Uri.parse(ApiPath.verifyOtp);

  //   final Map<String, dynamic> requestBody = {
  //     "otp": otp,
  //     "phone": phoneNumber ?? "9908479999",
  //     "fcmToken": "test-fcm-token-123",
  //     "deviceId": "device-001",
  //   };

  //   try {
  //     final http.Response response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(requestBody),
  //     );

  //     final Map<String, dynamic> data = jsonDecode(response.body);

  //     print("Status Code : ${response.statusCode}");
  //     print("Response Message : ${data['message']}");

  //  print("Response Message otp verify full respsone  : ${data['driver']}");
  //  print("Response Message otp verify full respsone  : ${data['driver']['id']}");

  //  print("Driver ID : ${data['driver']['id']}");

  //     /// 🔔 SHOW TOAST MESSAGE
  //     // Fluttertoast.showToast(
  //     //   msg: data['message'] ?? "Something went wrong",
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.BOTTOM,
  //     // );
  //     //  Fluttertoast.showToast(
  //     //   msg: data['error'] ?? "Something went wrong",
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.BOTTOM,
  //     // );

  //     // "error": "Maximum OTP attempts exceeded. Please request a new OTP"

  //     final OtpverifyRes otpResponse = OtpverifyRes.fromJson(data);

  //     /// ✅ SAVE TOKEN IF EXISTS
  //     if (otpResponse.token != null && otpResponse.token!.isNotEmpty) {
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("auth_token", otpResponse.token!);
  //    await prefs.setString("driver_userid", data['driver']['id']);

  //       // prefs.getString("driver_userid");
  //     }

  //     return otpResponse;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Connection error");
  //     return OtpverifyRes(success: false, message: "Connection error");
  //   }
  // }

  void prettyPrintJson(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      const encoder = JsonEncoder.withIndent('  '); // 2 space indent
      final prettyString = encoder.convert(decoded);
      print(prettyString);
    } catch (e) {
      print("Invalid JSON: $e");
      print(responseBody); // fallback normal print
    }
  }

  static Future<CreateVehicleRes> createVehicle_Api({
    required String vehicleName,
    String? vehicleNumber,
    String? vehicleColor,
    String? vehicleType,
    String? vehicleStatus,
    String? vehicleModel,
    int? vehicleCapacity,
    String? driverId,
    String? vehicleSubType,
    int? vehicleYear,
    File? rcImage,
    File? vehicleInsuraneImage,
    File? vehicleNumberImage,
  }) async {
    // Print all received parameters
    print("\n📋 VEHICLE CREATION PARAMETERS:");
    print("├─ vehicleName: $vehicleName");
    print("├─ vehicleNumber: $vehicleNumber");
    print("├─ vehicleColor: $vehicleColor");
    print("├─ vehicleType: $vehicleType");
    print("├─ vehicleStatus: $vehicleStatus");
    print("├─ vehicleModel: $vehicleModel");
    print(
      "├─ vehicleCapacity: $vehicleCapacity (type: ${vehicleCapacity.runtimeType})",
    );
    print("├─ driverId: $driverId");
    print("├─ vehicleSubType: $vehicleSubType");
    print("├─ vehicleYear: $vehicleYear");
    print("├─ rcImage: ${rcImage?.path ?? 'NULL'}");
    print("├─ vehicleInsuraneImage: ${vehicleInsuraneImage?.path ?? 'NULL'}");
    print("└─ vehicleNumberImage: ${vehicleNumberImage?.path ?? 'NULL'}");

    final Uri url = Uri.parse(ApiPath.createVehicle);

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");
    final String? userId = prefs.getString("driver_userid2");

    print("Token: $token");
    print("User ID from SharedPreferences: $userId");

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add text fields - Use userId from SharedPreferences if driverId is null
      final actualDriverId = userId ?? "";

      request.fields['vehicleName'] = vehicleName;
      request.fields['vehicleNumber'] = vehicleNumber ?? "";
      request.fields['vehicleColor'] = vehicleColor ?? "";
      request.fields['vehicleType'] = vehicleType ?? "";
      request.fields['vehicleStatus'] = vehicleStatus ?? "Active";
      request.fields['vehicleModel'] = vehicleModel ?? "";
      request.fields['vehicleSubType'] = vehicleSubType ?? "";

      // Handle vehicleCapacity - convert int to string
      if (vehicleCapacity != null) {
        request.fields['vehicleCapacity'] = vehicleCapacity.toString();
      } else {
        request.fields['vehicleCapacity'] = "4"; // default value
      }

      if (vehicleYear != null) {
        request.fields['vehicleYear'] = vehicleYear.toString();
      } else {
        request.fields['vehicleYear'] = "";
      }

      request.fields['driverId'] = actualDriverId;

      print("Text fields added to request");
      print("Using driverId: $actualDriverId");

      // Helper function to extract filename from path
      String getFileNameFromPath(String path) {
        final parts = path.split('/');
        return parts.isNotEmpty ? parts.last : 'image.jpg';
      }

      // Add RC image if exists
      if (rcImage != null && await rcImage.exists()) {
        final fileName = getFileNameFromPath(rcImage.path);
        print("Adding RC image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'rcImage',
            rcImage.path,
            filename: fileName,
          ),
        );
        print("✓ Added RC image as: $fileName");
      } else {
        print("RC Image is null or doesn't exist");
      }

      // Add Vehicle Insurance image if exists
      if (vehicleInsuraneImage != null && await vehicleInsuraneImage.exists()) {
        final fileName = getFileNameFromPath(vehicleInsuraneImage.path);
        print("Adding Vehicle Insurance image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleInsuraneImage',
            vehicleInsuraneImage.path,
            filename: fileName,
          ),
        );
        print("✓ Added Insurance image as: $fileName");
      } else {
        print("Vehicle Insurance Image is null or doesn't exist");
      }

      // Add Vehicle Number image if exists
      if (vehicleNumberImage != null && await vehicleNumberImage.exists()) {
        final fileName = getFileNameFromPath(vehicleNumberImage.path);
        print("Adding Vehicle Number image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleNumberImage',
            vehicleNumberImage.path,
            filename: fileName,
          ),
        );
        print("✓ Added Number Plate image as: $fileName");
      } else {
        print("Vehicle Number Image is null or doesn't exist");
      }

      print("\n========== CREATE VEHICLE API ==========");
      print("URL: $url");
      print("Request Fields: ${request.fields}");
      print("Number of Files: ${request.files.length}");

      // List all files with their field names and filenames
      for (var i = 0; i < request.files.length; i++) {
        var file = request.files[i];
        print("File $i: field='${file.field}', filename='${file.filename}'");
      }

      // Send request
      print("\n🚀 Sending request...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("\n📥 Response Received:");
      print("Status Code: ${response.statusCode}");

      // Check if response is HTML (error) or JSON
      if (responseBody.trim().startsWith('<!DOCTYPE') ||
          responseBody.trim().startsWith('<html>') ||
          response.statusCode >= 400) {
        print("❌ Server returned error");
        print("Response Body: $responseBody");

        // Fluttertoast.

        print("❌ Server returned error");
        print("Response Body: $responseBody");

        try {
          final decoded = jsonDecode(responseBody);

          Fluttertoast.showToast(
            msg: decoded['message'] ?? "Something went wrong",
            toastLength: Toast.LENGTH_SHORT, // ≈ 2 seconds
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );

          // Fluttertoast.showToast(
          //   msg: decoded['message'] ?? "Something went wrong",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.TOP,

          //   backgroundColor: Colors.red,
          // );
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
          );
        }

        //   Fluttertoast.showToast(
        //   msg: responseBody['']?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );

        String errorMessage = "Server error (${response.statusCode})";

        if (response.statusCode == 413) {
          errorMessage = "Images are too large. Please use smaller images.";
        } else if (responseBody.contains('MulterError:')) {
          final startIndex = responseBody.indexOf('MulterError:');
          final endIndex = responseBody.indexOf('<br>', startIndex);
          if (startIndex != -1 && endIndex != -1) {
            errorMessage = responseBody.substring(startIndex, endIndex);
          }
        }

        return CreateVehicleRes(success: false, message: errorMessage);
      }

      try {
        print("Response Body: $responseBody");
        final Map<String, dynamic> data = jsonDecode(responseBody);
        final CreateVehicleRes createVehicleRes = CreateVehicleRes.fromJson(
          data,
        );

        print("hellooo5");

        print("hello_regiter_vehical_Api");

        final data1 = jsonDecode(responseBody);

        const encoder = JsonEncoder.withIndent('  ');
        print(encoder.convert(data1));

        if (createVehicleRes.success == true) {
          print("✅ Vehicle created successfully!");

          print("hellooo4");

          print("after_suceesssssssss");
          final DriverFormController driverFormController =
              Get.find<DriverFormController>();
          // driverFormController.activeStep.value = 0;
          driverFormController.activeStep.value = 1;
        } else {
          print("hellooo2");
          print("❌ Vehicle creation failed: ${createVehicleRes.message}");
        }

        return createVehicleRes;
      } catch (e) {
        print("hellooo3");

        print("❌ Failed to parse JSON response: $e");
        print("Raw response: ${responseBody}");

        return CreateVehicleRes(
          success: false,
          message: "Invalid response format: $e",
        );
      }
    } catch (e) {
      print("❌ Exception in Create Vehicle API: $e");
      print("Stack trace: ${e.toString()}");
      return CreateVehicleRes(success: false, message: "Connection error: $e");
    }
  }

  static Future<RegisterProfileRes> createRegister_Api({
    required String name,
    String? email,
    File? dlImage,
    File? aadharFront,
    File? aadharBack,
    File? panImage,
    String? phone,
    String? dob,
    String? alternateContact1,
    String? relation1,
    String? address1,
    String? alternateContact2,
    String? relation2,
    String? address2,
  }) async {
    // Print all received parameters
    print("\n📋 RECEIVED PARAMETERS:");
    print("├─ name: $name");
    print("├─ email: $email");
    print("├─ phone: $phone");
    print("├─ dob: $dob");
    print("├─ dlImage: ${dlImage?.path ?? 'NULL'}");
    print("├─ aadharFront: ${aadharFront?.path ?? 'NULL'}");
    print("├─ aadharBack: ${aadharBack?.path ?? 'NULL'}");
    print("├─ panImage: ${panImage?.path ?? 'NULL'}");
    print("├─ alternateContact1: $alternateContact1");
    print("├─ relation1: $relation1");
    print("├─ address1: $address1");
    print("├─ alternateContact2: $alternateContact2");
    print("└─ relation2: $relation2");
    print("  └─ address2: $address2");

    final Uri url = Uri.parse(ApiPath.createPersonalDetails);

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");

    print("Token: $token");

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add text fields
      request.fields['name'] = name;
      request.fields['email'] = email ?? "";
      request.fields['phone'] = phone ?? "";
      request.fields['dob'] = dob ?? "";
      request.fields['alternateContact1'] = alternateContact1 ?? "";
      request.fields['relation1'] = relation1 ?? "";
      request.fields['address1'] = address1 ?? "";
      request.fields['alternateContact2'] = alternateContact2 ?? "";
      request.fields['relation2'] = relation2 ?? "";
      request.fields['address2'] = address2 ?? "";

      print("Text fields added to request");

      // Add DL image if exists
      if (dlImage != null && await dlImage.exists()) {
        print("Adding DL image: ${dlImage.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'dlImage',
            dlImage.path,
            filename: 'dl_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        print("DL Image is null or doesn't exist");
      }

      // Add Aadhar Front if exists
      if (aadharFront != null && await aadharFront.exists()) {
        print("Adding Aadhar Front image: ${aadharFront.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharFront',
            aadharFront.path,
            filename:
                'aadhar_front_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        print("Aadhar Front is null or doesn't exist");
      }

      // Add Aadhar Back if exists
      if (aadharBack != null && await aadharBack.exists()) {
        print("Adding Aadhar Back image: ${aadharBack.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharBack',
            aadharBack.path,
            filename:
                'aadhar_back_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        print("Aadhar Back is null or doesn't exist");
      }

      // Add PAN image if exists
      if (panImage != null && await panImage.exists()) {
        print("Adding PAN image: ${panImage.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'panImage',
            panImage.path,
            filename: 'pan_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        print("PAN Image is null or doesn't exist");
      }

      print("========== CREATE REGISTER API ==========");
      print("URL: $url");
      print("Request Fields: ${request.fields}");
      print("Number of Files: ${request.files.length}");

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseBody");

      //   Fluttertoast.showToast(
      //   msg: message,
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.TOP,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );

      final Map<String, dynamic> data = jsonDecode(responseBody);
      final RegisterProfileRes registerProfileRes = RegisterProfileRes.fromJson(
        data,
      );

      final data1 = jsonDecode(responseBody);

      const encoder = JsonEncoder.withIndent('  ');
      print(encoder.convert(data1));

      // Save driver user ID to SharedPreferences
      // Check if response is successful, has data, and ID is not null
      if (registerProfileRes.success == true &&
          registerProfileRes.data != null &&
          registerProfileRes.data!.id != null) {
        // Use ! to assert non-null or provide default value
        await prefs.setString("driver_userid", registerProfileRes.data!.id!);
        print(
          "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        );
      } else {
        print("theee_errorrr_hererrrr ${data['message']}");
        print(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );

        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }

      return registerProfileRes;
    } catch (e) {
      print("❌ Exception in Create Register: $e");
      return RegisterProfileRes(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<DriverImageUploadRes> uploadNewDriverImage({
    required File image,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("driver_userid2");
    final String? token = prefs.getString("auth_token2");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
    );

    try {
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        })
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        final res = DriverImageUploadRes.fromJson(jsonDecode(body));

        // 🔴 SHOW ERROR TOAST DIRECTLY HERE
        if (res.success == false) {
          final data1 = jsonDecode(body);

          const encoder = JsonEncoder.withIndent('  ');
          print(encoder.convert(data1));
          Fluttertoast.showToast(
            msg: res.message ?? "Something went wrong",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14,
          );
        }

        return res;
      } else {
        Fluttertoast.showToast(
          msg: "Unexpected server response",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        return DriverImageUploadRes(
          success: false,
          message: "Unexpected server response",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return DriverImageUploadRes(success: false, message: "Network error");
    }
  }

  //   static Future<DriverImageUploadRes> uploadNewDriverImage({
  //   required File image,
  //   required String userType,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? userId = prefs.getString("driver_userid2");
  //   final String? token = prefs.getString("auth_token2");

  //   final Uri url = Uri.parse(
  //     "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
  //   );

  //   print("URL => $url");

  //   try {
  //     final request = http.MultipartRequest('PUT', url)
  //       ..headers.addAll({
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       })
  //       ..files.add(
  //         await http.MultipartFile.fromPath('image', image.path),
  //       );

  //     final response = await request.send();
  //     final body = await response.stream.bytesToString();

  //     print("Status Code: ${response.statusCode}");
  //     print("Response Body: $body");

  //     if (response.headers['content-type']
  //             ?.contains('application/json') ==
  //         true) {

  //           print("hellooo1");
  //       return DriverImageUploadRes.fromJson(jsonDecode(body));
  //     } else {

  //       print("hellooo2");
  //       return DriverImageUploadRes(
  //         success: false,
  //         message: "Unexpected server response",
  //       );
  //     }
  //   } catch (e) {

  //     print("hellooo3");
  //     print("Upload error: $e");
  //     return DriverImageUploadRes(
  //       success: false,
  //       message: e.toString(),
  //     );
  //   }
  // }

  // static Future<DriverImageUploadRes> uploadNewDriverImage({
  //   required File image,

  //   required String userType,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? userId = prefs.getString("driver_userid2");

  //   print("the_paramssss1 ${image}");
  //   print("the_paramssss2 ${userId}");
  //   print("the_paramssss3 ${userType}");

  //   print("the_paramssss3_useriddd ${userId}");

  //   final Uri url = Uri.parse(
  //     "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
  //   );

  //   print("URL => $url");

  //   final token = prefs.getString("auth_token2");

  //   print("tookennnn_print ${token}");
  //   try {
  //     final request = http.MultipartRequest('PUT', url)
  //       ..headers.addAll({
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       })
  //       ..files.add(await http.MultipartFile.fromPath('image', image.path));

  //     final response = await request.send();
  //     final statusCode = response.statusCode;
  //     final body = await response.stream.bytesToString();

  //     print("Response Status Code: $statusCode");
  //     print("Response Body: ${body.substring(0, min(body.length, 200))}...");

  //     // Check if response is JSON before decoding
  //     if (response.headers['content-type']?.contains('application/json') ==
  //         true) {
  //       return DriverImageUploadRes.fromJson(jsonDecode(body));
  //     } else {
  //       // Handle non-JSON responses (HTML error pages, etc.)
  //       if (statusCode >= 400) {
  //         return DriverImageUploadRes(
  //           success: false,
  //           message:
  //               "Server error ($statusCode): ${_extractErrorMessage(body)}",
  //         );
  //       } else {
  //         print("helloooo_errorrrr22 ${body['']}");
  //         return DriverImageUploadRes(
  //           success: false,
  //           message: "Unexpected response format from server",
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("Upload error: $e");
  //     return DriverImageUploadRes(success: false, message: e.toString());
  //   }
  // }

  // Helper method to extract error message from HTML
  static String _extractErrorMessage(String html) {
    try {
      // Try to extract title from HTML
      final titleMatch = RegExp(
        r'<title[^>]*>(.*?)</title>',
        caseSensitive: false,
      ).firstMatch(html);
      if (titleMatch != null && titleMatch.groupCount >= 1) {
        return titleMatch.group(1) ?? 'Unknown error';
      }

      // Try to find common error patterns
      final h1Match = RegExp(
        r'<h1[^>]*>(.*?)</h1>',
        caseSensitive: false,
      ).firstMatch(html);
      if (h1Match != null && h1Match.groupCount >= 1) {
        return h1Match.group(1) ?? 'Unknown error';
      }

      return 'Server returned HTML instead of JSON';
    } catch (_) {
      return 'Server error (check logs)';
    }
  }

  //   static Future<HomeModalResponse> get_home_data(

  // ) async {

  //   // final Uri url = Uri.parse(ApiPath.createVehicle);
  //    final Uri url = Uri.parse("${ApiPath.driver_home}");

  //   /// 🔐 GET TOKEN
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");

  //   print("========== CREATE VEHICLE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");
  //   // print("Request Body : ${jsonEncode(requestBody)}");
  //   print("my_tokennnn ${token}");

  //     try {
  //     final http.Response response = await http.get(
  //       url,
  //         headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token", // ✅ BEARER TOKEN
  //       },
  //       // body: jsonEncode(requestBody),
  //     );

  //     print("Status Code : ${response.statusCode}");
  //     print("Response Body : ${response.body}");

  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     final HomeModalResponse homeModalResponse = HomeModalResponse.fromJson(data);

  //     return homeModalResponse;
  //   } catch (e) {
  //     print("❌ Exception in Create Vehicle : $e");
  //     return HomeModalResponse(success: false, message: "Connection error: $e");
  //   }
  // }

  static Future<GetAllVehicleCategoriesResponse> get_vehical_data({
    required int limit,
    required int page,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/getAllVehicleCategories?limit=$limit&page=$page",
    );

    print("========== 🔵 CASH PAYMENT API ==========");
    print("URL : $url");
    print("Token : $token");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("✅ Status Code : ${response.statusCode}");

      // Check if response is valid JSON
      if (response.body.trim().isEmpty) {
        throw FormatException("Empty response from server");
      }

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE html>') ||
          response.body.trim().startsWith('<html')) {
        throw FormatException(
          "Server returned HTML error page. Check endpoint URL.",
        );
      }

      // Try to parse JSON
      dynamic decodedJson;
      try {
        decodedJson = jsonDecode(response.body);
      } catch (jsonError) {
        print("JSON Parse Error: $jsonError");
        print("Raw Response: ${response.body}");
        throw FormatException("Invalid JSON response from server");
      }

      // Pretty print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);
      print("📦 FULL RESPONSE (Pretty Print) 👇");
      print(prettyJson);

      // Parse the response
      final GetAllVehicleCategoriesResponse getAllVehicleCategoriesResponse =
          GetAllVehicleCategoriesResponse.fromJson(decodedJson);

      print("🎯 Parsed Model Object 👇");
      print(getAllVehicleCategoriesResponse);

      return getAllVehicleCategoriesResponse;
    } catch (e) {
      print("❌ Exception in cash_update_data");
      print(e.toString());

      // Return a proper error response
      return GetAllVehicleCategoriesResponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<GetAllsubVehicleCategoriesResponse> get_sub_vehical_data({
    required String vehicalCategoryId,
    required int limit,
    required int page,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");

    // final Uri url = Uri.parse("${ApiPath.baseUri}/getAllVehicleCategories");

    // final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/getAllVehicleSubCategories/vehicleCategoryId${idis}",
    // );

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/getAllVehicleSubCategories?vehicleCategoryId=${vehicalCategoryId}&limit=$limit&page=$page",
    );

    print("========== 🔵 CASH PAYMENT API ==========");
    print("URL : $url");
    print("Token : $token");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("✅ Status Code : ${response.statusCode}");

      // Check if response is valid JSON
      if (response.body.trim().isEmpty) {
        throw FormatException("Empty response from server");
      }

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE html>') ||
          response.body.trim().startsWith('<html')) {
        throw FormatException(
          "Server returned HTML error page. Check endpoint URL.",
        );
      }

      print("hellooo3");

      // Try to parse JSON
      dynamic decodedJson;
      try {
        print("hellooo2");
        print(
          "myyyyy_fulll_body_Resposneeee>>>> sub_vehicaldattaaa ${decodedJson}",
        );
        decodedJson = jsonDecode(response.body);
      } catch (jsonError) {
        print("hellooo4");

        print("JSON Parse Error: $jsonError");
        print("Raw Response: ${response.body}");
        throw FormatException("Invalid JSON response from server");
      }

      // Pretty print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);
      print("📦 FULL RESPONSE (Pretty Print) 👇");
      print(prettyJson);

      print("hellooo6");

      // Parse the response
      final GetAllsubVehicleCategoriesResponse getAllVehicleCategoriesResponse =
          GetAllsubVehicleCategoriesResponse.fromJson(decodedJson);

      print("🎯 Parsed Model Object 👇");
      print(getAllVehicleCategoriesResponse);

      return getAllVehicleCategoriesResponse;
    } catch (e) {
      print("hellooo5");

      print("❌ Exception in cash_update_data");
      print(e.toString());

      // Return a proper error response
      return GetAllsubVehicleCategoriesResponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }
}
