// class Updateorderresposne {
//   bool? success;
//   Data? data;
//   String? message;

//   Updateorderresposne({
//     this.success,
//     this.data,
//     this.message,
//   });

//   factory Updateorderresposne.fromJson(Map<String, dynamic> json) =>
//       Updateorderresposne(
//         success: json["success"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data?.toJson(),
//         "message": message,
//       };
// }

// class Data {
//   Location? startLocation;
//   Location? endLocation;
//   RentalBillingDetails? rentalBillingDetails;
//   String? id;
//   UserId? userId;
//   String? vehicleType;
//   bool? otpVerified;
//   String? orderStatus;
//   double? distance;
//   double? duration;
//   int? totalFare;
//   String? paymentMethod;
//   String? orderType;
//   dynamic rentalPackageId;
//   dynamic rentalStartTime;
//   dynamic rentalEndTime;
//   dynamic bookedDurationHours;
//   dynamic actualDurationMinutes;
//   dynamic totalDistanceKm;
//   dynamic rentalMetrics;
//   List<String>? rejectedByDrivers;
//   List<String>? notifiedDrivers;
//   dynamic promoCodeId;
//   dynamic cityId;
//   bool? isScheduled;
//   dynamic scheduledStartTime;
//   dynamic scheduledSearchStartTime;
//   List<dynamic>? cancellationHistory;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//   DriverId? driverId;
//   String? rideOtp;
//   String? dataId;

//   Data({
//     this.startLocation,
//     this.endLocation,
//     this.rentalBillingDetails,
//     this.id,
//     this.userId,
//     this.vehicleType,
//     this.otpVerified,
//     this.orderStatus,
//     this.distance,
//     this.duration,
//     this.totalFare,
//     this.paymentMethod,
//     this.orderType,
//     this.rentalPackageId,
//     this.rentalStartTime,
//     this.rentalEndTime,
//     this.bookedDurationHours,
//     this.actualDurationMinutes,
//     this.totalDistanceKm,
//     this.rentalMetrics,
//     this.rejectedByDrivers,
//     this.notifiedDrivers,
//     this.promoCodeId,
//     this.cityId,
//     this.isScheduled,
//     this.scheduledStartTime,
//     this.scheduledSearchStartTime,
//     this.cancellationHistory,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.driverId,
//     this.rideOtp,
//     this.dataId,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         startLocation: json["startLocation"] == null
//             ? null
//             : Location.fromJson(json["startLocation"]),
//         endLocation: json["endLocation"] == null
//             ? null
//             : Location.fromJson(json["endLocation"]),
//         rentalBillingDetails: json["rentalBillingDetails"] == null
//             ? null
//             : RentalBillingDetails.fromJson(json["rentalBillingDetails"]),
//         id: json["_id"],
//         userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
//         vehicleType: json["vehicleType"],
//         otpVerified: json["otpVerified"],
//         orderStatus: json["orderStatus"],
//         distance: json["distance"]?.toDouble(),
//         duration: json["duration"]?.toDouble(),
//         totalFare: json["totalFare"],
//         paymentMethod: json["paymentMethod"],
//         orderType: json["orderType"],
//         rentalPackageId: json["rentalPackageId"],
//         rentalStartTime: json["rentalStartTime"],
//         rentalEndTime: json["rentalEndTime"],
//         bookedDurationHours: json["bookedDurationHours"],
//         actualDurationMinutes: json["actualDurationMinutes"],
//         totalDistanceKm: json["totalDistanceKm"],
//         rentalMetrics: json["rentalMetrics"],
//         rejectedByDrivers: json["rejectedByDrivers"] == null
//             ? []
//             : List<String>.from(json["rejectedByDrivers"]!.map((x) => x)),
//         notifiedDrivers: json["notifiedDrivers"] == null
//             ? []
//             : List<String>.from(json["notifiedDrivers"]!.map((x) => x)),
//         promoCodeId: json["promoCodeId"],
//         cityId: json["cityId"],
//         isScheduled: json["isScheduled"],
//         scheduledStartTime: json["scheduledStartTime"],
//         scheduledSearchStartTime: json["scheduledSearchStartTime"],
//         cancellationHistory: json["cancellationHistory"] == null
//             ? []
//             : List<dynamic>.from(json["cancellationHistory"]!.map((x) => x)),
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         driverId: json["driverId"] == null
//             ? null
//             : DriverId.fromJson(json["driverId"]),
//         rideOtp: json["rideOtp"],
//         dataId: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "startLocation": startLocation?.toJson(),
//         "endLocation": endLocation?.toJson(),
//         "rentalBillingDetails": rentalBillingDetails?.toJson(),
//         "_id": id,
//         "userId": userId?.toJson(),
//         "vehicleType": vehicleType,
//         "otpVerified": otpVerified,
//         "orderStatus": orderStatus,
//         "distance": distance,
//         "duration": duration,
//         "totalFare": totalFare,
//         "paymentMethod": paymentMethod,
//         "orderType": orderType,
//         "rentalPackageId": rentalPackageId,
//         "rentalStartTime": rentalStartTime,
//         "rentalEndTime": rentalEndTime,
//         "bookedDurationHours": bookedDurationHours,
//         "actualDurationMinutes": actualDurationMinutes,
//         "totalDistanceKm": totalDistanceKm,
//         "rentalMetrics": rentalMetrics,
//         "rejectedByDrivers": rejectedByDrivers == null
//             ? []
//             : List<dynamic>.from(rejectedByDrivers!.map((x) => x)),
//         "notifiedDrivers": notifiedDrivers == null
//             ? []
//             : List<dynamic>.from(notifiedDrivers!.map((x) => x)),
//         "promoCodeId": promoCodeId,
//         "cityId": cityId,
//         "isScheduled": isScheduled,
//         "scheduledStartTime": scheduledStartTime,
//         "scheduledSearchStartTime": scheduledSearchStartTime,
//         "cancellationHistory": cancellationHistory == null
//             ? []
//             : List<dynamic>.from(cancellationHistory!.map((x) => x)),
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "driverId": driverId?.toJson(),
//         "rideOtp": rideOtp,
//         "id": dataId,
//       };
// }

