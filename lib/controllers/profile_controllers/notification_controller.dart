import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/notification_response.dart';
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
        errorMessage.value =
            response.message ?? 'Failed to load notifications.';
        print("❌ Notification failed: ${errorMessage.value}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Failed',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
          );
        });
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in getNotifications: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
      });
    } finally {
      isLoading.value = false;
    }
  }
}
