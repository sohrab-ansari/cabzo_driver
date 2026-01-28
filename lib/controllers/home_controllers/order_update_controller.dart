// // import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
// // import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// // import 'package:corezap_driver/modals/home_modal_response.dart';
// // import 'package:corezap_driver/modals/update_order_response.dart';
// // import 'package:corezap_driver/utilities/navigator.dart';
// // import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class OrderUpdateController extends GetxController {
// //   // Change to Rx<HomeModalResponse?> and use .obs
// //   Rx<Updateorderresposne?> updateorderresposne = Rx<Updateorderresposne?>(null);

// //   // Add loading state
// //   RxBool isLoading = false.obs;
// //   RxString errorMessage = ''.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //   }

// //   Future<void> update_order_method({
// //     required dynamic orderstatus,
// //     required dynamic orderid,
// //     BuildContext? context,
// //      final Map<String, dynamic>? ridedata
// //   }) async {
// //     print("home_data_method called");

// //     // Set loading state
// //     isLoading.value = true;
// //     errorMessage.value = '';

// //     try {
// //       // Call API
// //       final Updateorderresposne res =
// //           await ProfileApiServices.order_update_data(
// //             orderstatus: orderstatus,
// //             orderid: orderid,
// //           );

// //       print("API Response: ${res.success}");

// //       if (res.success == true) {
// //         print(
// //           "order_________update___method___successs>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
// //         );

// //         print("update order methodddsuccessfully");
// //         updateorderresposne.value = res;

// //         print(
// //           "my____update_order_data respsoneeee_here  ${updateorderresposne.value}",
// //         );

// //         print("respsoneeee_here_fulll_data>>>>>>  ${res}");
// //  final StepperController stepperController = Get.find();
// //          stepperController.resetSteps();
// //     print("myyy_tappp255555");
// //     CustomNavigator.push(
// //       context,
// //       ArrivingClient(rideData: ridedata),
// //       transition: TransitionType.slideLeft,
// //     );
// //       } else {
// //         print(
// //           "order_________update___method___failedddd>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",
// //         );

// //         print("myupdate_order_data22222222  faileddd111");
// //         errorMessage.value = res.message ?? 'Failed to fetch home data';
// //         print("Error: ${errorMessage.value}");
// //         Get.snackbar(
// //           'Error',
// //           errorMessage.value,
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //         );
// //       }
// //     } catch (e) {
// //       errorMessage.value = 'An error occurred: $e';
// //       print("Exception: $e");
// //       Get.snackbar(
// //         'Error',
// //         errorMessage.value,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //     } finally {
// //       // Reset loading state
// //       isLoading.value = false;
// //     }
// //   }
// // }

// import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
// import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
// import 'package:corezap_driver/modals/update_order_response.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/accepted_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/arrived_otp_screen.dart';
// import 'package:corezap_driver/views/scheduled_pickups/receive_payment_modes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class OrderUpdateController extends GetxController {
//   final StepperController stepperController = Get.find<StepperController>();
//   Rx<Updateorderresposne?> updateOrderResponse = Rx<Updateorderresposne?>(null);
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   Future<void> updateOrder({
//     required dynamic orderstatus,
//     required dynamic orderid,
//     BuildContext? context,
//     Map<String, dynamic>? rideData,
//     String? step_control,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     print("my_orderrridddd ${orderid}");
//     try {
//       final res = await ProfileApiServices.order_update_data(
//         orderstatus: orderstatus,
//         orderid: orderid,
//         context: context,
//       );

//       if (res.success == true) {
//         updateOrderResponse.value = res;

//         if (step_control == "Progress") {
//           print("step_controllll>>>> ${step_control}");
//           stepperController.nextStep();
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         if (step_control == "Cancelled") {
//           print("step_controllll>>>> caneclleddd >>>> ${step_control}");

//           CustomNavigator.removeUntil(
//             context!,
//             BottomnavmainScreen(),
//             transition: TransitionType.fade,
//           );
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         if (step_control == "Arriving") {
//           print("step_controllll>>>> caneclleddd >>>> ${step_control}");

//           Navigator.push(
//             context!,
//             MaterialPageRoute(
//               builder: (context) => ArrivedOtpScreen(
//                 bookridetypecheck: false,
//                 rideData: rideData,
//               ),
//             ),
//           );
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         if (step_control == "Progress") {
//           print("step_controllll>>>> Progress  >>>> ${step_control}");

//           stepperController.nextStep();
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         if (step_control == "Completed") {
//           print("step_controllll>>>> Progress  >>>> ${step_control}");

//           CustomNavigator.removeUntil(
//             context!,
//             ReceivePaymentModes(),
//             transition: TransitionType.fade,
//           );
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         if (step_control == "Progress") {
//           print("step_controllll>>>> Progress  >>>> ${step_control}");

//           stepperController.nextStep();
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }

//         /// ✅ Safe Stepper reset
//         if (Get.isRegistered<StepperController>()) {
//           Get.find<StepperController>().resetSteps();
//         }

//         if (step_control == "Accepted") {
//           print("step_controllll>>>> Progress  >>>> ${step_control}");

//           CustomNavigator.push(
//             context!,
//             ArrivingClient(rideData: rideData),
//             transition: TransitionType.slideLeft,
//           );
//         } else {
//           print("step_controllll>>>> nullll_emptyy");
//         }
//       } else {
//         _showError(res.message ?? 'Order update failed');
//       }
//     } catch (e) {
//       _showError(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _showError(String message) {
//     errorMessage.value = message;
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }

// import 'package:corezap_driver/apiServices/services/profile_api_services.dart';
import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/controllers/home_controllers/stepper_controller.dart';
import 'package:corezap_driver/modals/update_order_response.dart';
// import 'package:corezap_driver/models/update_order_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderUpdateController extends GetxController {
  final StepperController stepperController = Get.find<StepperController>();
  Rx<Updateorderresposne?> updateOrderResponse = Rx<Updateorderresposne?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<Updateorderresposne?> updateOrder({
    required dynamic orderStatus,
    required dynamic orderId,
    BuildContext? context,
    Map<String, dynamic>? rideData,
    String? stepControl,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    print("Order Update - Order ID: $orderId, Status: $orderStatus");

    try {
      final res = await ProfileApiServices.order_update_data(
        orderstatus: orderStatus,
        orderid: orderId,
        context: context,
      );

      if (res.success == true) {
        updateOrderResponse.value = res;

        // Handle stepper updates only, no navigation
        if (stepControl == "Progress") {
          print("Stepper control: Progress - Moving to next step");
          stepperController.nextStep();
        }

        print("✅ Order update successful: ${res.message}");
        return res;
      } else {
        _showError(res.message ?? 'Order update failed');
        return null;
      }
    } catch (e) {
      print("❌ Order update error: $e");
      _showError(e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void resetStepper() {
    if (Get.isRegistered<StepperController>()) {
      Get.find<StepperController>().resetSteps();
    }
  }

  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
