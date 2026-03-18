import 'package:flutter/material.dart';
import 'package:nzcu_driver/services/location_service.dart';
import 'package:nzcu_driver/utilities/colors/colors.dart';
import 'package:permission_handler/permission_handler.dart';
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

  // Notification permission state
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  bool _notificationChecked = false;

  // Track how many times we've already shown the in-app request dialog.
  // Android stops showing the system dialog after 2 total denials (splash used 1),
  // so after 1 failed attempt here we fall back to opening settings.
  int _locationRequestAttempts = 0;
  int _notificationRequestAttempts = 0;

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
        _checkAllStatus();
      }
    }
  }

  void _startMonitoring() {
    _locationService.startMonitoring(() {
      if (mounted) {
        _updatePermissionScreen();
      }
    });

    _checkAllStatus();
  }

  Future<void> _checkAllStatus() async {
    await _locationService.checkLocationStatus();
    await _checkNotificationStatus();
    if (!mounted) return;
    _updatePermissionScreen();
  }

  Future<void> _checkNotificationStatus() async {
    _notificationStatus = await Permission.notification.status;
    _notificationChecked = true;
  }

  void _updatePermissionScreen() {
    if (!mounted) return;
    setState(() {
      _showPermissionScreen =
          !_locationService.allGood ||
          (_notificationChecked && !_notificationStatus.isGranted);
    });

    if (!_showPermissionScreen) {
      _permissionCheckTimer?.cancel();
    }
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
      await _checkNotificationStatus();

      if (_locationService.allGood && _notificationStatus.isGranted) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _showPermissionScreen = false;
          });
        }
      }
    });
  }

  /// Returns true if we should skip the in-app dialog and go straight to settings.
  /// Android silently refuses requestPermission() after 2 denials total;
  /// since splash already used 1, we only get 1 re-request here.
  bool _shouldGoToSettingsForLocation() =>
      _locationService.locationPermissionPermanentlyDenied ||
      _locationRequestAttempts >= 1;

  bool _shouldGoToSettingsForNotification() =>
      _notificationStatus.isPermanentlyDenied ||
      _notificationRequestAttempts >= 1;

  /// Handles the action button press.
  Future<void> _handleEnableButton() async {
    // --- Location ---
    if (!_locationService.locationServiceEnabled) {
      _isReturningFromSettings = true;
      await _locationService.openLocationSettings();
      return;
    }

    if (!_locationService.locationPermissionGranted) {
      if (_shouldGoToSettingsForLocation()) {
        _isReturningFromSettings = true;
        await _locationService.openAppPermissionSettings();
      } else {
        _locationRequestAttempts++;
        await _locationService.requestLocationPermission();
        if (mounted) {
          setState(() {}); // refresh button text based on new attempt count
          _updatePermissionScreen();
        }
      }
      return;
    }

    // --- Notification ---
    if (_notificationChecked && !_notificationStatus.isGranted) {
      if (_shouldGoToSettingsForNotification()) {
        _isReturningFromSettings = true;
        await openAppSettings();
      } else {
        _notificationRequestAttempts++;
        _notificationStatus = await Permission.notification.request();
        if (mounted) {
          setState(() {}); // refresh button text based on new attempt count
          _updatePermissionScreen();
        }
      }
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

  // ─── Status helpers ───────────────────────────────────────────────────────

  bool get _isNotificationIssue =>
      _notificationChecked && !_notificationStatus.isGranted;

  IconData _getIconForStatus() {
    if (!_locationService.locationServiceEnabled) return Icons.location_off;
    if (!_locationService.locationPermissionGranted) {
      return Icons.location_disabled;
    }
    if (_isNotificationIssue) return Icons.notifications_off;
    return Icons.location_on;
  }

  String _getTitleForStatus() {
    if (!_locationService.locationServiceEnabled) return "GPS is Off";
    if (!_locationService.locationPermissionGranted) {
      return "Location Required";
    }
    if (_isNotificationIssue) return "Notifications Required";
    return "Enable Location";
  }

  String _getButtonText() {
    if (!_locationService.locationServiceEnabled) return "Turn On GPS";
    if (!_locationService.locationPermissionGranted) {
      return _shouldGoToSettingsForLocation()
          ? "Open Settings"
          : "Allow Location";
    }
    if (_isNotificationIssue) {
      return _shouldGoToSettingsForNotification()
          ? "Open Settings"
          : "Allow Notifications";
    }
    return "Enable";
  }

  String _buildPermissionMessage() {
    if (!_locationService.locationServiceEnabled &&
        !_locationService.locationPermissionGranted) {
      return "GPS is turned off and location permission is not granted.\n\nTo continue using the app, you need to:\n\n1. Turn on GPS (Location Services)\n2. Grant location permission";
    } else if (!_locationService.locationServiceEnabled) {
      return "Please turn on GPS to continue using the app for tracking and navigation.";
    } else if (!_locationService.locationPermissionGranted) {
      return _shouldGoToSettingsForLocation()
          ? "Location permission was denied.\n\nPlease open Settings and grant location access to continue."
          : "Location permission is required to use the app.\n\nTap below to allow location access.";
    } else if (_isNotificationIssue) {
      return _shouldGoToSettingsForNotification()
          ? "Notification permission was denied.\n\nPlease open Settings and enable notifications to continue."
          : "Notification permission is required for ride alerts.\n\nTap below to allow notifications.";
    }
    return "";
  }

  String _getStatusMessage() {
    if (!_locationService.locationServiceEnabled) {
      return "Waiting for GPS to be turned on...";
    } else if (!_locationService.locationPermissionGranted) {
      return _shouldGoToSettingsForLocation()
          ? "Please grant permission from app settings."
          : "Tap the button to allow location access.";
    } else if (_isNotificationIssue) {
      return _shouldGoToSettingsForNotification()
          ? "Please enable notifications from app settings."
          : "Tap the button to allow notifications.";
    }
    return "";
  }
}
