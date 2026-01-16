import 'dart:io';

import 'package:corezap_driver/controller/home_controller.dart';
import 'package:corezap_driver/modals/driverId_response.dart';
import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/modals/transactions_response.dart';
import 'package:corezap_driver/modals/wallet_response.dart';
import 'package:corezap_driver/my_apis_services/services/auth_api_service.dart';
import 'package:corezap_driver/my_apis_services/services/profile_api_services.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DriveridController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<DriverIdResponse?> driveridresponse = Rx<DriverIdResponse?>(
    null,
  );

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> driverid_mdethod(
   
  ) async {
    print("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final DriverIdResponse res =
          await ProfileApiServices.get_driverid_data(
          
          );

      print("API Response: ${res.success}");

       print("API Response2222: ${res.driver}");

      if (res.success == true) {
        print("driverid data fetched successfully");

        Fluttertoast.showToast(
          msg: res.message ?? "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        driveridresponse.value = res;
      } else {
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
