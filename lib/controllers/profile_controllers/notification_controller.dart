import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/modals/profile_modals/notification_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

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
        AppLogger.d("Notifications fetched successfully");
      } else {
        errorMessage.value =
            response.message ?? 'Failed to load notifications.';
        AppLogger.d("❌ Notification failed: ${errorMessage.value}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomToast.showError(errorMessage.value);
        });
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("❌ Exception in getNotifications: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomToast.showError('Something went wrong. Please try again.');
      });
    } finally {
      isLoading.value = false;
    }
  }
}
