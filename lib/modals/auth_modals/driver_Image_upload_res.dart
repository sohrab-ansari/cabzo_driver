class DriverImageUploadRes {
  bool? success;
  String? message;
  Driver? driver;

  DriverImageUploadRes({
    this.success,
    this.message,
    this.driver,
  });

  factory DriverImageUploadRes.fromJson(Map<String, dynamic> json) {
    return DriverImageUploadRes(
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
  String? id;
  String? phone;
  String? gender;
  String? email;
  String? name;
  String? image;

  String? dlImage;
  String? panImage;
  String? aadharImageFront;
  String? aadharImageBack;

  String? imageVerificationStatus;
  String? verificationStatus;
  String? preference;

  bool? startDuty;
  bool? isCancelledAnyOrder;
  bool? disable;
  bool? isProfileCompleted;

  int? rating;
  String? createdAt;
  String? updatedAt;
  int? v;

  Driver({
    this.id,
    this.phone,
    this.gender,
    this.email,
    this.name,
    this.image,
    this.dlImage,
    this.panImage,
    this.aadharImageFront,
    this.aadharImageBack,
    this.imageVerificationStatus,
    this.verificationStatus,
    this.preference,
    this.startDuty,
    this.isCancelledAnyOrder,
    this.disable,
    this.isProfileCompleted,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['_id'] ?? json['id'],
      phone: json['phone'],
      gender: json['gender'],
      email: json['email'],
      name: json['name'],
      image: json['image'],

      dlImage: json['DLImage'],
      panImage: json['PANImage'],
      aadharImageFront: json['aadharImageFront'],
      aadharImageBack: json['aadharImageBack'],

      imageVerificationStatus: json['imageVerificationStatus'],
      verificationStatus: json['verificationStatus'],
      preference: json['preference'],

      startDuty: json['startDuty'],
      isCancelledAnyOrder: json['isCancelledAnyOrder'],
      disable: json['disable'],
      isProfileCompleted: json['isProfileCompleted'],

      rating: json['rating'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'gender': gender,
      'email': email,
      'name': name,
      'image': image,

      'DLImage': dlImage,
      'PANImage': panImage,
      'aadharImageFront': aadharImageFront,
      'aadharImageBack': aadharImageBack,

      'imageVerificationStatus': imageVerificationStatus,
      'verificationStatus': verificationStatus,
      'preference': preference,

      'startDuty': startDuty,
      'isCancelledAnyOrder': isCancelledAnyOrder,
      'disable': disable,
      'isProfileCompleted': isProfileCompleted,

      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
