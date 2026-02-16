import 'dart:convert';

class CreateByDriverResponse {
  bool? success;
  Data? data;
  String? message;

  CreateByDriverResponse({this.success, this.data, this.message});

  factory CreateByDriverResponse.fromJson(Map<String, dynamic> json) =>
      CreateByDriverResponse(
        success: json['success'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data?.toJson(),
    'message': message,
  };
}

class Data {
  UserId? userId;
  DriverId? driverId;
  VehicleId? vehicleId;
  String? vehicleType;
  String? vehicleSubType;
  String? rideOtp;
  bool? otpVerified;
  String? orderStatus;
  Location? startLocation;
  Location? endLocation;
  double? distance;
  int? duration;
  String? weather;
  String? traffic;
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
  dynamic polyline;
  RentalBillingDetails? rentalBillingDetails;
  List<dynamic>? rejectedByDrivers;
  List<dynamic>? notifiedDrivers;
  dynamic promoCodeId;
  dynamic cityId;
  bool? isScheduled;
  dynamic scheduledStartTime;
  dynamic scheduledSearchStartTime;
  String? id;
  List<dynamic>? cancellationHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? dataId;

  Data({
    this.userId,
    this.driverId,
    this.vehicleId,
    this.vehicleType,
    this.vehicleSubType,
    this.rideOtp,
    this.otpVerified,
    this.orderStatus,
    this.startLocation,
    this.endLocation,
    this.distance,
    this.duration,
    this.weather,
    this.traffic,
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
    this.polyline,
    this.rentalBillingDetails,
    this.rejectedByDrivers,
    this.notifiedDrivers,
    this.promoCodeId,
    this.cityId,
    this.isScheduled,
    this.scheduledStartTime,
    this.scheduledSearchStartTime,
    this.id,
    this.cancellationHistory,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
    driverId: json['driverId'] != null
        ? DriverId.fromJson(json['driverId'])
        : null,
    vehicleId: json['vehicleId'] != null
        ? VehicleId.fromJson(json['vehicleId'])
        : null,
    vehicleType: json['vehicleType'],
    vehicleSubType: json['vehicleSubType'],
    rideOtp: json['rideOtp'],
    otpVerified: json['otpVerified'],
    orderStatus: json['orderStatus'],
    startLocation: json['startLocation'] != null
        ? Location.fromJson(json['startLocation'])
        : null,
    endLocation: json['endLocation'] != null
        ? Location.fromJson(json['endLocation'])
        : null,
    distance: (json['distance'] as num?)?.toDouble(),
    duration: (json['duration'] as num?)?.toInt(),
    weather: json['weather'],
    traffic: json['traffic'],
    totalFare: (json['totalFare'] as num?)?.toInt(),
    paymentMethod: json['paymentMethod'],
    orderType: json['orderType'],
    rentalPackageId: json['rentalPackageId'],
    rentalStartTime: json['rentalStartTime'],
    rentalEndTime: json['rentalEndTime'],
    bookedDurationHours: json['bookedDurationHours'],
    actualDurationMinutes: json['actualDurationMinutes'],
    totalDistanceKm: json['totalDistanceKm'],
    rentalMetrics: json['rentalMetrics'],
    polyline: json['polyline'],
    rentalBillingDetails: json['rentalBillingDetails'] != null
        ? RentalBillingDetails.fromJson(json['rentalBillingDetails'])
        : null,
    rejectedByDrivers: json['rejectedByDrivers'] != null
        ? List<dynamic>.from(json['rejectedByDrivers'].map((x) => x))
        : null,
    notifiedDrivers: json['notifiedDrivers'] != null
        ? List<dynamic>.from(json['notifiedDrivers'].map((x) => x))
        : null,
    promoCodeId: json['promoCodeId'],
    cityId: json['cityId'],
    isScheduled: json['isScheduled'],
    scheduledStartTime: json['scheduledStartTime'],
    scheduledSearchStartTime: json['scheduledSearchStartTime'],
    id: json['_id'],
    cancellationHistory: json['cancellationHistory'] != null
        ? List<dynamic>.from(json['cancellationHistory'].map((x) => x))
        : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    v: json['__v'],
    dataId: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId?.toJson(),
    'driverId': driverId?.toJson(),
    'vehicleId': vehicleId?.toJson(),
    'vehicleType': vehicleType,
    'vehicleSubType': vehicleSubType,
    'rideOtp': rideOtp,
    'otpVerified': otpVerified,
    'orderStatus': orderStatus,
    'startLocation': startLocation?.toJson(),
    'endLocation': endLocation?.toJson(),
    'distance': distance,
    'duration': duration,
    'weather': weather,
    'traffic': traffic,
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
    'polyline': polyline,
    'rentalBillingDetails': rentalBillingDetails?.toJson(),
    'rejectedByDrivers': rejectedByDrivers,
    'notifiedDrivers': notifiedDrivers,
    'promoCodeId': promoCodeId,
    'cityId': cityId,
    'isScheduled': isScheduled,
    'scheduledStartTime': scheduledStartTime,
    'scheduledSearchStartTime': scheduledSearchStartTime,
    '_id': id,
    'cancellationHistory': cancellationHistory,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'id': dataId,
  };
}

class DriverId {
  dynamic phoneOtp;
  String? id;
  String? phone;
  String? gender;
  String? imageVerificationStatus;
  bool? startDuty;
  double? rating;
  String? verificationStatus;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? isProfileCompleted;
  String? preference;
  int? totalRating;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? dlImage;
  String? panImage;
  String? aadharImageBack;
  String? aadharImageFront;
  String? email;
  String? name;
  String? image;
  DateTime? dateOfBirth;
  String? driverIdId;

