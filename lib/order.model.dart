class OrderDetailModel {
  final String? id;
  final String? userId;
  final String? vehicleType;
  final String? orderType;
  final String? orderStatus;
  final Map<String, dynamic>? startLocation;
  final Map<String, dynamic>? endLocation;
  final bool? otpVerified;
  final String? rideOtp;
  final double? distance;
  final int? duration;
  final String? paymentMethod;
  final String? createdAt;
  final String? vehicleNumber;
  final Map<String, dynamic>? driverId;
  final Map<String, dynamic>? vehicleId;
  final double? totalFare;
  final double? waitingCharge;
  final double? waitingTimeMinutes;
  final String? promoCode;
  final double? promoCodeDiscount;
  final double? pendingDue;
  final bool isScheduled;
  final String? scheduledStartTime;
  final num? bookedDurationHours;
  final num? actualDurationMinutes;
  final double? totalDistanceKm;
  final Map<String, dynamic>? rentalBillingDetails;
  final Map<String, dynamic>? waitingChargeDetails;
  OrderDetailModel({
    this.id,
    this.userId,
    this.vehicleType,
    this.orderType,
    this.orderStatus,
    this.startLocation,
    this.endLocation,
    this.otpVerified,
    this.rideOtp,
    this.distance,
    this.duration,
    this.paymentMethod,
    this.createdAt,
    this.vehicleNumber,
    this.driverId,
    this.vehicleId,
    this.totalFare,
    this.waitingCharge,
    this.waitingTimeMinutes,
    this.promoCode,
    this.promoCodeDiscount,
    this.pendingDue,
    this.isScheduled = false,
    this.scheduledStartTime,
    this.bookedDurationHours,
    this.actualDurationMinutes,
    this.totalDistanceKm,
    this.rentalBillingDetails,
    this.waitingChargeDetails,
  });
  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      vehicleType: json['vehicleType'] is String
          ? json['vehicleType']
          : json['vehicleType']?['_id'] ??
              (json['vehicleId'] != null
                  ? json['vehicleId']['vehicleType']
                  : null),
      orderType: json['orderType'],
      orderStatus: json['orderStatus'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      otpVerified: json['otpVerified'],
      rideOtp: json['rideOtp'],
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toInt(),
      paymentMethod: json['paymentMethod'],
      createdAt: json['createdAt'],
      vehicleNumber: json['vehicleId'] is Map<String, dynamic>
          ? json['vehicleId']['vehicleNumber']?.toString()
          : json['vehicleNumber']?.toString(),
      driverId: json['driverId'] is Map<String, dynamic>
          ? json['driverId']
          : null,
      vehicleId: json['vehicleId'] is Map<String, dynamic>
          ? json['vehicleId']
          : null,
      totalFare: (json['totalFare'] as num?)?.toDouble(),
      waitingCharge: (json['waitingCharge'] as num?)?.toDouble(),
      waitingTimeMinutes: (json['waitingTimeMinutes'] as num?)?.toDouble(),
      promoCode: json['promoCode'] as String?,
      promoCodeDiscount: (json['promoCodeDiscount'] as num?)?.toDouble(),
      pendingDue: (json['pendingDue'] as num?)?.toDouble(),
      isScheduled: json['isScheduled'] == true,
      scheduledStartTime: json['scheduledStartTime'],
      bookedDurationHours: json['bookedDurationHours'] as num?,
      actualDurationMinutes: json['actualDurationMinutes'] as num?,
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble(),
      rentalBillingDetails: json['rentalBillingDetails'],
      waitingChargeDetails: json['waitingChargeDetails'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (userId != null) 'userId': userId,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (orderType != null) 'orderType': orderType,
      if (orderStatus != null) 'orderStatus': orderStatus,
      if (startLocation != null) 'startLocation': startLocation,
      if (endLocation != null) 'endLocation': endLocation,
      if (otpVerified != null) 'otpVerified': otpVerified,
      if (rideOtp != null) 'rideOtp': rideOtp,
      if (distance != null) 'distance': distance,
      if (duration != null) 'duration': duration,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (createdAt != null) 'createdAt': createdAt,
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
      if (driverId != null) 'driverId': driverId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      if (totalFare != null) 'totalFare': totalFare,
      if (waitingCharge != null) 'waitingCharge': waitingCharge,
      if (waitingTimeMinutes != null) 'waitingTimeMinutes': waitingTimeMinutes,
      if (promoCode != null) 'promoCode': promoCode,
      if (promoCodeDiscount != null) 'promoCodeDiscount': promoCodeDiscount,
      if (pendingDue != null) 'pendingDue': pendingDue,
      if (isScheduled) 'isScheduled': isScheduled,
      if (scheduledStartTime != null) 'scheduledStartTime': scheduledStartTime,
      if (bookedDurationHours != null) 'bookedDurationHours': bookedDurationHours,
      if (actualDurationMinutes != null) 'actualDurationMinutes': actualDurationMinutes,
      if (totalDistanceKm != null) 'totalDistanceKm': totalDistanceKm,
      if (rentalBillingDetails != null) 'rentalBillingDetails': rentalBillingDetails,
      if (waitingChargeDetails != null) 'waitingChargeDetails': waitingChargeDetails,
    };
  }
}
