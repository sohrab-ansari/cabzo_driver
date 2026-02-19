import 'package:nzcu_driver/modals/home_modals/get_city_by_location_response.dart';
import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetCityByLocationController extends GetxController {
  // Observable response
  Rx<GetCityByLocationResponse?> faqsCategoriesResponse = 
      Rx<GetCityByLocationResponse?>(null);

  // Loading and error states
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> faqscategorimethod(

  {
      required String lat,
    required String lng,
  }
  ) async {
    print("faqscategorimethod called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final GetCityByLocationResponse res =
          await ProfileApiServices.get_cit_by_loc_method(lat: lat,lng: lng);

      print("API Response Success: ${res.success}");
      print("API Response Message: ${res.message}");
    

      if (res.success == true) {
        print("FAQs categories fetched successfully");
        
        // Assign the response to the observable
        faqsCategoriesResponse.value = res;
        
      
        
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch FAQs categories';
        print("Error: ${errorMessage.value}");
        
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception in faqscategorimethod: $e");
      
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Method to clear data
  void clearData() {
    faqsCategoriesResponse.value = null;
    errorMessage.value = '';
  }
}