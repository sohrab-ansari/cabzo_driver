import 'dart:io';

import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/profile_modals/transactions_response.dart';
import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

// import 'package:nzcu_driver/apiServices/services/auth_api_service.dart';
// import 'package:nzcu_driver/apiServices/services/profile_api_services.dart';
import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<TransactionsResponse?> transactionsres = Rx<TransactionsResponse?>(
    null,
  );

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> transactions_method(
   
  ) async {
    print("transactions_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final TransactionsResponse res =
          await ProfileApiServices.get_transactions_data(
          
          );

      print("API Response: ${res.success}");

       print("API Response2222: ${res.data}");

      if (res.success == true) {
        print("transactions data fetched successfully");

        Fluttertoast.showToast(
          msg: res.message ?? "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );

        // Get.offAll(BottomnavmainScreen());

        // ✅ IMPORTANT: Refresh home data after profile update
        // try {
        //   final HomeController homeController = Get.find<HomeController>();
        //   await homeController.home_data_method();
        //   print("wallet data refreshed after profile update");
        // } catch (e) {
        //   print("Failed to refresh home data: $e");
        // }

        transactionsres.value = res;
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
