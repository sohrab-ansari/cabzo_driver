import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/driverId_response.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class DriveridController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<DriverIdResponse?> driveridresponse = Rx<DriverIdResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> driverid_mdethod() async {
    AppLogger.d("driveridd  called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final DriverIdResponse res = await HomeApiServices.get_driverid_data();

      AppLogger.d("API Response: ${res.success}");

      AppLogger.d("API Response2222: ${res.driver}");

      if (res.success == true) {
        AppLogger.d("driverid data fetched successfully");
        driveridresponse.value = res;
      } else {
        errorMessage.value = res.message ?? 'Failed to fetch home data';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("Exception: $e");
      CustomToast.showError(errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
