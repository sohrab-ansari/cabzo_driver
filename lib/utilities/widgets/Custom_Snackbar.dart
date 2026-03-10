// // utilities/custom_snackbar.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomSnackbar {
//   static void showCustomSnackbar({
//     required BuildContext context,
//     required String title,
//     required String subtitle,
//     required Color backgroundColor,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     Get.snackbar(
//       title,
//       subtitle,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: backgroundColor,
//       colorText: Colors.white,
//       borderRadius: 10,
//       margin: EdgeInsets.all(10),
//       duration: duration,
//     );
//   }
// }

// utilities/custom_snackbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showCustomSnackbar({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      subtitle,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: duration,
    );
  }

  // Add these convenience methods for common snackbar types
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
    );
  }

  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 3),
    );
  }
}
