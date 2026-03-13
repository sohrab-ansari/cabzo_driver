import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/home_modal_response.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class HomeController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<HomeModalResponse?> homemodalresponse = Rx<HomeModalResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> home_data_method() async {
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final HomeModalResponse res = await HomeApiServices.get_home_data();

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("Home data fetched successfully");
        homemodalresponse.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        print("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
