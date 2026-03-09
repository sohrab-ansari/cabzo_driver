import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class HomeApiServices {
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
        await prefs.setString(
          "driver_userid",
          homeModalResponse.driver!.id.toString(),
        );

        await prefs.setString(
          "driver_name",
          homeModalResponse.driver!.name.toString(),
        );

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
      print("❌ Exception in Create Vehicle1 : $e");
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
    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.patch(
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
      final Drivertoggledutyresponse drivertoggledutyresponse =
          Drivertoggledutyresponse.fromJson(data);

      print("my_driver_tokennnn_toggle_respose ${data}");
      print("Response Body222222222 : ${drivertoggledutyresponse.driver!.id}");

      if (drivertoggledutyresponse.success == true &&
          drivertoggledutyresponse.driver != null &&
          drivertoggledutyresponse.driver!.id != null) {
        print(
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

        print(
          "Response Body222222222jjjj : ${drivertoggledutyresponse.driver!.id}",
        );
        // print(
        //   "✅ Driver user ID saved to SharedPreferences: ${registerProfileRes.data!.id}",
        // );
      } else {
        print(
          "⚠️  Could not save driver_userid - ID is null or response not successful",
        );
      }
      return drivertoggledutyresponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle1 : $e");
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

    print("herrrerrere_the_driverrrriddd_calling>>>>");
    print("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/getDriverProfile/${userId}",
    );

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    print("my_tokennnn ${token}");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },
      );

      print("Status Code : ${response.statusCode}");
      print("drievrrrrrid>>>>>>> resss >>>> Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final DriverIdResponse driverIdResponse = DriverIdResponse.fromJson(data);

      print(
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
          print("✅ Vehicle ID stored: ${vehicle.id}");
        }

        // Store vehicle type ID
        if (vehicle.vehicleType != null && vehicle.vehicleType!.isNotEmpty) {
          await prefs.setString("vehicle_type_id", vehicle.vehicleType!);
          print("✅ Vehicle Type ID stored: ${vehicle.vehicleType}");
        }

        // Optionally store other vehicle info if needed
        await prefs.setString("vehicle_name", vehicle.vehicleName ?? "");
        await prefs.setString("vehicle_number", vehicle.vehicleNumber ?? "");
        await prefs.setString("vehicle_color", vehicle.vehicleColor ?? "");
        await prefs.setString("vehicle_model", vehicle.vehicleModel ?? "");
        // await prefs.setInt("vehicle_capacity", vehicle.vehicleCapacity ?? 0);
      } else {
        print("⚠️ No vehicle data available");
      }

      return driverIdResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle5 : $e");
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

      print("🔄 Order Update API: $orderid -> $orderstatus");

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

      print("✅ Response Status: ${response.statusCode}");

      print("myyyy_fulllll_respsoneeeee ${response.body}");

      // Fluttertoast.showToast(msg: response.body['message']);

      final Map<String, dynamic> decodedJson = jsonDecode(response.body);

      Fluttertoast.showToast(
        msg: decodedJson['message'] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP, // 👈 THIS
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14,
      );

      // ✅ Show API message in toast
      // Fluttertoast.showToast(
      //   msg: decodedJson['message'] ?? "Something went wrong",
      // );
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);

        // print("myyyy_fulllll_respsoneeeee ${decodedJson}");

        final prettyJson = const JsonEncoder.withIndent(
          '  ',
        ).convert(decodedJson);

        for (var i = 0; i < prettyJson.length; i += 800) {
          debugPrint(
            prettyJson.substring(
              i,
              i + 800 > prettyJson.length ? prettyJson.length : i + 800,
            ),
          );
        }

        print("herrrrrrrrrrrrrrrrrrrrrr ${prettyJson}");

        //         print(
        //   "myyyy_fulllll_respsoneeeee\n"
        //   "${const JsonEncoder.withIndent('  ').convert(decodedJson)}"
        // );
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
      print("❌ API Error: $e");
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

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    print(
      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID  form chartid : $orderid",
    );
    // print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

    // final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/order/update/$orderid",
    // );

    // final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    final Uri url = Uri.parse("${ApiPath.baseUri}/chat/ride/$orderid");

    print("========== 🔵 ORDER UPDATE API ==========");
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

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      print("charttt_iddd>>>>>> 📦 FULL RESPONSE (Pretty Print) 👇");
      print(prettyJson);

      final ChatResponse getchatidresposne = ChatResponse.fromJson(decodedJson);

      print("🎯 Parsed Model Object 👇");
      print(getchatidresposne);

      print("myyyyy_chart_iddd  ${getchatidresposne}");

      return getchatidresposne;
    } catch (e) {
      print("❌ Exception in  charttt_iddd");
      print(e);

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

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> enteredOtp Status : $enteredOtp");

    // final Uri url = Uri.parse(
    //   "${ApiPath.baseUri}/order/update/$orderid",
    // );

    final Uri url = Uri.parse("${ApiPath.order_verify_otp}");

    print("========== 🔵 ORDER UPDATE API ==========");
    print("URL : $url");
    print("Token : $token");

    try {
      final http.Response response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid, "rideOtp": enteredOtp}),
      );

      print("✅ Status Code : ${response.statusCode}");

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      print("📦 FULL RESPONSE (Pretty Print) 👇");
      print(prettyJson);

      final VerifyOtpResponse verifyOtpResponse = VerifyOtpResponse.fromJson(
        decodedJson,
      );

      print("🎯 Parsed Model Object 👇");
      print(verifyOtpResponse);

      return verifyOtpResponse;
    } catch (e) {
      print("❌ Exception in order_update_data");
      print(e);

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

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

    final Uri url = Uri.parse("${ApiPath.baseUri}/order/decline/$orderid");

    // final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    // order/decline/$orderId

    print("========== 🔵 ORDER UPDATE API ==========");
    print("URL : $url");
    print("Token : $token");

    try {
      final http.Response response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid}),
      );

      print("✅ Status Code : ${response.statusCode}");

      /// 🔥 PRETTY PRINT FULL RESPONSE
      final decodedJson = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(decodedJson);

      print("📦 FULL RESPONSE (Pretty Print) 👇");
      print(prettyJson);

      final Ordercompletecashresponse ordercompletecashresponse =
          Ordercompletecashresponse.fromJson(decodedJson);

      print("🎯 Parsed Model Object 👇");
      print(ordercompletecashresponse);

      return ordercompletecashresponse;
    } catch (e) {
      print("❌ Exception in order_update_data");
      print(e);

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

    print("myyyyyy>>>>status ${status}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/order/driver/history?status=${status}",
    );

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

        // /getCompany
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
      print("❌ Exception in Create Vehicle10 : $e");
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

    print("========== 🔵 GET CHAT MESSAGES API ==========");
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

      final decodedJson = jsonDecode(response.body);

      print("📦 FULL RESPONSE 👇");
      print(const JsonEncoder.withIndent('  ').convert(decodedJson));

      if (response.statusCode == 200) {
        return ChatResponse.fromJson(decodedJson);
      } else {
        throw Exception(decodedJson['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      print("❌ Exception in get_chat_messages_data");
      throw Exception(e);
    }
  }
}
