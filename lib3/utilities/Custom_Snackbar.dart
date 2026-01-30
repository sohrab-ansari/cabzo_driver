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
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      duration: duration,
    );
  }
}