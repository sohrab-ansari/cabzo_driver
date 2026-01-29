class RegisterProfileRes {
  bool? success;
  String? message;
  DriverProfile? data;

  RegisterProfileRes({
    this.success,
    this.message,
    this.data,
  });

  factory RegisterProfileRes.fromJson(Map<String, dynamic> json) {
    return RegisterProfileRes(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? DriverProfile.fromJson(json['data']) : null,
    );
  }
}

class DriverProfile {
  String? id;
  String? phone;
  String? name;
  String? email;
  String? gender;

  String? imageVerificationStatus;
  String? verificationStatus;

  bool? startDuty;
  bool? disable;
  bool? isProfileCompleted;
  bool? isCancelledAnyOrder;

  int? rating;
  String? preference;

  String? dlImage;
  String? panImage;
  String? aadharImageFront;
  String? aadharImageBack;

  String? createdAt;
  String? updatedAt;

  DriverProfile({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.gender,
    this.imageVerificationStatus,
    this.verificationStatus,
    this.startDuty,
    this.disable,
    this.isProfileCompleted,
    this.isCancelledAnyOrder,
    this.rating,
    this.preference,
    this.dlImage,
    this.panImage,
    this.aadharImageFront,
    this.aadharImageBack,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['_id'],
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      imageVerificationStatus: json['imageVerificationStatus'],
      verificationStatus: json['verificationStatus'],
      startDuty: json['startDuty'],
      disable: json['disable'],
      isProfileCompleted: json['isProfileCompleted'],
      isCancelledAnyOrder: json['isCancelledAnyOrder'],
      rating: json['rating'],
      preference: json['preference'],
      dlImage: json['DLImage'],
      panImage: json['PANImage'],
      aadharImageFront: json['aadharImageFront'],
      aadharImageBack: json['aadharImageBack'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
