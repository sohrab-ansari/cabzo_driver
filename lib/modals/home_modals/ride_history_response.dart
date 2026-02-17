

// class RideHistoryResponse {
//   bool? success;
//   List<Datum>? data;
//   Pagination? pagination;
//   String? message;

//   RideHistoryResponse({
//     this.success,
//     this.data,
//     this.pagination,
//     this.message,
//   });

//   factory RideHistoryResponse.fromJson(Map<String, dynamic> json) =>
//       RideHistoryResponse(
//         success: json["success"],
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//         pagination: json["pagination"] == null
//             ? null
//             : Pagination.fromJson(json["pagination"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data == null
//         ? []
//         : List<dynamic>.from(data!.map((x) => x.toJson())),
//     "pagination": pagination?.toJson(),
//     "message": message,
//   };
// }

// class Datum {
//   String? id;
//   UserId? userId;
//   String? vehicleType;
//   bool? otpVerified;
//   String? orderStatus;
//   Location? startLocation;
//   Location? endLocation;
//   double? distance;
//   double? duration;
//   dynamic? totalFare;
//   String? paymentMethod;
//   String? orderType;
//   dynamic rentalPackageId;
//   dynamic rentalStartTime;
//   dynamic rentalEndTime;
//   dynamic bookedDurationHours;
//   dynamic actualDurationMinutes;
//   dynamic totalDistanceKm;
//   dynamic rentalMetrics;
//   RentalBillingDetails? rentalBillingDetails;
//   List<dynamic>? rejectedByDrivers;
//   List<String>? notifiedDrivers;
//   dynamic promoCodeId;
//   dynamic cityId;
//   bool? isScheduled;
//   dynamic scheduledStartTime;
//   dynamic scheduledSearchStartTime;
//   List<dynamic>? cancellationHistory;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   dynamic? v;
//   DriverId? driverId;
//   String? rideOtp;
//   Ratings? ratings;
//   DriverRelation? driverRelation;

//   Datum({
//     this.id,
//     this.userId,
//     this.vehicleType,
//     this.otpVerified,
//     this.orderStatus,
//     this.startLocation,
//     this.endLocation,
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
//     this.rentalBillingDetails,
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
//     this.ratings,
//     this.driverRelation,
//   });

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["_id"],
//     userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
//     vehicleType: json["vehicleType"],
//     otpVerified: json["otpVerified"],
//     orderStatus: json["orderStatus"],
//     startLocation: json["startLocation"] == null
//         ? null
//         : Location.fromJson(json["startLocation"]),
//     endLocation: json["endLocation"] == null
//         ? null
//         : Location.fromJson(json["endLocation"]),
//     distance: json["distance"]?.toDouble(),
//     duration: json["duration"]?.toDouble(),
//     totalFare: json["totalFare"],
//     paymentMethod: json["paymentMethod"],
//     orderType: json["orderType"],
//     rentalPackageId: json["rentalPackageId"],
//     rentalStartTime: json["rentalStartTime"],
//     rentalEndTime: json["rentalEndTime"],
//     bookedDurationHours: json["bookedDurationHours"],
//     actualDurationMinutes: json["actualDurationMinutes"],
//     totalDistanceKm: json["totalDistanceKm"],
//     rentalMetrics: json["rentalMetrics"],
//     rentalBillingDetails: json["rentalBillingDetails"] == null
//         ? null
//         : RentalBillingDetails.fromJson(json["rentalBillingDetails"]),
//     rejectedByDrivers: json["rejectedByDrivers"] == null
//         ? []
//         : List<dynamic>.from(json["rejectedByDrivers"]!.map((x) => x)),
//     notifiedDrivers: json["notifiedDrivers"] == null
//         ? []
//         : List<String>.from(json["notifiedDrivers"]!.map((x) => x)),
//     promoCodeId: json["promoCodeId"],
//     cityId: json["cityId"],
//     isScheduled: json["isScheduled"],
//     scheduledStartTime: json["scheduledStartTime"],
//     scheduledSearchStartTime: json["scheduledSearchStartTime"],
//     cancellationHistory: json["cancellationHistory"] == null
//         ? []
//         : List<dynamic>.from(json["cancellationHistory"]!.map((x) => x)),
//     createdAt: json["createdAt"] == null
//         ? null
//         : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null
//         ? null
//         : DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     driverId: json["driverId"] == null
//         ? null
//         : DriverId.fromJson(json["driverId"]),
//     rideOtp: json["rideOtp"],
//     ratings: json["ratings"] == null ? null : Ratings.fromJson(json["ratings"]),
//     driverRelation: json["driverRelation"] == null
//         ? null
//         : DriverRelation.fromJson(json["driverRelation"]),
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userId": userId?.toJson(),
//     "vehicleType": vehicleType,
//     "otpVerified": otpVerified,
//     "orderStatus": orderStatus,
//     "startLocation": startLocation?.toJson(),
//     "endLocation": endLocation?.toJson(),
//     "distance": distance,
//     "duration": duration,
//     "totalFare": totalFare,
//     "paymentMethod": paymentMethod,
//     "orderType": orderType,
//     "rentalPackageId": rentalPackageId,
//     "rentalStartTime": rentalStartTime,
//     "rentalEndTime": rentalEndTime,
//     "bookedDurationHours": bookedDurationHours,
//     "actualDurationMinutes": actualDurationMinutes,
//     "totalDistanceKm": totalDistanceKm,
//     "rentalMetrics": rentalMetrics,
//     "rentalBillingDetails": rentalBillingDetails?.toJson(),
//     "rejectedByDrivers": rejectedByDrivers == null
//         ? []
//         : List<dynamic>.from(rejectedByDrivers!.map((x) => x)),
//     "notifiedDrivers": notifiedDrivers == null
//         ? []
//         : List<dynamic>.from(notifiedDrivers!.map((x) => x)),
//     "promoCodeId": promoCodeId,
//     "cityId": cityId,
//     "isScheduled": isScheduled,
//     "scheduledStartTime": scheduledStartTime,
//     "scheduledSearchStartTime": scheduledSearchStartTime,
//     "cancellationHistory": cancellationHistory == null
//         ? []
//         : List<dynamic>.from(cancellationHistory!.map((x) => x)),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//     "driverId": driverId?.toJson(),
//     "rideOtp": rideOtp,
//     "ratings": ratings?.toJson(),
//     "driverRelation": driverRelation?.toJson(),
//   };
// }

