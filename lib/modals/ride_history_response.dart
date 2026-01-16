class RideHistoryResponse {
  bool? success;
  String? message;
  List<RideHistory>? data;
  Pagination? pagination;

  RideHistoryResponse({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory RideHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RideHistoryResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => RideHistory.fromJson(e))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}


class RideHistory {
  String? id;
  User? user;
  Driver? driver;
  String? orderStatus;
  double? distance;
  int? duration;
  int? totalFare;
  String? paymentMethod;
  String? orderType;
  String? rideOtp;
  DateTime? createdAt;

  RideHistory({
    this.id,
    this.user,
    this.driver,
    this.orderStatus,
    this.distance,
    this.duration,
    this.totalFare,
    this.paymentMethod,
    this.orderType,
    this.rideOtp,
    this.createdAt,
  });

  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      id: json['_id'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      driver: json['driverId'] != null ? Driver.fromJson(json['driverId']) : null,
      orderStatus: json['orderStatus'],
      distance: (json['distance'] as num?)?.toDouble(),
      duration: json['duration'],
      totalFare: json['totalFare'],
      paymentMethod: json['paymentMethod'],
      orderType: json['orderType'],
      rideOtp: json['rideOtp'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}



class User {
  String? id;
  String? name;
  String? email;
  int? phone;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}



class Driver {
  String? id;
  String? name;
  String? phone;
  String? image;
  bool? startDuty;
  String? verificationStatus;
  String? imageVerificationStatus;

  Driver({
    this.id,
    this.name,
    this.phone,
    this.image,
    this.startDuty,
    this.verificationStatus,
    this.imageVerificationStatus,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      startDuty: json['startDuty'],
      verificationStatus: json['verificationStatus'],
      imageVerificationStatus: json['imageVerificationStatus'],
    );
  }
}



class Pagination {
  int? page;
  int? limit;
  int? total;
  int? pages;

  Pagination({
    this.page,
    this.limit,
    this.total,
    this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }
}