// class DriverId {
//   dynamic phoneOtp;
//   String? id;
//   String? phone;
//   String? gender;
//   String? imageVerificationStatus;
//   bool? startDuty;
//   int? rating;
//   String? verificationStatus;
//   bool? isCancelledAnyOrder;
//   bool? disable;
//   bool? isProfileCompleted;
//   String? preference;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;
//   String? dlImage;
//   String? panImage;
//   String? aadharImageBack;
//   String? aadharImageFront;
//   String? aadharNumber;
//   String? email;
//   String? name;
//   String? panNumber;
//   String? image;
//   int? totalRating;
//   String? driverIdId;

//   DriverId({
//     this.phoneOtp,
//     this.id,
//     this.phone,
//     this.gender,
//     this.imageVerificationStatus,
//     this.startDuty,
//     this.rating,
//     this.verificationStatus,
//     this.isCancelledAnyOrder,
//     this.disable,
//     this.isProfileCompleted,
//     this.preference,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.dlImage,
//     this.panImage,
//     this.aadharImageBack,
//     this.aadharImageFront,
//     this.aadharNumber,
//     this.email,
//     this.name,
//     this.panNumber,
//     this.image,
//     this.totalRating,
//     this.driverIdId,
//   });

//   factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
//         phoneOtp: json["phoneOtp"],
//         id: json["_id"],
//         phone: json["phone"],
//         gender: json["gender"],
//         imageVerificationStatus: json["imageVerificationStatus"],
//         startDuty: json["startDuty"],
//         rating: json["rating"],
//         verificationStatus: json["verificationStatus"],
//         isCancelledAnyOrder: json["isCancelledAnyOrder"],
//         disable: json["disable"],
//         isProfileCompleted: json["isProfileCompleted"],
//         preference: json["preference"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         dlImage: json["dlImage"],
//         panImage: json["panImage"],
//         aadharImageBack: json["aadharImageBack"],
//         aadharImageFront: json["aadharImageFront"],
//         aadharNumber: json["aadharNumber"],
//         email: json["email"],
//         name: json["name"],
//         panNumber: json["panNumber"],
//         image: json["image"],
//         totalRating: json["totalRating"],
//         driverIdId: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "phoneOtp": phoneOtp,
//         "_id": id,
//         "phone": phone,
//         "gender": gender,
//         "imageVerificationStatus": imageVerificationStatus,
//         "startDuty": startDuty,
//         "rating": rating,
//         "verificationStatus": verificationStatus,
//         "isCancelledAnyOrder": isCancelledAnyOrder,
//         "disable": disable,
//         "isProfileCompleted": isProfileCompleted,
//         "preference": preference,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//         "dlImage": dlImage,
//         "panImage": panImage,
//         "aadharImageBack": aadharImageBack,
//         "aadharImageFront": aadharImageFront,
//         "aadharNumber": aadharNumber,
//         "email": email,
//         "name": name,
//         "panNumber": panNumber,
//         "image": image,
//         "totalRating": totalRating,
//         "id": driverIdId,
//       };
// }

