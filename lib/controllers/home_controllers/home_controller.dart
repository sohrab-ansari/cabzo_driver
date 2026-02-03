

import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modal_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<HomeModalResponse?> homemodalresponse = Rx<HomeModalResponse?>(null);
  
  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    home_data_method();
  }

  Future<void> home_data_method() async {
    print("home_data_method called");
    
    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      // Call API
      final HomeModalResponse res = await ProfileApiServices.get_home_data();
      
      print("API Response: ${res.success}");
      
      if (res.success == true) {
        print("Home data fetched successfully");
        homemodalresponse.value = res;
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