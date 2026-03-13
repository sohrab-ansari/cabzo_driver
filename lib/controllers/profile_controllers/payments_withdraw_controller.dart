import 'package:nzcu_driver/services/apiservices/profile_api_services.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/modals/profile_modals/payments_withdraw_response.dart';
import 'package:nzcu_driver/views/profile_screens/payment_screen.dart';
import 'package:get/get.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class PaymentsWithdrawController extends GetxController {
  Rx<PaymentsWithdrawResponse?> transactionsres = Rx<PaymentsWithdrawResponse?>(
    null,
  );
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> withdrawal_method({
    required String amount,

    required String? BankAccountId,
  }) async {
    AppLogger.d("add bankaccount called");

    // Validate inputs
    if (amount.isEmpty) {
      return;
    }

    // Set loading state
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call API
      final PaymentsWithdrawResponse res =
          await ProfileApiServices.money_transfer(
            BankAccountId: BankAccountId,
            amount: amount,
          );

      AppLogger.d("API Response success: ${res.success}");
      AppLogger.d("API Response message: ${res.message}");
      AppLogger.d("API Response data: ${res.data}");

      // Check both possible success indicators
      if (res.success == true) {
        AppLogger.d("✅ Bank account added successfully!");

        // IMPORTANT: Refresh home data after profile update
        try {
          // final HomeController homeController = Get.find<HomeController>();
          // await homeController.home_data_method();

          final WalletController walletController =
              Get.find<WalletController>();

          walletController.wallet_method();

          AppLogger.d("Wallet data refreshed after profile update");
        } catch (e) {
          AppLogger.d("Failed to refresh home data: $e");
        }

        transactionsres.value = res;

        //Use GetX navigation instead of CustomNavigator
        await Future.delayed(Duration(milliseconds: 500));

        Get.off(PaymentScreen());

        final WalletController walletController = Get.find<WalletController>();
        walletController.wallet_method();
      } else {
        errorMessage.value = res.message ?? 'Failed to add bank account';
        AppLogger.d("❌ Error: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      AppLogger.d("❌ Exception: $e");
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }

}
