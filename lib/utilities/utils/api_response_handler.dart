// // // utils/api_response_handler.dart
// // import 'package:nzcu_driver/utilities/utils/button_state_manager.dart';
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
// // //   }

// //   static void _showSuccessToast(String message) {
// // //   }

// //   static void showCustomToast(String title, String message, Color color) {
// // //   }
// // }

// // utils/api_response_handler.dart
// import 'package:nzcu_driver/utilities/utils/button_state_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:nzcu_driver/utils/button_state_manager.dart';

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
//   }

//   static void _showSuccessToast(String message) {
//   }
// }

// utilities/utils/api_response_handler.dart
// utilities/utils/api_response_handler.dart
import 'package:nzcu_driver/utilities/widgets/custom_toast.dart';
import 'package:nzcu_driver/utilities/utils/button_state_manager.dart';
import 'package:flutter/material.dart';
import 'package:nzcu_driver/utilities/widgets/connection_error_popup.dart';

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
    // Prevent multiple calls if already loading
    if (ButtonStateManager.isLoading(buttonId)) {
      return;
    }

    // Set button to loading state
    ButtonStateManager.setLoading(buttonId, true);

    try {
      final response = await apiCall();

      // Handle response
      if (response?.success == true) {
        onSuccess(response);
        if (successMessage != null && successMessage.isNotEmpty) {
          CustomToast.showSuccess(successMessage);
        }
      } else {
        final errorMessage = response?.message;
        
        if (errorMessage != null && errorMessage.isNotEmpty) {
           if (_isNetworkError(errorMessage)) {
             _showConnectionErrorPopup(context, errorMessage);
           } else {
             CustomToast.showError(errorMessage);
           }
        } else {
           CustomToast.showError(errorTitle ?? 'Error');
        }

        onError?.call(errorMessage ?? '');
      }
    } catch (e) {
      final errorMessage = _parseError(e);

      if (_isNetworkError(e.toString()) || _isNetworkError(errorMessage)) {
         _showConnectionErrorPopup(context, errorMessage);
      } else {
         CustomToast.showError(errorTitle != null ? '$errorTitle: $errorMessage' : errorMessage);
      }
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

  static bool _isNetworkError(String errorMsg) {
    final msg = errorMsg.toLowerCase();
    return msg.contains('socketexception') ||
           msg.contains('connection error') ||
           msg.contains('no internet') ||
           msg.contains('timeout') ||
           msg.contains('connection refused') ||
           msg.contains('handshake') ||
           msg.contains('software caused connection abort');
  }

  static void _showConnectionErrorPopup(BuildContext context, String rawMessage) {
    String displayMessage = "Please check your internet settings and try again.";
    if (rawMessage.toLowerCase().contains("timeout")) {
      displayMessage = "The request timed out. Please try again when you have a better connection.";
    }

    ConnectionErrorPopup.show(context, message: displayMessage);
  }
}
