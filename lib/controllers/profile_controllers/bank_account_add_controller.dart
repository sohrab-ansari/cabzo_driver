import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/bank_account_add_Res.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/views/profile_screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankAccountAddController extends GetxController {
  Rx<BankAccountAddResp?> transactionsres = Rx<BankAccountAddResp?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> addbankaccount_method({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required String ifscCode,
    String? type,
    String? upiId,
    required BuildContext context,
  }) async {
    print("add bankaccount called");

    // Validate inputs based on the type
    if (type == "UPI") {
      // For UPI, only validate UPI ID
      if (upiId == null || upiId.isEmpty) {
        CustomToast.showWarning("Please enter UPI ID");
        return;
      }
    } else {
      // For bank account, validate all bank fields
      if (bankName.isEmpty ||
          accountNumber.isEmpty ||
          accountHolderName.isEmpty ||
          ifscCode.isEmpty) {
        CustomToast.showWarning("Please fill all fields");
        return;
      }
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final BankAccountAddResp res =
          await ProfileApiServices.addBankAccountData(
            accountHolderName: accountHolderName,
            accountNumber: accountNumber,
            bankName: bankName,
            ifscCode: ifscCode,
            type: type,
            upiId: upiId,
          );

      print("API Response success1: ${res.success}");
      print("API Response message2: ${res.message}");
      print("API Response data3: ${res.data}");

      //Check both possible success indicators
      if (res.success == true) {
        print("✅ Bank account added successfully!");

        // Show success message
        CustomToast.showSuccess(res.message ?? "Bank account added successfully");

        //IMPORTANT: Refresh home data after profile update
        try {
          final WalletController walletController =
              Get.find<WalletController>();
          walletController.wallet_method();
          print("Wallet data refreshed after profile update");
        } catch (e) {
          print("Failed to refresh home data: $e");
        }

        transactionsres.value = res;

        //Use GetX navigation instead of CustomNavigator
        await Future.delayed(Duration(milliseconds: 500));

        // Navigate to PaymentScreen
        Get.off(PaymentScreen());
      } else {
        errorMessage.value = res.message ?? 'Failed to add bank account';
        print("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

}
