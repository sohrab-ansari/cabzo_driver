import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:nzcu_driver/modals/home_modals/get_city_by_location_response.dart';
import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
import 'package:nzcu_driver/modals/profile_modals/get_by_category_response.dart';
import 'package:nzcu_driver/modals/profile_modals/update_bank_and_upi_response.dart';
import 'package:nzcu_driver/services/baseurl/api_path.dart';
import 'package:nzcu_driver/modals/profile_modals/add_money_wallet_response.dart';
import 'package:nzcu_driver/modals/profile_modals/bank_account_add_Res.dart';
import 'package:nzcu_driver/modals/auth_modals/create_by_driver_respose.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
import 'package:nzcu_driver/modals/profile_modals/get_promo_code_data.dart';
import 'package:nzcu_driver/modals/profile_modals/notification_response.dart';
import 'package:nzcu_driver/modals/home_modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/modals/profile_modals/payments_withdraw_response.dart';
import 'package:nzcu_driver/modals/profile_modals/review_rating_response.dart';
import 'package:nzcu_driver/modals/profile_modals/terms_and_policy_response.dart';
import 'package:nzcu_driver/modals/profile_modals/transactions_response.dart';
import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class ProfileApiServices {
  static Future<GetCityByLocationResponse> get_cit_by_loc_method({
    required String lat,
    required String lng,
  }) async {

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/location/city?lat=$lat&lng=$lng",
    );

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

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

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body  get city by id>>>>>> data : ${response.body}");
      
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final GetCityByLocationResponse categoriesResponse =
            GetCityByLocationResponse.fromJson(data);
        return categoriesResponse;
      } else {
        // Handle non-200 status codes
        return GetCityByLocationResponse(
          success: false,
          message: "Error: ${data['message']}",
        );
      }
    } catch (e) { 
      AppLogger.d("Exception in get city by id>>>>>> data : $e");
      return GetCityByLocationResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<FaqsCategoriesResponse> get_all_categories_data() async {
    final Uri url = Uri.parse("${ApiPath.get_All_Categories}");

    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    AppLogger.d("========== GET FAQS CATEGORIES API ==========");
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

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final FaqsCategoriesResponse categoriesResponse =
            FaqsCategoriesResponse.fromJson(data);
        return categoriesResponse;
      } else {
        // Handle non-200 status codes
        return FaqsCategoriesResponse(
          success: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      AppLogger.d("❌ Exception in get_all_categories_data: $e");
      return FaqsCategoriesResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<GetByCategoryResponse> get_faq_categories_data({
    required String category,
  }) async {
    // final Uri url = Uri.parse("${ApiPath.baseUri}/getByCategory?category=$category");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/getByCategory/${Uri.encodeComponent(category)}",
    );

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString("auth_token");

    AppLogger.d("========== GET FAQS BY CATEGORY API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Category: $category");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("faqqss_get_Response Body : ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final GetByCategoryResponse faqResponse =
            GetByCategoryResponse.fromJson(data);
        return faqResponse;
      } else {
        return GetByCategoryResponse(
          success: false,
          message: "Error: ${response.statusCode}",
        );
      }
    } catch (e) {
      AppLogger.d("❌ Exception in get_faq_categories_data: $e");
      return GetByCategoryResponse(
        success: false,
        message: "Connection error: $e",
      );
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

    AppLogger.d("my_tokennnnn ${token}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/driver/update?userId=$userId&userType=$userType",
    );

    AppLogger.d("URL => $url");
    AppLogger.d("Name => $name");
    AppLogger.d("Email => $email");
    AppLogger.d("dateOfBirth ===== => $dateOfBirth");
    AppLogger.d("gender =====> $gender");
    AppLogger.d("Image provided: ${image != null ? 'Yes' : 'No'}");

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
        AppLogger.d("Image attached: ${image.path}");
      } else {
        AppLogger.d("No image provided - skipping image upload");
      }

      final response = await request.send();
      final statusCode = response.statusCode;
      final body = await response.stream.bytesToString();

      AppLogger.d("Status Code: $statusCode");
      AppLogger.d("Response Body: $body");

      if (statusCode == 200) {
        AppLogger.d("hekllooooo");

        // Parse the response
        Map<String, dynamic> responseData = json.decode(body);

        // Check if response contains driver data and update name in SharedPreferences
        if (responseData.containsKey('driver') &&
            responseData['driver'] != null) {
          String driverName = responseData['driver']['name'] ?? '';
          if (driverName.isNotEmpty) {
            await prefs.setString('driver_name', driverName);
            AppLogger.d("Driver name updated in SharedPreferences: $driverName");
          }
        } else if (name != null && name.isNotEmpty) {
          // Fallback: use the name that was sent in the request
          await prefs.setString('driver_name', name);
          AppLogger.d("Driver name updated with request name: $name");
        }

        Get.offAll(BottomnavmainScreen(initialIndex: 3));
        return DriverImageUploadRes.fromJson(responseData);
      } else {
        AppLogger.d("hekllooooo222");
        return DriverImageUploadRes(
          success: false,
          message: "Unexpected response format",
        );
      }
    } catch (e) {
      AppLogger.d("hekllooooo3333");
      AppLogger.d("API Error: $e");
      return DriverImageUploadRes(success: false, message: e.toString());
    }
  }

  static Future<WalletResponse> get_wallet_data() async {
    final Uri url = Uri.parse("${ApiPath.wallet_api}");

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
      final WalletResponse walletResponse = WalletResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle4 : $e");
      return WalletResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<TransactionsResponse> get_transactions_data(
    dynamic limit,
    dynamic page,
  ) async {
    // final Uri url = Uri.parse(ApiPath.createVehicle);
    // final Uri url = Uri.parse("${ApiPath.transactions_api}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/transactions?limit=$limit&page=$page",
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
        // body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final TransactionsResponse walletResponse = TransactionsResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle2 : $e");
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
      final TransactionsResponse walletResponse = TransactionsResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle3 : $e");
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

    String? type,
    String? upiId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString("driver_userid");
      final String? token = prefs.getString("auth_token");

      if (userId == null || userId.isEmpty) {
        return BankAccountAddResp(success: false, message: "User ID not found");
      }

      AppLogger.d("Sending driverId: $userId");

      // Build the request body dynamically
      Map<String, dynamic> requestBody = {
        "driverId": userId,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "accountHolderName": accountHolderName,
        "ifscCode": ifscCode,
      };

      // Add type if provided
      if (type != null && type.isNotEmpty) {
        requestBody["type"] = type;
      }

      // Add upiId ONLY if it's not null and not empty
      if (upiId != null && upiId.isNotEmpty) {
        requestBody["upiId"] = upiId;
      }

      final response = await http.post(
        Uri.parse(ApiPath.bank_account_add),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      AppLogger.d("Status Code: ${response.statusCode}");
      AppLogger.d("Response: ${response.body}");

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
      AppLogger.d("Error in addBankAccountData: $e");
      return BankAccountAddResp(
        success: false,
        message: "Network error: ${e.toString()}",
      );
    }
  }

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

      AppLogger.d("Sending driverId: $userId");
      AppLogger.d("Bank_account_id: $BankAccountId");
      AppLogger.d("amount_i_am_Sending: $amount");

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

      AppLogger.d("Status Code: ${response.statusCode}");
      AppLogger.d("Response: ${response.body}");

      final responseData = jsonDecode(response.body);

      // ✅ If response has success field, parse normally
      if (responseData.containsKey('success')) {
        AppLogger.d("helloooo111");

        AppLogger.d("came_or_not");
        if (responseData['success'] == true) {
          AppLogger.d("came_or_no222t");
          CustomToast.showSuccess("Withdrawal Successful");
        } else {
          AppLogger.d("helloooo111 failedd data");
          CustomToast.showError("Insufficient Balance");
          Get.back();
        }

        return PaymentsWithdrawResponse.fromJson(responseData);
      }
      // ✅ For successful status codes but unexpected format
      else if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.d("helloooo1112222");

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
        AppLogger.d("helloooo111333");

        return PaymentsWithdrawResponse(
          success: false,
          message: responseData['message'] ?? "Failed to process withdrawal",
        );
      }
    } catch (e) {
      AppLogger.d("helloooo1114444");

      AppLogger.d("Error in money_transfer: $e");
      // ✅ FIXED: Return correct type
      return PaymentsWithdrawResponse(
        success: false,
        message: "Network error: ${e.toString()}",
      );
    }
  }

  static Future<AddMoneyWalletResponse> initializeWalletTopUp({
    required dynamic amount,
    required String promoCodeId,
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("theeeee____ useriddddd ${userId}");

    AppLogger.d("theeeee____ amount gott ${amount}");

    final Uri url = Uri.parse(ApiPath.addwalletapi);

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    // AppLogger.d("Request Body : ${jsonEncode(requestBody)}");
    AppLogger.d("my_tokennnn ${token}");

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
      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("total__Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);

      CustomToast.showSuccess(data['message'] ?? 'Something went wrong');

      final AddMoneyWalletResponse walletResponse =
          AddMoneyWalletResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in promo code craete : $e");
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

    AppLogger.d("theeeee____ razorpayOrderId ${razorpayOrderId}");

    AppLogger.d("theeeee____ razorpayPaymentId ${razorpayPaymentId}");

    AppLogger.d("theeeee____ razorpaySignature ${razorpaySignature}");
    final Uri url = Uri.parse(ApiPath.addwalletapi);

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    // AppLogger.d("Request Body : ${jsonEncode(requestBody)}");
    AppLogger.d("my_tokennnn ${token}");

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
      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("total__Response Body : ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);

      CustomToast.showSuccess(data['message'] ?? "Something went wrong");

      return true;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle6 : $e");

      return false;
      // return AddMoneyWalletResponse(success: false, message: "Connection error: $e");
    }
  }

  static Future<GetBankAccountsResponse> get_bankdetails_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/bank-accounts/driverId/${userId}",
    );

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
      final GetBankAccountsResponse walletResponse =
          GetBankAccountsResponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Excesssssssssssption in drivverrrrrr idd : $e");
      return GetBankAccountsResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<UpdateBankAndUpiResponse> update_Upi_data({
    required dynamic acoountid,

    required dynamic upiId,
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("herrrerrere_the_driverrrriddd_calling>>>>");
    AppLogger.d("theeeee____ accountidddddd ${acoountid}");

    AppLogger.d("theeeee____ upiId ${upiId}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/bank-accounts/update/${acoountid}",
    );

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },

        body: jsonEncode({
          // "type": type,
          "type": "UPI",

          "upiId": upiId,
        }),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d(
        "update upiiiii respsoneeee>>>>>>> resss >>>> Response Body : ${response.body}",
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final UpdateBankAndUpiResponse driverIdResponse =
          UpdateBankAndUpiResponse.fromJson(data);

      return driverIdResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle5 : $e");
      return UpdateBankAndUpiResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<UpdateBankAndUpiResponse> update_bank_data({
    required dynamic acoountid,

    required dynamic bankName,

    required dynamic accountNumber,

    required dynamic ifscCode,

    required dynamic accountHolderName,
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("herrrerrere_the_driverrrriddd_calling>>>>");
    AppLogger.d("theeeee____ accountidddddd ${acoountid}");

    //  AppLogger.d("theeeee____ type ${type}");
    AppLogger.d("theeeee____ bankName ${bankName}");

    AppLogger.d("theeeee____ accountNumber ${accountNumber}");
    AppLogger.d("theeeee____ ifscCode ${ifscCode}");
    AppLogger.d("theeeee____ accountHolderName ${accountHolderName}");
    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/bank-accounts/update/${acoountid}",
    );

    AppLogger.d("========== CREATE VEHICLE API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");
    AppLogger.d("my_tokennnn ${token}");

    try {
      final http.Response response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ BEARER TOKEN
        },

        body: jsonEncode({
          "type": "BankAccount",
          "bankName": bankName,

          "accountNumber": accountNumber,

          "ifscCode": ifscCode,
          "accountHolderName": accountHolderName,
        }),
      );

      AppLogger.d("Status Code : ${response.statusCode}");
      AppLogger.d("drievrrrrrid>>>>>>> resss >>>> Response Body : ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final UpdateBankAndUpiResponse driverIdResponse =
          UpdateBankAndUpiResponse.fromJson(data);

      return driverIdResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle5 : $e");
      return UpdateBankAndUpiResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  // In your profile_api_services.dart file

  static Future<UpdateBankAndUpiResponse> delete_bank_upi_data({
    required dynamic accountid, // Fixed spelling
  }) async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");
    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("herrrerrere_the_driverrrriddd_calling>>>>");
    AppLogger.d("theeeee____ accountid: $accountid"); // Fixed print
    AppLogger.d("userId: $userId");
    AppLogger.d("token exists: ${token != null}");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/bank-accounts/delete/$accountid", // Use fixed parameter
    );

    AppLogger.d("========== DELETE BANK/UPI API ==========");
    AppLogger.d("URL: $url");
    AppLogger.d(
      "Token: ${token != null ? token!.substring(0, token.length > 10 ? 10 : token.length) + '...' : 'null'}",
    );

    try {
      final http.Response response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      AppLogger.d("Status Code: ${response.statusCode}");
      AppLogger.d("Response Body: ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);
      final UpdateBankAndUpiResponse driverIdResponse =
          UpdateBankAndUpiResponse.fromJson(data);

      return driverIdResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in delete_bank_upi_data: $e");
      return UpdateBankAndUpiResponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  // delete_bank_upi_data
  static Future<ReviewRatingResponse> get_review_rating_data() async {
    /// 🔐 GET TOKEN
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final String? userId = prefs.getString("driver_userid");

    AppLogger.d("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse("${ApiPath.ratings_api}");
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
      final ReviewRatingResponse walletResponse = ReviewRatingResponse.fromJson(
        data,
      );

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle9 : $e");
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

    AppLogger.d("theeeee____ useriddddd ${userId}");

    final Uri url = Uri.parse("${ApiPath.privacy_terms_api}");
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
      final Termsandpolicyresponse walletResponse =
          Termsandpolicyresponse.fromJson(data);

      return walletResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in Create Vehicle8 : $e");
      return Termsandpolicyresponse(
        success: false,
        message: "Connection error: $e",
      );
    }
  }

  static Future<Ordercompletecashresponse> cash_update_data({
    required dynamic orderid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    AppLogger.d(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Order ID : $orderid");

    final Uri url = Uri.parse("${ApiPath.baseUri}/payments/cash");

    AppLogger.d("========== 🔵 CASH PAYMENT API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"orderId": orderid}),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

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
      final Ordercompletecashresponse ordercompletecashresponse =
          Ordercompletecashresponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(ordercompletecashresponse);

      return ordercompletecashresponse;
    } catch (e) {
      AppLogger.d("❌ Exception in cash_update_data");
      AppLogger.d(e.toString());

      // Return a proper error response
      return Ordercompletecashresponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<CreateByDriverResponse> createByDriverData({
    required double startLat,
    required double startLng,
    required String startAddress,
    required double endLat,
    required double endLng,
    required String endAddress,
    required String userName,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse("${ApiPath.baseUri}/order/createByDriver");

    AppLogger.d("========== 🔵 CREATE BY DRIVER API ==========");
    AppLogger.d("URL : $url");
    AppLogger.d("Token : $token");

    /// 🔥 Payload exactly as backend expects
    final Map<String, dynamic> payload = {
      "startLocation": {
        "type": "Point",
        "coordinates": [startLat, startLng],
        "address": startAddress,
      },
      "endLocation": {
        "type": "Point",
        "coordinates": [endLat, endLng],
        "address": endAddress,
      },
      "userName": userName,
      "phone": phone,
    };

    AppLogger.d("📤 REQUEST BODY 👇");
    AppLogger.d(const JsonEncoder.withIndent('  ').convert(payload));

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

      final decodedJson = jsonDecode(response.body);

      AppLogger.d("📦 RESPONSE 👇");
      AppLogger.d(const JsonEncoder.withIndent('  ').convert(decodedJson));

      return CreateByDriverResponse.fromJson(decodedJson);
    } catch (e) {
      AppLogger.d("❌ Exception in createByDriverData");
      AppLogger.d(e.toString());

      return CreateByDriverResponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<NotificationResponse> get_notification_data() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse(
      "${ApiPath.baseUri}/notification/userNotifications",
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
        // body: jsonEncode({"orderId": orderid}),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

      AppLogger.d("thee_response_notification_bodyyyyyy ${response.body}");
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
      final NotificationResponse notificationResponse =
          NotificationResponse.fromJson(decodedJson);

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(notificationResponse);

      return notificationResponse;
    } catch (e) {
      AppLogger.d("❌ Exception in get_notification_data");
      AppLogger.d(e.toString());

      // Return a proper error response
      return NotificationResponse(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }

  static Future<Getpromocodedata> get_promocode_data() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    final Uri url = Uri.parse("${ApiPath.baseUri}/promocodes/eligible");

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
        // body: jsonEncode({"orderId": orderid}),
      );

      AppLogger.d("✅ Status Code : ${response.statusCode}");

      AppLogger.d("thee_response_promocode_bodyyyyyy ${response.body}");
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
      final Getpromocodedata getpromocodedata = Getpromocodedata.fromJson(
        decodedJson,
      );

      AppLogger.d("🎯 Parsed Model Object 👇");
      AppLogger.d(getpromocodedata);

      return getpromocodedata;
    } catch (e) {
      AppLogger.d("❌ Exception in get_promocode_data");
      AppLogger.d(e.toString());

      // Return a proper error response
      return Getpromocodedata(
        success: false,
        message: "Connection error: ${e.toString()}",
      );
    }
  }
}
