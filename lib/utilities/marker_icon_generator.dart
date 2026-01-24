import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility class to create custom markers for Google Maps
class MarkerIconGenerator {
  /// Create a bike/motorcycle marker icon
  static Future<BitmapDescriptor> getBikeMarkerIcon({
    double size = 100,
    Color color = const Color.fromARGB(255, 2, 120, 166),
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Draw background circle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 48, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(const Offset(50, 50), 48, borderPaint);

    // Draw simple bike icon (Unicode character)
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🏍',
        style: TextStyle(fontSize: 50),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(25, 25));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create a simple driver location marker
  static Future<BitmapDescriptor> getDriverMarkerIcon({
    double size = 100,
    Color color = const Color.fromARGB(255, 2, 120, 166),
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Draw outer circle (shadow effect)
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 50, shadowPaint);

    // Draw main circle
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 45, paint);

    // Draw white center dot
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 15, centerPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(const Offset(50, 50), 45, borderPaint);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create pickup location marker
  static Future<BitmapDescriptor> getPickupMarkerIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Green circle for pickup
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 45, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(const Offset(50, 50), 45, borderPaint);

    // Draw checkmark
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '✓',
        style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 20));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create dropoff location marker
  static Future<BitmapDescriptor> getDropoffMarkerIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Red circle for dropoff
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 45, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(const Offset(50, 50), 45, borderPaint);

    // Draw X mark
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '✕',
        style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(20, 20));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
