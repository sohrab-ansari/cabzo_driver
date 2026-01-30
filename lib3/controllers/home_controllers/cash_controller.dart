
// import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
// import 'package:corezap_driver/modals/home_modal_response.dart';
// import 'package:corezap_driver/modals/order_complete_cash_response.dart';
// import 'package:corezap_driver/modals/update_order_response.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/payment_modes_screen.dart/cash_payment_screen.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CashController extends GetxController {
//   // Change to Rx<HomeModalResponse?> and use .obs
//   Rx<Ordercompletecashresponse?> cashcompletecashresposne = Rx<Ordercompletecashresponse?>(null);
  
//   // Add loading state
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();

//   }

//   Future<void> cash_method({required dynamic orderid,BuildContext? context}) async {
//     print("home_data_method called");
    
//     // Set loading state
//     isLoading.value = true;
//     errorMessage.value = '';
    
//     try {
//       // Call API
//       final Ordercompletecashresponse res = await ProfileApiServices.cash_update_data(orderid:orderid );

      
//       print("API Response: ${res.success}");
      
//       if (res.success == true) {
//         print("update orderget fetched successfully");
//         cashcompletecashresposne.value = res;

//         print("myupdate_order_data111  ${cashcompletecashresposne.value}");

//         print("myupdate_order_data22222222  ${res}");


//          Future.delayed(const Duration(milliseconds: 300), () {
//                           CustomNavigator.push(
//                             context!,
//                             const CashPaymentScreen(),
//                             transition: TransitionType.slideLeft,
//                           );
                          
                          
                      
//                         });
//       } else {
//          print("myupdate_order_data22222222  faileddd111");
//         errorMessage.value = res.message ?? 'Failed to fetch home data';
//         print("Error: ${errorMessage.value}");
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred: $e';
//       print("Exception: $e");
//       Get.snackbar(
//         'Error',
//         errorMessage.value,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       // Reset loading state
//       isLoading.value = false;
//     }
//   }
// }


import 'package:corezap_driver/apiervices/services/profile_api_services.dart';
import 'package:corezap_driver/modals/order_complete_cash_response.dart';
import 'package:corezap_driver/views/payment_modes_screen.dart/cash_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class CashController extends GetxController {
//   Rx<Ordercompletecashresponse?> cashcompletecashresponse = Rx<Ordercompletecashresponse?>(null);
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   Future<void> cash_method({required dynamic orderid, required BuildContext context}) async {
//     print("cash_method called");
    
//     isLoading.value = true;
//     errorMessage.value = '';
    
//     try {
//       final Ordercompletecashresponse res = await ProfileApiServices.cash_update_data(orderid: orderid);
      
//       print("API Response success: ${res.success}");
//       print("API Response message: ${res.message}");
      
//       if (res.success == true) {
//         print("Cash payment successful");
//         cashcompletecashresponse.value = res;
        
//         // Navigate to cash payment screen on success
//         Future.delayed(Duration.zero, () {
//           Get.to(() => CashPaymentScreen(),
//             transition: Transition.rightToLeft,
//             duration: const Duration(milliseconds: 300),
//           );
//         });
//       } else {
//         errorMessage.value = res.message ?? 'Payment failed';
//         print("Payment failed: ${errorMessage.value}");
        
//         // Show error using ScaffoldMessenger instead of Get.snackbar
//         Future.delayed(Duration.zero, () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(errorMessage.value),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 3),
//             ),
//           );
//         });
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred: $e';
//       print("Exception in cash_method: $e");
      
//       // Show error using ScaffoldMessenger
//       Future.delayed(Duration.zero, () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Network error. Please try again.'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       });
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// import 'package:corezap_driver/api_services/profile_api_services.dart';
import 'package:corezap_driver/modals/order_complete_cash_response.dart';
// import 'package:corezap_driver/views/payment_modes_screen/cash_payment_screen.dart';
import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashController extends GetxController {
  // Rx variables for state management
  Rx<Ordercompletecashresponse?> cashResponse = Rx<Ordercompletecashresponse?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Process cash payment
  Future<void> processCashPayment({
    required String orderId,
  }) async {
    print("🔄 Processing cash payment for order: $orderId");
    
    // Reset states
    isLoading.value = true;
    errorMessage.value = '';
    cashResponse.value = null;
    
    try {
      // Call API
      final Ordercompletecashresponse response = 
          await ProfileApiServices.cash_update_data(orderid: orderId);
      
      // Update response
      cashResponse.value = response;
      
      if (response.success == true) {
        print("✅ Cash payment successful");
        
        // Navigate to cash payment success screen
        Get.offAll(() => CashPaymentScreen(
          // orderData: {
          //   'orderId': orderId,
          //   'success': true,
          //   'message': response.message,
          // },
        ), transition: Transition.rightToLeft);
        
      } else {
        // Payment failed
        errorMessage.value = response.message ?? 'Payment failed. Please try again.';
        print("❌ Payment failed: ${errorMessage.value}");
        
        // Show error snackbar
        Get.snackbar(
          'Payment Failed',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
        );
      }
      
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'An error occurred: $e';
      print("❌ Exception in processCashPayment: $e");
      
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
      );
      
    } finally {
      // Always reset loading state
      isLoading.value = false;
    }
  }

  // Navigate to home screen
  void navigateToHome() {
    Get.offAll(() => BottomnavmainScreen(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 300),
    );
  }
}