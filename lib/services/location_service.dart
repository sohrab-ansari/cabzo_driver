import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' hide ServiceStatus;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  bool _locationServiceEnabled = false;
  bool _locationPermissionGranted = false;
  bool _locationPermissionPermanentlyDenied = false;
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  Function? _onStatusChanged;

  bool get locationServiceEnabled => _locationServiceEnabled;
  bool get locationPermissionGranted => _locationPermissionGranted;
  bool get locationPermissionPermanentlyDenied =>
      _locationPermissionPermanentlyDenied;
  bool get allGood => _locationServiceEnabled && _locationPermissionGranted;

  Future<void> initialize() async {
    await checkLocationStatus();

    // Listen for service status changes (GPS on/off)
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      ServiceStatus status,
    ) {
      _locationServiceEnabled = (status == ServiceStatus.enabled);
      _onStatusChanged?.call();
    });
  }

  Future<void> checkLocationStatus() async {
    _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    LocationPermission permission = await Geolocator.checkPermission();
    _locationPermissionGranted =
        (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse);
    _locationPermissionPermanentlyDenied =
        permission == LocationPermission.deniedForever;

    _onStatusChanged?.call();
  }

  /// Requests location permission directly (shows system dialog).
  /// Returns true if granted.
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    _locationPermissionGranted =
        (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse);
    _locationPermissionPermanentlyDenied =
        permission == LocationPermission.deniedForever;
    _onStatusChanged?.call();
    return _locationPermissionGranted;
  }

  void startMonitoring(Function onStatusChanged) {
    _onStatusChanged = onStatusChanged;
    checkLocationStatus();
  }

  void stopMonitoring() {
    _onStatusChanged = null;
    _serviceStatusSubscription?.cancel();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppPermissionSettings() async {
    await openAppSettings();
  }
}
