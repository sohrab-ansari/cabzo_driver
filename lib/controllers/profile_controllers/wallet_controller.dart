import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<WalletResponse?> walletresponse = Rx<WalletResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> wallet_method() async {
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final WalletResponse res = await ProfileApiServices.get_wallet_data();

      print("API Response: ${res.success}");

      print("API Response2222: ${res.data}");

      if (res.success == true) {
        print("wallet data fetched successfully");

        // Fluttertoast.showToast(
        //   msg: res.message ?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );

        walletresponse.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
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
