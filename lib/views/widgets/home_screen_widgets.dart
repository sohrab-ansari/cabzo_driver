import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable Custom Widgets for Home Screen
class HomeScreenWidgets {
  /// Top Navigation Action Button
  static Widget topAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
    double height = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          _buildIcon(icon, height),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Icon (SVG or Image Asset)
  static Widget _buildIcon(String icon, double height) {
    if (icon.endsWith('.svg')) {
      return SvgPicture.asset(icon, height: height);
    }
    return Image.asset(icon, height: height);
  }

  /// Elevated Box Container
  static Widget elevatedBox({
    required Widget child,
    double? height,
    double? width,
    Color? shadowColor,
    double borderRadius = 12,
    EdgeInsets padding = const EdgeInsets.all(12),
  }) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black12,
            blurRadius: 1,
            offset: const Offset(0, 0.2),
          )
        ],
      ),
      child: child,
    );
  }

  /// Primary Action Button
  static Widget primaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    double height = 48,
    double borderRadius = 10,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  /// Secondary Button
  static Widget secondaryButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double height = 48,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Status Card
  static Widget statusCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Color iconColor = Colors.blue,
  }) {
    return elevatedBox(
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Loading Dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Toast Notification (simple implementation)
  static void showToast(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Info Section Header
  static Widget sectionHeader({
    required String title,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onTap != null)
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Divider with padding
  static Widget paddedDivider({
    double vertical = 16,
    double horizontal = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: const Divider(height: 1, color: Colors.grey),
    );
  }

  /// Center Message
  static Widget centerMessage({
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