  DriverId({
    this.phoneOtp,
    this.id,
    this.phone,
    this.gender,
    this.imageVerificationStatus,
    this.startDuty,
    this.rating,
    this.verificationStatus,
    this.isCancelledAnyOrder,
    this.disable,
    this.isProfileCompleted,
    this.preference,
    this.totalRating,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dlImage,
    this.panImage,
    this.aadharImageBack,
    this.aadharImageFront,
    this.email,
    this.name,
    this.image,
    this.dateOfBirth,
    this.driverIdId,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
    phoneOtp: json['phoneOtp'],
    id: json['_id'],
    phone: json['phone'],
    gender: json['gender'],
    imageVerificationStatus: json['imageVerificationStatus'],
    startDuty: json['startDuty'],
    rating: (json['rating'] as num?)?.toDouble(),
    verificationStatus: json['verificationStatus'],
    isCancelledAnyOrder: json['isCancelledAnyOrder'],
    disable: json['disable'],
    isProfileCompleted: json['isProfileCompleted'],
    preference: json['preference'],
    totalRating: (json['totalRating'] as num?)?.toInt(),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    v: json['__v'],
    dlImage: json['dlImage'],
    panImage: json['panImage'],
    aadharImageBack: json['aadharImageBack'],
    aadharImageFront: json['aadharImageFront'],
    email: json['email'],
    name: json['name'],
    image: json['image'],
    dateOfBirth: json['dateOfBirth'] != null
        ? DateTime.parse(json['dateOfBirth'])
        : null,
    driverIdId: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'phoneOtp': phoneOtp,
    '_id': id,
    'phone': phone,
    'gender': gender,
    'imageVerificationStatus': imageVerificationStatus,
    'startDuty': startDuty,
    'rating': rating,
    'verificationStatus': verificationStatus,
    'isCancelledAnyOrder': isCancelledAnyOrder,
    'disable': disable,
    'isProfileCompleted': isProfileCompleted,
    'preference': preference,
    'totalRating': totalRating,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'dlImage': dlImage,
    'panImage': panImage,
    'aadharImageBack': aadharImageBack,
    'aadharImageFront': aadharImageFront,
    'email': email,
    'name': name,
    'image': image,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'id': driverIdId,
  };
}

class Location {
  String? address;
  String? type;
  List<double>? coordinates;

