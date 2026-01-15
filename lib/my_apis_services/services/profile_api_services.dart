import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/views/profile_related.dart/edit_profile.dart';

import 'package:http/http.dart' as http;

import 'package:corezap_driver/my_apis_services/api_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ProfileApiServices {
  


//    static Future<DriverImageUploadRes> edit_profile_data_api({
//     required File image,
//     required String userIds,
//     required String userType,
//     required String name,
//     required String email,
    

//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? userId = prefs.getString("driver_userid");

//     print("the_paramssss1 ${image}");
//     print("the_paramssss2 ${userId}");
//     print("the_paramssss3 ${userType}");

//     print("the_paramssss3_useriddd ${userId}");

//     final Uri url = Uri.parse(
//       "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
//     );

//     print("URL => $url");

//     final token = prefs.getString("auth_token");

//     try {
//       final request = http.MultipartRequest('PUT', url)
//         ..headers.addAll({
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         })
//         ..files.add(await http.MultipartFile.fromPath('image', image.path));

//       final response = await request.send();
//       final statusCode = response.statusCode;
//       final body = await response.stream.bytesToString();

//       print("Response Status Code: $statusCode");
//       print("Response Body: ${body.substring(0, min(body.length, 200))}...");

//       // Check if response is JSON before decoding
//       if (response.headers['content-type']?.contains('application/json') ==
//           true) {
//         return DriverImageUploadRes.fromJson(jsonDecode(body));
//       } else {
//         // Handle non-JSON responses (HTML error pages, etc.)
//         if (statusCode >= 400) {
//           return DriverImageUploadRes(
//             success: false,
//             message:
//                 "Server error ($statusCode): ${_extractErrorMessage(body)}",
//           );
//         } else {
//           return DriverImageUploadRes(
//             success: false,
//             message: "Unexpected response format from server",
//           );
//         }
//       }
//     } catch (e) {
//       print("Upload error: $e");
//       return DriverImageUploadRes(success: false, message: e.toString());
//     }
//   }

//  static String _extractErrorMessage(String html) {
//     try {
//       // Try to extract title from HTML
//       final titleMatch = RegExp(
//         r'<title[^>]*>(.*?)</title>',
//         caseSensitive: false,
//       ).firstMatch(html);
//       if (titleMatch != null && titleMatch.groupCount >= 1) {
//         return titleMatch.group(1) ?? 'Unknown error';
//       }

//       // Try to find common error patterns
//       final h1Match = RegExp(
//         r'<h1[^>]*>(.*?)</h1>',
//         caseSensitive: false,
//       ).firstMatch(html);
//       if (h1Match != null && h1Match.groupCount >= 1) {
//         return h1Match.group(1) ?? 'Unknown error';
//       }

//       return 'Server returned HTML instead of JSON';
//     } catch (_) {
//       return 'Server error (check logs)';
//     }
//   }


// }



class ProfileApiServices {

  

    static Future<HomeModalResponse> get_home_data(
  
  ) async {

    
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
      final HomeModalResponse homeModalResponse = HomeModalResponse.fromJson(data);

      return homeModalResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle : $e");
      return HomeModalResponse(success: false, message: "Connection error: $e");
    }
  }
  static Future<DriverImageUploadRes> edit_profile_data_api({
    required File image,
    required String userType,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("driver_userid");
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
    );

    print("URL => $url");
    print("Name => $name");
    print("Email => $email");

    try {
      final request = http.MultipartRequest('PUT', url);

      /// ✅ Headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      /// ✅ TEXT FIELDS (IMPORTANT)
      request.fields['name'] = name;
      request.fields['email'] = email;

      /// ✅ IMAGE FILE
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );

      final response = await request.send();
      final statusCode = response.statusCode;
      final body = await response.stream.bytesToString();

      print("Status Code: $statusCode");
      print("Response Body: $body");

      if (response.headers['content-type']
              ?.contains('application/json') ==
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
      return DriverImageUploadRes(
        success: false,
        message: e.toString(),
      );
    }
  }


}
