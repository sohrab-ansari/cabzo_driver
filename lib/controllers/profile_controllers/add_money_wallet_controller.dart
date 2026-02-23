import 'dart:convert';
// import 'package:nzcu_driver/apiServices/services/payments/razorpay_service.dart';
import 'package:nzcu_driver/services/payments_service/razorpay_service.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/views/profile_screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nzcu_driver/apiServices/services/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/add_money_wallet_response.dart';
// import 'package:nzcu_driver/services/razorpay_service.dart';
import 'package:http/http.dart' as http;

class AddMoneyWalletController extends GetxController {
  // State management
  Rx<AddMoneyWalletResponse?> walletResponse = Rx<AddMoneyWalletResponse?>(
    null,
  );
  RxBool isLoading = false.obs;
  RxBool isPaymentProcessing = false.obs;
  RxString errorMessage = ''.obs;

  // Razorpay
  final RazorpayService razorpayService = RazorpayService();

  // Payment verification data
  String? currentOrderId;
  int? currentAmount;

  @override
  void onInit() {
    super.onInit();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    razorpayService.initialize(
      onSuccess: _handlePaymentSuccess,
      onError: _handlePaymentError,
    );
  }

  @override
  void onClose() {
    razorpayService.dispose();
    super.onClose();
  }

  Future<void> add_wallet_method({
    required dynamic amount,
    dynamic promoCodeId,
  }) async {
    print("💰 add_wallet_method called with amount: $amount");

    // Validate amount
    if (amount.toString().isEmpty) {
      _showError('Please enter amount');
      return;
    }

    final amountNum = double.tryParse(amount.toString());
    if (amountNum == null || amountNum <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';
    isPaymentProcessing.value = false;

    try {
      // Step 1: Initialize wallet top-up to get order details
      final AddMoneyWalletResponse res =
          await ProfileApiServices.initializeWalletTopUp(
            amount: amount.toString(),
            promoCodeId: promoCodeId ?? '',
          );

      print("🎯 Order Creation Response: ${res.success}");
      print("📦 Order Data: ${res.data?.toJson()}");

      print(">>>>>>>>> Order Data: ${res.data?.toJson()}");

      print(">>>>>>>>>amount Order Data: ${res.data!.amount}");

      if (res.success == true && res.data != null) {
        // Store order data for verification
        currentOrderId = res.data!.orderId;
        currentAmount = res.data!.amount;
        walletResponse.value = res;

        // Step 2: Get user details for prefill
        final prefs = await SharedPreferences.getInstance();
        final userEmail = prefs.getString("user_email") ?? '';
        final userPhone = prefs.getString("user_phone") ?? '';
        final userName = prefs.getString("user_name") ?? '';

        print("👤 User Prefill - Email: $userEmail, Phone: $userPhone");

        // Step 3: Open Razorpay checkout
        isLoading.value = false;
        isPaymentProcessing.value = true;

        razorpayService.openCheckout(
          keyId: res.data!.razorpayKeyId!,
          orderId: res.data!.orderId!,
          amount: res.data!.amount!.toString(),
          currency: res.data!.currency ?? 'INR',
          name: 'NZCU Driver Wallet',
          description: 'Wallet Top-up of ₹$amount',
          prefill: {'email': userEmail, 'contact': userPhone, 'name': userName},
          theme: {'color': '#F37254'},
          notes: {
            'purpose': 'wallet_topup',
            'user_id': prefs.getString("driver_userid") ?? '',
          },
        );
      } else {
        _showError(res.message ?? 'Failed to create payment order');
      }
    } catch (e) {
      print('❌ Exception in add_wallet_method: $e');
      _showError('An error occurred: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('✅ Payment Success Callback:');
    print('  Payment ID: ${response.paymentId}');
    print('  Order ID: ${response.orderId}');
    print('  Signature: ${response.signature}');

    // Verify payment with backend
    _verifyPayment(
      razorpayPaymentId: response.paymentId!,
      razorpayOrderId: response.orderId!,
      razorpaySignature: response.signature!,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment Error Callback: ${response.code} - ${response.message}');
    isPaymentProcessing.value = false;

    // Don't show snackbar here - RazorpayService already shows it
  }

  Future<void> _verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    print('🔐 Verifying payment...');

    isLoading.value = true;
    isPaymentProcessing.value = false;

    try {
      // Call your backend verification API
      final bool successcheck = await ProfileApiServices.verifyAndAddMoneydata(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      if (successcheck == true) {
        print('agsdgshgfjds____Payment verified successfully');

        // Show success message
        Fluttertoast.showToast(
          msg: "Payment successful!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Clear stored data
        currentOrderId = null;
        currentAmount = null;

        // You might want to refresh wallet balance here
        // Get.find<HomeController>().fetchWalletBalance();

        // Navigate back or show success screen
        // Future.delayed(Duration(seconds: 2), () {
        //   Get.back(); // Close payment screen
        // });
        final WalletController walletController = Get.find<WalletController>();

        walletController.wallet_method();
        // Get.off(PaymentScreen());

        Get.offAll(() => PaymentScreen());
      } else {
        Fluttertoast.showToast(
          msg: "Payment verification failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        // _showError(verificationResponse.message ?? 'Payment verification failed');
      }
    } catch (e) {
      print('❌ Verification Error: $e');
      _showError('Payment verification error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<AddMoneyWalletResponse> _callVerificationApi({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("auth_token");

    try {
      // Replace with your actual verification endpoint
      final response = await http.post(
        Uri.parse(
          'http://api.corezap.framekarts.com/api/v1/payments/verify',
        ), // Update with your verification endpoint
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
          "amount": currentAmount,
        }),
      );

      print("🔐 Verification Status: ${response.statusCode}");
      print("🔐 Verification Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AddMoneyWalletResponse.fromJson(data);
      } else {
        return AddMoneyWalletResponse(
          success: false,
          message: 'Verification failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Verification API Error: $e');
      return AddMoneyWalletResponse(
        success: false,
        message: 'Connection error: $e',
      );
    }
  }

  void _showError(String message) {
    errorMessage.value = message;
    print("❌ Error: $message");

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 4),
    );
  }
}
