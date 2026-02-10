import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/get_promo_code_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetPromoCodeController extends GetxController {
  Rx<Getpromocodedata?> cashResponse = Rx<Getpromocodedata?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> getPromoCode() async {
    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;

    try {
      final Getpromocodedata response =
          await ProfileApiServices.get_promocode_data();

      cashResponse.value = response;

      if (response.success == true) {
        print("promo code data successful");
      } else {
        errorMessage.value = response.message ?? 'promo code Please try again.';
        print("❌ getPromoCode failed: ${errorMessage.value}");

        Get.snackbar(
          'promo code d Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in promo code d: $e");

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
    } finally {
      // Always reset loading state
      isLoading.value = false;
    }
  }

  // Navigate to home screen
}
