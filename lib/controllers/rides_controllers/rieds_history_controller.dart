import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/ride_history_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class RiedsHistoryController extends GetxController {
  Rx<RideHistoryResponse?> transactionsres = Rx<RideHistoryResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> get_history_method({required String status}) async {
    AppLogger.d("rides history called");

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final RideHistoryResponse res =
          await HomeApiServices.get_rides_history_data(status: status);

      AppLogger.d("API Response: ${res.success}");
      AppLogger.d("API Data: ${res.data?.length}");

      if (res.success == true) {
        AppLogger.d("rides history data fetched successfully");
        transactionsres.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch rides history';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
