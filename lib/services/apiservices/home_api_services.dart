import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/modals/home_modals/chat_id_response.dart';
import 'package:nzcu_driver/modals/home_modals/driverId_response.dart';
import 'package:nzcu_driver/modals/home_modals/driver_toggle_duty_response.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/home_modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/modals/home_modals/ride_history_response.dart';
import 'package:nzcu_driver/modals/home_modals/update_order_response.dart';
import 'package:nzcu_driver/modals/home_modals/verify_Otp_Order_response.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class HomeApiServices {
  static Future<HomeModalResponse> get_home_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.driver_home}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    // AppLogger.d("Request Body : ${jsonEncode(requestBody)}");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final HomeModalResponse homeModalResponse = HomeModalResponse.fromJson(
        data,
      );

      AppLogger.d("Response Body222222222 : ${homeModalResponse.driver!.id}");

      if (homeModalResponse.success == true &&
          homeModalResponse.driver != null &&
          homeModalResponse.driver!.id != null) {
        AppLogger.d("Response Body222222222kkkk : ${homeModalResponse.driver!.id}");
        // Use ! to assert non-null or provide default value
        await prefs.setString(
          "driver_userid",
          homeModalResponse.driver!.id.toString(),
        );

        await prefs.setString(
          "driver_name",
          homeModalResponse.driver!.name.toString(),
        );

        AppLogger.d("Response Body222222222jjjj : ${homeModalResponse.driver!.id}");
        // AppLogger.d(
        //   "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        // );
      } else {
        AppLogger.d(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );
      }
      return homeModalResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle1 : $e");
      return HomeModalResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<Drivertoggledutyresponse> toggle_duty_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    // final Uri url = Uri.parse("${ApiPath.driver_home}");
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString("driver_userid");
    final String? token = prefs.getString("auth_token");

    //  final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/driver/toggleDuty?$userId",
    // );

    final Uri url = Uri.parse("${ApiPath.baseUri}/driver/toggleDuty/$userId");
    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    // AppLogger.d("Request Body : ${jsonEncode(requestBody)}");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
        // body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final Drivertoggledutyresponse drivertoggledutyresponse =
          Drivertoggledutyresponse.fromJson(data);

      AppLogger.d("my_driver_tokennnn_toggle_respose ${data}");
      AppLogger.d("Response Body222222222 : ${drivertoggledutyresponse.driver!.id}");

      if (drivertoggledutyresponse.success == true &&
          drivertoggledutyresponse.driver != null &&
          drivertoggledutyresponse.driver!.id != null) {
        AppLogger.d(
          "Response Body222222222kkkk : ${drivertoggledutyresponse.driver!.id}",
        );
        // Use ! to assert non-null or provide default value
        await prefs.setString(
          "driver_userid",
          drivertoggledutyresponse.driver!.id.toString(),
        );

        await prefs.setString(
          "driver_name",
          drivertoggledutyresponse.driver!.name.toString(),
        );

        AppLogger.d(
          "Response Body222222222jjjj : ${drivertoggledutyresponse.driver!.id}",
        );
        // AppLogger.d(
        //   "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        // );
      } else {
        AppLogger.d(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );
      }
      return drivertoggledutyresponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle1 : $e");
      return Drivertoggledutyresponse(
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

    AppLogger.d("herrrerrere_the_driverrrriddd_calling>>>>");
    AppLogger.d("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/getDriverProfile/${userId}",
    );

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("drievrrrrrid>>>>>>> resss >>>> Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final DriverIdResponse driverIdResponse = DriverIdResponse.fromJson(data);

      AppLogger.d(
        "vehicleSubType>>>>> comingggg >>>>> ${driverIdResponse.driver?.vehicle?.vehicleSubType}",
      );

      // Store driver basic info
      if (driverIdResponse.driver?.name != null) {
        await prefs.setString("driver_name", driverIdResponse.driver!.name!);
      }

      if (driverIdResponse.driver?.image != null) {
        await prefs.setString("driver_image", driverIdResponse.driver!.image!);
      }

      if (driverIdResponse.driver?.vehicle?.vehicleSubType != null) {
        await prefs.setString(
          "vehicle_SubType",
          driverIdResponse.driver!.vehicle!.vehicleSubType!,
        );
      }

      if (driverIdResponse.driver?.phone != null) {
        await prefs.setString("driver_mobile", driverIdResponse.driver!.phone!);
      }

      // Store vehicle info if available
      if (driverIdResponse.driver?.vehicle != null) {
        final vehicle = driverIdResponse.driver!.vehicle!;

        // Store vehicle ID
        if (vehicle.id != null && vehicle.id!.isNotEmpty) {
          await prefs.setString("vehicle_id", vehicle.id!);
          AppLogger.d("✅ Vehicle ID stored: ${vehicle.id}");
        }

        // Store vehicle type ID
        if (vehicle.vehicleType != null && vehicle.vehicleType!.isNotEmpty) {
          await prefs.setString("vehicle_type_id", vehicle.vehicleType!);
          AppLogger.d("✅ Vehicle Type ID stored: ${vehicle.vehicleType}");
        }

        // Optionally store other vehicle info if needed
        await prefs.setString("vehicle_name", vehicle.vehicleName ?? "");
        await prefs.setString("vehicle_number", vehicle.vehicleNumber ?? "");
        await prefs.setString("vehicle_color", vehicle.vehicleColor ?? "");
        await prefs.setString("vehicle_model", vehicle.vehicleModel ?? "");
        // await prefs.setInt("vehicle_capacity", vehicle.vehicleCapacity ?? 0);
      } else {
        AppLogger.d("⚠️ No vehicle data available");
      }

      return driverIdResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle5 : $e");
      return DriverIdResponse(success: false, message: "Connection error: $e");
    }
  }

  static const Duration apiTimeout = Duration(seconds: 15);

  static Future<Updateorderresposne> order_update_data({
    required dynamic orderstatus,
    required dynamic orderid,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        return Updateorderresposne(
          success: false,
          message: "Authentication required. Please login again.",
        );
      }

      final Uri url = Uri.parse("${ApiPath.baseUri}/order/update/$orderid");

      AppLogger.d('[RIDE_FLOW] Order update API request: $orderid -> $orderstatus');

      final response = await http
          .patch(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"orderStatus": orderstatus}),
          )
          .timeout(apiTimeout);

      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLogger.d('[RIDE_FLOW] Order update API success: $orderid -> $orderstatus');
        return Updateorderresposne.fromJson(decodedJson);
      } else if (response.statusCode == 401) {
        return Updateorderresposne(
          success: false,
          message: "Session expired. Please login again.",
        );
      } else if (response.statusCode >= 500) {
        return Updateorderresposne(
          success: false,
          message: "Server error. Please try again later.",
        );
      } else {
        return Updateorderresposne(
          success: false,
          // message: "Request failed with status ${response.statusCode}",
        );
      }
    } on TimeoutException {
      return Updateorderresposne(
        success: false,
        message: "Request timeout. Please check your connection.",
      );
    } catch (e) {
      AppLogger.d('[RIDE_FLOW] Order update API error: $e');
      return Updateorderresposne(
        success: false,
        message: "Connection error. Please check your internet.",
      );
    }
  }

  static Future<ChatResponse> chartidmethod({required dynamic orderid}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    AppLogger.d(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID  form chartid : $orderid",
    );
    // AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

    // final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/order/update/$orderid",
    // );

    // final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    final Uri url = Uri.parse("${ApiPath.baseUri}/chat/ride/$orderid");

    AppLogger.d("========== 🔵 ORDER UPDATE API ==========");
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

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      AppLogger.d("charttt_iddd>>>>>> 📦 FULL RESPONSE (Pretty Print) 👇");
      AppLogger.d(prettyJson);

      final ChatResponse getchatidresposne = ChatResponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(getchatidresposne);

      AppLogger.d("myyyyy_chart_iddd  ${getchatidresposne}");

      return getchatidresposne;
    } catch (e) {
      AppLogger.d("❌ Exception in  charttt_iddd");
      AppLogger.d(e);

      return ChatResponse(success: false);
    }
  }

  static Future<VerifyOtpResponse> verify_order_otp_data({
    required dynamic enteredOtp,
    required dynamic orderid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>> enteredOtp Status : $enteredOtp");

    // final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/order/update/$orderid",
    // );

    final Uri url = Uri.parse("${ApiPath.order_verify_otp}");

    AppLogger.d("========== 🔵 ORDER UPDATE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid, "rideOtp": enteredOtp}),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      AppLogger.d("📦 FULL RESPONSE (Pretty Print) 👇");
      AppLogger.d(prettyJson);

      final VerifyOtpResponse verifyOtpResponse = VerifyOtpResponse.fromJson(
        decodedJson,
      );

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(verifyOtpResponse);

      return verifyOtpResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in order_update_data");
      AppLogger.d(e);

      return VerifyOtpResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<Ordercompletecashresponse> declined_order_data({
    required dynamic orderstatus,
    required dynamic orderid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

    final Uri url = Uri.parse("${ApiPath.baseUri}/order/decline/$orderid");

    // final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    // order/decline/$orderId

    AppLogger.d("========== 🔵 ORDER UPDATE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid}),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      AppLogger.d("📦 FULL RESPONSE (Pretty Print) 👇");
      AppLogger.d(prettyJson);

      final Ordercompletecashresponse ordercompletecashresponse =
          Ordercompletecashresponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(ordercompletecashresponse);

      return ordercompletecashresponse;
    } catch (e) {
      AppLogger.d("❌ Exception in order_update_data");
      AppLogger.d(e);

      return Ordercompletecashresponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<RideHistoryResponse> get_rides_history_data({
    required String status,
  }) async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    //  final Uri url = Uri.parse(
    //     "${ApiPath.baseUri}/order/driver/history?status=${userId}",
    //   );

    AppLogger.d("myyyyyy>>>>status ${status}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/order/driver/history?status=${status}",
    );

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    // AppLogger.d("Request Body : ${jsonEncode(requestBody)}");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,

        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },

        // /getCompany
        // body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final RideHistoryResponse walletResponse = RideHistoryResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle10 : $e");
      return RideHistoryResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<ChatResponse> get_chat_messages_data({
    required String chatId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse("${ApiPath.baseUri}/chat/$chatId/messages");

    AppLogger.d("========== 🔵 GET CHAT MESSAGES API ==========");
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

      final decodedJson = jsonDecode(response.body);

      AppLogger.d("📦 FULL RESPONSE 👇");
      AppLogger.d(const JsonEncoder.withIndent('  ').convert(decodedJson));

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(decodedJson);
      } else {
        throw Exception(decodedJson['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      AppLogger.d("❌ Exception in get_chat_messages_data");
      throw Exception(e);
    }
  }
}
