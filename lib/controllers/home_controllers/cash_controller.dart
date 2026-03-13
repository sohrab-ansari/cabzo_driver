import 'package:get/get.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/order_complete_cash_response.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/views/payment_modes_screen.dart/cash_payment_screen.dart';
import 'package:nzcu_driver/views/bottomnav/bottomNavMain_screen.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class CashController extends GetxController {
  // Rx variables for state management
  Rx<Ordercompletecashresponse?> cashResponse = Rx<Ordercompletecashresponse?>(
    null,
  );
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Process cash payment
  Future<void> processCashPayment({
    required String orderId,
    dynamic rideData,
  }) async {
    AppLogger.d("🔄 Processing cash payment for order: $orderId");

    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;

    try {
      // Call API
      final Ordercompletecashresponse response =
          await ProfileApiServices.cash_update_data(orderid: orderId);

      // Update response
      cashResponse.value = response;

      if (response.success == true) {
        AppLogger.d("✅ Cash payment successful");

        // Navigate to cash payment success screen
        Get.offAll(
          () => CashPaymentScreen(rideData: rideData),
          transition: Transition.rightToLeft,
        );
      } else {
        // Payment failed
        errorMessage.value =
            response.message ?? 'Payment failed. Please try again.';
        AppLogger.d("❌ Payment failed: ${errorMessage.value}");

        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("❌ Exception in processCashPayment: $e");
      CustomToast.showError('Something went wrong. Please try again.');
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
