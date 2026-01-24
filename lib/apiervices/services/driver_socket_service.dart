
import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class DriverSocketService {
  // Singleton instance
  static final DriverSocketService _instance = DriverSocketService._internal();
  factory DriverSocketService() => _instance;
  DriverSocketService._internal();

  // Socket
  IO.Socket? _socket;
  bool _isConnected = false;
  String? _socketId;
  
  // Driver data
  String? _driverId;
  String? _driverName;
  String? _driverPhone;
  String? _driverImage;
  String? _vehicleType;
  String? _vehicleNumber;
  String? _vehicleImage;
  String? _fleetId;
  
  // Location
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;
  DateTime? _lastLocationUpdate;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;
  
  // Location optimization
  double? _lastSentLatitude;
  double? _lastSentLongitude;
  static const double LOCATION_CHANGE_THRESHOLD = 0.0001; // ~11 meters
  
  // Ride tracking
  Map<String, dynamic>? _currentRide;
  String? _activeRideId;
  DateTime? _rideStartTime;
  bool _isRideInProgress = false;
  bool _isOnDuty = false;
  
  // Configuration
  static const String SOCKET_URL = 'https://corezap.smarttechbros.com';
  static const int LOCATION_UPDATE_INTERVAL = 5000; // 5 seconds (optimized from 3)
  static const int LOCATION_TIMEOUT = 15000; // 15 seconds (reduced from 30)
  static const int MAX_RECONNECT_ATTEMPTS = 5; // Reduced from 10
  static const int CONNECTION_TIMEOUT = 10000; // 10 seconds
  int _reconnectAttempts = 0;
  
  // App state
  bool _isAppReady = false;
  bool _permissionCheckInProgress = false;
  
  // Event listeners
  final Map<String, List<Function(dynamic)>> _listeners = {};
  
  // Debug
  bool _debug = true;

  // ==================== PUBLIC API ====================

  Future<bool> connect() async {
    try {
      if (_socket != null && _isConnected) {
        _log('Socket already connected');
        return true;
      }

      // Get driver ID
      final prefs = await SharedPreferences.getInstance();
      _driverId = prefs.getString('driver_userid');

      if (_driverId == null || _driverId!.isEmpty) {
        _logError('No driver ID found');
        return false;
      }

      // Get token
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        _logError('No authentication token found');
        return false;
      }

      // Get driver data
      await _fetchDriverData();

      // Disconnect existing
      disconnect();

      _log('🔌 Connecting driver socket...');

      // Create socket connection with optimized settings
      _socket = IO.io(
        SOCKET_URL,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .setReconnectionAttempts(MAX_RECONNECT_ATTEMPTS)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(CONNECTION_TIMEOUT) // Faster timeout
            .setAuth({'token': token})
            .setQuery({
              'userRole': 'Driver',
              'platform': 'flutter',
              'driverId': _driverId,
            })
            .build(),
      );

      // Setup event listeners
      _setupEventListeners();

      // Connect
      _socket!.connect();

      // Wait for connection with timeout
      return await _waitForConnection();
    } catch (error) {
      _logError('Socket connection error: $error');
      return false;
    }
  }

  Future<void> disconnect() async {
    // Don't disconnect if ride is in progress
    if (_isRideInProgress && _activeRideId != null) {
      _log('⚠️ Cannot disconnect - RIDE IN PROGRESS (ID: $_activeRideId)! Socket will remain connected.');
      return;
    }

    _stopLocationWatch();
    _stopLocationUpdates();
    
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    
    _isConnected = false;
    _socketId = null;
    _isOnDuty = false;
    _log('🔌 Driver socket disconnected');
  }

  Future<bool> goOnline() async {
    try {
      if (_socket == null || !_isConnected) {
        _log('⚠️ Socket not connected, cannot go online');
        return false;
      }

      // Get location
      try {
        await _getCurrentLocation();
      } catch (error) {
        _log('⚠️ Location fetch failed: $error');
      }

      final payload = {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
        'vehicleType': _vehicleType,
        'vehicleImage': _vehicleImage,
        'fleetId': _fleetId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _log('📡 Emitting user:online:', payload);
      _socket!.emit('user:online', payload);

      // Start location tracking
      _startLocationWatch();
      _startLocationUpdates();

      _isOnDuty = true;
      _log('🟢 Driver is now online and ready for rides');
      
      return true;
    } catch (error) {
      _logError('Error going online: $error');
      _isOnDuty = false;
      return false;
    }
  }

  Future<void> goOffline() async {
    try {
      if (_socket != null && _isConnected) {
        _log('🔴 Going offline');
        
        // Emit offline event to backend
        final payload = {
          'driverId': _driverId,
          'timestamp': DateTime.now().toIso8601String(),
        };
        _socket!.emit('user:offline', payload);
        _log('📡 Emitted user:offline event:', payload);
        
        // Stop location updates immediately
        _stopLocationWatch();
        _stopLocationUpdates();
        _isOnDuty = false;
        
        // Disconnect socket completely (instantly, no delay)
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
        _isConnected = false;
        _socketId = null;
        
        _log('✅ Socket completely disconnected');
        
        _notifyListeners('driver:offline', {
          'message': 'Driver is now offline and socket disconnected',
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    } catch (error) {
      _logError('Error going offline: $error');
    }
  }

  bool acceptRide(Map<String, dynamic> rideData) {
    if (_socket == null || !_isConnected) {
      _logError('Cannot accept ride - socket not connected');
      return false;
    }

    final orderId = rideData['orderId'] ?? 
                   rideData['_id'] ?? 
                   rideData['id'] ?? 
                   rideData['rideId'];
    
    if (orderId == null) {
      _logError('No order ID found in ride data');
      return false;
    }

    // Mark ride as in progress
    _activeRideId = orderId;
    _rideStartTime = DateTime.now();
    _isRideInProgress = true;
    
    _currentRide = {
      'orderId': orderId,
      'status': 'accepting',
      'data': rideData,
    };

    final payload = {
      'orderId': orderId,
      'driverId': _driverId,
      'driverName': _driverName,
      'driverPhone': _driverPhone,
      'driverImage': _driverImage,
      'acceptedAt': DateTime.now().toIso8601String(),
      'location': {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
      },
      'vehicleType': _vehicleType,
      'vehicleNumber': _vehicleNumber,
      'vehicleImage': _vehicleImage,
    };

    _log('✅ Emitting ride:accept with driver data:', payload);
    _socket!.emit('ride:accept', payload);
    
    return true;
  }

  bool declineRide(String rideId, {String reason = ''}) {
    if (_socket == null || !_isConnected) {
      return false;
    }

    final payload = {
      'orderId': rideId,
      'driverId': _driverId,
      'reason': reason,
      'declinedAt': DateTime.now().toIso8601String(),
    };

    _log('❌ Declining ride:', payload);
    _socket!.emit('ride:decline', payload);
    return true;
  }

  bool joinChatRoom(String orderId, {String userRole = 'driver'}) {
    if (_socket == null || !_isConnected) {
      _logError('Cannot join chat - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      'userRole': userRole,
      'userId': _driverId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _log('💬 Joining chat room:', payload);
    _socket!.emit('chat:join', payload);
    return true;
  }

  bool sendChatMessage(
    String orderId, 
    String message, {
    String? receiverId,
    String? chatId,
  }) {
    if (_socket == null || !_isConnected) {
      _logError('Cannot send message - socket not connected');
      return false;
    }

    final payload = {
      'rideId': orderId,
      'orderId': orderId,
      'chatId': chatId,
      'message': message.trim(),
      'senderId': _driverId,
      'senderType': 'Driver',
      'senderRole': 'driver',
      'receiverId': receiverId,
      'receiverRole': 'user',
      'timestamp': DateTime.now().toIso8601String(),
    };

    _log('💬 Sending message:', payload);
    
    // Emit to both known events for compatibility
    _socket!.emit('chat:sendMessage', payload);
    _socket!.emit('sendChatMessage', payload);
    
    return true;
  }

  bool sendTypingIndicator(String orderId, bool isTyping, {String userRole = 'driver'}) {
    if (_socket == null || !_isConnected) {
      return false;
    }

    final payload = {
      'orderId': orderId,
      'userRole': userRole,
      'isTyping': isTyping,
    };

    _socket!.emit('chat:typing', payload);
    return true;
  }

  void completeRide(String rideId) {
    if (_activeRideId == rideId || rideId.isNotEmpty) {
      _log('✅ Ride completed (ID: $rideId)');
      _activeRideId = null;
      _rideStartTime = null;
      _isRideInProgress = false;
      _currentRide = null;
      
      _notifyListeners('ride:completed', {
        'rideId': rideId,
        'message': 'Ride completed successfully',
      });
    }
  }

  void addEventListener(String event, Function(dynamic) callback) {
    if (!_listeners.containsKey(event)) {
      _listeners[event] = [];
    }
    _listeners[event]!.add(callback);
    _log('✅ Added listener for: $event');
  }

  void removeEventListener(String event, Function(dynamic) callback) {
    if (_listeners.containsKey(event)) {
      _listeners[event]!.remove(callback);
      _log('❌ Removed listener for: $event');
    }
  }

  void setAppReady(bool ready) {
    _isAppReady = ready;
    _log(ready ? '✅ App ready for location requests' : '⏳ App not ready');
  }

  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected,
      'socketId': _socketId,
      'driverId': _driverId,
      'isOnDuty': _isOnDuty,
      'currentRide': _currentRide,
      'location': {
        'latitude': _currentLatitude,
        'longitude': _currentLongitude,
      },
      'rideInProgress': _isRideInProgress,
      'activeRideId': _activeRideId,
    };
  }

  Map<String, dynamic> getCurrentCoordinates() {
    return {
      'latitude': _currentLatitude,
      'longitude': _currentLongitude,
    };
  }

  Map<String, dynamic> getRideStatus() {
    return {
      'activeRideId': _activeRideId,
      'isRideInProgress': _isRideInProgress,
      'rideStartTime': _rideStartTime?.millisecondsSinceEpoch,
      'duration': _rideStartTime != null 
          ? DateTime.now().difference(_rideStartTime!).inMilliseconds 
          : 0,
    };
  }

  void debugSocket() {
    print('🔍 === DRIVER SOCKET DEBUG ===');
    print('Connected: $_isConnected');
    print('Socket ID: $_socketId');
    print('Driver ID: $_driverId');
    print('On Duty: $_isOnDuty');
    print('Current Ride: $_currentRide');
    print('Ride In Progress: $_isRideInProgress');
    print('Active Ride ID: $_activeRideId');
    print('Location: ${getCurrentCoordinates()}');
    print('==============================');
  }

  // ==================== PRIVATE METHODS ====================

  void _setupEventListeners() {
    if (_socket == null) return;

    // CONNECTION EVENTS
    _socket!.onConnect((_) {
      _log('✅ Driver socket connected: ${_socket!.id}');
      _isConnected = true;
      _socketId = _socket!.id;
      _reconnectAttempts = 0;
      
      _notifyListeners('socket:connected', {
        'socketId': _socket!.id,
        'message': 'Driver socket connected successfully',
      });
      
      // Auto go online if driver was on duty
      if (_isOnDuty) {
        Timer(const Duration(seconds: 1), () {
          goOnline();
        });
      }
    });

    _socket!.onDisconnect((_) {
      _log('❌ Driver socket disconnected');
      _isConnected = false;
      _stopLocationUpdates();
      _notifyListeners('socket:disconnected', {'reason': 'disconnected'});
    });

    _socket!.onConnectError((data) {
      _logError('Socket connection error: $data');
      _reconnectAttempts++;
      _notifyListeners('socket:error', {'error': data.toString()});
    });

    _socket!.onReconnect((data) {
      _log('🔄 Socket reconnected');
      _reconnectAttempts = 0;
      _notifyListeners('socket:reconnected', {'attemptNumber': _reconnectAttempts});
    });

    // DRIVER STATUS EVENTS
    _socket!.on('driver:online_success', (data) {
      _log('✅ Driver online confirmed:', data);
      _isOnDuty = true;
      _notifyListeners('driver:online:success', data);
    });

    _socket!.on('driver:online_failed', (data) {
      _logError('❌ Driver online failed:', data);
      _isOnDuty = false;
      _notifyListeners('driver:online:failed', data);
    });

    // RIDE REQUEST EVENTS
    _socket!.on('ride:newRide', (data) {
      final rideData = _mapRideData(data);
      _log('🚕 NEW RIDE REQUEST RECEIVED:', rideData);
      _notifyListeners('ride:newRequest', rideData);
    });

    _socket!.on('ride:confirmed', (data) {
      _log('✅ Ride accepted - Backend confirmed:', data);
      
      final orderId = data['orderId'] ?? data['_id'];
      if (orderId == null) return;
      
      // Update current ride state
      _currentRide = {
        'orderId': orderId,
        'status': 'confirmed',
        'rider': data['rider'] ?? data['user'],
        'pickup': data['pickupLocation'] ?? data['startLocation'],
        'dropoff': data['dropoffLocation'] ?? data['endLocation'],
        'fare': data['fare'] ?? data['totalFare'],
        'distance': data['distance'],
        'duration': data['duration'] ?? data['estimatedTime'],
        'otp': data['otp'],
        'completeData': data,
      };
      
      if (_activeRideId == orderId) {
        _log('🚗 Ride confirmation matched active ride');
      } else {
        _log('⚠️ Ride confirmation for different ride, updating active ride');
        _activeRideId = orderId;
        _rideStartTime = DateTime.now();
        _isRideInProgress = true;
      }
      
      _log('🚗 Ride state updated to CONFIRMED');
      _notifyListeners('ride:acceptedConfirmed', _currentRide);
    });

    _socket!.on('ride:status', (data) {
      _log('📊 Ride status update:', data);
      
      final orderId = data['orderId'];
      if (_currentRide != null && _currentRide!['orderId'] == orderId) {
        _currentRide!['status'] = data['status'];
      }
      
      // Mark ride as complete
      final status = data['status'];
      if (status == 'completed' || status == 'finished' || status == 'ended') {
        _log('✅ Ride completion status received: $status');
        completeRide(orderId);
      }
      
      _notifyListeners('ride:status', data);
    });

    _socket!.on('ride:orderCancelled', (data) {
      _log('❌ Ride cancelled:', data);
      completeRide(data['orderId']);
      _currentRide = null;
      _notifyListeners('ride:cancelled', data);
    });

    _socket!.on('ride:location', (data) {
      _log('📍 Rider location during ride:', data);
      _notifyListeners('ride:location', data);
    });

    // CHAT EVENTS
    _socket!.on('chat:join_success', (data) {
      _log('✅ Joined chat room:', data);
      _notifyListeners('chat:joined', data);
    });

    _socket!.on('chat:receiveMessage', (data) {
      _log('💬 New chat message received:', data);
      _notifyListeners('chat:message', data);
    });

    _socket!.on('chat:message', (data) {
      _log('💬 New chat message received:', data);
      _notifyListeners('chat:message', data);
    });

    // Generic event listener for debugging
    _socket!.onAny((event, data) {
      _log('[RECEIVED] $event:', data);
    });
  }

  Map<String, dynamic> _mapRideData(dynamic data) {
    final Map<String, dynamic> rideData = Map<String, dynamic>.from(data);
    
    // Extract pickup coordinates
    Map<String, dynamic>? pickupCoords;
    if (rideData['pickup'] != null) {
      final pickup = Map<String, dynamic>.from(rideData['pickup']);
      if (pickup['latitude'] != null && pickup['longitude'] != null) {
        pickupCoords = {
          'latitude': double.parse(pickup['latitude'].toString()),
          'longitude': double.parse(pickup['longitude'].toString()),
        };
      }
    }
    
    // Extract dropoff coordinates
    Map<String, dynamic>? dropoffCoords;
    if (rideData['destination'] != null) {
      final destination = Map<String, dynamic>.from(rideData['destination']);
      if (destination['latitude'] != null && destination['longitude'] != null) {
        dropoffCoords = {
          'latitude': double.parse(destination['latitude'].toString()),
          'longitude': double.parse(destination['longitude'].toString()),
        };
      }
    }
    
    // Build mapped data
    return {
      ...rideData,
      'orderId': rideData['orderId'] ?? rideData['rideId'] ?? rideData['_id'],
      'pickup': pickupCoords,
      'destination': dropoffCoords,
      'startLocation': {
        'address': rideData['startLocation']?['address'] ?? 'Pickup Location',
        'coordinates': pickupCoords,
      },
      'endLocation': rideData['endLocation'] != null ? {
        'address': rideData['endLocation']?['address'] ?? 'Drop Location',
        'coordinates': dropoffCoords,
      } : null,
      'riderId': rideData['riderId'] ?? rideData['userId']?['_id'] ?? rideData['userId'],
      'riderName': rideData['riderName'] ?? rideData['userId']?['name'] ?? 'Customer',
      'riderNumber': (rideData['riderNumber'] ?? rideData['userId']?['phone'] ?? '').toString(),
      'totalFare': (rideData['totalFare'] ?? rideData['fare']?['total'] ?? rideData['fare'] ?? '0').toString(),
      'distance': (rideData['distance'] ?? '0').toString(),
      'estimatedTime': (rideData['estimatedTime'] ?? '15').toString(),
      'vehicleType': rideData['vehicleType'] ?? 'sedan',
      'otp': rideData['otp'],
    };
  }

  Future<bool> _waitForConnection() async {
    final completer = Completer<bool>();
    
    // Faster timeout for connection (5 seconds instead of 10)
    final timeout = Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        _logError('Connection timeout');
        completer.complete(false);
      }
    });
    
    _socket!.once('connect', (_) {
      timeout.cancel();
      if (!completer.isCompleted) {
        _log('✅ Socket connected!');
        completer.complete(true);
      }
    });
    
    _socket!.once('connect_error', (error) {
      timeout.cancel();
      if (!completer.isCompleted) {
        _logError('Connection error: $error');
        completer.complete(false);
      }
    });
    
    return completer.future;
  }

  // ==================== LOCATION METHODS ====================

  Future<bool> _requestLocationPermission() async {
    if (_permissionCheckInProgress) {
      return false;
    }

    try {
      _permissionCheckInProgress = true;

      // Check if permission is already granted
      var status = await Permission.location.status;
      if (status.isGranted) {
        _permissionCheckInProgress = false;
        return true;
      }

      // Request permission
      status = await Permission.location.request();
      _permissionCheckInProgress = false;
      
      return status.isGranted;
    } catch (error) {
      _permissionCheckInProgress = false;
      _logError('Location permission error: $error');
      return false;
    }
  }

  Future<Position> _getCurrentLocation() async {
    try {
      // If app is not ready, use cached location
      if (!_isAppReady) {
        _log('⏳ App not ready yet, using cached location if available');
        if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
          // Return a simple location object without creating a full Position
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );
        }
        throw Exception('App not ready and no cached location available');
      }

      final hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        _log('⚠️ Location permission denied');
        if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
          _log('ℹ️ Using last known location');
          // Return current location instead of creating a Position manually
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );
        }
        throw Exception('Location permission denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 30),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          _log('⚠️ Location request timeout');
          if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
            // Return a simple location by making a new request
            return Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
            );
          }
          throw TimeoutException('Location timeout');
        },
      ).then((position) {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _lastLocationUpdate = DateTime.now();
        
        _log('📍 Location fetched:', {
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
          'accuracy': position.accuracy,
        });
        
        return position;
      });
    } catch (error) {
      _logError('Failed to get location: $error');
      
      // Fallback to cached location
      if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
        _log('✅ Returning fallback cached location');
        // Return the last known coordinates via a new location request
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
      }
      
      rethrow;
    }
  }

  void _startLocationWatch() {
    if (_positionStreamSubscription != null) {
      _log('ℹ️ Location watch already active');
      return;
    }

    _log('📍 Starting continuous location watch');

    // Get initial location immediately
    _getInitialLocation();

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((position) {
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
      _lastLocationUpdate = DateTime.now();
      _log('📍 Location updated: $_currentLatitude, $_currentLongitude');
      
      // Send location update if on duty
      if (_isOnDuty && _socket != null && _isConnected) {
        _sendLocationUpdate();
      }
    }, onError: (error) {
      _log('⚠️ Location watch error: $error');
    });
  }

  Future<void> _getInitialLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: false,
        timeLimit: const Duration(seconds: 5),
      );
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
      _lastLocationUpdate = DateTime.now();
      _log('✅ Initial location obtained: $_currentLatitude, $_currentLongitude');
    } catch (e) {
      _log('⚠️ Error getting initial location: $e');
      // Try to get last known location as fallback
      try {
        final lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          _currentLatitude = lastPosition.latitude;
          _currentLongitude = lastPosition.longitude;
          _log('📍 Using last known location: $_currentLatitude, $_currentLongitude');
        }
      } catch (e) {
        _log('⚠️ Could not get last known position: $e');
      }
    }
  }

  void _stopLocationWatch() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
      _log('⏹️ Stopped location watch');
    }
  }

  void _sendLocationUpdate() {
    if (_socket == null || !_isConnected) return;

    // Only send if location has changed significantly
    final latDiff = (_currentLatitude - (_lastSentLatitude ?? _currentLatitude)).abs();
    final lngDiff = (_currentLongitude - (_lastSentLongitude ?? _currentLongitude)).abs();
    
    if (latDiff < LOCATION_CHANGE_THRESHOLD && lngDiff < LOCATION_CHANGE_THRESHOLD) {
      return; // Skip sending if location change is too small
    }

    // Update last sent coordinates
    _lastSentLatitude = _currentLatitude;
    _lastSentLongitude = _currentLongitude;

    // 1. General driver location update
    final driverPayload = {
      'latitude': _currentLatitude,
      'longitude': _currentLongitude,
      'role': 'Driver',
      'vehicleType': _vehicleType,
      'vehicleImage': _vehicleImage,
      'fleetId': _fleetId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _socket!.emit('driver:location:update', driverPayload);

    // 2. Specific ride location update (if in a ride)
    final rideId = _activeRideId ?? _currentRide?['orderId'] ?? _currentRide?['rideId'];
    
    if (rideId != null) {
      final ridePayload = {
        'rideId': rideId,
        'location': {
          'latitude': _currentLatitude,
          'longitude': _currentLongitude,
          'lat': _currentLatitude,
          'lng': _currentLongitude,
          'timestamp': DateTime.now().toIso8601String(),
          'accuracy': 0.0,
          'speed': 0.0,
        },
      };

      _socket!.emit('ride:location:update', ridePayload);
    }
  }

  void _startLocationUpdates() {
    _stopLocationUpdates();

    _log('🔄 Starting location update broadcasts every 3 seconds');

    _locationUpdateTimer = Timer.periodic(
      const Duration(milliseconds: LOCATION_UPDATE_INTERVAL),
      (_) {
        if (_socket != null && _isConnected && _isOnDuty) {
          if (_currentLatitude != 0.0 && _currentLongitude != 0.0) {
            _sendLocationUpdate();
          }
        }
      },
    );
  }

  void _stopLocationUpdates() {
    if (_locationUpdateTimer != null) {
      _locationUpdateTimer!.cancel();
      _locationUpdateTimer = null;
      _log('⏹️ Stopped location update broadcasts');
    }
  }

  // ==================== DRIVER DATA ====================

  Future<void> _fetchDriverData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedDriverData = prefs.getString('driverData');
      
      if (storedDriverData != null) {
        final driverData = json.decode(storedDriverData);
        
        // Store complete driver profile data
        _driverName = driverData['name'] ?? driverData['driverName'];
        _driverPhone = driverData['phone'] ?? driverData['phoneNumber'];
        _driverImage = driverData['profileImage'] ?? 
                       driverData['image'] ?? 
                       driverData['driverImage'];
        _vehicleType = driverData['vehicleType'];
        _vehicleNumber = driverData['vehicleNumber'] ?? driverData['vehicleNo'];
        _vehicleImage = driverData['vehicleImage'];
        _fleetId = driverData['fleetId'];
        
        _log('✅ Driver profile loaded:', {
          'name': _driverName,
          'phone': _driverPhone,
          'vehicleType': _vehicleType,
          'vehicleNumber': _vehicleNumber,
        });
      }
    } catch (error) {
      _logError('Error fetching driver data: $error');
    }
  }

  // ==================== HELPER METHODS ====================

  void _notifyListeners(String event, dynamic data) {
    if (_listeners.containsKey(event)) {
      for (final callback in _listeners[event]!) {
        try {
          callback(data);
        } catch (error) {
          _logError('Error in $event listener: $error');
        }
      }
    }
  }

  void _log(String message, [dynamic data]) {
    if (_debug) {
      if (data != null) {
        print('[DRIVER SOCKET] $message ${data.toString()}');
      } else {
        print('[DRIVER SOCKET] $message');
      }
    }
  }

  void _logError(String message, [dynamic data]) {
    if (_debug) {
      if (data != null) {
        print('[DRIVER SOCKET ERROR] $message ${data.toString()}');
      } else {
        print('[DRIVER SOCKET ERROR] $message');
      }
    }
  }
}