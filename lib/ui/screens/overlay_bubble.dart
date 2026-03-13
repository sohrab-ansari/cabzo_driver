import 'dart:convert';
import 'dart:typed_data';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:nzcu_driver/utilities/widgets/app_logger.dart';

class OverlayBubble extends StatefulWidget {
  const OverlayBubble({super.key});

  @override
  State<OverlayBubble> createState() => _OverlayBubbleState();
}

class _OverlayBubbleState extends State<OverlayBubble> {
  Uint8List? _appIcon;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      if (event == 'close_overlay') {
        FlutterOverlayWindow.closeOverlay();
      } else if (event is String && event.startsWith('icon:')) {
        final base64Str = event.substring(5);
        if (mounted) {
          setState(() {
            _appIcon = base64Decode(base64Str);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: GestureDetector(
        onTap: () async {
          AppLogger.d('🔥 [OVERLAY_BUBBLE] Bubble Tapped!');
          final intent = AndroidIntent(
            action: 'android.intent.action.MAIN',
            category: 'android.intent.category.LAUNCHER',
            package: 'com.nzcu_driver',
            componentName: 'com.nzcu_driver.MainActivity',
            flags: <int>[
              Flag.FLAG_ACTIVITY_NEW_TASK,
              Flag.FLAG_ACTIVITY_REORDER_TO_FRONT,
              Flag.FLAG_ACTIVITY_SINGLE_TOP,
            ],
          );
          AppLogger.d('🔥 [OVERLAY_BUBBLE] Launching AndroidIntent natively...');
          await intent.launch();
          await Future.delayed(const Duration(milliseconds: 300));
          await FlutterOverlayWindow.closeOverlay();
        },
        child: Container(
          padding: EdgeInsets.all(20),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/overlay_icon.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
