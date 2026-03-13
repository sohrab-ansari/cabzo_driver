// import 'dart:io';

// import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
// import 'package:nzcu_driver/modals/profile_modals/get_by_category_response.dart';
// import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
// import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
// import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
// import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';
// import 'package:nzcu_driver/utilities/widgets/navigator.dart';
// import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// class FaqsGetByCategoriesController extends GetxController {
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
//     final GetByCategoryResponse res =
//         await ProfileApiServices.get_faq_categories_data(

//         );

//     print("API Response: ${res.success}");

//     if (res.success == true) {
//       print("faqs categories updated successfully");

//     } else {
//       errorMessage.value = res.message ?? 'Failed to update faqs categories';
//       print("Error: ${errorMessage.value}");
//     }
//   } catch (e) {
//     errorMessage.value = 'An error occurred: $e';
//     print("Exception: $e");
//   } finally {
//     // Reset loading state
//     isLoading.value = false;
//   }
// }

// }

import 'package:nzcu_driver/modals/profile_modals/get_by_category_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class FaqsGetByCategoriesController extends GetxController {
  // Observable response
  Rx<GetByCategoryResponse?> faqsByCategoryResponse =
      Rx<GetByCategoryResponse?>(null);

  // Loading and error states
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Selected category info
  RxString selectedCategoryId = ''.obs;
  RxString selectedCategoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getFaqsByCategory({
    required String categoryId,
    required String categoryName,
  }) async {
    print("getFaqsByCategory called for category: $categoryName");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';
    selectedCategoryId.value = categoryId;
    selectedCategoryName.value = categoryName;

    try {
      // Call API with category parameter
      final GetByCategoryResponse res =
          await ProfileApiServices.get_faq_categories_data(
            category: categoryId,
          );

      print("API Response Success: ${res.success}");
      print("API Response Message: ${res.message}");
      print("Questions count: ${res.count ?? 0}");

      if (res.success == true) {
        print("FAQs fetched successfully");

        // Assign the response to the observable
        faqsByCategoryResponse.value = res;

        // Log questions for debugging
        if (res.questions != null) {
          for (var question in res.questions!) {
            print("Question: ${question.question}");
            print("Answer: ${question.answer}");
          }
        }
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch FAQs';
        print("Error: ${errorMessage.value}");

        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception in getFaqsByCategory: $e");

      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Clear data
  void clearData() {
    faqsByCategoryResponse.value = null;
    errorMessage.value = '';
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
  }
}
