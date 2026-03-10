import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Complete helper class for showing riders/drivers on Google Maps
class MapHelper {
  /// Create markers for multiple riders/drivers nearby
  ///
  /// Each rider should have:
  /// - riderId: String
  /// - location: { lat: double, lng: double }
  /// - name: String (optional)
  /// - status: String (optional)
  /// - vehicleType: String (optional)
  static Set<Marker> createRiderMarkers({
    required List<Map<String, dynamic>> riders,
    BitmapDescriptor? customIcon,
    Map<String, BitmapDescriptor>? vehicleIcons,
    double distanceKm = 5.0, // Show riders within 5km
  }) {
    final Set<Marker> markers = {};

    for (var rider in riders) {
      try {
        final riderId = rider['riderId'] as String?;
        final location = rider['location'] as Map<String, dynamic>?;

        if (riderId == null || location == null) continue;

        final lat = location['lat'] as double?;
        final lng = location['lng'] as double?;

        if (lat == null || lng == null) continue;

        // Select icon based on vehicle type or use custom icon
        BitmapDescriptor icon =
            customIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);

        final vehicleType = rider['vehicleType'] as String?;
        if (vehicleType != null && vehicleIcons != null) {
          icon = vehicleIcons[vehicleType] ?? icon;
        }

        markers.add(
          Marker(
            markerId: MarkerId('rider_$riderId'),
            position: LatLng(lat, lng),
            icon: icon,
            anchor: const Offset(0.5, 0.5),
            infoWindow: InfoWindow(
              title: rider['name'] ?? 'Riderr',
              snippet:
                  '${rider['status'] ?? 'Available'} • ${vehicleType ?? 'Unknown'}',
            ),
            zIndex: 1, // Below driver marker
          ),
        );
      } catch (e) {
        print('⚠️ MapHelper: Invalid rider data: $e');
        continue;
      }
    }
    return markers;
  }

  /// Load custom icon from assets with proper sizing
  static Future<BitmapDescriptor> loadCustomIcon({
    required String assetPath,
    int width = 80,
    int height = 80,
  }) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
        targetHeight: height,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to ByteData');
      }

      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } catch (e) {
      print('⚠️ MapHelper: Failed to load icon: $e');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
  }

  /// Load multiple vehicle type icons
  static Future<Map<String, BitmapDescriptor>> loadVehicleIcons({
    Map<String, String>? vehicleAssetPaths,
    int iconSize = 70,
  }) async {
    final Map<String, BitmapDescriptor> icons = {};

    // Default vehicle asset paths
    final defaultPaths = {
      'bike': 'assets/images/bike.png',
      'car':
          'assets/images/vehicle1.png', // Changed from car.png to vehicle1.png which exists
      'auto':
          'assets/images/bike.png', // Changed from auto.png to bike.png which exists
    };

    final assetPaths = vehicleAssetPaths ?? defaultPaths;

    for (var entry in assetPaths.entries) {
      try {
        final icon = await loadCustomIcon(
          assetPath: entry.value,
          width: iconSize,
          height: iconSize,
        );
        icons[entry.key] = icon;
      } catch (e) {
        print('⚠️ Failed to load icon for ${entry.key}: $e');
        icons[entry.key] = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
      }
    }

    return icons;
  }

  /// Create a single rider marker
  static Marker createSingleRiderMarker({
    required String riderId,
    required LatLng position,
    required BitmapDescriptor icon,
    String? name,
    String? status,
    String? vehicleType,
  }) {
    return Marker(
      markerId: MarkerId('rider_$riderId'),
      position: position,
      icon: icon,
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: name ?? 'Riderr',
        snippet: '${status ?? 'Available'} • ${vehicleType ?? 'Unknown'}',
      ),
      zIndex: 1,
    );
  }

  /// Calculate distance between two coordinates (in km)
  static double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a =
        0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lng2 - lng1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Filter riders within distance
  static List<Map<String, dynamic>> filterRidersByDistance(
    List<Map<String, dynamic>> riders,
    double driverLat,
    double driverLng,
    double maxDistanceKm,
  ) {
    return riders.where((rider) {
      try {
        final location = rider['location'] as Map<String, dynamic>?;
        if (location == null) return false;

        final lat = location['lat'] as double?;
        final lng = location['lng'] as double?;

        if (lat == null || lng == null) return false;

        final distance = calculateDistance(driverLat, driverLng, lat, lng);
        return distance <= maxDistanceKm;
      } catch (e) {
        return false;
      }
    }).toList();
  }
}
