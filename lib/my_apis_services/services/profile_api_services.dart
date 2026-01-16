import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:corezap_driver/modals/driverId_response.dart';
import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/modals/review_rating_response.dart';
import 'package:corezap_driver/modals/ride_history_response.dart';
import 'package:corezap_driver/modals/transactions_response.dart';
import 'package:corezap_driver/modals/wallet_response.dart';
import 'package:corezap_driver/views/profile_related.dart/edit_profile.dart';

import 'package:http/http.dart' as http;

import 'package:corezap_driver/my_apis_services/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileApiServices {
  static Future<HomeModalResponse> get_home_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.driver_home}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");



      final Map<String, dynamic> data = jsonDecode(response.body);
      final HomeModalResponse homeModalResponse = HomeModalResponse.fromJson(
        data,
      );

print("Response Body222222222 : ${homeModalResponse.driver!.id}");

 if (homeModalResponse.success == true &&
          homeModalResponse.driver != null &&
          homeModalResponse.driver!.id != null) {

            print("Response Body222222222kkkk : ${homeModalResponse.driver!.id}");
        // Use ! to assert non-null or provide default value
        await prefs.setString("driver_userid", homeModalResponse.driver!.id.toString());


         print("Response Body222222222jjjj : ${homeModalResponse.driver!.id}");
        // print(
        //   "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        // );
      } else {
        print(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );
      }
      return homeModalResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return HomeModalResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<DriverImageUploadRes> edit_profile_data_api({
    File? image,
    required String userType,
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("driver_userid");
    final String? token = prefs.getString("auth_token");

    print("my_tokennnnn ${token}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
    );

    print("URL => $url");
    print("Name => $name");
    print("Email => $email");
    print("dateOfBirth ===== => $dateOfBirth");
    print("gender =====> $gender");
    print("Image provided: ${image != null ? 'Yes' : 'No'}");

    try {
      final request = http.MultipartRequest('PUT', url);

      /// ✅ Headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      /// ✅ TEXT FIELDS (Add only if not empty/null)
      if (name != null && name.isNotEmpty) {
        request.fields['name'] = name;
      }

      if (email != null && email.isNotEmpty) {
        request.fields['email'] = email;
      }

      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        request.fields['dateOfBirth'] = dateOfBirth;
      }

      if (gender != null && gender.isNotEmpty) {
        request.fields['gender'] = gender;
      }

      /// ✅ IMAGE FILE (only if provided and exists)
      if (image != null && await image.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
        print("Image attached: ${image.path}");
      } else {
        print("No image provided - skipping image upload");
      }

      final response = await request.send();
      final statusCode = response.statusCode;
      final body = await response.stream.bytesToString();

      print("Status Code: $statusCode");
      print("Response Body: $body");

      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        return DriverImageUploadRes.fromJson(jsonDecode(body));
      } else {
        return DriverImageUploadRes(
          success: false,
          message: "Unexpected response format",
        );
      }
    } catch (e) {
      print("API Error: $e");
      return DriverImageUploadRes(success: false, message: e.toString());
    }
  }

  // static Future<DriverImageUploadRes> edit_profile_data_api({
  //   required dynamic image,
  //   required String userType,
  //   required String name,
  //   required String email,

  //   required String dateOfBirth,

  //   required String gender,

  // }) async {

  //   final prefs = await SharedPreferences.getInstance();
  //   final String? userId = prefs.getString("driver_userid");
  //   final String? token = prefs.getString("auth_token");

  //   print("my_tokennnnn ${token}");
  //   final Uri url = Uri.parse(
  //     "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
  //   );

  //   print("URL => $url");
  //   print("Name => $name");
  //   print("Email => $email");

  //   print("dateOfBirth ===== => $dateOfBirth");
  //   print("gender =====> $gender");

  //   try {
  //     final request = http.MultipartRequest('PUT', url);

  //     /// ✅ Headers
  //     request.headers.addAll({
  //       "Authorization": "Bearer $token",
  //       "Accept": "application/json",
  //     });

  //     /// ✅ TEXT FIELDS (IMPORTANT)
  //     request.fields['name'] = name;
  //     request.fields['email'] = email;

  //     request.fields['dateOfBirth'] = dateOfBirth;

  //     request.fields['email'] = gender;

  //     /// ✅ IMAGE FILE
  //     request.files.add(await http.MultipartFile.fromPath('image', image.path));

  //     final response = await request.send();
  //     final statusCode = response.statusCode;
  //     final body = await response.stream.bytesToString();

  //     print("Status Code: $statusCode");
  //     print("Response Body: $body");

  //     if (response.headers['content-type']?.contains('application/json') ==
  //         true) {
  //       return DriverImageUploadRes.fromJson(jsonDecode(body));
  //     } else {
  //       return DriverImageUploadRes(
  //         success: false,
  //         message: "Unexpected response format",
  //       );
  //     }
  //   } catch (e) {
  //     print("API Error: $e");
  //     return DriverImageUploadRes(success: false, message: e.toString());
  //   }
  // }

  static Future<WalletResponse> get_wallet_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.wallet_api}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final WalletResponse walletResponse = WalletResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return WalletResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<TransactionsResponse> get_transactions_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.transactions_api}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final TransactionsResponse walletResponse = TransactionsResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return TransactionsResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<DriverIdResponse> get_driverid_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");


    print("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/getDriverProfile/${userId}",
    );

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final DriverIdResponse walletResponse = DriverIdResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return DriverIdResponse(success: false, message: "Connection error: $e");
    }
  }













  static Future<ReviewRatingResponse> get_review_rating_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");


    print("theeeee____ useriddddd ${userId}");

    

  final Uri url = Uri.parse("${ApiPath.ratings_api}");
    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final ReviewRatingResponse walletResponse = ReviewRatingResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return ReviewRatingResponse(success: false, message: "Connection error: $e");
    }
  }







  static Future<RideHistoryResponse> get_rides_history_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.transactions_api}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      print("Status Code : ${response.statusCode}");
      print("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final RideHistoryResponse walletResponse = RideHistoryResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return RideHistoryResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }
}
