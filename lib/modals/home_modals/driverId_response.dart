


class DriverIdResponse {
  bool? success;
  String? message;
  Driver? driver;

  DriverIdResponse({
    this.success,
    this.message,
    this.driver,
  });

  factory DriverIdResponse.fromJson(Map<String, dynamic> json) {
    return DriverIdResponse(
      success: json['success'],
      message: json['message'],
      driver: json['driver'] != null
          ? Driver.fromJson(json['driver'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'driver': driver?.toJson(),
    };
  }
}

class Driver {
  dynamic phoneOtp;
  String? id;
  String? phone;
  bool? startDuty;
  double? rating; // Changed from int? to double?
  String? verificationStatus;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? isProfileCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? dlImage;
  String? panImage;
  String? aadharImageBack;
  String? aadharImageFront;
  String? aadharNumber;
  String? email;
  String? name;
  String? panNumber;
  String? image;
  String? imageVerificationStatus;
  String? preference;
  int? platformCommission;
  FleetId? fleetId;
  String? commissionCityId;
  DateTime? lastCommissionCityUpdate;
  String? gender;
  DateTime? dateOfBirth;
  int? totalRating;
  Vehicle? vehicle;
  String? driverId;

  Driver({
    this.phoneOtp,
    this.id,
    this.phone,
    this.startDuty,
    this.rating,
    this.verificationStatus,
    this.isCancelledAnyOrder,
    this.disable,
    this.isProfileCompleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dlImage,
    this.panImage,
    this.aadharImageBack,
    this.aadharImageFront,
    this.aadharNumber,
    this.email,
    this.name,
    this.panNumber,
    this.image,
    this.imageVerificationStatus,
    this.preference,
    this.platformCommission,
    this.fleetId,
    this.commissionCityId,
    this.lastCommissionCityUpdate,
    this.gender,
    this.dateOfBirth,
    this.totalRating,
    this.vehicle,
    this.driverId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    // Handle rating conversion
    double? ratingValue;
    if (json['rating'] != null) {
      if (json['rating'] is int) {
        ratingValue = (json['rating'] as int).toDouble();
      } else if (json['rating'] is double) {
        ratingValue = json['rating'] as double;
      }
    }

    return Driver(
      phoneOtp: json['phoneOtp'],
      id: json['_id'],
      phone: json['phone'],
      startDuty: json['startDuty'],
      rating: ratingValue,
      verificationStatus: json['verificationStatus'],
      isCancelledAnyOrder: json['isCancelledAnyOrder'],
      disable: json['disable'],
      isProfileCompleted: json['isProfileCompleted'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
      dlImage: json['DLImage'],
      panImage: json['PANImage'],
      aadharImageBack: json['aadharImageBack'],
      aadharImageFront: json['aadharImageFront'],
      aadharNumber: json['aadharNumber'],
      email: json['email'],
      name: json['name'],
      panNumber: json['panNumber'],
      image: json['image'],
      imageVerificationStatus: json['imageVerificationStatus'],
      preference: json['preference'],
      platformCommission: json['platformCommission'],
      fleetId: json['fleetId'] != null
          ? FleetId.fromJson(json['fleetId'])
          : null,
      commissionCityId: json['commissionCityId'],
      lastCommissionCityUpdate: json['lastCommissionCityUpdate'] != null
          ? DateTime.parse(json['lastCommissionCityUpdate'])
          : null,
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      totalRating: json['totalRating'],
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,
      driverId: json['driverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneOtp': phoneOtp,
      '_id': id,
      'phone': phone,
      'startDuty': startDuty,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'isCancelledAnyOrder': isCancelledAnyOrder,
      'disable': disable,
      'isProfileCompleted': isProfileCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'DLImage': dlImage,
      'PANImage': panImage,
      'aadharImageBack': aadharImageBack,
      'aadharImageFront': aadharImageFront,
      'aadharNumber': aadharNumber,
      'email': email,
      'name': name,
      'panNumber': panNumber,
      'image': image,
      'imageVerificationStatus': imageVerificationStatus,
      'preference': preference,
      'platformCommission': platformCommission,
      'fleetId': fleetId?.toJson(),
      'commissionCityId': commissionCityId,
      'lastCommissionCityUpdate':
          lastCommissionCityUpdate?.toIso8601String(),
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'totalRating': totalRating,
      'vehicle': vehicle?.toJson(),
      'driverId': driverId,
    };
  }
}

class FleetId {
  dynamic phoneOtp;
  String? id;
  String? name;
  int? phone;
  String? email;
  bool? disable;
  int? driverCommision;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  FleetId({
    this.phoneOtp,
    this.id,
    this.name,
    this.phone,
    this.email,
    this.disable,
    this.driverCommision,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FleetId.fromJson(Map<String, dynamic> json) {
    return FleetId(
      phoneOtp: json['phoneOtp'],
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      disable: json['disable'],
      driverCommision: json['driverCommision'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneOtp': phoneOtp,
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'disable': disable,
      'driverCommision': driverCommision,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Vehicle {
  String? id;
  String? vehicleName;
  String? vehicleNumber;
  String? vehicleType;
  String? vehicleSubType;

  String? vehicleColor;
  String? vehicleModel;
  int? vehicleYear;
  int? vehicleCapacity;
  String? vehicleStatus;
  String? driverId;
  String? createdBy;
  String? createdByModel;
  bool? disable;
  String? verificationStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Vehicle({
    this.id,
    this.vehicleName,
    this.vehicleNumber,
    this.vehicleType,
    this.vehicleColor,
    this.vehicleModel,
    this.vehicleYear,
    this.vehicleCapacity,
    this.vehicleStatus,
    this.driverId,
    this.createdBy,
    this.createdByModel,
    this.disable,
    this.verificationStatus,
    this.createdAt,
    this.updatedAt,
    this.vehicleSubType,
    this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    // Handle vehicleYear - convert double to int if needed
    int? vehicleYear;
    if (json['vehicleYear'] != null) {
      if (json['vehicleYear'] is int) {
        vehicleYear = json['vehicleYear'] as int;
      } else if (json['vehicleYear'] is double) {
        vehicleYear = (json['vehicleYear'] as double).toInt();
      }
    }

    // Handle vehicleCapacity - convert double to int if needed
    int? vehicleCapacity;
    if (json['vehicleCapacity'] != null) {
      if (json['vehicleCapacity'] is int) {
        vehicleCapacity = json['vehicleCapacity'] as int;
      } else if (json['vehicleCapacity'] is double) {
        vehicleCapacity = (json['vehicleCapacity'] as double).toInt();
      }
    }

    return Vehicle(
      id: json['_id'],
      vehicleName: json['vehicleName'],
      vehicleNumber: json['vehicleNumber'],
      vehicleType: json['vehicleType'],
      vehicleSubType: json['vehicleSubType'],
      vehicleColor: json['vehicleColor'],
      vehicleModel: json['vehicleModel'],
      vehicleYear: vehicleYear,
      vehicleCapacity: vehicleCapacity,
      vehicleStatus: json['vehicleStatus'],
      driverId: json['driverId'],
      createdBy: json['createdBy'],
      createdByModel: json['createdByModel'],
      disable: json['disable'],
      verificationStatus: json['verificationStatus'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleColor': vehicleColor,
      'vehicleModel': vehicleModel,
      'vehicleYear': vehicleYear,
      'vehicleCapacity': vehicleCapacity,
      'vehicleStatus': vehicleStatus,
      'driverId': driverId,
      'createdBy': createdBy,
      'createdByModel': createdByModel,
      'disable': disable,
      'verificationStatus': verificationStatus,
      'vehicleSubType': vehicleSubType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}