// class DriverId {
//   String? id;
//   String? phone;
//   dynamic phoneOtp;
//   bool? startDuty;
//   dynamic rating;
//   String? verificationStatus;
//   bool? isCancelledAnyOrder;
//   bool? disable;
//   bool? isProfileCompleted;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   dynamic v;
//   String? dlImage;
//   String? panImage;
//   String? aadharImageBack;
//   String? aadharImageFront;
//   String? email;
//   String? name;
//   String? image;
//   String? imageVerificationStatus;
//   String? gender;
//   String? preference;
//   dynamic totalRating;

//   DriverId({
//     this.id,
//     this.phone,
//     this.phoneOtp,
//     this.startDuty,
//     this.rating,
//     this.verificationStatus,
//     this.isCancelledAnyOrder,
//     this.disable,
//     this.isProfileCompleted,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.dlImage,
//     this.panImage,
//     this.aadharImageBack,
//     this.aadharImageFront,
//     this.email,
//     this.name,
//     this.image,
//     this.imageVerificationStatus,
//     this.gender,
//     this.preference,
//     this.totalRating,
//   });

//   factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
//     id: json["_id"],
//     phone: json["phone"],
//     phoneOtp: json["phoneOtp"],
//     startDuty: json["startDuty"],
//     rating: json["rating"],
//     verificationStatus: json["verificationStatus"],
//     isCancelledAnyOrder: json["isCancelledAnyOrder"],
//     disable: json["disable"],
//     isProfileCompleted: json["isProfileCompleted"],
//     createdAt: json["createdAt"] == null
//         ? null
//         : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null
//         ? null
//         : DateTime.parse(json["updatedAt"]),
//     v: json["__v"],
//     dlImage: json["dlImage"],
//     panImage: json["panImage"],
//     aadharImageBack: json["aadharImageBack"],
//     aadharImageFront: json["aadharImageFront"],
//     email: json["email"],
//     name: json["name"],
//     image: json["image"],
//     imageVerificationStatus: json["imageVerificationStatus"],
//     gender: json["gender"],
//     preference: json["preference"],
//     totalRating: json["totalRating"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "phone": phone,
//     "phoneOtp": phoneOtp,
//     "startDuty": startDuty,
//     "rating": rating,
//     "verificationStatus": verificationStatus,
//     "isCancelledAnyOrder": isCancelledAnyOrder,
//     "disable": disable,
//     "isProfileCompleted": isProfileCompleted,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//     "dlImage": dlImage,
//     "panImage": panImage,
//     "aadharImageBack": aadharImageBack,
//     "aadharImageFront": aadharImageFront,
//     "email": email,
//     "name": name,
//     "image": image,
//     "imageVerificationStatus": imageVerificationStatus,
//     "gender": gender,
//     "preference": preference,
//     "totalRating": totalRating,
//   };
// }

