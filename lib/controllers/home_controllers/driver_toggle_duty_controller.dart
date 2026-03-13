import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/driver_toggle_duty_response.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class DriverToggleDutyController extends GetxController {
  // Change to Rx<Drivertoggledutyresponse?> and use .obs
  Rx<Drivertoggledutyresponse?> homemodalresponse =
      Rx<Drivertoggledutyresponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> driver_toggle_method() async {
    AppLogger.d("driver_toggle_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final Drivertoggledutyresponse res =
          await HomeApiServices.toggle_duty_data();

      AppLogger.d("API Response: ${res.success}");

      if (res.success == true) {
        AppLogger.d("driver toggle duty data fetched successfully");
        homemodalresponse.value = res;
      } else {
        errorMessage.value =
            res.message ?? 'Failed to fetch driver toggle duty data';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
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
