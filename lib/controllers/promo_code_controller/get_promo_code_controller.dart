import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/modals/get_promo_code_data.dart';
import 'package:corezap_driver/modals/order_complete_cash_response.dart';
// import 'package:corezap_driver/views/payment_modes_screen/cash_payment_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetPromoCodeController extends GetxController {
  // Rx variables for state management
  Rx<Getpromocodedata?> cashResponse = Rx<Getpromocodedata?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Process cash payment
  Future<void> getPromoCode(
  
  )
   async {

    
    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;
    
    try {
      // Call API
      final Getpromocodedata response = 
          await ProfileApiServices.get_promocode_data();
      
      // Update response
      cashResponse.value = response;
      
      if (response.success == true) {
        print("promo code data successful");
        
    
        
      } else {
        // Payment failed
        errorMessage.value = response.message ?? 'promo code Please try again.';
        print("❌ getPromoCode failed: ${errorMessage.value}");
        
        // Show error snackbar
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
      // Handle exceptions
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in promo code d: $e");
      
      // Show error snackbar
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