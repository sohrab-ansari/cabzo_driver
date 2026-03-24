import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nzcu_driver/utilities/widgets/custom_font.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';
import 'package:nzcu_driver/services/overlay_service.dart';

/// Model representing a single permission item in the gate checklist.
class _PermissionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGranted;

  _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isGranted,
  });
}

/// A comprehensive permission gate that blocks drivers from going online
/// until ALL required permissions are granted.
///
/// Checks:
/// 1. Location (Always / Background)
/// 2. Battery Optimization Exemption (Doze whitelist)
/// 3. Notifications
/// 4. Overlay / Draw Over Apps
///
/// Returns `true` if ALL permissions are granted, `false` otherwise.
class PermissionGatePopup {
  static bool _isShowing = false;

  /// Checks all required permissions. Returns `true` if everything is granted.
  /// If any permission is missing, shows a premium popup and returns `false`.
  static Future<bool> checkAndShow(BuildContext context) async {
    if (!Platform.isAndroid) return true; // Only enforce on Android

    // Check all permissions in parallel
    final results = await Future.wait([
      Permission.locationAlways.isGranted,
      Permission.ignoreBatteryOptimizations.isGranted,
      Permission.notification.isGranted,
      OverlayService.instance.hasPermission(),
    ]);

    final isLocationAlways = results[0];
    final isBatteryExempt = results[1];
    final isNotification = results[2];
    final isOverlay = results[3];

    final allGranted =
        isLocationAlways && isBatteryExempt && isNotification && isOverlay;

    if (allGranted) return true;

    // Build the checklist items
    final items = <_PermissionItem>[
      _PermissionItem(
        icon: Icons.location_on_rounded,
        title: 'Location (Always)',
        subtitle: 'Required for continuous tracking',
        isGranted: isLocationAlways,
      ),
      _PermissionItem(
        icon: Icons.battery_alert_rounded,
        title: 'Battery Unrestricted',
        subtitle: 'Set to "Unrestricted" & enable "Allow background activity"',
        isGranted: isBatteryExempt,
      ),
      _PermissionItem(
        icon: Icons.notifications_active_rounded,
        title: 'Notifications',
        subtitle: 'Required for ride alerts',
        isGranted: isNotification,
      ),
      _PermissionItem(
        icon: Icons.layers_rounded,
        title: 'Display Over Other Apps',
        subtitle: 'Required for floating status bubble',
        isGranted: isOverlay,
      ),
    ];

    // Show the popup
    if (_isShowing) return false;
    _show(context, items);
    return false;
  }

  static void _show(BuildContext context, List<_PermissionItem> items) {
    if (_isShowing) return;
    _isShowing = true;

    final double w = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: w * 0.9,
            padding: EdgeInsets.symmetric(
              vertical: w * 0.06,
              horizontal: w * 0.05,
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
                // Icon
                Container(
                  padding: EdgeInsets.all(w * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF26061).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    color: const Color(0xFFF26061),
                    size: w * 0.10,
                  ).animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  ).scale(
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
                ),
                SizedBox(height: w * 0.04),

                // Title
                AppFonts.textPoppins(
                  ctx,
                  "Permissions Required",
                  w * 0.048,
                  FontWeight.w700,
                  Colors.black87,
                  TextAlign.center,
                  TextOverflow.visible,
                ),
                SizedBox(height: w * 0.02),

                // Subtitle
                AppFonts.textPoppins(
                  ctx,
                  "Please enable all permissions to go online and receive rides.",
                  w * 0.032,
                  FontWeight.w400,
                  Colors.grey,
                  TextAlign.center,
                  TextOverflow.visible,
                  maxLines: 2,
                ),
                SizedBox(height: w * 0.05),

                // Checklist
                ...items.map((item) => _buildPermissionRow(ctx, w, item)),

                SizedBox(height: w * 0.05),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87,
                          padding:
                              EdgeInsets.symmetric(vertical: w * 0.035),
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
                          "Cancel",
                          w * 0.038,
                          FontWeight.w600,
                          Colors.black87,
                          TextAlign.center,
                          TextOverflow.visible,
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF26061),
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: w * 0.035),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          _openAppSettings();
                        },
                        child: AppFonts.textPoppins(
                          ctx,
                          "Open Settings",
                          w * 0.038,
                          FontWeight.w600,
                          Colors.white,
                          TextAlign.center,
                          TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
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

  static Widget _buildPermissionRow(
      BuildContext context, double w, _PermissionItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.015),
      child: Row(
        children: [
          // Status icon
          Container(
            width: w * 0.09,
            height: w * 0.09,
            decoration: BoxDecoration(
              color: item.isGranted
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.isGranted
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: item.isGranted ? Colors.green : Colors.red,
              size: w * 0.055,
            ),
          ),
          SizedBox(width: w * 0.03),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFonts.textPoppins(
                  context,
                  item.title,
                  w * 0.035,
                  FontWeight.w600,
                  item.isGranted ? Colors.black87 : Colors.red.shade700,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                ),
                AppFonts.textPoppins(
                  context,
                  item.subtitle,
                  w * 0.028,
                  FontWeight.w400,
                  Colors.grey,
                  TextAlign.left,
                  TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the app's own settings page where the user can manage
  /// battery, notifications, location, and overlay permissions.
  static Future<void> _openAppSettings() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final String packageName = packageInfo.packageName;
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:$packageName',
      );
      await intent.launch();
    } catch (e) {
      AppLogger.d("Error opening app settings: $e");
      // Fallback to generic app settings
      openAppSettings();
    }
  }
}
