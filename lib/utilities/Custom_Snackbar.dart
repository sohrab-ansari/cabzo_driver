// utilities/custom_snackbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void showCustomSnackbar({
    BuildContext? context,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    try {
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
    } catch (e) {
      // Fallback to ScaffoldMessenger if overlay is not available
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title\n$subtitle'),
            backgroundColor: backgroundColor,
            duration: duration,
          ),
        );
      } else {
        // Last resort: log the error so app does not crash
        debugPrint('Failed to show snackbar: $e');
      }
    }
  }
}