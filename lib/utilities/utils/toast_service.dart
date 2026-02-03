// // utils/toast_service.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ToastService {
//   static void showSuccess(BuildContext? context, String message) {
//     if (context != null && context.mounted) {
//       // Use ScaffoldMessenger if we have a valid context
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (Get.isSnackbarOpen == false) {
//       // Fall back to GetX snackbar
//       Get.snackbar(
//         'Success',
//         message,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(10),
//         borderRadius: 8,
//         icon: const Icon(Icons.check_circle, color: Colors.white),
//       );
//     }
//   }

//   static void showError(BuildContext? context, String title, String message) {
//     if (context != null && context.mounted) {
//       // Use ScaffoldMessenger if we have a valid context
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (Get.isSnackbarOpen == false) {
//       // Fall back to GetX snackbar
//       Get.snackbar(
//         title,
//         message,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//         margin: const EdgeInsets.all(10),
//         borderRadius: 8,
//         icon: const Icon(Icons.error_outline, color: Colors.white),
//       );
//     }
//   }

//   static void showInfo(BuildContext? context, String title, String message) {
//     if (context != null && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.blue,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (Get.isSnackbarOpen == false) {
//       Get.snackbar(
//         title,
//         message,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(10),
//         borderRadius: 8,
//       );
//     }
//   }
// }



// // utils/toast_service.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ToastService {

//   static EdgeInsets _topMargin(BuildContext context) {
//     return EdgeInsets.only(
//       top: MediaQuery.of(context).padding.top + 12,
//       left: 12,
//       right: 12,
//     );
//   }

//   // ✅ SUCCESS
//   static void showSuccess(BuildContext? context, String message) {
//     if (context != null && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,

//           // 👇 THIS puts it at TOP
//           margin: _topMargin(context),

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (!Get.isSnackbarOpen) {
//       Get.snackbar(
//         'Success',
//         message,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(12),
//         borderRadius: 8,
//         icon: const Icon(Icons.check_circle, color: Colors.white),
//       );
//     }
//   }

//   // ❌ ERROR
//   static void showError(BuildContext? context, String title, String message) {
//     if (context != null && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//           behavior: SnackBarBehavior.floating,
//           margin: _topMargin(context),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (!Get.isSnackbarOpen) {
//       Get.snackbar(
//         title,
//         message,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//         margin: const EdgeInsets.all(12),
//         borderRadius: 8,
//         icon: const Icon(Icons.error_outline, color: Colors.white),
//       );
//     }
//   }

//   // ℹ️ INFO
//   static void showInfo(BuildContext? context, String title, String message) {
//     if (context != null && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.blue,
//           duration: const Duration(seconds: 2),
//           behavior: SnackBarBehavior.floating,
//           margin: _topMargin(context),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } else if (!Get.isSnackbarOpen) {
//       Get.snackbar(
//         title,
//         message,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.blue,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(12),
//         borderRadius: 8,
//       );
//     }
//   }
// }
