import 'dart:io';

import 'package:corezap_driver/controller/home_controller.dart';
import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
import 'package:corezap_driver/modals/home_modal_response.dart';
import 'package:corezap_driver/my_apis_services/services/auth_api_service.dart';
import 'package:corezap_driver/my_apis_services/services/profile_api_services.dart';
import 'package:corezap_driver/utilities/navigator.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<DriverImageUploadRes?> driverImageUploadRes = Rx<DriverImageUploadRes?>(
    null,
  );

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> edit_profile_method({
    required dynamic image,

    String? name,

    String? email,
  }) async {
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final DriverImageUploadRes res =
          await ProfileApiServices.edit_profile_data_api(
            image: image,
            userType: '',
            name: name.toString(),

            email: email.toString(),
          );

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("Home data fetched successfully");

        Fluttertoast.showToast(
          msg: res.message ?? "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        Get.offAll(BottomnavmainScreen());

        // ✅ IMPORTANT: Refresh home data after profile update
        try {
          final HomeController homeController = Get.find<HomeController>();
          await homeController.home_data_method();
          print("Home data refreshed after profile update");
        } catch (e) {
          print("Failed to refresh home data: $e");
        }

        driverImageUploadRes.value = res;
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
