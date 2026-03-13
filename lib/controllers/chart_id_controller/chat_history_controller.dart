import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/chat_id_response.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class ChatHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // ✅ Store API response
  Rx<ChatResponse?> chatResponse = Rx<ChatResponse?>(null);

  Future<void> getchat_history({required String chatId}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final ChatResponse res = await HomeApiServices.get_chat_messages_data(
        chatId: chatId,
      );

      chatResponse.value = res;
    } catch (e) {
      errorMessage.value = e.toString();
      CustomToast.showError('Failed to load chat');
    } finally {
      isLoading.value = false;
    }
  }
}
