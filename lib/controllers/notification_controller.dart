// import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
// import 'package:nzcu_driver/modals/get_promo_code_data.dart';
// import 'package:nzcu_driver/modals/notification_response.dart';
// import 'package:nzcu_driver/modals/order_complete_cash_response.dart';
// // import 'package:nzcu_driver/views/payment_modes_screen/cash_payment_screen.dart';
// import 'package:nzcu_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NotificationController extends GetxController {
//   // Rx variables for state management
//   Rx<NotificationResponse?> cashResponse = Rx<NotificationResponse?>(null);
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   // Process cash payment
//   Future<void> getNotifications() async {
//     // Reset states
//     isLoading.value = true;
//     errorMessage.value = '';
//     cashResponse.value = null;

//     try {
//       // Call API
//       final NotificationResponse response =
//           await ProfileApiServices.get_notification_data();

//       // Update response
//       cashResponse.value = response;

//       if (response.success == true) {
//         print("promo code data successful");
//       } else {
//         // Payment failed
//         errorMessage.value = response.message ?? 'promo code Please try again.';
//         print("❌ Notification failed: ${errorMessage.value}");

//         // Show error snackbar
//         Get.snackbar(
//           'Notification code d Failed',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//           margin: const EdgeInsets.all(10),
//         );
//       }
//     } catch (e) {
//       // Handle exceptions
//       errorMessage.value = 'An error occurred: $e';
//       print("❌ Exception in Notification code d: $e");

//       // Show error snackbar
//       Get.snackbar(
//         'Error',
//         'Something went wrong. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//         margin: const EdgeInsets.all(10),
//       );
//     } finally {
//       // Always reset loading state
//       isLoading.value = false;
//     }
//   }
// }


// import 'package:nzcu_driver/api/services/profile_api_services.dart';
import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/modals/notification_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  Rx<NotificationResponse?> cashResponse = Rx<NotificationResponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> getNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;

    try {
      final NotificationResponse response =
          await ProfileApiServices.get_notification_data();

      cashResponse.value = response;

      if (response.success == true) {
        print("Notifications fetched successfully");
      } else {
        errorMessage.value = response.message ?? 'Failed to load notifications.';
        print("❌ Notification failed: ${errorMessage.value}");

        Get.snackbar(
          'Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in getNotifications: $e");

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }
}