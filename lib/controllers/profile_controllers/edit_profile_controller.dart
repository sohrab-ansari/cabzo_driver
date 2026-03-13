import 'dart:io';

import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/controllers/home_controllers/home_controller.dart';
import 'package:nzcu_driver/modals/auth_modals/driver_Image_upload_res.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
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
    File? image,
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
  }) async {
    print("edit_profile_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Format date from DD/MM/YYYY to YYYY-MM-DD if provided
      String? formattedDateOfBirth;
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        try {
          // Parse from DD/MM/YYYY to DateTime
          final parts = dateOfBirth.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            final date = DateTime(year, month, day);
            // Format to YYYY-MM-DD
            formattedDateOfBirth =
                "${date.year.toString().padLeft(4, '0')}-"
                "${date.month.toString().padLeft(2, '0')}-"
                "${date.day.toString().padLeft(2, '0')}";
            print("Formatted date: $dateOfBirth -> $formattedDateOfBirth");
          }
        } catch (e) {
          print("Error parsing date: $e");
          formattedDateOfBirth = dateOfBirth; // Keep original if parsing fails
        }
      }

      // Call API with all optional parameters
      final DriverImageUploadRes res =
          await ProfileApiServices.edit_profile_data_api(
            image: image,
            userType: '',
            name: name,
            email: email,
            dateOfBirth: formattedDateOfBirth ?? dateOfBirth,
            gender: gender,
          );

      print("API>>>>>>Ressssponse: ${res.success}");

      if (res.success == true) {
        print("Profile updated successfully");
        CustomToast.showSuccess( res.message ?? "Profile updated successfully");

        // ✅ Refresh home data after profile update
        try {
          final HomeController homeController = Get.find<HomeController>();
          await homeController.home_data_method();
          print("Home data refreshed after profile update");
        } catch (e) {
          print("Failed to refresh home data: $e");
        }

        driverImageUploadRes.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to update profile';
        print("Error: ${errorMessage.value}");
        CustomToast.showError( errorMessage.value);
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
