// // // utils/api_response_handler.dart
// // import 'package:corezap_driver/utilities/utils/button_state_manager.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';

// // class ApiResponseHandler {
// //   // Handle API call with reactive button loading
// //   static Future<void> handleApiCall({
// //     required BuildContext context,
// //     required String buttonId,
// //     required Future<dynamic> Function() apiCall,
// //     required Function(dynamic) onSuccess,
// //     Function(String)? onError,
// //     String? successMessage,
// //     String? errorTitle = 'Error',
// //   }) async {
// //     // Set button to loading state
// //     ButtonStateManager.setLoading(buttonId, true);

// //     try {
// //       final response = await apiCall();
      
// //       // Handle response
// //       if (response?.success == true) {
// //         onSuccess(response);
// //         if (successMessage != null && successMessage.isNotEmpty) {
// //           _showSuccessToast(successMessage);
// //         }
// //       } else {
// //         final errorMessage = response?.message ?? 'Operation failed';
// //         _showErrorToast(errorTitle ?? 'Error', errorMessage);
// //         onError?.call(errorMessage);
// //       }
// //     } catch (e) {
// //       final errorMessage = _parseError(e);
// //       _showErrorToast(errorTitle ?? 'Error', errorMessage);
// //       onError?.call(errorMessage);
// //     } finally {
// //       // Reset button loading state
// //       Future.delayed(const Duration(milliseconds: 300), () {
// //         ButtonStateManager.setLoading(buttonId, false);
// //       });
// //     }
// //   }

// //   static String _parseError(dynamic error) {
// //     if (error is String) return error;
// //     if (error.toString().contains('SocketException')) {
// //       return 'No internet connection. Please check your network.';
// //     }
// //     if (error.toString().contains('Timeout')) {
// //       return 'Request timeout. Please try again.';
// //     }
// //     if (error.toString().contains('Connection refused')) {
// //       return 'Server is not responding. Please try later.';
// //     }
// //     return 'Something went wrong. Please try again.';
// //   }

// //   static void _showErrorToast(String title, String message) {
// //     Get.snackbar(
// //       title,
// //       message,
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: Colors.red,
// //       colorText: Colors.white,
// //       duration: const Duration(seconds: 3),
// //       margin: const EdgeInsets.all(10),
// //       borderRadius: 8,
// //       icon: const Icon(Icons.error_outline, color: Colors.white),
// //     );
// //   }

// //   static void _showSuccessToast(String message) {
// //     Get.snackbar(
// //       'Success',
// //       message,
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: Colors.green,
// //       colorText: Colors.white,
// //       duration: const Duration(seconds: 2),
// //       margin: const EdgeInsets.all(10),
// //       borderRadius: 8,
// //       icon: const Icon(Icons.check_circle, color: Colors.white),
// //     );
// //   }

// //   static void showCustomToast(String title, String message, Color color) {
// //     Get.snackbar(
// //       title,
// //       message,
// //       snackPosition: SnackPosition.BOTTOM,
// //       backgroundColor: color,
// //       colorText: Colors.white,
// //       duration: const Duration(seconds: 3),
// //       margin: const EdgeInsets.all(10),
// //       borderRadius: 8,
// //     );
// //   }
// // }


// // utils/api_response_handler.dart
// import 'package:corezap_driver/utilities/utils/button_state_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:corezap_driver/utils/button_state_manager.dart';

// class ApiResponseHandler {
//   // Handle API call with reactive button loading
//   static Future<void> handleApiCall({
//     required BuildContext context,
//     required String buttonId,
//     required Future<dynamic> Function() apiCall,
//     required Function(dynamic) onSuccess,
//     Function(String)? onError,
//     String? successMessage,
//     String? errorTitle = 'Error',
//   }) async {
//     // Set button to loading state
//     ButtonStateManager.setLoading(buttonId, true);

//     try {
//       final response = await apiCall();
      
//       // Handle response
//       if (response?.success == true) {
//         onSuccess(response);
//         if (successMessage != null && successMessage.isNotEmpty) {
//           _showSuccessToast(successMessage);
//         }
//       } else {
//         final errorMessage = response?.message ?? 'Operation failed';
//         _showErrorToast(errorTitle ?? 'Error', errorMessage);
//         onError?.call(errorMessage);
//       }
//     } catch (e) {
//       final errorMessage = _parseError(e);
//       _showErrorToast(errorTitle ?? 'Error', errorMessage);
//       onError?.call(errorMessage);
//     } finally {
//       // Reset button loading state
//       Future.delayed(const Duration(milliseconds: 300), () {
//         ButtonStateManager.setLoading(buttonId, false);
//       });
//     }
//   }

//   static String _parseError(dynamic error) {
//     if (error is String) return error;
//     if (error.toString().contains('SocketException')) {
//       return 'No internet connection. Please check your network.';
//     }
//     if (error.toString().contains('Timeout')) {
//       return 'Request timeout. Please try again.';
//     }
//     if (error.toString().contains('Connection refused')) {
//       return 'Server is not responding. Please try later.';
//     }
//     return 'Something went wrong. Please try again.';
//   }

//   static void _showErrorToast(String title, String message) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//       margin: const EdgeInsets.all(10),
//       borderRadius: 8,
//       icon: const Icon(Icons.error_outline, color: Colors.white),
//     );
//   }

//   static void _showSuccessToast(String message) {
//     Get.snackbar(
//       'Success',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       margin: const EdgeInsets.all(10),
//       borderRadius: 8,
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//     );
//   }
// }


// utilities/utils/api_response_handler.dart
import 'package:corezap_driver/utilities/utils/button_state_manager.dart';
import 'package:corezap_driver/utilities/utils/toast_service.dart';
import 'package:flutter/material.dart';


class ApiResponseHandler {
  // Handle API call with reactive button loading
  static Future<void> handleApiCall({
    required BuildContext context,
    required String buttonId,
    required Future<dynamic> Function() apiCall,
    required Function(dynamic) onSuccess,
    Function(String)? onError,
    String? successMessage,
    String? errorTitle = 'Error',
  }) async {
    // Set button to loading state
    ButtonStateManager.setLoading(buttonId, true);

    try {
      final response = await apiCall();
      
      // Handle response
      if (response?.success == true) {
        onSuccess(response);
        if (successMessage != null && successMessage.isNotEmpty) {
          ToastService.showSuccess(context, successMessage);
        }
      } else {
        final errorMessage = response?.message ?? 'Operation failed';
        ToastService.showError(context, errorTitle ?? 'Error', errorMessage);
        onError?.call(errorMessage);
      }
    } catch (e) {
      final errorMessage = _parseError(e);
      ToastService.showError(context, errorTitle ?? 'Error', errorMessage);
      onError?.call(errorMessage);
    } finally {
      // Reset button loading state
      Future.delayed(const Duration(milliseconds: 300), () {
        ButtonStateManager.setLoading(buttonId, false);
      });
    }
  }

  static String _parseError(dynamic error) {
    if (error is String) return error;
    if (error.toString().contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.toString().contains('Timeout')) {
      return 'Request timeout. Please try again.';
    }
    if (error.toString().contains('Connection refused')) {
      return 'Server is not responding. Please try later.';
    }
    return 'Something went wrong. Please try again.';
  }
}