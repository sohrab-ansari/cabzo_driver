import 'package:nzcu_driver/modals/profile_modals/faq_category_responses.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

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
    AppLogger.d("faqscategorimethod called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final FaqsCategoriesResponse res =
          await ProfileApiServices.get_all_categories_data();

      AppLogger.d("API Response Success: ${res.success}");
      AppLogger.d("API Response Message: ${res.message}");
      AppLogger.d("Categories count: ${res.categories?.length ?? 0}");

      if (res.success == true) {
        AppLogger.d("FAQs categories fetched successfully");

        // Assign the response to the observable
        faqsCategoriesResponse.value = res;

        // Log categories for debugging
        if (res.categories != null) {
          for (var category in res.categories!) {
            AppLogger.d("Category: ${category.name}, Image: ${category.image}");
          }
        }
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch FAQs categories';
        AppLogger.d("Error: ${errorMessage.value}");

        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception in faqscategorimethod: $e");

      CustomToast.showError(errorMessage.value);
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
