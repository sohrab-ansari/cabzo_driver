import 'dart:io';

import 'package:corezap_driver/controllers/home_controllers/home_controller.dart';
import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';

import 'package:corezap_driver/modals/ride_history_response2.dart';
import 'package:corezap_driver/modals/transactions_response.dart';
import 'package:corezap_driver/modals/wallet_response.dart';
import 'package:corezap_driver/apiervices/services/profile_api_services.dart';

// import 'package:corezap_driver/apiServices/services/auth_api_service.dart';
// import 'package:corezap_driver/apiServices/services/profile_api_services.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RiedsHistoryController extends GetxController {
  Rx<RideHistoryResponse2?> transactionsres = Rx<RideHistoryResponse2?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;



  Future<void> get_history_method({required String  status}) async {
    print("rides history called");

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final RideHistoryResponse2 res =
          await ProfileApiServices.get_rides_history_data(status: status);

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
