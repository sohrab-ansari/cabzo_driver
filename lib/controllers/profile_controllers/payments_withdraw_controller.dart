import 'dart:io';
import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/modals/bank_account_add_Res.dart';
import 'package:nzcu_driver/modals/payments_withdraw_response.dart';
import 'package:nzcu_driver/utilities/navigator.dart';
import 'package:nzcu_driver/views/profile_related.dart/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentsWithdrawController extends GetxController {
  Rx<PaymentsWithdrawResponse?> transactionsres = Rx<PaymentsWithdrawResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> withdrawal_method(
    
     {
    required String amount,

    required String? BankAccountId,
  }
  ) async {
    print("add bankaccount called");

    // Validate inputs
    if (amount.isEmpty) {
      // _showError(context, "Please fill all fields");
      return;
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final PaymentsWithdrawResponse res =
          await ProfileApiServices.money_transfer(
     BankAccountId: BankAccountId,amount: amount
          );

      print("API Response success: ${res.success}");
      print("API Response message: ${res.message}");
      print("API Response data: ${res.data}");

      // ✅ Check both possible success indicators
      if (res.success == true) {
        print("✅ Bank account added successfully!");

        // Show success message
        // _showSuccess(context, res.message ?? "Bank account added successfully");

        // ✅ IMPORTANT: Refresh home data after profile update
        try {
          // final HomeController homeController = Get.find<HomeController>();
          // await homeController.home_data_method();

          final WalletController walletController =
              Get.find<WalletController>();

          walletController.wallet_method();
          print("Wallet data refreshed after profile update");
        } catch (e) {
          print("Failed to refresh home data: $e");
        }

        transactionsres.value = res;

        // ✅ Use GetX navigation instead of CustomNavigator
        await Future.delayed(Duration(milliseconds: 500));

        // Option 1: Using GetX navigation

        Get.off(PaymentScreen());
        // Get.offAll(() => PaymentScreen());

        // Option 2: Using Navigator if you prefer
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => PaymentScreen()),
        //   (route) => false,
        // );
      } else {
        errorMessage.value = res.message ?? 'Failed to add bank account';
        print("❌ Error: ${errorMessage.value}");
        // _showError(context, errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception: $e");
      // _showError(context, errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Helper method to show error messages
  void _showError(BuildContext context, String message) {
    // Try using ScaffoldMessenger first (more reliable with context)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Fallback to Fluttertoast if context is not available
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Helper method to show success messages
  void _showSuccess(BuildContext context, String message) {
    // Try using ScaffoldMessenger first (more reliable with context)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Fallback to Fluttertoast if context is not available
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }
}
