// import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
// import 'package:corezap_driver/modals/home_modal_response.dart';
// import 'package:corezap_driver/modals/order_complete_cash_response.dart';
// import 'package:corezap_driver/modals/update_order_response.dart';
// import 'package:corezap_driver/views/scheduled_pickups/otp_and_Declined_files/verify_Otp_Order_response.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class VerifyOtpOrderController extends GetxController {
//   // Change to Rx<HomeModalResponse?> and use .obs
//   Rx<VerifyOtpResponse?> cashcompletecashresposne = Rx<VerifyOtpResponse?>(
//     null,
//   );

//   // Add loading state
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   Future<void> verifyOtpOrder({
//     required dynamic enteredOtp,
//     required dynamic orderid,
//   }) async {
//     print("home_data_method called");

//     // Set loading state
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       // Call API
//       final VerifyOtpResponse res =
//           await ProfileApiServices.verify_order_otp_data(
//             enteredOtp: enteredOtp,
//             orderid: orderid,
//           );

//       print("API Response: ${res.success}");

//       if (res.success == true) {
//         print("update orderget fetched successfully");
//         cashcompletecashresposne.value = res;

//         print("myupdate_order_data111  ${cashcompletecashresposne.value}");

//         print("myupdate_order_data22222222  ${res}");
//       } else {
//         print("myupdate_order_data22222222  faileddd111");
//         errorMessage.value = res.message ?? 'Failed to fetch home data';
//         print("Error: ${errorMessage.value}");
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred: $e';
//       print("Exception: $e");
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       // Reset loading state
//       isLoading.value = false;
//     }
//   }
// }

import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/views/scheduled_pickups/otp_and_Declined_files/verify_Otp_Order_response.dart';
import 'package:get/get.dart';

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
    print("verifyOtpOrder called for order: $orderId");

    // Store current order ID
    currentOrderId = orderId;

    // Check if order was cancelled
    if (isOrderCancelled.value) {
      final message = "Order was cancelled";
      print("❌ $message");
      onComplete?.call(false, message);
      return;
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final VerifyOtpResponse res =
          await ProfileApiServices.verify_order_otp_data(
            enteredOtp: enteredOtp,
            orderid: orderId,
          );

      print("API Response success: ${res.success}");

      if (res.success == true) {
        print("✅ OTP verified successfully");
        verifyOtpResponse.value = res;

        // Call success callback
        onComplete?.call(true, res.message ?? "OTP verified successfully");
      } else {
        print("❌ OTP verification failed");
        errorMessage.value = res.message ?? 'Failed to verify OTP';

        // Call error callback
        onComplete?.call(false, errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception: $e");

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

    print('❌ Order cancelled: $rideId - $message');

    // Check if this is the current order being verified
    if (rideId == currentOrderId) {
      isOrderCancelled.value = true;
      isLoading.value = false;

      // You can add navigation logic here if needed
      // Get.offAllNamed('/home');
    }
  }
}
