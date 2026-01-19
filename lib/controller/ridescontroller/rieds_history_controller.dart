// import 'dart:io';

// import 'package:corezap_driver/controller/home_controller.dart';
// import 'package:corezap_driver/modals/driver_Image_upload_res.dart';
// import 'package:corezap_driver/modals/home_modal_response.dart';
// import 'package:corezap_driver/modals/ride_history_response.dart';
// import 'package:corezap_driver/modals/transactions_response.dart';
// import 'package:corezap_driver/modals/wallet_response.dart';
// import 'package:corezap_driver/my_apis_services/services/auth_api_service.dart';
// import 'package:corezap_driver/my_apis_services/services/profile_api_services.dart';
// import 'package:corezap_driver/utilities/navigator.dart';
// import 'package:corezap_driver/views/bottomNavigation/bottomNavMain_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';

// // class RiedsHistoryController extends GetxController {
// //   // Change to Rx<HomeModalResponse?> and use .obs
// //   Rx<RideHistoryResponse?> transactionsres = Rx<RideHistoryResponse?>(
// //     null,
// //   );

// //   // Add loading state
// //   RxBool isLoading = false.obs;
// //   RxString errorMessage = ''.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //   }

// //   Future<void> transactions_method(
   
// //   ) async {
// //     print("rides historyyy called");

// //     // Set loading state
// //     isLoading.value = true;
// //     errorMessage.value = '';

// //     try {
// //       // Call API
// //       final RideHistoryResponse res =
// //           await ProfileApiServices.get_rides_history_data(
          
// //           );

// //       print("API Response: ${res.success}");

// //        print("API Response2222: ${res.data}");

// //       if (res.success == true) {
// //         print("rides history data fetched successfully");

// //         Fluttertoast.showToast(
// //           msg: res.message ?? "Something went wrong",
// //           toastLength: Toast.LENGTH_SHORT,
// //           gravity: ToastGravity.BOTTOM,
// //         );

    

// //         transactionsres.value = res;
// //       } else {
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

// class RiedsHistoryController extends GetxController {
//   Rx<RideHistoryResponse?> transactionsres = Rx<RideHistoryResponse?>(null);
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // Load data when controller initializes
//     transactions_method();
//   }

//   Future<void> transactions_method() async {
//     print("rides history called");

//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final RideHistoryResponse res =
//           await ProfileApiServices.get_rides_history_data();

//       print("API Response: ${res.success}");
//       print("API Data: ${res.data?.length}");

//       if (res.success == true) {
//         print("rides history data fetched successfully");
//         transactionsres.value = res;
//       } else {
//         errorMessage.value = res.message ?? 'Failed to fetch rides history';
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
//       isLoading.value = false;
//     }
//   }

//   // Method to get filtered rides based on tab index
//   List<RideHistory> getFilteredRides(int tabIndex) {
//     if (transactionsres.value?.data == null) return [];
    
//     final allRides = transactionsres.value!.data!;
    
//     switch (tabIndex) {
//       case 0: // New trip - show all data
//         return allRides;
//       case 1: // Completed
//         return allRides
//             .where((ride) => ride.orderStatus?.toLowerCase() == 'Completed')
//             .toList();
//       case 2: // Cancelled
//         return allRides
//             .where((ride) => ride.orderStatus?.toLowerCase() == 'Cancelled')
//             .toList();
//       default:
//         return allRides;
//     }
//   }
// }
