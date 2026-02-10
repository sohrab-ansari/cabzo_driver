
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
  String? name;
  String? phone;
  String? email;
  String? image;
  String? imageVerificationStatus;
  String? profileVerificationStatus;
  String? vehicleVerificationStatus;
  String? isCompleteVerified;
  dynamic isProfileCompleted; // Could be bool or string

  Driver({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.image,
    this.imageVerificationStatus,
    this.profileVerificationStatus,
    this.vehicleVerificationStatus,
    this.isCompleteVerified,
    this.isProfileCompleted,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      imageVerificationStatus: json['imageVerificationStatus'],
      profileVerificationStatus: json['profileVerificationStatus'],
      vehicleVerificationStatus: json['vehicleVerificationStatus'],
      isCompleteVerified: json['isCompleteVerified'],
      isProfileCompleted: json['isProfileCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'imageVerificationStatus': imageVerificationStatus,
      'profileVerificationStatus': profileVerificationStatus,
      'vehicleVerificationStatus': vehicleVerificationStatus,
      'isCompleteVerified': isCompleteVerified,
      'isProfileCompleted': isProfileCompleted,
    };
  }
}