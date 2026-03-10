import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

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
      print('[OverlayService] No overlay permission - skipping');
      return;
    }

    // Calculate dynamic size using MediaQuery logic without BuildContext (25% of screen width)
    final flutterView = ui.PlatformDispatcher.instance.views.first;
    final logicalWidth =
        flutterView.physicalSize.width / flutterView.devicePixelRatio;
    final dynamicSize = (logicalWidth * 0.35)
        .toInt(); // 39% of screen width e.g., ~150px on typical phones

    try {
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        height: height ?? dynamicSize,
        width: width ?? dynamicSize,
        alignment: OverlayAlignment.centerRight,
        visibility: NotificationVisibility.visibilitySecret,
        flag: OverlayFlag.defaultFlag,
      );
      print('[OverlayService] Overlay shown');
    } catch (e) {
      print('[OverlayService] Failed to show overlay: $e');
    }
  }

  Future<void> hideOverlay() async {
    try {
      final isActive = await FlutterOverlayWindow.isActive();
      if (!isActive) return;

      await FlutterOverlayWindow.closeOverlay();
      print('[OverlayService] Overlay hidden');
    } catch (e) {
      print('[OverlayService] Failed to hide overlay: $e');
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
      print('[OverlayService] Received overlay message: $message');
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
      print('[OverlayService] App brought to foreground');
    } catch (e) {
      print('[OverlayService] Failed to bring app to front: $e');
    }
  }
}
