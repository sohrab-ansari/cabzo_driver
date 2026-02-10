import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/ride_history_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RiedsHistoryController extends GetxController {
  Rx<RideHistoryResponse?> transactionsres = Rx<RideHistoryResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> get_history_method({required String status}) async {
    print("rides history called");

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final RideHistoryResponse res =
          await HomeApiServices.get_rides_history_data(status: status);

      print("API Response: ${res.success}");
      print("API Data: ${res.data?.length}");

      if (res.success == true) {
        print("rides history data fetched successfully");
        transactionsres.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch rides history';
        print("Error: ${errorMessage.value}");
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
