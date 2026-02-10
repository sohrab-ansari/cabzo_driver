import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/home_modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/modals/home_modals/update_order_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeclineOrderController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<Ordercompletecashresponse?> cashcompletecashresposne =
      Rx<Ordercompletecashresponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> cash_method({
    required dynamic orderstatus,
    required dynamic orderid,
  }) async {
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final Ordercompletecashresponse res =
          await HomeApiServices.declined_order_data(
            orderstatus: orderstatus,
            orderid: orderid,
          );

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("update orderget fetched successfully");
        cashcompletecashresposne.value = res;

        print("myupdate_order_data111  ${cashcompletecashresposne.value}");

        print("myupdate_order_data22222222  ${res}");
      } else {
        print("myupdate_order_data22222222  faileddd111");
        errorMessage.value = res.message ?? 'Failed to fetch home data';
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
      // Reset loading state
      isLoading.value = false;
    }
  }
}
