import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class OverlayService {
  OverlayService._();

  static final OverlayService instance = OverlayService._();

  static const MethodChannel _channel = MethodChannel(
    'com.nzcu_driver/background_service',
  );

  StreamSubscription<dynamic>? _overlayListenerSub;

  // ---------------------------------------------------------------------------
  // PERMISSION
  // ---------------------------------------------------------------------------

  Future<bool> hasPermission() async {
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  Future<void> requestPermission() async {
    await FlutterOverlayWindow.requestPermission();
  }

  // ---------------------------------------------------------------------------
  // SHOW / HIDE
  // ---------------------------------------------------------------------------

  Future<void> showOverlay({int? width, int? height}) async {
    final alreadyActive = await FlutterOverlayWindow.isActive();
    if (alreadyActive) return;

    final hasP = await hasPermission();
    if (!hasP) {
      AppLogger.d('[OverlayService] No overlay permission - skipping');
      return;
    }

    // Use a safe fallback size because some OEM lifecycle transitions
    // (notably OPPO/realme on lock/unlock) may briefly report zero Flutter views.
    int dynamicSize = 150;
    try {
      final views = ui.PlatformDispatcher.instance.views;
      if (views.isNotEmpty) {
        final flutterView = views.first;
        final logicalWidth =
            flutterView.physicalSize.width / flutterView.devicePixelRatio;
        dynamicSize = (logicalWidth * 0.35).toInt();
      } else {
        AppLogger.d('[OverlayService] No Flutter views available; using fallback size');
      }
    } catch (e) {
      AppLogger.d('[OverlayService] Failed to compute overlay size: $e');
    }

    try {
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        height: height ?? dynamicSize,
        width: width ?? dynamicSize,
        alignment: OverlayAlignment.centerRight,
        visibility: NotificationVisibility.visibilitySecret,
        flag: OverlayFlag.defaultFlag,
      );
      AppLogger.d('[OverlayService] Overlay shown');
    } catch (e) {
      AppLogger.d('[OverlayService] Failed to show overlay: $e');
    }
  }

  Future<void> hideOverlay() async {
    try {
      final isActive = await FlutterOverlayWindow.isActive();
      if (!isActive) return;

      await FlutterOverlayWindow.closeOverlay();
      AppLogger.d('[OverlayService] Overlay hidden');
    } catch (e) {
      AppLogger.d('[OverlayService] Failed to hide overlay: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // OVERLAY LISTENER
  // ---------------------------------------------------------------------------

  void initOverlayListener(Function(String) onTap) {
    _overlayListenerSub?.cancel();
    _overlayListenerSub = FlutterOverlayWindow.overlayListener.listen((
      message,
    ) {
      AppLogger.d('[OverlayService] Received overlay message: $message');
      if (message == 'bring_to_front') {
        _bringAppToForeground();
        onTap(message);
      }
    });
  }

  void dispose() {
    _overlayListenerSub?.cancel();
  }

  // ---------------------------------------------------------------------------
  // BRING APP TO FOREGROUND
  // ---------------------------------------------------------------------------

  Future<void> _bringAppToForeground() async {
    try {
      await _channel.invokeMethod('bringToFront');
      AppLogger.d('[OverlayService] App brought to foreground');
    } catch (e) {
      AppLogger.d('[OverlayService] Failed to bring app to front: $e');
    }
  }
}
