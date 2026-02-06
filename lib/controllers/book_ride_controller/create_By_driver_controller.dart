// import 'package:nzcu_driver/api_services/profile_api_services.dart';
import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/modals/create_by_driver_respose.dart';
// import 'package:nzcu_driver/views/payment_modes_screen/cash_payment_screen.dart';
import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:get/get.dart';

class CreateByDriverController extends GetxController {
  // Rx variables for state management
  Rx<CreateByDriverResponse?> cashResponse = Rx<CreateByDriverResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Process cash payment
  Future<void> processCashPayment({
    required double startLat,
    required double startLng,
    required String startAddress,
    required double endLat,
    required double endLng,
    required String endAddress,
    required String userName,
    required String phone,
  }) async {
    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;

    try {
      // Call API
      final CreateByDriverResponse response =
          await ProfileApiServices.createByDriverData(
            startLat: startLat,
            startLng: startLng,
            startAddress: startAddress,
            endLat: endLat,
            endLng: endLng,
            endAddress: endAddress,
            userName: userName,
            phone: phone,
          );

      // Update response
      cashResponse.value = response;

      if (response.success == true) {
        print("✅ Ride created successfully");
      } else {
        // Creation failed - store error message for UI to display
        errorMessage.value =
            response.message ?? 'Failed to create ride. Please try again.';
        print("❌ Ride creation failed: ${errorMessage.value}");
      }
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in processCashPayment: $e");
    } finally {
      // Always reset loading state
      isLoading.value = false;
    }
  }

  // Navigate to home screen
  void navigateToHome() {
    Get.offAll(
      () => BottomnavmainScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }
}
