import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';

class ConnectionErrorPopup {
  static bool _isShowing = false;

  static void show(BuildContext context, {String message = "Please check your internet settings and try again."}) {
    if (_isShowing) return;
    _isShowing = true;

    double w = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: w * 0.85,
            padding: EdgeInsets.symmetric(
              vertical: w * 0.08,
              horizontal: w * 0.06,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(w * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.red,
                    size: w * 0.12,
                  ).animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  ).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
                ),
                SizedBox(height: w * 0.05),
                AppFonts.textPoppins(
                  ctx,
                  "Connection Failed",
                  w * 0.05,
                  FontWeight.w700,
                  Colors.black87,
                  TextAlign.center,
                  TextOverflow.visible,
                ),
                SizedBox(height: w * 0.03),
                AppFonts.textPoppins(
                  ctx,
                  message,
                  w * 0.035,
                  FontWeight.w400,
                  Colors.grey,
                  TextAlign.center,
                  TextOverflow.visible,
                  maxLines: 4,
                ),
                SizedBox(height: w * 0.07),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: w * 0.035),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: AppFonts.textPoppins(
                      ctx,
                      "Okay",
                      w * 0.04,
                      FontWeight.w600,
                      Colors.white,
                      TextAlign.center,
                      TextOverflow.visible,
                    ),
                  ),
                ),
              ],
            ),
          ).animate()
           .scale(duration: 400.ms, curve: Curves.easeOutBack)
           .fadeIn(duration: 300.ms),
        );
      },
    ).then((_) {
      _isShowing = false;
    });
  }
}
