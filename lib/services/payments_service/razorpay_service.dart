import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class RazorpayService {
  late Razorpay _razorpay;

  // For handling payment callbacks
  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;
  Function(ExternalWalletResponse)? onExternalWallet;

  // Initialize Razorpay with optional callbacks
  void initialize({
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onError,
    Function(ExternalWalletResponse)? onExternal,
  }) {
    _razorpay = Razorpay();
    onPaymentSuccess = onSuccess;
    onPaymentError = onError;
    onExternalWallet = onExternal;
    _setupEventListeners();
  }

  void _setupEventListeners() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Open Razorpay checkout with required parameters
  void openCheckout({
    required String keyId,
    required String orderId,
    required String amount,
    String currency = 'INR',
    required String name,
    required String description,
    Map<String, String>? prefill,
    Map<String, dynamic>? theme,
    Map<String, dynamic>? notes,
  }) {
    // Convert amount to paise (Razorpay expects amount in smallest currency unit)
    // For INR, amount should be in paise

    final numAmount = amount;
    // final numAmount = int.tryParse(amount) ?? 0;
    final amountInPaise = (numAmount * 100).toString();

    final options = {
      'key': keyId,
      'amount': amountInPaise, // Amount in paise
      'name': name,
      'description': description,
      'order_id': orderId,
      'currency': currency,
      'prefill': prefill ?? {'contact': '', 'email': ''},
      'theme': theme ?? {'color': '#F37254'},
      'notes': notes ?? {},
      'timeout': 300, // 5 minutes timeout
    };

    print('🚀 Opening Razorpay with options: $options');

    try {
      _razorpay.open(options);
    } on Exception catch (e) {
      print('❌ Razorpay Exception: $e');
      _showErrorSnackbar('Failed to open payment gateway');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('✅ Payment Success:');
    print('  Payment ID: ${response.paymentId}');
    print('  Order ID: ${response.orderId}');
    print('  Signature: ${response.signature}');

    // Call success callback if provided
    onPaymentSuccess?.call(response);

    _showSuccessSnackbar('Payment successful!');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('❌ Payment Error:');
    print('  Code: ${response.code}');
    print('  Message: ${response.message}');

    String errorMessage = 'Payment failed';

    switch (response.code) {
      case 2:
        errorMessage = 'Payment cancelled by user';
        break;
      case 0:
        errorMessage = 'Network error. Please check your internet connection.';
        break;
      case 1:
        errorMessage = 'Payment failed. Please try again.';
        break;
      case 3:
        errorMessage = 'Invalid parameters. Please contact support.';
        break;
    }

    // Call error callback if provided
    onPaymentError?.call(response);

    _showErrorSnackbar(errorMessage);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('💰 External Wallet: ${response.walletName}');

    // Call external wallet callback if provided
    onExternalWallet?.call(response);

    _showInfoSnackbar('Redirected to ${response.walletName}');
  }

  void _showSuccessSnackbar(String message) {
    CustomToast.showSuccess(message);
  }

  void _showErrorSnackbar(String message) {
    CustomToast.showError(message);
  }

  void _showInfoSnackbar(String message) {
    CustomToast.showInfo(message);
  }

  // Clean up
  void dispose() {
    if (_razorpay != null) {
      _razorpay.clear();
    }
  }
}
