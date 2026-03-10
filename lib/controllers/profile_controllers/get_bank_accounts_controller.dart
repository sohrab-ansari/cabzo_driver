import 'dart:io';

import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/modals/home_modals/driverId_response.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/modals/profile_modals/get_bank_accounts_response.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
import 'package:nzcu_driver/modals/profile_modals/transactions_response.dart';
import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';

import 'package:nzcu_driver/utilities/widgets/navigator.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GetBankAccountsController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<GetBankAccountsResponse?> driveridresponse = Rx<GetBankAccountsResponse?>(
    null,
  );

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> bankdetails_mdethod() async {
    print("get bank details  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final GetBankAccountsResponse res =
          await ProfileApiServices.get_bankdetails_data();

      if (res.success == true) {
        print("get bank details  data fetched successfully");

        // Fluttertoast.showToast(
        //   msg: res.message ?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );

        driveridresponse.value = res;
      } else {
        String msg = res.message ?? 'Failed to fetch home data';
        
        // Intercept the specific error message to suppress the snackbar and show custom text
        if (msg.toLowerCase().contains('payment method') || msg.toLowerCase().contains('no payment')) {
          errorMessage.value = 'Add bank account to deposit money';
          print("Intercepted error: ${errorMessage.value}");
        } else {
          errorMessage.value = msg;
          print("Error: ${errorMessage.value}");
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
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
