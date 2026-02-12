import 'package:nzcu_driver/controllers/auth_controllers/login.controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/vehicle_subtypes_controller.dart';
import 'package:nzcu_driver/controllers/auth_controllers/vehicle_types_controller.dart';
import 'package:nzcu_driver/controllers/book_ride_controller/create_By_driver_controller.dart';
import 'package:nzcu_driver/controllers/chart_id_controller/chatid_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/cash_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/driver_toggle_duty_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/order_update_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/faqs_categories_controler.dart';
import 'package:nzcu_driver/controllers/profile_controllers/notification_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/bank_account_add_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/review_and_rating_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/terms_and_policy_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/transaction_controller.dart';
import 'package:nzcu_driver/controllers/profile_controllers/wallet_controller.dart';
import 'package:nzcu_driver/controllers/promo_code_controller/get_promo_code_controller.dart';
import 'package:nzcu_driver/controllers/rides_controllers/rieds_history_controller.dart';
import 'package:nzcu_driver/services/notification_services/notification_service_controller.dart';
import 'package:nzcu_driver/services/apiservices/socket_manager.dart';
import 'package:nzcu_driver/controllers/home_controllers/decline_Order_controller.dart';
import 'package:nzcu_driver/controllers/home_controllers/verify_Otp_Order_controller.dart';
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

    Get.put(ChatidController(), permanent: true);

    Get.put(SocketManager(), permanent: true);

    Get.put(VehicleTypesController(), permanent: true);

    Get.put(GetPromoCodeController(), permanent: true);

    Get.put(NotificationServiceController(), permanent: true);

    Get.put(VehicleSubtypesController(), permanent: true);

    Get.put(DriverToggleDutyController(), permanent: true);

    Get.put(CreateByDriverController(), permanent: true);

    Get.put(LoginController(), permanent: true);

    Get.put(NotificationController(), permanent: true);


    Get.put(NotificationController(), permanent: true);

    Get.put(FaqsCategoriesControler(), permanent: true);

    // final LoginController loginController = Get.put(LoginController());

  }
}