// class DriverRelation {
//   bool? isCurrentDriver;
//   bool? didCancel;
//   dynamic cancellationDetails;

//   DriverRelation({
//     this.isCurrentDriver,
//     this.didCancel,
//     this.cancellationDetails,
//   });

//   factory DriverRelation.fromJson(Map<String, dynamic> json) => DriverRelation(
//     isCurrentDriver: json["isCurrentDriver"],
//     didCancel: json["didCancel"],
//     cancellationDetails: json["cancellationDetails"],
//   );

//   Map<String, dynamic> toJson() => {
//     "isCurrentDriver": isCurrentDriver,
//     "didCancel": didCancel,
//     "cancellationDetails": cancellationDetails,
//   };
// }

// class Location {
//   String? address;
//   String? type;
//   List<double>? coordinates;

//   Location({this.address, this.type, this.coordinates});

//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//     address: json["address"],
//     type: json["type"],
//     coordinates: json["coordinates"] == null
//         ? []
//         : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
//   );

//   Map<String, dynamic> toJson() => {
//     "address": address,
//     "type": type,
//     "coordinates": coordinates == null
//         ? []
//         : List<dynamic>.from(coordinates!.map((x) => x)),
//   };
// }

// class Ratings {
//   String? id;
//   String? userId;
//   String? orderId;
//   dynamic v;
//   String? driverId;
//   String? expreienceType;
//   String? exprerienceDescription;
//   dynamic rating;

//   Ratings({
//     this.id,
//     this.userId,
//     this.orderId,
//     this.v,
//     this.driverId,
//     this.expreienceType,
//     this.exprerienceDescription,
//     this.rating,
//   });

//   factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
//     id: json["_id"],
//     userId: json["userId"],
//     orderId: json["orderId"],
//     v: json["__v"],
//     driverId: json["driverId"],
//     expreienceType: json["expreienceType"],
//     exprerienceDescription: json["exprerienceDescription"],
//     rating: json["rating"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "userId": userId,
//     "orderId": orderId,
//     "__v": v,
//     "driverId": driverId,
//     "expreienceType": expreienceType,
//     "exprerienceDescription": exprerienceDescription,
//     "rating": rating,
//   };
// }

// class RentalBillingDetails {
//   dynamic basePackageCost;
//   dynamic extraTimeMinutes;
//   dynamic extraTimeCost;
//   dynamic includedKm;
//   dynamic extraDistanceKm;
//   dynamic extraDistanceCost;
//   dynamic totalRentalCost;

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
//     "basePackageCost": basePackageCost,
//     "extraTimeMinutes": extraTimeMinutes,
//     "extraTimeCost": extraTimeCost,
//     "includedKm": includedKm,
//     "extraDistanceKm": extraDistanceKm,
//     "extraDistanceCost": extraDistanceCost,
//     "totalRentalCost": totalRentalCost,
//   };
// }

// class UserId {
//   String? id;
//   num? phone; // Changed from int? to num?
//   dynamic phoneOtp;
//   bool? isCancelledAnyOrder;
//   bool? disable;
//   bool? referralRewardClaimed;
//   dynamic referredBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? referralCode;
//   dynamic v;
//   String? image;
//   String? name;
//   String? email;
//   String? gender;

//   UserId({
//     this.id,
//     this.phone,
//     this.phoneOtp,
//     this.isCancelledAnyOrder,
//     this.disable,
//     this.referralRewardClaimed,
//     this.referredBy,
//     this.createdAt,
//     this.updatedAt,
//     this.referralCode,
//     this.v,
//     this.image,
//     this.name,
//     this.email,
//     this.gender,
//   });

