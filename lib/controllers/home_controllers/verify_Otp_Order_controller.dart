

import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/verify_Otp_Order_response.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class VerifyOtpOrderController extends GetxController {
  Rx<VerifyOtpResponse?> verifyOtpResponse = Rx<VerifyOtpResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isOrderCancelled = false.obs;

  // Add orderId to track current order
  String? currentOrderId;

  @override
  void onInit() {
    super.onInit();
  }

  // Method to verify OTP with callback
  Future<void> verifyOtpOrder({
    required String enteredOtp,
    required String orderId,
    Function(bool success, String message)? onComplete,
  }) async {
    AppLogger.d("verifyOtpOrder called for order: $orderId");

    // Store current order ID
    currentOrderId = orderId;

    // Check if order was cancelled
    if (isOrderCancelled.value) {
      final message = "Order was cancelled";
      AppLogger.d("❌ $message");
      onComplete?.call(false, message);
      return;
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final VerifyOtpResponse res =
          await HomeApiServices.verify_order_otp_data(
            enteredOtp: enteredOtp,
            orderid: orderId,
          );

      AppLogger.d("API Response success: ${res.success}");

      if (res.success == true) {
        AppLogger.d("✅ OTP verified successfully");
        verifyOtpResponse.value = res;

        // Call success callback
        onComplete?.call(true, res.message ?? "OTP verified successfully");
      } else {
        AppLogger.d("❌ OTP verification failed");
        errorMessage.value = res.message ?? 'Failed to verify OTP';

        // Call error callback
        onComplete?.call(false, errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("❌ Exception: $e");

      // Call error callback
      onComplete?.call(false, errorMessage.value);
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Method to handle order cancellation
  void handleOrderCancelled(Map<String, dynamic> data) {
    final rideId = data['rideId']?.toString();
    final message = data['message'] ?? 'Order no longer available';

    AppLogger.d('❌ Order cancelled: $rideId - $message');

    // Check if this is the current order being verified
    if (rideId == currentOrderId) {
      isOrderCancelled.value = true;
      isLoading.value = false;

      // You can add navigation logic here if needed
      // Get.offAllNamed('/home');
    }
  }
}
