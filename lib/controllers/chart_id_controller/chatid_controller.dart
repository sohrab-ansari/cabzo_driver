import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/chat_id_response.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class ChatidController extends GetxController {
  // Change to Rx<HomeModalResponse?> and use .obs
  Rx<ChatResponse?> chartresposne = Rx<ChatResponse?>(null);

  // Add loading state
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getchartidmethod({required dynamic orderid}) async {
    AppLogger.d("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';
    chartresposne.value = null;

    try {
      // Call API
      final ChatResponse res = await HomeApiServices.chartidmethod(
        orderid: orderid,
      );

      AppLogger.d("API Response: ${res.success}");

      if (res.success == true) {
        chartresposne.value = res;

        AppLogger.d("Chat ID>>>>  ${chartresposne.value}");

        AppLogger.d("Chat ID respsone ${res}");
      } else {
        AppLogger.d("myupdate_order_data22222222  faileddd111");
        errorMessage.value = 'Failed to fetch chat data';
        AppLogger.d("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("charttt_iddd   exception: $e");
      CustomToast.showError('Failed to load chat');
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

  // Clear the chat response when needed
  void clearChartResponse() {
    chartresposne.value = null;
  }
}