//   factory UserId.fromJson(Map<String, dynamic> json) => UserId(
//     id: json["_id"],
//     phone: json["phone"],
//     phoneOtp: json["phoneOtp"],
//     isCancelledAnyOrder: json["isCancelledAnyOrder"],
//     disable: json["disable"],
//     referralRewardClaimed: json["referralRewardClaimed"],
//     referredBy: json["referredBy"],
//     createdAt: json["createdAt"] == null
//         ? null
//         : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null
//         ? null
//         : DateTime.parse(json["updatedAt"]),
//     referralCode: json["referralCode"],
//     v: json["__v"],
//     image: json["image"],
//     name: json["name"],
//     email: json["email"],
//     gender: json["gender"],
//   );

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "phone": phone,
//     "phoneOtp": phoneOtp,
//     "isCancelledAnyOrder": isCancelledAnyOrder,
//     "disable": disable,
//     "referralRewardClaimed": referralRewardClaimed,
//     "referredBy": referredBy,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "referralCode": referralCode,
//     "__v": v,
//     "image": image,
//     "name": name,
//     "email": email,
//     "gender": gender,
//   };
// }

// class Pagination {
//   dynamic page;
//   dynamic limit;
//   dynamic total;
//   dynamic pages;

//   Pagination({this.page, this.limit, this.total, this.pages});

//   factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//     page: json["page"],
//     limit: json["limit"],
//     total: json["total"],
//     pages: json["pages"],
//   );

//   Map<String, dynamic> toJson() => {
//     "page": page,
//     "limit": limit,
//     "total": total,
//     "pages": pages,
//   };
// }


class RideHistoryResponse {
  bool? success;
  List<Datum>? data;
  Pagination? pagination;
  String? message;

  RideHistoryResponse({
    this.success,
    this.data,
    this.pagination,
    this.message,
  });

  factory RideHistoryResponse.fromJson(Map<String, dynamic> json) =>
      RideHistoryResponse(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
        "message": message,
      };
}

class Datum {
  String? id;
  UserId? userId;
  String? vehicleType;
  String? vehicleSubType;
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
  RentalBillingDetails? rentalBillingDetails;
  List<dynamic>? rejectedByDrivers;
  List<String>? notifiedDrivers;
  dynamic promoCodeId;
  dynamic cityId;
  bool? isScheduled;
  dynamic scheduledStartTime;
  dynamic scheduledSearchStartTime;
  List<CancellationHistory>? cancellationHistory;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  DriverId? driverId;
  String? rideOtp;
  VehicleId? vehicleId;
  String? cancellationReason;
  Ratings? ratings;
  DriverRelation? driverRelation;

