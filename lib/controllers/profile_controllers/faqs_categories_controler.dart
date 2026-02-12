// import 'dart:io';

// import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
// import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
// import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
// import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// class FaqsCategoriesControler extends GetxController {
//   // Change to Rx<HomeModalResponse?> and use .obs
//   Rx<FaqsCategoriesResponse?> faqsCategoriesResponse = Rx<FaqsCategoriesResponse?>(
//     null,
//   );

//   // Add loading state
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   Future<void> faqscategorimethod() async {
//   print("faqscategorimethod called");

//   // Set loading state
//   isLoading.value = true;
//   errorMessage.value = '';

//   try {
//     // Format date from DD/MM/YYYY to YYYY-MM-DD if provided
   
//     // Call API with all optional parameters
//     final FaqsCategoriesResponse res =
//         await ProfileApiServices.get_all_categories_data(
         
//         );

//     print("API Response: ${res.success}");

//     if (res.success == true) {
//       print("faqs categories updated successfully");

    


//     } else {
//       errorMessage.value = res.message ?? 'Failed to update faqs categories';
//       print("Error: ${errorMessage.value}");
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   } catch (e) {
//     errorMessage.value = 'An error occurred: $e';
//     print("Exception: $e");
//     Get.snackbar(
//       'Error',
//       errorMessage.value,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   } finally {
//     // Reset loading state
//     isLoading.value = false;
//   }
// }




// }


import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqsCategoriesControler extends GetxController {
  // Observable response
  Rx<FaqsCategoriesResponse?> faqsCategoriesResponse = 
      Rx<FaqsCategoriesResponse?>(null);

  // Loading and error states
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> faqscategorimethod() async {
    print("faqscategorimethod called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final FaqsCategoriesResponse res =
          await ProfileApiServices.get_all_categories_data();

      print("API Response Success: ${res.success}");
      print("API Response Message: ${res.message}");
      print("Categories count: ${res.categories?.length ?? 0}");

      if (res.success == true) {
        print("FAQs categories fetched successfully");
        
        // Assign the response to the observable
        faqsCategoriesResponse.value = res;
        
        // Log categories for debugging
        if (res.categories != null) {
          for (var category in res.categories!) {
            print("Category: ${category.name}, Image: ${category.image}");
          }
        }
        
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