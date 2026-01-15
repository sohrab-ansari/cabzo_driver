

class OtpverifyRes {
  bool? success;
  String? message;
  String? token;
  Driver? driver;

  OtpverifyRes({
    this.success,
    this.message,
    this.token,
    this.driver,
  });

  factory OtpverifyRes.fromJson(Map<String, dynamic> json) {
    return OtpverifyRes(
      success: json['success'],
      message: json['message'],
      token: json['token'],
      driver:
          json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'driver': driver?.toJson(),
    };
  }
}

class Driver {
  String? id;
  String? phone;
  String? imageVerificationStatus;
  dynamic isProfileCompleted; // Could be bool or string

  Driver({
    this.id,
    this.phone,
    this.imageVerificationStatus,
    this.isProfileCompleted,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'],
      phone: json['phone'],
      imageVerificationStatus: json['imageVerificationStatus'],
      isProfileCompleted: json['isProfileCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'imageVerificationStatus': imageVerificationStatus,
      'isProfileCompleted': isProfileCompleted,
    };
  }
}