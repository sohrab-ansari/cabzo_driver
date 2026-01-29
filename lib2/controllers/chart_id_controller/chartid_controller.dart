import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/modals/chartid_response.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/modals/order_complete_cash_response.dart';
import 'package:corezap_driver/modals/update_order_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartidController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<ChatResponse?> chartresposne = Rx<ChatResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getchartidmethod({required dynamic orderid}) async {
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final ChatResponse res = await ProfileApiServices.chartidmethod(
        orderid: orderid,
      );

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("update orderget fetched successfully");
        chartresposne.value = res;

        print("myupdate_order_data111  ${chartresposne.value}");

        print("myupdate_order_data22222222  ${res}");
      } else {
        print("myupdate_order_data22222222  faileddd111");
        // errorMessage.value = res.success ?? 'Failed to fetch home data';
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
