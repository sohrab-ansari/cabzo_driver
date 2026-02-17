import 'dart:convert';

// Helper methods for safe parsing
double _safeParseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}

int _safeParseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    return parsed ?? 0;
  }
  return 0;
}

class ChatResponse {
  bool? success;
  Data? data;

  ChatResponse({this.success, this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    try {
      return ChatResponse(
        success: json['success'] as bool?,
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
    } catch (e) {
      print("Error parsing ChatResponse: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  UnreadCount? unreadCount;
  String? id;
  Ride? rideId;
  User? riderId;
  User? driverId;
  String? status;
  List<dynamic>? readStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.unreadCount,
    this.id,
    this.rideId,
    this.riderId,
    this.driverId,
    this.status,
    this.readStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      return Data(
        unreadCount: json['unreadCount'] != null
            ? UnreadCount.fromJson(json['unreadCount'])
            : null,
        id: json['_id']?.toString(),
        rideId: json['rideId'] != null ? Ride.fromJson(json['rideId']) : null,
        riderId: json['riderId'] != null
            ? User.fromJson(json['riderId'])
            : null,
        driverId: json['driverId'] != null
            ? User.fromJson(json['driverId'])
            : null,
        status: json['status']?.toString(),
        readStatus: json['readStatus'] != null
            ? List<dynamic>.from(json['readStatus'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
            : null,
        v: _safeParseInt(json['__v']),
      );
    } catch (e) {
      print("Error parsing Data: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'unreadCount': unreadCount?.toJson(),
      '_id': id,
      'rideId': rideId?.toJson(),
      'riderId': riderId?.toJson(),
      'driverId': driverId?.toJson(),
      'status': status,
      'readStatus': readStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class UnreadCount {
  int? rider;
  int? driver;

  UnreadCount({this.rider, this.driver});

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(
      rider: _safeParseInt(json['rider']),
      driver: _safeParseInt(json['driver']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'rider': rider, 'driver': driver};
  }
}

class Ride {
  Location? startLocation;
  Location? endLocation;
  RentalBillingDetails? rentalBillingDetails;
  String? id;
  String? userId;
  String? vehicleType;
  bool? otpVerified;
  String? orderStatus;
  double? distance;
  int? duration;
  int? totalFare;
  String? paymentMethod;
  String? orderType;
  dynamic rentalPackageId;
  dynamic rentalStartTime;
  dynamic rentalEndTime;
  dynamic bookedDurationHours;
  dynamic actualDurationMinutes;
  dynamic totalDistanceKm;
  dynamic rentalMetrics;
  List<dynamic>? rejectedByDrivers;
  List<String>? notifiedDrivers;
  dynamic promoCodeId;
  dynamic cityId;
  bool? isScheduled;
  dynamic scheduledStartTime;
  dynamic scheduledSearchStartTime;
  List<dynamic>? cancellationHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? driverId;
  String? rideOtp;

  Ride({
    this.startLocation,
    this.endLocation,
    this.rentalBillingDetails,
    this.id,
    this.userId,
    this.vehicleType,
    this.otpVerified,
    this.orderStatus,
    this.distance,
    this.duration,
    this.totalFare,
    this.paymentMethod,
    this.orderType,
    this.rentalPackageId,
    this.rentalStartTime,
    this.rentalEndTime,
    this.bookedDurationHours,
    this.actualDurationMinutes,
    this.totalDistanceKm,
    this.rentalMetrics,
    this.rejectedByDrivers,
    this.notifiedDrivers,
    this.promoCodeId,
    this.cityId,
    this.isScheduled,
    this.scheduledStartTime,
    this.scheduledSearchStartTime,
    this.cancellationHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.driverId,
    this.rideOtp,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    try {
      return Ride(
        startLocation: json['startLocation'] != null
            ? Location.fromJson(json['startLocation'])
            : null,
        endLocation: json['endLocation'] != null
            ? Location.fromJson(json['endLocation'])
            : null,
        rentalBillingDetails: json['rentalBillingDetails'] != null
            ? RentalBillingDetails.fromJson(json['rentalBillingDetails'])
            : null,
        id: json['_id']?.toString(),
        userId: json['userId']?.toString(),
        vehicleType: json['vehicleType']?.toString(),
        otpVerified: json['otpVerified'] as bool?,
        orderStatus: json['orderStatus']?.toString(),
        distance: _safeParseDouble(json['distance']),
        duration: _safeParseInt(json['duration']),
        totalFare: _safeParseInt(json['totalFare']),
        paymentMethod: json['paymentMethod']?.toString(),
        orderType: json['orderType']?.toString(),
        rentalPackageId: json['rentalPackageId'],
        rentalStartTime: json['rentalStartTime'],
        rentalEndTime: json['rentalEndTime'],
        bookedDurationHours: json['bookedDurationHours'],
        actualDurationMinutes: json['actualDurationMinutes'],
        totalDistanceKm: json['totalDistanceKm'],
        rentalMetrics: json['rentalMetrics'],
        rejectedByDrivers: json['rejectedByDrivers'] != null
            ? List<dynamic>.from(json['rejectedByDrivers'])
            : null,
        notifiedDrivers: json['notifiedDrivers'] != null
            ? List<String>.from(
                json['notifiedDrivers'].map((x) => x.toString()),
              )
            : null,
        promoCodeId: json['promoCodeId'],
        cityId: json['cityId'],
        isScheduled: json['isScheduled'] as bool?,
        scheduledStartTime: json['scheduledStartTime'],
        scheduledSearchStartTime: json['scheduledSearchStartTime'],
        cancellationHistory: json['cancellationHistory'] != null
            ? List<dynamic>.from(json['cancellationHistory'])
            : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
            : null,
        v: _safeParseInt(json['__v']),
        driverId: json['driverId']?.toString(),
        rideOtp: json['rideOtp']?.toString(),
      );
    } catch (e) {
      print("Error parsing Ride: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'startLocation': startLocation?.toJson(),
      'endLocation': endLocation?.toJson(),
      'rentalBillingDetails': rentalBillingDetails?.toJson(),
      '_id': id,
      'userId': userId,
      'vehicleType': vehicleType,
      'otpVerified': otpVerified,
      'orderStatus': orderStatus,
      'distance': distance,
      'duration': duration,
      'totalFare': totalFare,
      'paymentMethod': paymentMethod,
      'orderType': orderType,
      'rentalPackageId': rentalPackageId,
      'rentalStartTime': rentalStartTime,
      'rentalEndTime': rentalEndTime,
      'bookedDurationHours': bookedDurationHours,
      'actualDurationMinutes': actualDurationMinutes,
      'totalDistanceKm': totalDistanceKm,
      'rentalMetrics': rentalMetrics,
      'rejectedByDrivers': rejectedByDrivers,
      'notifiedDrivers': notifiedDrivers,
      'promoCodeId': promoCodeId,
      'cityId': cityId,
      'isScheduled': isScheduled,
      'scheduledStartTime': scheduledStartTime,
      'scheduledSearchStartTime': scheduledSearchStartTime,
      'cancellationHistory': cancellationHistory,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'driverId': driverId,
      'rideOtp': rideOtp,
    };
  }
}

class Location {
  String? address;
  String? type;
  List<double>? coordinates;

  Location({this.address, this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    try {
      List<double>? coordinates;

      if (json['coordinates'] != null && json['coordinates'] is List) {
        coordinates = [];
        for (var coord in json['coordinates']) {
          coordinates.add(_safeParseDouble(coord));
        }
      }

      return Location(
        address: json['address']?.toString(),
        type: json['type']?.toString(),
        coordinates: coordinates,
      );
    } catch (e) {
      print("Error parsing Location: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'type': type, 'coordinates': coordinates};
  }
}

class RentalBillingDetails {
  int? basePackageCost;
  int? extraTimeMinutes;
  int? extraTimeCost;
  int? includedKm;
  int? extraDistanceKm;
  int? extraDistanceCost;
  int? totalRentalCost;

  RentalBillingDetails({
    this.basePackageCost,
    this.extraTimeMinutes,
    this.extraTimeCost,
    this.includedKm,
    this.extraDistanceKm,
    this.extraDistanceCost,
    this.totalRentalCost,
  });

  factory RentalBillingDetails.fromJson(Map<String, dynamic> json) {
    return RentalBillingDetails(
      basePackageCost: _safeParseInt(json['basePackageCost']),
      extraTimeMinutes: _safeParseInt(json['extraTimeMinutes']),
      extraTimeCost: _safeParseInt(json['extraTimeCost']),
      includedKm: _safeParseInt(json['includedKm']),
      extraDistanceKm: _safeParseInt(json['extraDistanceKm']),
      extraDistanceCost: _safeParseInt(json['extraDistanceCost']),
      totalRentalCost: _safeParseInt(json['totalRentalCost']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basePackageCost': basePackageCost,
      'extraTimeMinutes': extraTimeMinutes,
      'extraTimeCost': extraTimeCost,
      'includedKm': includedKm,
      'extraDistanceKm': extraDistanceKm,
      'extraDistanceCost': extraDistanceCost,
      'totalRentalCost': totalRentalCost,
    };
  }
}

class User {
  dynamic phoneOtp;
  String? id;
  String? name;
  dynamic phone;
  String? email;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? referralRewardClaimed;
  dynamic referredBy;
  String? gender;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? referralCode;
  int? v;
  // Driver specific fields
  String? imageVerificationStatus;
  bool? startDuty;
  double? rating;
  String? verificationStatus;
  bool? isProfileCompleted;
  String? preference;
  int? totalRating;
  String? dLImage;
  String? pANImage;
  String? aadharImageBack;
  String? aadharImageFront;
  String? image;

  User({
    this.phoneOtp,
    this.id,
    this.name,
    this.phone,
    this.email,
    this.isCancelledAnyOrder,
    this.disable,
    this.referralRewardClaimed,
    this.referredBy,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.v,
    this.imageVerificationStatus,
    this.startDuty,
    this.rating,
    this.verificationStatus,
    this.isProfileCompleted,
    this.preference,
    this.totalRating,
    this.dLImage,
    this.pANImage,
    this.aadharImageBack,
    this.aadharImageFront,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        phoneOtp: json['phoneOtp'],
        id: json['_id']?.toString(),
        name: json['name']?.toString(),
        phone: json['phone'],
        email: json['email']?.toString(),
        isCancelledAnyOrder: json['isCancelledAnyOrder'] as bool?,
        disable: json['disable'] as bool?,
        referralRewardClaimed: json['referralRewardClaimed'] as bool?,
        referredBy: json['referredBy'],
        gender: json['gender']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
            : null,
        referralCode: json['referralCode']?.toString(),
        v: _safeParseInt(json['__v']),
        // Driver specific fields
        imageVerificationStatus: json['imageVerificationStatus']?.toString(),
        startDuty: json['startDuty'] as bool?,
        rating: _safeParseDouble(json['rating']),
        verificationStatus: json['verificationStatus']?.toString(),
        isProfileCompleted: json['isProfileCompleted'] as bool?,
        preference: json['preference']?.toString(),
        totalRating: _safeParseInt(json['totalRating']),
        dLImage: json['DLImage']?.toString(),
        pANImage: json['PANImage']?.toString(),
        aadharImageBack: json['aadharImageBack']?.toString(),
        aadharImageFront: json['aadharImageFront']?.toString(),
        image: json['image']?.toString(),
      );
    } catch (e) {
      print("Error parsing User: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneOtp': phoneOtp,
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'isCancelledAnyOrder': isCancelledAnyOrder,
      'disable': disable,
      'referralRewardClaimed': referralRewardClaimed,
      'referredBy': referredBy,
      'gender': gender,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'referralCode': referralCode,
      '__v': v,
      'imageVerificationStatus': imageVerificationStatus,
      'startDuty': startDuty,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'isProfileCompleted': isProfileCompleted,
      'preference': preference,
      'totalRating': totalRating,
      'DLImage': dLImage,
      'PANImage': pANImage,
      'aadharImageBack': aadharImageBack,
      'aadharImageFront': aadharImageFront,
      'image': image,
    };
  }
}