  Datum({
    this.id,
    this.userId,
    this.vehicleType,
    this.vehicleSubType,
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
    this.rentalBillingDetails,
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
    this.vehicleId,
    this.cancellationReason,
    this.ratings,
    this.driverRelation,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
        vehicleType: json["vehicleType"],
        vehicleSubType: json["vehicleSubType"],
        otpVerified: json["otpVerified"],
        orderStatus: json["orderStatus"],
        startLocation: json["startLocation"] == null
            ? null
            : Location.fromJson(json["startLocation"]),
        endLocation: json["endLocation"] == null
            ? null
            : Location.fromJson(json["endLocation"]),
        distance: json["distance"]?.toDouble(),
        duration: json["duration"],
        weather: json["weather"],
        traffic: json["traffic"],
        totalFare: json["totalFare"],
        paymentMethod: json["paymentMethod"],
        orderType: json["orderType"],
        rentalPackageId: json["rentalPackageId"],
        rentalStartTime: json["rentalStartTime"],
        rentalEndTime: json["rentalEndTime"],
        bookedDurationHours: json["bookedDurationHours"],
        actualDurationMinutes: json["actualDurationMinutes"],
        totalDistanceKm: json["totalDistanceKm"],
        rentalMetrics: json["rentalMetrics"],
        rentalBillingDetails: json["rentalBillingDetails"] == null
            ? null
            : RentalBillingDetails.fromJson(json["rentalBillingDetails"]),
        rejectedByDrivers: json["rejectedByDrivers"] == null
            ? []
            : List<dynamic>.from(json["rejectedByDrivers"]!.map((x) => x)),
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
            : List<CancellationHistory>.from(json["cancellationHistory"]!
                .map((x) => CancellationHistory.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        driverId: json["driverId"] == null
            ? null
            : DriverId.fromJson(json["driverId"]),
        rideOtp: json["rideOtp"],
        vehicleId: json["vehicleId"] == null
            ? null
            : VehicleId.fromJson(json["vehicleId"]),
        cancellationReason: json["cancellationReason"],
        ratings: json["ratings"] == null
            ? null
            : Ratings.fromJson(json["ratings"]),
        driverRelation: json["driverRelation"] == null
            ? null
            : DriverRelation.fromJson(json["driverRelation"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId?.toJson(),
        "vehicleType": vehicleType,
        "vehicleSubType": vehicleSubType,
        "otpVerified": otpVerified,
        "orderStatus": orderStatus,
        "startLocation": startLocation?.toJson(),
        "endLocation": endLocation?.toJson(),
        "distance": distance,
        "duration": duration,
        "weather": weather,
        "traffic": traffic,
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
        "rentalBillingDetails": rentalBillingDetails?.toJson(),
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
            : List<dynamic>.from(cancellationHistory!.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "driverId": driverId?.toJson(),
        "rideOtp": rideOtp,
        "vehicleId": vehicleId?.toJson(),
        "cancellationReason": cancellationReason,
        "ratings": ratings?.toJson(),
        "driverRelation": driverRelation?.toJson(),
      };
}

class CancellationHistory {
  String? cancelledBy;
  String? driverId;
  String? vehicleId;
  DateTime? cancelledAt;
  String? statusAtCancellation;
  String? id;

  CancellationHistory({
    this.cancelledBy,
    this.driverId,
    this.vehicleId,
    this.cancelledAt,
    this.statusAtCancellation,
    this.id,
  });

  factory CancellationHistory.fromJson(Map<String, dynamic> json) =>
      CancellationHistory(
        cancelledBy: json["cancelledBy"],
        driverId: json["driverId"],
        vehicleId: json["vehicleId"],
        cancelledAt: json["cancelledAt"] == null
            ? null
            : DateTime.parse(json["cancelledAt"]),
        statusAtCancellation: json["statusAtCancellation"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "cancelledBy": cancelledBy,
        "driverId": driverId,
        "vehicleId": vehicleId,
        "cancelledAt": cancelledAt?.toIso8601String(),
        "statusAtCancellation": statusAtCancellation,
        "_id": id,
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
        id: json["_id"],
        vehicleName: json["vehicleName"],
        vehicleNumber: json["vehicleNumber"],
        vehicleType: json["vehicleType"],
        vehicleSubType: json["vehicleSubType"],
        vehicleColor: json["vehicleColor"],
        vehicleModel: json["vehicleModel"],
        vehicleYear: json["vehicleYear"],
        vehicleCapacity: json["vehicleCapacity"],
        vehicleStatus: json["vehicleStatus"],
        vehicleNumberImage: json["vehicleNumberImage"],
        rcImage: json["rcImage"],
        vehicleInsuraneImage: json["vehicleInsuraneImage"],
        driverId: json["driverId"],
        createdBy: json["createdBy"],
        createdByModel: json["createdByModel"],
        disable: json["disable"],
        verificationStatus: json["verificationStatus"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "vehicleName": vehicleName,
        "vehicleNumber": vehicleNumber,
        "vehicleType": vehicleType,
        "vehicleSubType": vehicleSubType,
        "vehicleColor": vehicleColor,
        "vehicleModel": vehicleModel,
        "vehicleYear": vehicleYear,
        "vehicleCapacity": vehicleCapacity,
        "vehicleStatus": vehicleStatus,
        "vehicleNumberImage": vehicleNumberImage,
        "rcImage": rcImage,
        "vehicleInsuraneImage": vehicleInsuraneImage,
        "driverId": driverId,
        "createdBy": createdBy,
        "createdByModel": createdByModel,
        "disable": disable,
        "verificationStatus": verificationStatus,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class DriverId {
  String? id;
  String? phone;
  String? gender;
  dynamic phoneOtp;
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
  String? dateOfBirth;

  DriverId({
    this.id,
    this.phone,
    this.gender,
    this.phoneOtp,
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
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        id: json["_id"],
        phone: json["phone"],
        gender: json["gender"],
        phoneOtp: json["phoneOtp"],
        imageVerificationStatus: json["imageVerificationStatus"],
        startDuty: json["startDuty"],
        rating: json["rating"]?.toDouble(),
        verificationStatus: json["verificationStatus"],
        isCancelledAnyOrder: json["isCancelledAnyOrder"],
        disable: json["disable"],
        isProfileCompleted: json["isProfileCompleted"],
        preference: json["preference"],
        totalRating: json["totalRating"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        dlImage: json["DLImage"],
        panImage: json["PANImage"],
        aadharImageBack: json["aadharImageBack"],
        aadharImageFront: json["aadharImageFront"],
        email: json["email"],
        name: json["name"],
        image: json["image"],
        dateOfBirth: json["dateOfBirth"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "phone": phone,
        "gender": gender,
        "phoneOtp": phoneOtp,
        "imageVerificationStatus": imageVerificationStatus,
        "startDuty": startDuty,
        "rating": rating,
        "verificationStatus": verificationStatus,
        "isCancelledAnyOrder": isCancelledAnyOrder,
        "disable": disable,
        "isProfileCompleted": isProfileCompleted,
        "preference": preference,
        "totalRating": totalRating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "DLImage": dlImage,
        "PANImage": panImage,
        "aadharImageBack": aadharImageBack,
        "aadharImageFront": aadharImageFront,
        "email": email,
        "name": name,
        "image": image,
        "dateOfBirth": dateOfBirth,
      };
}

class DriverRelation {
  bool? isCurrentDriver;
  bool? didCancel;
  CancellationHistory? cancellationDetails;

  DriverRelation({
    this.isCurrentDriver,
    this.didCancel,
    this.cancellationDetails,
  });

  factory DriverRelation.fromJson(Map<String, dynamic> json) => DriverRelation(
        isCurrentDriver: json["isCurrentDriver"],
        didCancel: json["didCancel"],
        cancellationDetails: json["cancellationDetails"] == null
            ? null
            : CancellationHistory.fromJson(json["cancellationDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "isCurrentDriver": isCurrentDriver,
        "didCancel": didCancel,
        "cancellationDetails": cancellationDetails?.toJson(),
      };
}

class Location {
  String? address;
  String? type;
  List<double>? coordinates;

  Location({this.address, this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        address: json["address"],
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Ratings {
  String? id;
  String? userId;
  String? orderId;
  int? v;
  DateTime? createdAt;
  String? driverId;
  String? expreienceType;
  String? exprerienceDescription;
  int? rating;
  DateTime? updatedAt;

  Ratings({
    this.id,
    this.userId,
    this.orderId,
    this.v,
    this.createdAt,
    this.driverId,
    this.expreienceType,
    this.exprerienceDescription,
    this.rating,
    this.updatedAt,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
        id: json["_id"],
        userId: json["userId"],
        orderId: json["orderId"],
        v: json["__v"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        driverId: json["driverId"],
        expreienceType: json["expreienceType"],
        exprerienceDescription: json["exprerienceDescription"],
        rating: json["rating"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "orderId": orderId,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "driverId": driverId,
        "expreienceType": expreienceType,
        "exprerienceDescription": exprerienceDescription,
        "rating": rating,
        "updatedAt": updatedAt?.toIso8601String(),
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
        basePackageCost: json["basePackageCost"],
        extraTimeMinutes: json["extraTimeMinutes"],
        extraTimeCost: json["extraTimeCost"],
        includedKm: json["includedKm"],
        extraDistanceKm: json["extraDistanceKm"],
        extraDistanceCost: json["extraDistanceCost"],
        totalRentalCost: json["totalRentalCost"],
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
}

class UserId {
  String? id;
  String? name;
  int? phone;
  String? email;
  dynamic phoneOtp;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? referralRewardClaimed;
  dynamic referredBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? referralCode;
  int? v;
  String? gender;
  String? dateOfBirth;
  String? image;

  UserId({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.phoneOtp,
    this.isCancelledAnyOrder,
    this.disable,
    this.referralRewardClaimed,
    this.referredBy,
    this.createdAt,
    this.updatedAt,
    this.referralCode,
    this.v,
    this.gender,
    this.dateOfBirth,
    this.image,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        phoneOtp: json["phoneOtp"],
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
        v: json["__v"],
        gender: json["gender"],
        dateOfBirth: json["dateOfBirth"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "phoneOtp": phoneOtp,
        "isCancelledAnyOrder": isCancelledAnyOrder,
        "disable": disable,
        "referralRewardClaimed": referralRewardClaimed,
        "referredBy": referredBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "referralCode": referralCode,
        "__v": v,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "image": image,
      };
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? pages;

  Pagination({this.page, this.limit, this.total, this.pages});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "pages": pages,
      };
}