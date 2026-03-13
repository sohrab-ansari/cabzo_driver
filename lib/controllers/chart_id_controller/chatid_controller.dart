import 'package:nzcu_driver/services/apiservices/home_api_services.dart';
import 'package:nzcu_driver/modals/home_modals/chat_id_response.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

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
    print("home_data_method called");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final ChatResponse res = await HomeApiServices.chartidmethod(
        orderid: orderid,
      );

      print("API Response: ${res.success}");

      if (res.success == true) {
        print("charttt_iddd  fetched successfully");
        chartresposne.value = res;

        print("charttt_iddd>>>>  ${chartresposne.value}");

        print("charttt_iddd respsoneee ${res}");
      } else {
        print("myupdate_order_data22222222  faileddd111");
        errorMessage.value = 'Failed to fetch chart data';
        print("Error: ${errorMessage.value}");
        CustomToast.showError(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      print("charttt_iddd   exception: $e");
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
