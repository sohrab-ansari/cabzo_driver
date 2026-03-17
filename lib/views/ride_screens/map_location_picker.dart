import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nzcu_driver/controllers/profile_controllers/get_city_by_location_controller.dart';
import 'package:nzcu_driver/modals/home_modals/place_prediction.dart';
import 'package:nzcu_driver/services/apiservices/places_api_service.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';

/// Full-screen map-based location picker (Uber / Rapido style).
///
/// The map moves freely while the pin stays fixed at the centre.
/// When the camera stops moving [onCameraIdle] reverse-geocodes the centre
/// coordinate. The user taps "Confirm Location" to pop and return a
/// [PlaceDetails] to the caller.
class MapLocationPicker extends StatefulWidget {
  final bool isPickup;

  /// Pre-populate the map at a known coordinate (e.g. already selected before).
  final double? initialLat;
  final double? initialLng;

  const MapLocationPicker({
    super.key,
    required this.isPickup,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  // --- Map ---
  GoogleMapController? _mapController;
  LatLng _pickedLatLng = const LatLng(20.5937, 78.9629); // India centre fallback

  // --- Address ---
  String _address = 'Move the map to your location…';
  bool _isReverseGeocoding = false;
  Timer? _geocodeDebounce;

  // --- Action button ---
  bool _isConfirming = false;

  // Colour shortcuts
  Color get _accentColor =>
      widget.isPickup ? AppColors.green : const Color(0xFFE53935);

  @override
  void initState() {
    super.initState();
    _resolveInitialPosition();
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // ─── Resolve starting camera position ───────────────────────────────────────

  Future<void> _resolveInitialPosition() async {
    // If caller knows the position already, use it
    if (widget.initialLat != null && widget.initialLng != null) {
      setState(() {
        _pickedLatLng = LatLng(widget.initialLat!, widget.initialLng!);
      });
      _reverseGeocode(_pickedLatLng);
      return;
    }

    // Otherwise try GPS
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      
      // Fetch city polygon
      Get.find<GetCityByLocationController>().getCityByLocation(
          lat: pos.latitude.toString(),
          lng: pos.longitude.toString());

      final loc = LatLng(pos.latitude, pos.longitude);
      if (mounted) setState(() => _pickedLatLng = loc);

      // Animate camera once map is ready
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(loc, 16));
      }
      _reverseGeocode(loc);
    } catch (_) {}
  }

  // ─── Reverse geocode with debounce ──────────────────────────────────────────

  void _reverseGeocode(LatLng position) {
    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      setState(() => _isReverseGeocoding = true);

      final addr = await PlacesApiService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        setState(() {
          _address = addr ??
              '${position.latitude.toStringAsFixed(6)}, '
                  '${position.longitude.toStringAsFixed(6)}';
          _isReverseGeocoding = false;
        });
      }
    });
  }

  // ─── Confirm & return ───────────────────────────────────────────────────────

  Future<void> _onConfirm() async {
    if (_isReverseGeocoding || _isConfirming) return;
    setState(() => _isConfirming = true);

    // If address is still the placeholder, do one final geocode
    String finalAddress = _address;
    if (finalAddress == 'Move the map to your location…') {
      final addr = await PlacesApiService.getAddressFromCoordinates(
        _pickedLatLng.latitude,
        _pickedLatLng.longitude,
      );
      finalAddress = addr ??
          '${_pickedLatLng.latitude.toStringAsFixed(6)}, '
              '${_pickedLatLng.longitude.toStringAsFixed(6)}';
    }

    final result = PlaceDetails(
      address: finalAddress,
      lat: _pickedLatLng.latitude,
      lng: _pickedLatLng.longitude,
    );

    if (mounted) Get.back(result: result);
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(w),
      body: Stack(
        children: [
          // 1. Full-screen map
          Obx(() => GoogleMap(
            polygons: Get.find<GetCityByLocationController>().cityPolygons.toSet(),
            initialCameraPosition: CameraPosition(
              target: _pickedLatLng,
              zoom: 16,
            ),
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              // Animate to GPS position if it arrived before map was ready
              if (widget.initialLat == null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(_pickedLatLng, 16),
                );
              }
            },
            onCameraMove: (pos) {
              _pickedLatLng = pos.target;
            },
            onCameraIdle: () {
              _reverseGeocode(_pickedLatLng);
            },
          )),

          // 2. Fixed centre pin (moves visually with map)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slight upward shift so pin tip sits at exact centre
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Image.asset(
                    widget.isPickup
                        ? 'assets/icons/pickup_pin.png'
                        : 'assets/icons/drop_pin.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // 3. Address card at the bottom (above confirm button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomCard(
              w: w,
              h: h,
              accentColor: _accentColor,
              isPickup: widget.isPickup,
              address: _address,
              isReverseGeocoding: _isReverseGeocoding,
              isConfirming: _isConfirming,
              onConfirm: _onConfirm,
            ),
          ),

          // 4. My-location FAB (right side, just above bottom card)
          Positioned(
            bottom: h * 0.28,
            right: w * 0.04,
            child: _LocationFab(
              onTap: () async {
                try {
                  final pos = await Geolocator.getCurrentPosition(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.high,
                      timeLimit: Duration(seconds: 6),
                    ),
                  );
                  final loc = LatLng(pos.latitude, pos.longitude);
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(loc, 16),
                  );
                } catch (_) {}
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(double w) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: Get.back,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
        ),
      ),
      title: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isPickup ? Icons.radio_button_checked : Icons.location_on,
              color: _accentColor,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              widget.isPickup ? 'Set Pickup' : 'Set Drop',
              style: GoogleFonts.poppins(
                fontSize: w * 0.038,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _BottomCard extends StatelessWidget {
  final double w;
  final double h;
  final Color accentColor;
  final bool isPickup;
  final String address;
  final bool isReverseGeocoding;
  final bool isConfirming;
  final VoidCallback onConfirm;

  const _BottomCard({
    required this.w,
    required this.h,
    required this.accentColor,
    required this.isPickup,
    required this.address,
    required this.isReverseGeocoding,
    required this.isConfirming,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.05, h * 0.025, w * 0.05, h * 0.04),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: w * 0.1,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: h * 0.018),

          // Label
          Text(
            isPickup ? 'Pickup Location' : 'Drop Location',
            style: GoogleFonts.poppins(
              fontSize: w * 0.032,
              fontWeight: FontWeight.w500,
              color: AppColors.mediumGray,
            ),
          ),
          SizedBox(height: h * 0.008),

          // Address row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  isPickup ? Icons.radio_button_checked : Icons.location_on,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: isReverseGeocoding
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: LinearProgressIndicator(
                          color: accentColor,
                          backgroundColor:
                              accentColor.withValues(alpha: 0.15),
                          minHeight: 3,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    : Text(
                        address,
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),

          SizedBox(height: h * 0.025),

          // Confirm button
          SizedBox(
            width: double.infinity,
            height: w * 0.13,
            child: ElevatedButton(
              onPressed:
                  (isReverseGeocoding || isConfirming) ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryblue,
                disabledBackgroundColor:
                    AppColors.primaryblue.withValues(alpha: 0.45),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: (isConfirming || isReverseGeocoding)
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Confirm Location',
                      style: GoogleFonts.poppins(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationFab extends StatelessWidget {
  final VoidCallback onTap;
  const _LocationFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.my_location,
          color: AppColors.primaryblue,
          size: 22,
        ),
      ),
    );
  }
}
