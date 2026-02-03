import 'package:nzcu_driver/controllers/auth_controllers/vehicle_types_controller.dart';
import 'package:nzcu_driver/controllers/chart_id_controller/chartid_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/cash_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/transaction_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
import 'package:nzcu_driver/controllers/rides_controllers/rieds_history_controller.dart';
import 'package:nzcu_driver/services/notification_controller.dart';
import 'package:nzcu_driver/services/socket_manager.dart';
import 'package:nzcu_driver/views/scheduled_pickups/otp_and_Declined_files/decline_Order_controller.dart';
import 'package:nzcu_driver/views/scheduled_pickups/otp_and_Declined_files/verify_Otp_Order_controller.dart';
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
    Get.put(OrderUpdateController(), permanent: true);

    Get.put(CashController(), permanent: true);

    Get.put(VerifyOtpOrderController(), permanent: true);

    Get.put(DeclineOrderController(), permanent: true);

    Get.put(ChartidController(), permanent: true);

    Get.put(SocketManager(), permanent: true);



    Get.put(VehicleTypesController(), permanent: true);


Get.put(GetPromoCodeController(), permanent: true);


Get.put(NotificationController(), permanent: true);


    
  }
}
