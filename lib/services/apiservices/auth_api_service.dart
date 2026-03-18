import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nzcu_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/services/notification_services/notification_service.dart';
import 'package:nzcu_driver/modals/auth_modals/Otp_verify_res.dart';
import 'package:nzcu_driver/modals/auth_modals/create_vehicle_res.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_sub_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/auth_modals/get_all_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/auth_modals/register_profile_res.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class AuthApiService {
  static final ApiPath apiPath = Get.put(ApiPath());

  static Future<bool> sendOtp({required String phone}) async {
    final Uri url = Uri.parse("${ApiPath.registerLogin}");

    final Map<String, dynamic> requestBody = {"phone": phone};

    AppLogger.d("========== SEND OTP API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Request Body : ${jsonEncode(requestBody)}");

    try {
      final http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      AppLogger.d("Response Body222 : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        AppLogger.d("Parsed Response : $data");
        return data["success"] == true;
      } else {
        CustomToast.showError(data['error'] ?? "Something went wrong");
        AppLogger.d("❌ Server error: ${data['error']}");
        return false;
      }
    } catch (e) {
      AppLogger.d("❌ Exception in Send OTP : $e");
      return false;
    }
  }

  static Future<OtpverifyRes> verifyOtp({
    required String otp,
    String? phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get real FCM token: live from NotificationService, then stored, then request from Firebase
    String? fcmToken = NotificationService.instance.fcmToken;
    if (fcmToken == null || fcmToken.isEmpty) {
      fcmToken = await NotificationService.instance.getStoredFcmToken();
    }
    if (fcmToken == null || fcmToken.isEmpty) {
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await prefs.setString('fcmToken', fcmToken);
        }
      } catch (e) {
        AppLogger.d('⚠️ [AuthApiService] Could not get FCM token: $e');
      }
    }
    AppLogger.d('FCM token for verify OTP: ${fcmToken != null && fcmToken.isNotEmpty ? "present" : "missing"}');

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    final Uri url = Uri.parse(ApiPath.verifyOtp);

    final Map<String, dynamic> requestBody = {
      "otp": otp,
      "phone": phoneNumber ?? "9908479999",
      "fcmToken": fcmToken ?? "",
      "deviceId": androidInfo.id,
    };

    AppLogger.d("otppppp_veriffyyyy___ ${requestBody}");

    try {
      final http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Message : ${data['message']}");
      AppLogger.d("Full Driver Object : ${data['driver']}");

      // Check if the response indicates failure
      if (data['success'] == false) {
        // Extract error message
        String errorMessage = data['message'] ?? 'Failed to verify OTP';
        if (data['error'] != null) {
          errorMessage = data['error'];
        } else if (data['errors'] != null) {
          errorMessage = data['errors'].toString();
        }

        AppLogger.d("Error occurred: $errorMessage");

        CustomToast.showError(errorMessage);

        return OtpverifyRes(success: false, message: errorMessage);
      }

      final String? driverId = data['driver']?['id']?.toString();
      AppLogger.d("Driver ID : $driverId");

      final OtpverifyRes otpResponse = OtpverifyRes.fromJson(data);

      AppLogger.d(
        "isprofileee_verifyyyyy_check ${otpResponse.driver!.isProfileCompleted}",
      );

      if (otpResponse.driver!.isProfileCompleted == true) {
        AppLogger.d(
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
        CustomToast.showSuccess("OTP verified successfully!");
      } else {
        AppLogger.d("else__data_storedd");
        if (otpResponse.token != null &&
            otpResponse.token!.isNotEmpty &&
            driverId != null &&
            driverId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token2", otpResponse.token!);
          await prefs.setString("driver_userid2", driverId);

          AppLogger.d("getting storeddd token2 ${prefs.getString("auth_token2")}");
          AppLogger.d("getting storeddd token2 ${prefs.getString("driver_userid2")}");

          if (otpResponse.driver?.name != null &&
              otpResponse.driver!.name!.isNotEmpty) {
            await prefs.setString("driver_name2", otpResponse.driver!.name!);
          }
        }
      }
      return otpResponse;
    } catch (e) {
      AppLogger.d("OTP verify API failed");

      final prefs = await SharedPreferences.getInstance();
      String? accountStatus = prefs.getString("account_status");

      if (accountStatus == null || accountStatus.isEmpty) {
        CustomToast.showError('Something went wrong. Please try again. $e');
      } else if (accountStatus == "pending") {
                CustomToast.showError('Please wait, adminnt.');
      } else {
        CustomToast.showError(e.toString());
        await prefs.setString("account_status", "Not_pending");
      }

      return OtpverifyRes(success: false, message: "Connection error");

    }

  }

  void prettyPrintJson(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      const encoder = JsonEncoder.withIndent('  '); // 2 space indent
      final prettyString = encoder.convert(decoded);
      AppLogger.d(prettyString);
    } catch (e) {
      AppLogger.d("Invalid JSON: $e");
      AppLogger.d(responseBody); // fallback normal print
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
    AppLogger.d("\n📋 VEHICLE CREATION PARAMETERS:");
    AppLogger.d("├─ vehicleName: $vehicleName");
    AppLogger.d("├─ vehicleNumber: $vehicleNumber");
    AppLogger.d("├─ vehicleColor: $vehicleColor");
    AppLogger.d("├─ vehicleType: $vehicleType");
    AppLogger.d("├─ vehicleStatus: $vehicleStatus");
    AppLogger.d("├─ vehicleModel: $vehicleModel");
    AppLogger.d(
      "├─ vehicleCapacity: $vehicleCapacity (type: ${vehicleCapacity.runtimeType})",
    );
    AppLogger.d("├─ driverId: $driverId");
    AppLogger.d("├─ vehicleSubType: $vehicleSubType");
    AppLogger.d("├─ vehicleYear: $vehicleYear");
    AppLogger.d("├─ rcImage: ${rcImage?.path ?? 'NULL'}");
    AppLogger.d("├─ vehicleInsuraneImage: ${vehicleInsuraneImage?.path ?? 'NULL'}");
    AppLogger.d("└─ vehicleNumberImage: ${vehicleNumberImage?.path ?? 'NULL'}");

    final Uri url = Uri.parse(ApiPath.createVehicle);

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");
    final String? userId = prefs.getString("driver_userid2");

    AppLogger.d("Token: $token");
    AppLogger.d("User ID from SharedPreferences: $userId");

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

      AppLogger.d("Text fields added to request");
      AppLogger.d("Using driverId: $actualDriverId");

      // Helper function to extract filename from path
      String getFileNameFromPath(String path) {
        final parts = path.split('/');
        return parts.isNotEmpty ? parts.last : 'image.jpg';
      }

      // Add RC image if exists
      if (rcImage != null && await rcImage.exists()) {
        final fileName = getFileNameFromPath(rcImage.path);
        AppLogger.d("Adding RC image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'rcImage',
            rcImage.path,
            filename: fileName,
          ),
        );
        AppLogger.d("✓ Added RC image as: $fileName");
      } else {
        AppLogger.d("RC Image is null or doesn't exist");
      }

      // Add Vehicle Insurance image if exists
      if (vehicleInsuraneImage != null && await vehicleInsuraneImage.exists()) {
        final fileName = getFileNameFromPath(vehicleInsuraneImage.path);
        AppLogger.d("Adding Vehicle Insurance image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleInsuraneImage',
            vehicleInsuraneImage.path,
            filename: fileName,
          ),
        );
        AppLogger.d("✓ Added Insurance image as: $fileName");
      } else {
        AppLogger.d("Vehicle Insurance Image is null or doesn't exist");
      }

      // Add Vehicle Number image if exists
      if (vehicleNumberImage != null && await vehicleNumberImage.exists()) {
        final fileName = getFileNameFromPath(vehicleNumberImage.path);
        AppLogger.d("Adding Vehicle Number image: $fileName");

        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicleNumberImage',
            vehicleNumberImage.path,
            filename: fileName,
          ),
        );
        AppLogger.d("✓ Added Number Plate image as: $fileName");
      } else {
        AppLogger.d("Vehicle Number Image is null or doesn't exist");
      }

      AppLogger.d("\n========== CREATE VEHICLE API ==========");
      AppLogger.d("URL: $url");
      AppLogger.d("Request Fields: ${request.fields}");
      AppLogger.d("Number of Files: ${request.files.length}");

      // List all files with their field names and filenames
      for (var i = 0; i < request.files.length; i++) {
        var file = request.files[i];
        AppLogger.d("File $i: field='${file.field}', filename='${file.filename}'");
      }

      // Send request
      AppLogger.d("\n🚀 Sending request...");
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      AppLogger.d("\n📥 Response Received:");
      AppLogger.d("Status Code: ${response.statusCode}");

      // Check if response is HTML (error) or JSON
      if (responseBody.trim().startsWith('<!DOCTYPE') ||
          responseBody.trim().startsWith('<html>') ||
          response.statusCode >= 400) {
        AppLogger.d("❌ Server returned error");
        AppLogger.d("Response Body: $responseBody");

        // Fluttertoast.

        AppLogger.d("❌ Server returned error");
        AppLogger.d("Response Body: $responseBody");

        try {
          final decoded = jsonDecode(responseBody);

          CustomToast.showError(decoded['message'] ?? "Something went wrong");

        } catch (e) {
          CustomToast.showError("Something went wrong");
        }

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
        AppLogger.d("Response Body: $responseBody");
        final Map<String, dynamic> data = jsonDecode(responseBody);
        final CreateVehicleRes createVehicleRes = CreateVehicleRes.fromJson(
          data,
        );



        final data1 = jsonDecode(responseBody);

        const encoder = JsonEncoder.withIndent('  ');
        AppLogger.d(encoder.convert(data1));

        if (createVehicleRes.success == true) {
          AppLogger.d("Vehicle created successfully!");


          final DriverFormController driverFormController =
              Get.find<DriverFormController>();
          // driverFormController.activeStep.value = 0;
          driverFormController.activeStep.value = 1;
        } else {
          AppLogger.d("Vehicle creation failed: ${createVehicleRes.message}");
        }

        return createVehicleRes;
      } catch (e) {

        AppLogger.d("Failed to parse JSON response: $e");
        AppLogger.d("Raw response: ${responseBody}");

        return CreateVehicleRes(
          success: false,
          message: "Invalid response format: $e",
        );
      }
    } catch (e) {
      AppLogger.d("Exception in Create Vehicle API: $e");
      AppLogger.d("Stack trace: ${e.toString()}");
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
    AppLogger.d("\n📋 RECEIVED PARAMETERS:");
    AppLogger.d("├─ name: $name");
    AppLogger.d("├─ email: $email");
    AppLogger.d("├─ phone: $phone");
    AppLogger.d("├─ dob: $dob");
    AppLogger.d("├─ dlImage: ${dlImage?.path ?? 'NULL'}");
    AppLogger.d("├─ aadharFront: ${aadharFront?.path ?? 'NULL'}");
    AppLogger.d("├─ aadharBack: ${aadharBack?.path ?? 'NULL'}");
    AppLogger.d("├─ panImage: ${panImage?.path ?? 'NULL'}");
    AppLogger.d("├─ alternateContact1: $alternateContact1");
    AppLogger.d("├─ relation1: $relation1");
    AppLogger.d("├─ address1: $address1");
    AppLogger.d("├─ alternateContact2: $alternateContact2");
    AppLogger.d("└─ relation2: $relation2");
    AppLogger.d("  └─ address2: $address2");

    final Uri url = Uri.parse(ApiPath.createPersonalDetails);

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");

    AppLogger.d("Token: $token");

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

      AppLogger.d("Text fields added to request");

      // Add DL image if exists
      if (dlImage != null && await dlImage.exists()) {
        AppLogger.d("Adding DL image: ${dlImage.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'dlImage',
            dlImage.path,
            filename: 'dl_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        AppLogger.d("DL Image is null or doesn't exist");
      }

      // Add Aadhar Front if exists
      if (aadharFront != null && await aadharFront.exists()) {
        AppLogger.d("Adding Aadhar Front image: ${aadharFront.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharFront',
            aadharFront.path,
            filename:
                'aadhar_front_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        AppLogger.d("Aadhar Front is null or doesn't exist");
      }

      // Add Aadhar Back if exists
      if (aadharBack != null && await aadharBack.exists()) {
        AppLogger.d("Adding Aadhar Back image: ${aadharBack.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharBack',
            aadharBack.path,
            filename:
                'aadhar_back_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        AppLogger.d("Aadhar Back is null or doesn't exist");
      }

      // Add PAN image if exists
      if (panImage != null && await panImage.exists()) {
        AppLogger.d("Adding PAN image: ${panImage.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            'panImage',
            panImage.path,
            filename: 'pan_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      } else {
        AppLogger.d("PAN Image is null or doesn't exist");
      }

      AppLogger.d("========== CREATE REGISTER API ==========");
      AppLogger.d("URL: $url");
      AppLogger.d("Request Fields: ${request.fields}");
      AppLogger.d("Number of Files: ${request.files.length}");

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      AppLogger.d("Status Code: ${response.statusCode}");
      AppLogger.d("Response Body: $responseBody");

      final Map<String, dynamic> data = jsonDecode(responseBody);
      final RegisterProfileRes registerProfileRes = RegisterProfileRes.fromJson(
        data,
      );

      final data1 = jsonDecode(responseBody);

      const encoder = JsonEncoder.withIndent('  ');
      AppLogger.d(encoder.convert(data1));

      // Save driver user ID to SharedPreferences
      // Check if response is successful, has data, and ID is not null
      if (registerProfileRes.success == true &&
          registerProfileRes.data != null &&
          registerProfileRes.data!.id != null) {
        // Use ! to assert non-null or provide default value
        await prefs.setString("driver_userid", registerProfileRes.data!.id!);
        AppLogger.d(
          "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        );
      } else {
        AppLogger.d("theee_errorrr_hererrrr ${data['message']}");
        AppLogger.d(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );

        CustomToast.showError(data['message']);

      }

      return registerProfileRes;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Register: $e");
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
          AppLogger.d(encoder.convert(data1));
          CustomToast.showSuccess(res.message ?? "Something went wrong");
        }

        return res;
      } else {
        CustomToast.showError('Unexpected server response');

        return DriverImageUploadRes(
          success: false,
          message: "Unexpected server response",
        );
      }
    } catch (e) {
      CustomToast.showError("Network error");
      return DriverImageUploadRes(success: false, message: "Network error");
    }
  }


  static Future<GetAllVehicleCategoriesResponse> get_vehical_data({
    required int limit,
    required int page,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token2");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/getAllVehicleCategories?limit=$limit&page=$page",
    );

    AppLogger.d("========== 🔵 CASH PAYMENT API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

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
        AppLogger.d("JSON Parse Error: $jsonError");
        AppLogger.d("Raw Response: ${response.body}");
        throw FormatException("Invalid JSON response from server");
      }

      // Pretty print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);
      AppLogger.d("📦 FULL RESPONSE (Pretty Print) 👇");
      AppLogger.d(prettyJson);

      // Parse the response
      final GetAllVehicleCategoriesResponse getAllVehicleCategoriesResponse =
          GetAllVehicleCategoriesResponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(getAllVehicleCategoriesResponse);

      return getAllVehicleCategoriesResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in cash_update_data");
      AppLogger.d(e.toString());

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

    AppLogger.d("========== 🔵 CASH PAYMENT API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

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

      AppLogger.d("hellooo3");

      // Try to parse JSON
      dynamic decodedJson;
      try {
        AppLogger.d("hellooo2");
        AppLogger.d(
          "myyyyy_fulll_body_Resposneeee>>>> sub_vehicaldattaaa ${decodedJson}",
        );
        decodedJson = jsonDecode(response.body);
      } catch (jsonError) {
        AppLogger.d("hellooo4");

        AppLogger.d("JSON Parse Error: $jsonError");
        AppLogger.d("Raw Response: ${response.body}");
        throw FormatException("Invalid JSON response from server");
      }

      // Pretty print for debugging
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);
      AppLogger.d("📦 FULL RESPONSE (Pretty Print) 👇");
      AppLogger.d(prettyJson);

      AppLogger.d("hellooo6");

      // Parse the response
      final GetAllsubVehicleCategoriesResponse getAllVehicleCategoriesResponse =
          GetAllsubVehicleCategoriesResponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(getAllVehicleCategoriesResponse);

      return getAllVehicleCategoriesResponse;
    } catch (e) {
      AppLogger.d("hellooo5");

      AppLogger.d("❌ Exception in cash_update_data");
      AppLogger.d(e.toString());

      // Return a proper error response
      return GetAllsubVehicleCategoriesResponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }
}