  Location({this.address, this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    address: json['address'],
    type: json['type'],
    coordinates: json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'address': address,
    'type': type,
    'coordinates': coordinates,
  };
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

  factory RentalBillingDetails.fromJson(Map<String, dynamic> json) =>
      RentalBillingDetails(
        basePackageCost: (json['basePackageCost'] as num?)?.toInt(),
        extraTimeMinutes: (json['extraTimeMinutes'] as num?)?.toInt(),
        extraTimeCost: (json['extraTimeCost'] as num?)?.toInt(),
        includedKm: (json['includedKm'] as num?)?.toInt(),
        extraDistanceKm: (json['extraDistanceKm'] as num?)?.toInt(),
        extraDistanceCost: (json['extraDistanceCost'] as num?)?.toInt(),
        totalRentalCost: (json['totalRentalCost'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
    'basePackageCost': basePackageCost,
    'extraTimeMinutes': extraTimeMinutes,
    'extraTimeCost': extraTimeCost,
    'includedKm': includedKm,
    'extraDistanceKm': extraDistanceKm,
    'extraDistanceCost': extraDistanceCost,
    'totalRentalCost': totalRentalCost,
  };
}

class UserId {
  dynamic phoneOtp;
  String? id;
  String? name;
  int? phone;
  String? email;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? referralRewardClaimed;
  dynamic referredBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? referralCode;
  int? v;
  String? gender;
  String? image;
  String? userIdId;

  UserId({
    this.phoneOtp,
    this.id,
    this.name,
    this.phone,
    this.email,
    this.isCancelledAnyOrder,
    this.disable,
    this.referralRewardClaimed,
    this.referredBy,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.v,
    this.gender,
    this.image,
    this.userIdId,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    phoneOtp: json['phoneOtp'],
    id: json['_id'],
    name: json['name'],
    phone: (json['phone'] as num?)?.toInt(),
    email: json['email'],
    isCancelledAnyOrder: json['isCancelledAnyOrder'],
    disable: json['disable'],
    referralRewardClaimed: json['referralRewardClaimed'],
    referredBy: json['referredBy'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null,
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    referralCode: json['referralCode'],
    v: json['__v'],
    gender: json['gender'],
    image: json['image'],
    userIdId: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'phoneOtp': phoneOtp,
    '_id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'isCancelledAnyOrder': isCancelledAnyOrder,
    'disable': disable,
    'referralRewardClaimed': referralRewardClaimed,
    'referredBy': referredBy,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'referralCode': referralCode,
    '__v': v,
    'gender': gender,
    'image': image,
    'id': userIdId,
  };
}

class VehicleId {
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
  String? vehicleNumberImage;
  String? rcImage;
  String? vehicleInsuraneImage;
  String? driverId;
  String? createdBy;
  String? createdByModel;
  bool? disable;
  String? verificationStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  VehicleId({
    this.id,
    this.vehicleName,
    this.vehicleNumber,
    this.vehicleType,
    this.vehicleSubType,
    this.vehicleColor,
    this.vehicleModel,
    this.vehicleYear,
    this.vehicleCapacity,
    this.vehicleStatus,
    this.vehicleNumberImage,
    this.rcImage,
    this.vehicleInsuraneImage,
    this.driverId,
    this.createdBy,
    this.createdByModel,
    this.disable,
    this.verificationStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory VehicleId.fromJson(Map<String, dynamic> json) => VehicleId(
    id: json['_id'],
    vehicleName: json['vehicleName'],
    vehicleNumber: json['vehicleNumber'],
    vehicleType: json['vehicleType'],
    vehicleSubType: json['vehicleSubType'],
    vehicleColor: json['vehicleColor'],
    vehicleModel: json['vehicleModel'],
    vehicleYear: json['vehicleYear'],
    vehicleCapacity: json['vehicleCapacity'],
    vehicleStatus: json['vehicleStatus'],
    vehicleNumberImage: json['vehicleNumberImage'],
    rcImage: json['rcImage'],
    vehicleInsuraneImage: json['vehicleInsuraneImage'],
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

  Map<String, dynamic> toJson() => {
    '_id': id,
    'vehicleName': vehicleName,
    'vehicleNumber': vehicleNumber,
    'vehicleType': vehicleType,
    'vehicleSubType': vehicleSubType,
    'vehicleColor': vehicleColor,
    'vehicleModel': vehicleModel,
    'vehicleYear': vehicleYear,
    'vehicleCapacity': vehicleCapacity,
    'vehicleStatus': vehicleStatus,
    'vehicleNumberImage': vehicleNumberImage,
    'rcImage': rcImage,
    'vehicleInsuraneImage': vehicleInsuraneImage,
    'driverId': driverId,
    'createdBy': createdBy,
    'createdByModel': createdByModel,
    'disable': disable,
    'verificationStatus': verificationStatus,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
