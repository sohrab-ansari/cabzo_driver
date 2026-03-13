import 'package:nzcu_driver/modals/profile_modals/update_bank_and_upi_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class UpdateBankAndUpiController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<UpdateBankAndUpiResponse?> update_bank_and_upi_response =
      Rx<UpdateBankAndUpiResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> update_upi_method({
    required dynamic accountid,

    required dynamic upiId,
  }) async {
    AppLogger.d("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.update_Upi_data(
            acoountid: accountid,

            upiId: upiId,
          );

      AppLogger.d("API Response: ${res.success}");

      if (res.success == true) {
        AppLogger.d("upiiii  data fetched successfully");
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        AppLogger.d("Error: ${errorMessage.value}");
        // Only show snackbar if context is available
        if (Get.isSnackbarOpen == false) {
          CustomToast.showError(errorMessage.value);
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e");
      // Only show snackbar if context is available
      if (Get.isSnackbarOpen == false) {
        CustomToast.showError(errorMessage.value);
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  Future<void> update_bank_method({
    required dynamic accountid,

    required dynamic bankName,

    required dynamic accountNumber,

    required dynamic ifscCode,

    required dynamic accountHolderName,
  }) async {
    AppLogger.d("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.update_bank_data(
            accountHolderName: accountHolderName,
            accountNumber: accountNumber,
            acoountid: accountid,
            bankName: bankName,
            ifscCode: ifscCode,
          );

      AppLogger.d("API Response: ${res.success}");

      if (res.success == true) {
        AppLogger.d("bank update data fetched successfully");
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e"); 
      // Only show snackbar if context is available
      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  Future<void> delete_bank_upi_method({required dynamic accountid}) async {
    AppLogger.d("delete_bank_upi_method called with accountid: $accountid");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.delete_bank_upi_data(
            accountid: accountid, // Make sure parameter name matches
          );

      AppLogger.d("API Response success: ${res.success}");
      AppLogger.d("API Response message: ${res.message}");

      if (res.success == true) {
        AppLogger.d("bank and upi deleted successfully");
      } else {
        errorMessage.value = res.message ?? 'Failed to delete';
        AppLogger.d("Error: ${errorMessage.value}");

        // Only show snackbar if context is available
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception in delete_bank_upi_method: $e");

      // Only show snackbar if context is available
      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

}
