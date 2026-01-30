import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:corezap_driver/apiervices/api_path.dart';
import 'package:corezap_driver/modals/Otp_verify_res.dart';
import 'package:corezap_driver/modals/create_vehicle_res.dart';
import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/modals/register_profile_res.dart';
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
        gravity: ToastGravity.BOTTOM,
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
          gravity: ToastGravity.BOTTOM,
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
    final Uri url = Uri.parse(ApiPath.verifyOtp);

    final Map<String, dynamic> requestBody = {
      "otp": otp,
      "phone": phoneNumber ?? "9908479999",
      "fcmToken": "test-fcm-token-123",
      "deviceId": "device-001",
    };

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

      final String? driverId = data['driver']?['id']?.toString();
      print("Driver ID : $driverId");

      final OtpverifyRes otpResponse = OtpverifyRes.fromJson(data);

      /// ✅ SAVE TOKEN & DRIVER ID
      if (otpResponse.token != null &&
          otpResponse.token!.isNotEmpty &&
          driverId != null &&
          driverId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", otpResponse.token!);
        await prefs.setString("driver_userid", driverId);
      }

      return otpResponse;
    } catch (e) {
      Fluttertoast.showToast(msg: "Connection error");
      return OtpverifyRes(success: false, message: "Connection error");
    }
  }

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

  static Future<CreateVehicleRes> createVehicle_Api({
  required String vehicleName,
  String? vehicleNumber,
  String? vehicleColor,
  String? vehicleType,
  String? vehicleStatus,
  String? vehicleModel,
  String? vehicleCapacity,
  String? driverId,
  int? vehicleYear,
  File? rcImage,
  File? vehicleInsuraneImage,
  File? vehicleNumberImage,
}) async {
  final Uri url = Uri.parse(ApiPath.createVehicle);

  /// 🔐 GET TOKEN
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("auth_token");
  final String? userId = prefs.getString("driver_userid");

  print("hhhhhh>>>>>useridddddddddddddd   ${userId}");
  print("hhhhh>>>> vehicleName ${vehicleName} ");
  print("hhhhh>>>> vehicleNumber ${vehicleNumber} ");
  print("hhhhh>>>> vehicleColor ${vehicleColor} ");
  print("hhhhh>>>> vehicleType ${vehicleType} ");
  print("hhhhh>>>> vehicleStatus ${vehicleStatus} ");
  print("hhhhh>>>> vehicleModel ${vehicleModel} ");
  print("hhhhh>>>> vehicleCapacity ${vehicleCapacity} ");
  print("hhhhh>>>> driverId ${driverId} ");
  print("hhhhh>>>> driverId>>>>>>>>> ${userId} ");
  print("hhhhh>>>> vehicleYear ${vehicleYear} ");

  // Print file paths for debugging
  print("hhhhh >>>>>>>> rc imageeee ${rcImage?.path}");
  print("hhhhh >>>>>>>> vehicleInsuraneImage ${vehicleInsuraneImage?.path}");
  print("hhhhh >>>>>>>> vehicleNumberImage ${vehicleNumberImage?.path}");

  print("========== CREATE VEHICLE API ==========");
  print("URL : $url");
  print("Token : $token");

  try {
    // Create multipart request
    var request = http.MultipartRequest('POST', url);
    
    // Add headers
    request.headers['Authorization'] = "Bearer $token";
    
    // Add text fields
    request.fields['vehicleName'] = vehicleName;
    request.fields['vehicleNumber'] = vehicleNumber ?? '';
    request.fields['vehicleColor'] = vehicleColor ?? '';
    request.fields['vehicleType'] = vehicleType ?? '';
    request.fields['vehicleStatus'] = vehicleStatus ?? 'Active';
    request.fields['vehicleModel'] = vehicleModel ?? '';
    request.fields['vehicleCapacity'] = vehicleCapacity ?? '4';
    request.fields['vehicleYear'] = vehicleYear?.toString() ?? '';
    request.fields['driverId'] = userId ?? '';
    
    // Add files if they exist
    if (rcImage != null) {
      var rcStream = http.ByteStream(rcImage.openRead());
      var rcLength = await rcImage.length();
      var rcMultipartFile = http.MultipartFile(
        'rcImage',
        rcStream,
        rcLength,
        filename: rcImage.path.split('/').last,
      );
      request.files.add(rcMultipartFile);
    }
    
    if (vehicleInsuraneImage != null) {
      var insuranceStream = http.ByteStream(vehicleInsuraneImage.openRead());
      var insuranceLength = await vehicleInsuraneImage.length();
      var insuranceMultipartFile = http.MultipartFile(
        'vehicleInsuraneImage',
        insuranceStream,
        insuranceLength,
        filename: vehicleInsuraneImage.path.split('/').last,
      );
      request.files.add(insuranceMultipartFile);
    }
    
    if (vehicleNumberImage != null) {
      var numberStream = http.ByteStream(vehicleNumberImage.openRead());
      var numberLength = await vehicleNumberImage.length();
      var numberMultipartFile = http.MultipartFile(
        'vehicleNumberImage',
        numberStream,
        numberLength,
        filename: vehicleNumberImage.path.split('/').last,
      );
      request.files.add(numberMultipartFile);
    }
    
    // Print request details for debugging
    print("Request fields: ${request.fields}");
    print("Request files count: ${request.files.length}");
    
    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    print("Status Code : ${response.statusCode}");
    print("Response Body : ${response.body}");
    
    final Map<String, dynamic> data = jsonDecode(response.body);
    final CreateVehicleRes createVehicleRes = CreateVehicleRes.fromJson(data);
    
    print("myyyyy_api_ressssposneee ${createVehicleRes}");
    
    return createVehicleRes;
  } catch (e) {
    print("❌ Exception in Create Vehicle : $e");
    print("Stack trace: ${e.toString()}");
    return CreateVehicleRes(success: false, message: "Connection error: $e");
  }
}

  // static Future<CreateVehicleRes> createVehicle_Api({
  //   required String vehicleName,
  //   String? vehicleNumber,
  //   String? vehicleColor,
  //   String? vehicleType,
  //   String? vehicleStatus,
  //   String? vehicleModel,
  //   String? vehicleCapacity,
  //   String? driverId,
  //   int? vehicleYear,

  //   dynamic rcImage,

  //   dynamic vehicleInsuraneImage,

  //   dynamic vehicleNumberImage,
  // }) async {
  //   final Uri url = Uri.parse(ApiPath.createVehicle);

  //   /// 🔐 GET TOKEN
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");

  //   final String? userId = prefs.getString("driver_userid");

  //   print("hhhhhh>>>>>useridddddddddddddd   ${userId}");

  //   print("hhhhh>>>> vehicleName ${vehicleName} ");
  //   print("hhhhh>>>> vehicleNumber ${vehicleNumber} ");
  //   print("hhhhh>>>> vehicleColor ${vehicleColor} ");
  //   print("hhhhh>>>> vehicleType ${vehicleType} ");
  //   print("hhhhh>>>> vehicleStatus ${vehicleStatus} ");
  //   print("hhhhh>>>> vehicleModel ${vehicleModel} ");
  //   print("hhhhh>>>> vehicleCapacity ${vehicleCapacity} ");
  //   print("hhhhh>>>> driverId ${driverId} ");
  //   print("hhhhh>>>> driverId>>>>>>>>> ${userId} ");
  //   print("hhhhh>>>> vehicleYear ${vehicleYear} ");

  //   print("hhhhh >>>>>>>> rc imageeee ${rcImage}");
  //   print("hhhhh >>>>>>>> vehicleInsuraneImage ${vehicleInsuraneImage}");
  //   print("hhhhh >>>>>>>> vehicleNumberImage ${vehicleNumberImage}");

  //   // final Map<String, dynamic> requestBody = {
  //   //   "vehicleName": "honda civic",
  //   // "vehicleNumber":
  //   //     "MH12sdsfsdddddddAsafdsSsdssdsansasslkdjskjfdsandsjkakjkhjhasjhfkjdfsdddsdddssafasdB112ddfsSDsas4adssd39adasdasasadvfgw" ??
  //   //     "",
  //   //   "vehicleColor": "Blue",
  //   //   "vehicleType": "691581132fbb2cbdd65fbd8d",
  //   //   "vehicleStatus": "Active",
  //   //   "vehicleModel": "VXI",
  //   //   "vehicleCapacity": "4",
  //   //   "vehicleYear": "2019",
  //   //   "driverId": "695907abb30f1d4e3c7ce75c",
  //   // };

  //   final Map<String, dynamic> requestBody = {
  //     "vehicleName": vehicleName,
  //     "vehicleNumber": vehicleNumber,

  //     "vehicleColor": vehicleColor,
  //     "vehicleType": vehicleType,
  //     "vehicleStatus": "Active",
  //     "vehicleModel": vehicleModel,
  //     "vehicleCapacity": "4",
  //     "vehicleYear": vehicleYear,
  //     "driverId": userId,
  //     "rcImage": rcImage,
  //     "vehicleInsuraneImage": vehicleInsuraneImage,

  //     "vehicleNumberImage": vehicleNumberImage,
  //   };

  //   print("========== CREATE VEHICLE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");
  //   print("Request Body : ${jsonEncode(requestBody)}");
  //   print("my_tokennnn ${token}");
  //   try {
  //     final http.Response response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token", // ✅ BEARER TOKEN
  //       },
  //       body: jsonEncode(requestBody),
  //     );

  //     print("Status Code : ${response.statusCode}");
  //     print("Response Body : ${response.body}");

  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     final CreateVehicleRes createVehicleRes = CreateVehicleRes.fromJson(data);

  //     print("myyyyy_api_ressssposneee ${createVehicleRes}");

  //     return createVehicleRes;
  //   } catch (e) {
  //     print("❌ Exception in Create Vehicle : $e");
  //     return CreateVehicleRes(success: false, message: "Connection error: $e");
  //   }
  // }

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
    final String? token = prefs.getString("auth_token");

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

      final Map<String, dynamic> data = jsonDecode(responseBody);
      final RegisterProfileRes registerProfileRes = RegisterProfileRes.fromJson(
        data,
      );

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
        print(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
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
    required String userIds,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("driver_userid");

    print("the_paramssss1 ${image}");
    print("the_paramssss2 ${userId}");
    print("the_paramssss3 ${userType}");

    print("the_paramssss3_useriddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
    );

    print("URL => $url");

    final token = prefs.getString("auth_token");

    try {
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        })
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final statusCode = response.statusCode;
      final body = await response.stream.bytesToString();

      print("Response Status Code: $statusCode");
      print("Response Body: ${body.substring(0, min(body.length, 200))}...");

      // Check if response is JSON before decoding
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        return DriverImageUploadRes.fromJson(jsonDecode(body));
      } else {
        // Handle non-JSON responses (HTML error pages, etc.)
        if (statusCode >= 400) {
          return DriverImageUploadRes(
            success: false,
            message:
                "Server error ($statusCode): ${_extractErrorMessage(body)}",
          );
        } else {
          return DriverImageUploadRes(
            success: false,
            message: "Unexpected response format from server",
          );
        }
      }
    } catch (e) {
      print("Upload error: $e");
      return DriverImageUploadRes(success: false, message: e.toString());
    }
  }

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
}
