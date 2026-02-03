import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:nzcu_driver/apiervices/api_path.dart';
import 'package:nzcu_driver/modals/add_money_wallet_response.dart';
import 'package:nzcu_driver/modals/bank_account_add_Res.dart';
import 'package:nzcu_driver/modals/chartid_response.dart';
import 'package:nzcu_driver/modals/driverId_response.dart';
import 'package:nzcu_driver/modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/get_all_vehicle_categories_response.dart';
import 'package:nzcu_driver/modals/get_bank_accounts_response.dart';
import 'package:nzcu_driver/modals/get_promo_code_data.dart';
import 'package:nzcu_driver/modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/modals/payments_withdraw_response.dart';
import 'package:nzcu_driver/modals/review_rating_response.dart';

import 'package:nzcu_driver/modals/ride_history_response2.dart';
import 'package:nzcu_driver/modals/terms_and_policy_response.dart';
import 'package:nzcu_driver/modals/transactions_response.dart';
import 'package:nzcu_driver/modals/update_order_response.dart';
import 'package:nzcu_driver/modals/wallet_response.dart';
import 'package:nzcu_driver/views/profile_related.dart/edit_profile.dart';
import 'package:nzcu_driver/views/scheduled_pickups/otp_and_Declined_files/verify_Otp_Order_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

