import 'package:flutter/material.dart';
import 'package:nzcu_driver/services/location_service.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'dart:async';

class LocationGuard extends StatefulWidget {
  final Widget child;

  const LocationGuard({super.key, required this.child});

  @override
  State<LocationGuard> createState() => _LocationGuardState();
}

class _LocationGuardState extends State<LocationGuard>
    with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  bool _showPermissionScreen = false;
  Timer? _permissionCheckTimer;
  bool _isReturningFromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startMonitoring();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationService.stopMonitoring();
    _permissionCheckTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isReturningFromSettings) {
        _isReturningFromSettings = false;
        _startAggressiveChecking();
      } else {
        _checkLocationStatus();
      }
    }
  }

  void _startMonitoring() {
    _locationService.startMonitoring(() {
      if (mounted) {
        setState(() {
          _showPermissionScreen = !_locationService.allGood;
        });

        if (_locationService.allGood) {
          _permissionCheckTimer?.cancel();
        }
      }
    });

    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    await _locationService.checkLocationStatus();
    if (!mounted) return;

    setState(() {
      _showPermissionScreen = !_locationService.allGood;
    });
  }

  void _startAggressiveChecking() {
    _permissionCheckTimer?.cancel();
    _permissionCheckTimer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      await _locationService.checkLocationStatus();

      if (_locationService.allGood) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _showPermissionScreen = false;
          });
        }
      }
    });
  }

  void _handleEnableButton() {
    _isReturningFromSettings = true;

    if (!_locationService.locationServiceEnabled) {
      _locationService.openLocationSettings();
    } else if (!_locationService.locationPermissionGranted) {
      _locationService.openAppPermissionSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Stack(
      children: [
        widget.child,
        if (_showPermissionScreen)
          Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: h * 0.02),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo3.png',
                              width: w * 0.3,
                            ),
                            SizedBox(height: h * 0.01),
                            Image.asset(
                              'assets/images/logo6.png',
                              width: w * 0.4,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.02),

                      Container(
                        width: w * 0.3,
                        height: w * 0.3,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForStatus(),
                          size: w * 0.15,
                          color: AppColors.primaryblue,
                        ),
                      ),

                      SizedBox(height: h * 0.04),

                      Text(
                        _getTitleForStatus(),
                        style: TextStyle(
                          fontSize: w * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: h * 0.02),

                      Text(
                        _buildPermissionMessage(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.04,
                          color: AppColors.mediumGray,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: h * 0.06),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleEnableButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryblue,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _getButtonText(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.03),

                      Text(
                        _getStatusMessage(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: AppColors.darkGray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _getIconForStatus() {
    if (!_locationService.locationServiceEnabled) {
      return Icons.location_off;
    } else if (!_locationService.locationPermissionGranted) {
      return Icons.location_disabled;
    }
    return Icons.location_on;
  }

  String _getTitleForStatus() {
    if (!_locationService.locationServiceEnabled) {
      return "GPS is Off";
    } else if (!_locationService.locationPermissionGranted) {
      return "Permission Required";
    }
    return "Enable Location";
  }

  String _getButtonText() {
    if (!_locationService.locationServiceEnabled) {
      return "Turn On GPS";
    } else if (!_locationService.locationPermissionGranted) {
      return "Grant Permission";
    }
    return "Enable Location";
  }

  String _buildPermissionMessage() {
    if (!_locationService.locationServiceEnabled &&
        !_locationService.locationPermissionGranted) {
      return "GPS is turned off and location permission is not granted.\n\nTo continue using the app, you need to:\n\n1. Turn on GPS (Location Services)\n2. Grant location permission";
    } else if (!_locationService.locationServiceEnabled) {
      return "Please turn on GPS to continue using the app for tracking and navigation.";
    } else if (!_locationService.locationPermissionGranted) {
      return "Location permission is not granted.\n\nPlease allow location access to continue using the app features.";
    }
    return "";
  }

  String _getStatusMessage() {
    if (!_locationService.locationServiceEnabled &&
        !_locationService.locationPermissionGranted) {
      return "Waiting for GPS to be turned on...";
    } else if (!_locationService.locationServiceEnabled) {
      return "Waiting for GPS to be turned on...";
    } else if (!_locationService.locationPermissionGranted) {
      return "Waiting for permission to be granted...";
    }
    return "";
  }
}
