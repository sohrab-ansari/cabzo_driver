import 'package:nzcu_driver/modals/profile_modals/wallet_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';

import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class WalletController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<WalletResponse?> walletresponse = Rx<WalletResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> wallet_method() async {
    AppLogger.d("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final WalletResponse res = await ProfileApiServices.get_wallet_data();

      AppLogger.d("API Response: ${res.success}");

      AppLogger.d("API Response2222: ${res.data}");

      if (res.success == true) {
        AppLogger.d("wallet data fetched successfully");
        walletresponse.value = res;
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
