import 'package:corezap_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:corezap_driver/controllers/profile_controllers/review_and_rating_controller.dart';
import 'package:corezap_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:corezap_driver/controllers/profile_controllers/transaction_controller.dart';
import 'package:corezap_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:corezap_driver/controllers/rides_controllers/rieds_history_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controllers/home_controller.dart';
import '../controllers/home_controllers/stepper_controller.dart';


class DependencyInjection {
  static void init() {
    Get.put(HomeController(), permanent: true);
    Get.put(StepperController(), permanent: true);
    Get.put(RiedsHistoryController(), permanent: true);
    Get.put(TransactionController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(BankAccountAddController(), permanent: true);
    Get.put(ReviewAndRatingController(), permanent: true);
    Get.put(TermsAndPolicyController(), permanent: true);
  }
}
