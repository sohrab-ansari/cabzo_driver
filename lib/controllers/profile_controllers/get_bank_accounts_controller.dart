import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class GetBankAccountsController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<GetBankAccountsResponse?> driveridresponse = Rx<GetBankAccountsResponse?>(
    null,
  );

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> bankdetails_mdethod() async {
    AppLogger.d("get bank details  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final GetBankAccountsResponse res =
          await ProfileApiServices.get_bankdetails_data();

      if (res.success == true) {
        AppLogger.d("get bank details  data fetched successfully");

        driveridresponse.value = res;
      } else {
        String msg = res.message ?? 'Failed to fetch home data';
        
        // Intercept the specific error message to suppress the snackbar and show custom text
        if (msg.toLowerCase().contains('payment method') || msg.toLowerCase().contains('no payment')) {
          errorMessage.value = 'Add bank account to deposit money';
          AppLogger.d("Intercepted error: ${errorMessage.value}");
        } else {
          errorMessage.value = msg;
          AppLogger.d("Error: ${errorMessage.value}");
          CustomToast.showError(errorMessage.value);
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
