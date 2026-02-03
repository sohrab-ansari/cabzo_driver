import 'package:nzcu_driver/apiervices/services/profile_api_services.dart';
import 'package:nzcu_driver/modals/chartid_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // ✅ Store API response
  Rx<ChatResponse?> chatResponse = Rx<ChatResponse?>(null);

  Future<void> getchat_history({required String chatId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final ChatResponse res =
          await ProfileApiServices.get_chat_messages_data(chatId: chatId);

      chatResponse.value = res;
    } catch (e) {
      errorMessage.value = e.toString();

      Get.snackbar(
        'Error',
        'Failed to load chat',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