// import 'package:nzcu_driver/apiServices/api_path.dart';
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
      print("❌ Exception in Create Vehicle4 : $e");
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
      print("❌ Exception in Create Vehicle2 : $e");
      return TransactionsResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<TransactionsResponse> add_bank_account_data() async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    final Uri url = Uri.parse("${ApiPath.bank_account_add}");

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
      print("❌ Exception in Create Vehicle3 : $e");
      return TransactionsResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<BankAccountAddResp> addBankAccountData({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String ifscCode,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString("driver_userid");
      final String? token = prefs.getString("auth_token");

      if (userId == null || userId.isEmpty) {
        return BankAccountAddResp(success: false, message: "User ID not found");
      }

      print("Sending driverId: $userId");

      final response = await http.post(
        Uri.parse(ApiPath.bank_account_add),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },

        // body: jsonEncode({
        //   "driverId": userId,
        //   "bankName": bankName,
        //   "accountNumber": accountNumber,
        //   "accountHolderName": accountHolderName,
        //   "ifscCode": ifscCode,
        // }),
        body: jsonEncode({
          "driverId": userId,
          "bankName": bankName,
          "accountNumber": accountNumber,
          "accountHolderName": accountHolderName,
          "ifscCode": ifscCode,
          "type": "UPI",
          "upiId": "d",
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      // ✅ FIX: Parse response regardless of status code
      final responseData = jsonDecode(response.body);

      // ✅ Check if success field exists in response
      if (responseData.containsKey('success')) {
        return BankAccountAddResp.fromJson(responseData);
      }
      // ✅ For 201 status (Created), treat as success
      else if (response.statusCode == 200 || response.statusCode == 201) {
        return BankAccountAddResp(
          success: true,
          message: "Bank account created successfully",
          data: BankAccountData.fromJson(responseData),
        );
      }
      // ✅ For error responses
      else {
        return BankAccountAddResp(
          success: false,
          message: responseData['message'] ?? "Failed to add bank account",
        );
      }
    } catch (e) {
      print("Error in addBankAccountData: $e");
      return BankAccountAddResp(
        success: false,
        message: "Network error: ${e.toString()}",
      );
    }
  }

  ////
  ///
  ///
  ///

  static Future<PaymentsWithdrawResponse> money_transfer({
    required String amount,
    required String? BankAccountId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString("driver_userid");
      final String? token = prefs.getString("auth_token");

      if (userId == null || userId.isEmpty) {
        return PaymentsWithdrawResponse(
          success: false,
          message: "User ID not found",
        );
      }

      print("Sending driverId: $userId");
      print("Bank_account_id: $BankAccountId");
      print("amount_i_am_Sending: $amount");

      // FIXED: Changed API endpoint to withdrawal endpoint
      final response = await http.post(
        Uri.parse(ApiPath.withdrawMoney), // Make sure this is correct endpoint
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"amount": amount, "BankAccountId": BankAccountId}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response: ${response.body}");

      final responseData = jsonDecode(response.body);

      // ✅ If response has success field, parse normally
      if (responseData.containsKey('success')) {
        return PaymentsWithdrawResponse.fromJson(responseData);
      }
      // ✅ For successful status codes but unexpected format
      else if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentsWithdrawResponse(
          success: true,
          message:
              responseData['message'] ??
              "Withdrawal request created successfully",
          data: responseData.containsKey('data')
              ? WithdrawData.fromJson(responseData['data'])
              : null,
        );
      }
      // ✅ For error responses
      else {
        return PaymentsWithdrawResponse(
          success: false,
          message: responseData['message'] ?? "Failed to process withdrawal",
        );
      }
    } catch (e) {
      print("Error in money_transfer: $e");
      // ✅ FIXED: Return correct type
      return PaymentsWithdrawResponse(
        success: false,
        message: "Network error: ${e.toString()}",
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

      // Store driver basic info
      await prefs.setString("driver_name", driverIdResponse.driver!.name ?? "");
      await prefs.setString(
        "driver_mobile",
        driverIdResponse.driver!.phone ?? "",
      );

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
        await prefs.setInt("vehicle_capacity", vehicle.vehicleCapacity ?? 0);
      } else {
        print("⚠️ No vehicle data available");
      }

      return driverIdResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle5 : $e");
      return DriverIdResponse(success: false, message: "Connection error: $e");
    }
  }

  //   static Future<DriverIdResponse> get_driverid_data() async {
  //     /// 🔐 GET TOKEN
  //     final prefs = await SharedPreferences.getInstance();
  //     final String? token = prefs.getString("auth_token");

  //     final String? userId = prefs.getString("driver_userid");

  //   print("herrrerrere_the_driverrrriddd_calling>>>>")
  // ;
  //     print("theeeee____ useriddddd ${userId}");

  //     final Uri url = Uri.parse(
  //       "${ApiPath.baseUri}/driver/getDriverProfile/${userId}",
  //     );

  //     print("========== CREATE VEHICLE API ==========");
  //     print("URL : $url");
  //     print("Token : $token");
  //     // print("Request Body : ${jsonEncode(requestBody)}");
  //     print("my_tokennnn ${token}");

  //     try {
  //       final http.Response response = await http.get(
  //         url,
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer $token", // ✅ BEARER TOKEN
  //         },
  //         // body: jsonEncode(requestBody),
  //       );

  //       print("Status Code : ${response.statusCode}");
  //       print("drievrrrrrid>>>>>>> resss >>>> Response Body : ${response.body}");

  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       final DriverIdResponse driverIdResponse = DriverIdResponse.fromJson(data);

  //   final prefs = await SharedPreferences.getInstance();

  //         await prefs.setString("driver_name", driverIdResponse.driver!.name ?? "");

  //         await prefs.setString("driver_mobile", driverIdResponse.driver!.phone ?? "");

  // //  if (driverIdResponse.token != null &&
  // //           otpResponse.token!.isNotEmpty &&
  // //           driverId != null &&
  // //           driverId.isNotEmpty) {

  // //       }
  //       return driverIdResponse;
  //     } catch (e) {
  //       print("❌ Exception in Create Vehicle5 : $e");
  //       return DriverIdResponse(success: false, message: "Connection error: $e");
  //     }
  //   }

  static Future<AddMoneyWalletResponse> initializeWalletTopUp({
    required dynamic amount,
    required String promoCodeId,
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    print("theeeee____ useriddddd ${userId}");

    print("theeeee____ amount gott ${amount}");

    final Uri url = Uri.parse(ApiPath.addwalletapi);

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final response = await http.post(
        Uri.parse(ApiPath.addwalletapi),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          // "driverId": userId,
          "amount": amount,
          // "promoCodeId": "696f52cdfa3339f023632110",
          "promoCodeId": promoCodeId,
        }),
      );
      print("Status Code : ${response.statusCode}");
      print("total__Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final AddMoneyWalletResponse walletResponse =
          AddMoneyWalletResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle7 : $e");
      return AddMoneyWalletResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<bool> verifyAndAddMoneydata({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    print("theeeee____ razorpayOrderId ${razorpayOrderId}");

    print("theeeee____ razorpayPaymentId ${razorpayPaymentId}");

    print("theeeee____ razorpaySignature ${razorpaySignature}");
    final Uri url = Uri.parse(ApiPath.addwalletapi);

    print("========== CREATE VEHICLE API ==========");
    print("URL : $url");
    print("Token : $token");
    // print("Request Body : ${jsonEncode(requestBody)}");
    print("my_tokennnn ${token}");

    try {
      final response = await http.post(
        Uri.parse(ApiPath.payments_verify_api),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          // "driverId": userId,
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
        }),
      );
      print("Status Code : ${response.statusCode}");
      print("total__Response Body : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);

      Fluttertoast.showToast(
        msg: data['message'] ?? "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

      return true;
    } catch (e) {
      print("❌ Exception in Create Vehicle6 : $e");

      return false;
      // return AddMoneyWalletResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<GetBankAccountsResponse> get_bankdetails_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    print("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/bank-accounts/driverId/${userId}",
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
      final GetBankAccountsResponse walletResponse =
          GetBankAccountsResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Excesssssssssssption in drivverrrrrr idd : $e");
      return GetBankAccountsResponse(
        success: false,
        message: "Connection error: $e",
      );
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
      final ReviewRatingResponse walletResponse = ReviewRatingResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle9 : $e");
      return ReviewRatingResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<Termsandpolicyresponse> get_terams_and_policy_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    print("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse("${ApiPath.privacy_terms_api}");
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
      final Termsandpolicyresponse walletResponse =
          Termsandpolicyresponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle8 : $e");
      return Termsandpolicyresponse(
        success: false,
        message: "Connection error: $e",
      );
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
          message: "Request failed with status ${response.statusCode}",
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

  // static Future<Updateorderresposne> order_update_data({
  //   required dynamic orderstatus,
  //   required dynamic orderid,
  //   BuildContext? context,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");
  //   final String? userId = prefs.getString("driver_userid");

  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

  //   final Uri url = Uri.parse("${ApiPath.baseUri}/order/update/$orderid");

  //   print("========== 🔵 ORDER UPDATE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");

  //   try {
  //     final http.Response response = await http.patch(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"orderStatus": orderstatus}),
  //     );

  //     print("✅ Status Code : ${response.statusCode}");

  //     final decodedJson = jsonDecode(response.body);

  //     /// 🔥 PRETTY PRINT
  //     final prettyJson = const JsonEncoder.withIndent(
  //       '  ',
  //     ).convert(decodedJson);
  //     print("📦 FULL RESPONSE 👇");
  //     print(prettyJson);

  //     /// 🔹 HANDLE SUCCESS TRUE / FALSE
  //     if (decodedJson["success"] == true) {
  //       print("🎉 ORDER UPDATE SUCCESS");

  //       return Updateorderresposne.fromJson(decodedJson);
  //     } else {
  //       print("⚠️ ORDER UPDATE FAILED");

  //       return Updateorderresposne(
  //         success: false,
  //         message: decodedJson["message"] ?? "Order update failed",
  //       );
  //     }
  //   } catch (e) {
  //     print("❌ Exception in order_update_data");
  //     print(e);

  //     return Updateorderresposne(
  //       success: false,
  //       message: "Connection error: $e",
  //     );
  //   }
  // }

  // static Future<Updateorderresposne> order_update_data({
  //   required dynamic orderstatus,
  //   required dynamic orderid,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");
  //   final String? userId = prefs.getString("driver_userid");

  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");
  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>> Order Status : $orderstatus");

  //   final Uri url = Uri.parse("${ApiPath.baseUri}/order/update/$orderid");

  //   print("========== 🔵 ORDER UPDATE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");

  //   try {
  //     final http.Response response = await http.patch(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"orderStatus": orderstatus}),
  //     );

  //     print("✅ Status Code : ${response.statusCode}");

  //     /// 🔥 PRETTY PRINT FULL RESPONSE
  //     final decodedJson = jsonDecode(response.body);
  //     final prettyJson = const JsonEncoder.withIndent(
  //       '  ',
  //     ).convert(decodedJson);

  //     print("📦 FULL RESPONSE (Pretty Print) 👇");
  //     print(prettyJson);

  //     final Updateorderresposne updateorderresposne =
  //         Updateorderresposne.fromJson(decodedJson);

  //     print("🎯 Parsed Model Object 👇");
  //     print(updateorderresposne);

  //     return updateorderresposne;
  //   } catch (e) {
  //     print("❌ Exception in order_update_data");
  //     print(e);

  //     return Updateorderresposne(
  //       success: false,
  //       message: "Connection error: $e",
  //     );
  //   }
  // }

  static Future<Ordercompletecashresponse> cash_update_data({
    required dynamic orderid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");

    final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    print("========== 🔵 CASH PAYMENT API ==========");
    print("URL : $url");
    print("Token : $token");

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid}),
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
      final Ordercompletecashresponse ordercompletecashresponse =
          Ordercompletecashresponse.fromJson(decodedJson);

      print("🎯 Parsed Model Object 👇");
      print(ordercompletecashresponse);

      return ordercompletecashresponse;
    } catch (e) {
      print("❌ Exception in cash_update_data");
      print(e.toString());

      // Return a proper error response
      return Ordercompletecashresponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<Getpromocodedata> get_promocode_data() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse("${ApiPath.baseUri}/promocodes/eligible");

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
        // body: jsonEncode({"orderId": orderid}),
      );

      print("✅ Status Code : ${response.statusCode}");

      print("thee_response_promocode_bodyyyyyy ${response.body}");
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
      final Getpromocodedata getpromocodedata = Getpromocodedata.fromJson(
        decodedJson,
      );

      print("🎯 Parsed Model Object 👇");
      print(getpromocodedata);

      return getpromocodedata;
    } catch (e) {
      print("❌ Exception in get_promocode_data");
      print(e.toString());

      // Return a proper error response
      return Getpromocodedata(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<GetAllVehicleCategoriesResponse> get_vehical_data() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse("${ApiPath.baseUri}/getAllVehicleCategories");

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

  // static Future<Ordercompletecashresponse> cash_update_data({

  //   required dynamic orderid,
  // }) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");
  //   final String? userId = prefs.getString("driver_userid");

  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> User ID : $userId");
  //   print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");

  //   // final Uri url = Uri.parse(
  //   //   "${ApiPath.baseUri}/order/update/$orderid",
  //   // );

  //   final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

  //   print("========== 🔵 ORDER UPDATE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");

  //   try {
  //     final http.Response response = await http.patch(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"orderId": orderid}),
  //     );

  //     print("✅ Status Code : ${response.statusCode}");

  //     /// 🔥 PRETTY PRINT FULL RESPONSE
  //     final decodedJson = jsonDecode(response.body);
  //     final prettyJson = const JsonEncoder.withIndent(
  //       '  ',
  //     ).convert(decodedJson);

  //     print("📦 FULL RESPONSE (Pretty Print) 👇");
  //     print(prettyJson);

  //     final Ordercompletecashresponse ordercompletecashresponse =
  //         Ordercompletecashresponse.fromJson(decodedJson);

  //     print("🎯 Parsed Model Object 👇");
  //     print(ordercompletecashresponse);

  //     print("myyyy_cashhhhh_resposeeee_hererrr ${ordercompletecashresponse}");

  //     return ordercompletecashresponse;
  //   } catch (e) {
  //     print("❌ Exception in order_update_data");
  //     print(e);

  //     return Ordercompletecashresponse(
  //       success: false,
  //       message: "Connection error: $e",
  //     );
  //   }
  // }

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

  // static Future<Updateorderresposne> order_update_data({required dynamic orderstatus, required dynamic orderid}) async {
  //   /// 🔐 GET TOKEN
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString("auth_token");

  //   final String? userId = prefs.getString("driver_userid");

  //   print("theeeee____ useriddddd ${userId}");

  //   print("theee_orderrrr_gottttttt>>>>>>>>> ${orderid}");

  //   print("theee_orderrrr_gottttttt>>>>>>>>> my_status ${orderstatus}");

  //   final Uri url = Uri.parse(
  //     "${ApiPath.baseUri}/order/update/${orderid}",
  //   );

  //   print("========== CREATE VEHICLE API ==========");
  //   print("URL : $url");
  //   print("Token : $token");
  //   // print("Request Body : ${jsonEncode(requestBody)}");
  //   print("my_tokennnn ${token}");

  //   try {
  //     final http.Response response = await http.patch(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token", // ✅ BEARER TOKEN
  //       },
  //       // body: jsonEncode(requestBody),

  //        body: jsonEncode({
  //         "orderStatus": orderstatus,

  //       }),
  //     );

  //     print("Status Code : ${response.statusCode}");
  //     print("Response Body : ${response.body}");

  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     final Updateorderresposne updateorderresposne =
  //         Updateorderresposne.fromJson(data);

  //         print("herreree_sudessss_update_order ${updateorderresposne}");

  //     return updateorderresposne;
  //   } catch (e) {
  //      print("myupdate_order_data22222222  faileddd111 in catchhh");
  //     print("❌ Exception in Create Vehicle : $e");
  //     return Updateorderresposne(
  //       success: false,
  //       message: "Connection error: $e",
  //     );
  //   }
  // }

  static Future<RideHistoryResponse2> get_rides_history_data({
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
      final RideHistoryResponse2 walletResponse = RideHistoryResponse2.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      print("❌ Exception in Create Vehicle10 : $e");
      return RideHistoryResponse2(
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
