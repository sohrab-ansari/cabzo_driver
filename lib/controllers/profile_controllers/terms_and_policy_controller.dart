import 'package:nzcu_driver/modals/profile_modals/terms_and_policy_response.dart';
import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';

class TermsAndPolicyController extends GetxController {
  Rx<Termsandpolicyresponse?> termspolicyres = Rx<Termsandpolicyresponse?>(
    null,
  );

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> terms_pricy_method() async {
    print("Fetching reviews...");

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final Termsandpolicyresponse res =
          await ProfileApiServices.get_terams_and_policy_data();

      print("API Response Success: ${res.success}");

      if (res.success == true) {
        print("Reviews fetched successfully");

        // Update the response
        termspolicyres.value = res;

      } else {
        errorMessage.value = res.message ?? 'Failed to fetch reviews';
        print("Error: ${errorMessage.value}");

        // Only show snackbar if there's no existing data
        if (termspolicyres.value == null) {
          CustomToast.showError(errorMessage.value);
        }
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: ${e.toString()}';
      print("Exception: $e");

      // Only show snackbar if there's no existing data
      if (termspolicyres.value == null) {
        CustomToast.showError(errorMessage.value);
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

}
