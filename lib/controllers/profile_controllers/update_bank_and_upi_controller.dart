import 'package:nzcu_driver/modals/profile_modals/update_bank_and_upi_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UpdateBankAndUpiController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<UpdateBankAndUpiResponse?> update_bank_and_upi_response =
      Rx<UpdateBankAndUpiResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> update_upi_method({
    required dynamic accountid,

    required dynamic upiId,
  }) async {
    print("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.update_Upi_data(
            acoountid: accountid,

            upiId: upiId,
          );

      print("API Response: ${res.success}");

      //  print("API Response2222: ${res.driver}");

      if (res.success == true) {
        print("upiiii  data fetched successfully");

        // Fluttertoast.showToast(
        //   msg: res.message ?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        print("Error: ${errorMessage.value}");
        // Only show snackbar if context is available
        if (Get.isSnackbarOpen == false) {
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
      // Only show snackbar if context is available
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  Future<void> update_bank_method({
    required dynamic accountid,

    required dynamic bankName,

    required dynamic accountNumber,

    required dynamic ifscCode,

    required dynamic accountHolderName,
  }) async {
    print("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.update_bank_data(
            accountHolderName: accountHolderName,
            accountNumber: accountNumber,
            acoountid: accountid,
            bankName: bankName,
            ifscCode: ifscCode,
          );

      print("API Response: ${res.success}");

      //  print("API Response2222: ${res.driver}");

      if (res.success == true) {
        print("bank update data fetched successfully");

        // Fluttertoast.showToast(
        //   msg: res.message ?? "Something went wrong",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        // );
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        print("Error: ${errorMessage.value}");
        // Only show snackbar if context is available
        if (Get.isSnackbarOpen == false) {
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
      // Only show snackbar if context is available
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // In your update_bank_and_upi_controller.dart file

  Future<void> delete_bank_upi_method({required dynamic accountid}) async {
    print("delete_bank_upi_method called with accountid: $accountid");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final UpdateBankAndUpiResponse res =
          await ProfileApiServices.delete_bank_upi_data(
            accountid: accountid, // Make sure parameter name matches
          );

      print("API Response success: ${res.success}");
      print("API Response message: ${res.message}");

      if (res.success == true) {
        print("bank and upi deleted successfully");

        // Show success toast if you have fluttertoast
        // Fluttertoast.showToast(
        //   msg: res.message ?? "Deleted successfully",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.TOP,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        // );
      } else {
        errorMessage.value = res.message ?? 'Failed to delete';
        print("Error: ${errorMessage.value}");

        // Only show snackbar if context is available
        if (Get.isSnackbarOpen == false) {
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception in delete_bank_upi_method: $e");

      // Only show snackbar if context is available
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
  // Future<void> delete_bank_upi_method({
  //   required dynamic accountid,

  // }) async {
  //   print("driveridd  called");

  //   // Set loading state
  //   isLoading.value = true;
  //   errorMessage.value = '';

  //   try {
  //     // Call API
  //     final UpdateBankAndUpiResponse res =
  //         await ProfileApiServices.delete_bank_upi_data(

  //           acoountid: accountid,

  //         );

  //     print("API Response: ${res.success}");

  //     //  print("API Response2222: ${res.driver}");

  //     if (res.success == true) {
  //       print("bank and upi deleted, data fetched successfully");

  //       // Fluttertoast.showToast(
  //       //   msg: res.message ?? "Something went wrong",
  //       //   toastLength: Toast.LENGTH_SHORT,
  //       //   gravity: ToastGravity.TOP,
  //       // );
  //     } else {
  //       errorMessage.value = res.message ?? 'Failed to fetch home data';
  //       print("Error: ${errorMessage.value}");
  //       // Only show snackbar if context is available
  //       if (Get.isSnackbarOpen == false) {
  //         Get.snackbar(
  //           'Error',
  //           errorMessage.value,
  //           snackPosition: SnackPosition.TOP,
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'An error occurred: $e';
  //     print("Exception: $e");
  //     // Only show snackbar if context is available
  //     if (Get.isSnackbarOpen == false) {
  //       Get.snackbar(
  //         'Error',
  //         errorMessage.value,
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } finally {
  //     // Reset loading state
  //     isLoading.value = false;
  //   }
  // }
}
