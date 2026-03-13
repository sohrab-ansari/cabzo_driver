import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/get_promo_code_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

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

        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in promo code d: $e");

      CustomToast.showError('Something went wrong. Please try again.');
    } finally {
      // Always reset loading state
      isLoading.value = false;
    }
  }

  // Navigate to home screen
}