// class Location {
//   String? address;
//   String? type;
//   List<double>? coordinates;

//   Location({
//     this.address,
//     this.type,
//     this.coordinates,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//         address: json["address"],
//         type: json["type"],
//         coordinates: json["coordinates"] == null
//             ? []
//             : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
//       );

//   Map<String, dynamic> toJson() => {
//         "address": address,
//         "type": type,
//         "coordinates": coordinates == null
//             ? []
//             : List<dynamic>.from(coordinates!.map((x) => x)),
//       };
// }

// class RentalBillingDetails {
//   int? basePackageCost;
//   int? extraTimeMinutes;
//   int? extraTimeCost;
//   int? includedKm;
//   int? extraDistanceKm;
//   int? extraDistanceCost;
//   int? totalRentalCost;

//   RentalBillingDetails({
//     this.basePackageCost,
//     this.extraTimeMinutes,
//     this.extraTimeCost,
//     this.includedKm,
//     this.extraDistanceKm,
//     this.extraDistanceCost,
//     this.totalRentalCost,
//   });

//   factory RentalBillingDetails.fromJson(Map<String, dynamic> json) =>
//       RentalBillingDetails(
//         basePackageCost: json["basePackageCost"],
//         extraTimeMinutes: json["extraTimeMinutes"],
//         extraTimeCost: json["extraTimeCost"],
//         includedKm: json["includedKm"],
//         extraDistanceKm: json["extraDistanceKm"],
//         extraDistanceCost: json["extraDistanceCost"],
//         totalRentalCost: json["totalRentalCost"],
//       );

//   Map<String, dynamic> toJson() => {
//         "basePackageCost": basePackageCost,
//         "extraTimeMinutes": extraTimeMinutes,
//         "extraTimeCost": extraTimeCost,
//         "includedKm": includedKm,
//         "extraDistanceKm": extraDistanceKm,
//         "extraDistanceCost": extraDistanceCost,
//         "totalRentalCost": totalRentalCost,
//       };
// }

// class UserId {
//   dynamic phoneOtp;
//   String? id;
//   String? name;
//   int? phone;
//   String? email;
//   bool? isCancelledAnyOrder;
//   bool? disable;
//   bool? referralRewardClaimed;
//   dynamic referredBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? referralCode;
//   int? v;
//   String? gender;

//   UserId({
//     this.phoneOtp,
//     this.id,
//     this.name,
//     this.phone,
//     this.email,
//     this.isCancelledAnyOrder,
//     this.disable,
//     this.referralRewardClaimed,
//     this.referredBy,
//     this.createdAt,
//     this.updatedAt,
//     this.referralCode,
//     this.v,
//     this.gender,
//   });

//   factory UserId.fromJson(Map<String, dynamic> json) => UserId(
//         phoneOtp: json["phoneOtp"],
//         id: json["_id"],
//         name: json["name"],
//         phone: json["phone"],
//         email: json["email"],
//         isCancelledAnyOrder: json["isCancelledAnyOrder"],
//         disable: json["disable"],
//         referralRewardClaimed: json["referralRewardClaimed"],
//         referredBy: json["referredBy"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         referralCode: json["referralCode"],
//         v: json["__v"],
//         gender: json["gender"],
//       );

//   Map<String, dynamic> toJson() => {
//         "phoneOtp": phoneOtp,
//         "_id": id,
//         "name": name,
//         "phone": phone,
//         "email": email,
//         "isCancelledAnyOrder": isCancelledAnyOrder,
//         "disable": disable,
//         "referralRewardClaimed": referralRewardClaimed,
//         "referredBy": referredBy,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "referralCode": referralCode,
//         "__v": v,
//         "gender": gender,
//       };
// }


class Updateorderresposne {
  bool? success;
  Data? data;
  String? message;

