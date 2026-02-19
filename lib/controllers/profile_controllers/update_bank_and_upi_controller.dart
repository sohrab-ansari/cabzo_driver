import 'package:nzcu_driver/modals/profile_modals/update_bank_and_upi_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UpdateBankAndUpiController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<UpdateBankAndUpiResponse?> update_bank_and_upi_response =
      Rx<UpdateBankAndUpiResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> driverid_mdethod() async {
    print("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.UpdateBankAndUpi_data(
            acoountid: "",
            type: "",
            upiId: "",
          );

      print("API Response: ${res.success}");

      //  print("API Response2222: ${res.driver}");

      if (res.success == true) {
        print("driverid data fetched successfully");

        // Fluttertoast.showToast(
        //   msg: res.message ?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        print("Error: ${errorMessage.value}");
        // Only show snackbar if context is available
        if (Get.isSnackbarOpen == false) {
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception: $e");
      // Only show snackbar if context is available
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
