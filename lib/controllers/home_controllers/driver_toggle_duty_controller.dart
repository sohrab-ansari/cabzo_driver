import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/driver_toggle_duty_response.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverToggleDutyController extends GetxController {
  // Change to Rx<Drivertoggledutyresponse?> and use .obs
  Rx<Drivertoggledutyresponse?> homemodalresponse =
      Rx<Drivertoggledutyresponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> driver_toggle_method() async {
    print("driver_toggle_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final Drivertoggledutyresponse res =
          await HomeApiServices.toggle_duty_data();

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("driver toggle duty data fetched successfully");
        homemodalresponse.value = res;
      } else {
        errorMessage.value =
            res.message ?? 'Failed to fetch driver toggle duty data';
        print("Error: ${errorMessage.value}");
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception: $e");
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