  Updateorderresposne({
    this.success,
    this.data,
    this.message,
  });

  factory Updateorderresposne.fromJson(Map<String, dynamic> json) =>
      Updateorderresposne(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Location? startLocation;
  Location? endLocation;
  RentalBillingDetails? rentalBillingDetails;
  String? id;
  UserId? userId;
  String? vehicleType;
  bool? otpVerified;
  String? orderStatus;
  double? distance;
  double? duration;
  double? totalFare; // Changed from int? to double?
  String? paymentMethod;
  String? orderType;
  dynamic rentalPackageId;
  dynamic rentalStartTime;
  dynamic rentalEndTime;
  dynamic bookedDurationHours;
  dynamic actualDurationMinutes;
  dynamic totalDistanceKm;
  dynamic rentalMetrics;
  List<String>? rejectedByDrivers;
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
  DriverId? driverId;
  String? rideOtp;
  String? dataId;

  Data({
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
    this.dataId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        startLocation: json["startLocation"] == null
            ? null
            : Location.fromJson(json["startLocation"]),
        endLocation: json["endLocation"] == null
            ? null
            : Location.fromJson(json["endLocation"]),
        rentalBillingDetails: json["rentalBillingDetails"] == null
            ? null
            : RentalBillingDetails.fromJson(json["rentalBillingDetails"]),
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        vehicleType: json["vehicleType"],
        otpVerified: json["otpVerified"],
        orderStatus: json["orderStatus"],
        distance: _parseDouble(json["distance"]),
        duration: _parseDouble(json["duration"]),
        totalFare: _parseDouble(json["totalFare"]), // Fixed
        paymentMethod: json["paymentMethod"],
        orderType: json["orderType"],
        rentalPackageId: json["rentalPackageId"],
        rentalStartTime: json["rentalStartTime"],
        rentalEndTime: json["rentalEndTime"],
        bookedDurationHours: json["bookedDurationHours"],
        actualDurationMinutes: json["actualDurationMinutes"],
        totalDistanceKm: json["totalDistanceKm"],
        rentalMetrics: json["rentalMetrics"],
        rejectedByDrivers: json["rejectedByDrivers"] == null
            ? []
            : List<String>.from(json["rejectedByDrivers"]!.map((x) => x)),
        notifiedDrivers: json["notifiedDrivers"] == null
            ? []
            : List<String>.from(json["notifiedDrivers"]!.map((x) => x)),
        promoCodeId: json["promoCodeId"],
        cityId: json["cityId"],
        isScheduled: json["isScheduled"],
        scheduledStartTime: json["scheduledStartTime"],
        scheduledSearchStartTime: json["scheduledSearchStartTime"],
        cancellationHistory: json["cancellationHistory"] == null
            ? []
            : List<dynamic>.from(json["cancellationHistory"]!.map((x) => x)),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: _parseInt(json["__v"]),
        driverId: json["driverId"] == null
            ? null
            : DriverId.fromJson(json["driverId"]),
        rideOtp: json["rideOtp"],
        dataId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "startLocation": startLocation?.toJson(),
        "endLocation": endLocation?.toJson(),
        "rentalBillingDetails": rentalBillingDetails?.toJson(),
        "_id": id,
        "userId": userId?.toJson(),
        "vehicleType": vehicleType,
        "otpVerified": otpVerified,
        "orderStatus": orderStatus,
        "distance": distance,
        "duration": duration,
        "totalFare": totalFare,
        "paymentMethod": paymentMethod,
        "orderType": orderType,
        "rentalPackageId": rentalPackageId,
        "rentalStartTime": rentalStartTime,
        "rentalEndTime": rentalEndTime,
        "bookedDurationHours": bookedDurationHours,
        "actualDurationMinutes": actualDurationMinutes,
        "totalDistanceKm": totalDistanceKm,
        "rentalMetrics": rentalMetrics,
        "rejectedByDrivers": rejectedByDrivers == null
            ? []
            : List<dynamic>.from(rejectedByDrivers!.map((x) => x)),
        "notifiedDrivers": notifiedDrivers == null
            ? []
            : List<dynamic>.from(notifiedDrivers!.map((x) => x)),
        "promoCodeId": promoCodeId,
        "cityId": cityId,
        "isScheduled": isScheduled,
        "scheduledStartTime": scheduledStartTime,
        "scheduledSearchStartTime": scheduledSearchStartTime,
        "cancellationHistory": cancellationHistory == null
            ? []
            : List<dynamic>.from(cancellationHistory!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "driverId": driverId?.toJson(),
        "rideOtp": rideOtp,
        "id": dataId,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class DriverId {
  dynamic phoneOtp;
  String? id;
  String? phone;
  String? gender;
  String? imageVerificationStatus;
  bool? startDuty;
  double? rating; // Changed from int? to double?
  String? verificationStatus;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? isProfileCompleted;
  String? preference;
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
  int? totalRating;
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
    this.totalRating,
    this.driverIdId,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        phoneOtp: json["phoneOtp"],
        id: json["_id"],
        phone: json["phone"],
        gender: json["gender"],
        imageVerificationStatus: json["imageVerificationStatus"],
        startDuty: json["startDuty"],
        rating: _parseDouble(json["rating"]), // Fixed
        verificationStatus: json["verificationStatus"],
        isCancelledAnyOrder: json["isCancelledAnyOrder"],
        disable: json["disable"],
        isProfileCompleted: json["isProfileCompleted"],
        preference: json["preference"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: _parseInt(json["__v"]),
        dlImage: json["dlImage"],
        panImage: json["panImage"],
        aadharImageBack: json["aadharImageBack"],
        aadharImageFront: json["aadharImageFront"],
        aadharNumber: json["aadharNumber"],
        email: json["email"],
        name: json["name"],
        panNumber: json["panNumber"],
        image: json["image"],
        totalRating: _parseInt(json["totalRating"]),
        driverIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "phoneOtp": phoneOtp,
        "_id": id,
        "phone": phone,
        "gender": gender,
        "imageVerificationStatus": imageVerificationStatus,
        "startDuty": startDuty,
        "rating": rating,
        "verificationStatus": verificationStatus,
        "isCancelledAnyOrder": isCancelledAnyOrder,
        "disable": disable,
        "isProfileCompleted": isProfileCompleted,
        "preference": preference,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "dlImage": dlImage,
        "panImage": panImage,
        "aadharImageBack": aadharImageBack,
        "aadharImageFront": aadharImageFront,
        "aadharNumber": aadharNumber,
        "email": email,
        "name": name,
        "panNumber": panNumber,
        "image": image,
        "totalRating": totalRating,
        "id": driverIdId,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Location {
  String? address;
  String? type;
  List<double>? coordinates;

  Location({
    this.address,
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        address: json["address"],
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => _parseDouble(x) ?? 0.0)),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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

  factory RentalBillingDetails.fromJson(Map<String, dynamic> json) =>
      RentalBillingDetails(
        basePackageCost: _parseInt(json["basePackageCost"]),
        extraTimeMinutes: _parseInt(json["extraTimeMinutes"]),
        extraTimeCost: _parseInt(json["extraTimeCost"]),
        includedKm: _parseInt(json["includedKm"]),
        extraDistanceKm: _parseInt(json["extraDistanceKm"]),
        extraDistanceCost: _parseInt(json["extraDistanceCost"]),
        totalRentalCost: _parseInt(json["totalRentalCost"]),
      );

  Map<String, dynamic> toJson() => {
        "basePackageCost": basePackageCost,
        "extraTimeMinutes": extraTimeMinutes,
        "extraTimeCost": extraTimeCost,
        "includedKm": includedKm,
        "extraDistanceKm": extraDistanceKm,
        "extraDistanceCost": extraDistanceCost,
        "totalRentalCost": totalRentalCost,
      };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
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
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        phoneOtp: json["phoneOtp"],
        id: json["_id"],
        name: json["name"],
        phone: _parseInt(json["phone"]), // Fixed
        email: json["email"],
        isCancelledAnyOrder: json["isCancelledAnyOrder"],
        disable: json["disable"],
        referralRewardClaimed: json["referralRewardClaimed"],
        referredBy: json["referredBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        referralCode: json["referralCode"],
        v: _parseInt(json["__v"]),
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "phoneOtp": phoneOtp,
        "_id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "isCancelledAnyOrder": isCancelledAnyOrder,
        "disable": disable,
        "referralRewardClaimed": referralRewardClaimed,
        "referredBy": referredBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "referralCode": referralCode,
        "__v": v,
        "gender": gender,
      };

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}