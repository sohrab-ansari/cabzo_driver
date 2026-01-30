
import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/modals/get_all_vehicle_categories_response.dart';
import 'package:corezap_driver/modals/order_complete_cash_response.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleTypesController extends GetxController {
  // Rx variables for state management
  Rx<GetAllVehicleCategoriesResponse?> cashResponse = Rx<GetAllVehicleCategoriesResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Process cash payment
  Future<void> vehicalmethod(
  
  ) async {
   
    
    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;
    
    try {
      // Call API
      final GetAllVehicleCategoriesResponse response = 
          await ProfileApiServices.get_vehical_data();
      
      // Update response
      cashResponse.value = response;
      
      if (response.success == true) {
        print("vehicallll data fetchedddd done successful");
        
      
        
      } else {
        // Payment failed
        errorMessage.value = response.message ?? 'vehicallll failed. Please try again.';
        print("❌ vehical data failed: ${errorMessage.value}");
        
        // Show error snackbar
        Get.snackbar(
          'vehical dta Failed',
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
      print("❌ Exception invehicallll : $e");
      
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
  void navigateToHome() {
    Get.offAll(() => BottomnavmainScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }
}