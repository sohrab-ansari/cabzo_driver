class Drivertoggledutyresponse {
  bool? success;
  String? message;
  Driver? driver;

  Drivertoggledutyresponse({
    this.success,
    this.message,
    this.driver,
  });

  factory Drivertoggledutyresponse.fromJson(Map<String, dynamic> json) {
    return Drivertoggledutyresponse(
      success: json['success'],
      message: json['message'],
      driver:
          json['driver'] != null ? Driver.fromJson(json['driver']) : null,
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
  String? gender;
  String? imageVerificationStatus;
  bool? startDuty;
  double? rating;
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
  String? driverId;

  Driver({
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
    this.driverId,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      phoneOtp: json['phoneOtp'],
      id: json['_id'],
      phone: json['phone'],
      gender: json['gender'],
      imageVerificationStatus: json['imageVerificationStatus'],
      startDuty: json['startDuty'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      verificationStatus: json['verificationStatus'],
      isCancelledAnyOrder: json['isCancelledAnyOrder'],
      disable: json['disable'],
      isProfileCompleted: json['isProfileCompleted'],
      preference: json['preference'],
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
      aadharNumber: json['aadharNumber'],
      email: json['email'],
      name: json['name'],
      panNumber: json['panNumber'],
      image: json['image'],
      totalRating: json['totalRating'],
      driverId: json['driverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'dlImage': dlImage,
      'panImage': panImage,
      'aadharImageBack': aadharImageBack,
      'aadharImageFront': aadharImageFront,
      'aadharNumber': aadharNumber,
      'email': email,
      'name': name,
      'panNumber': panNumber,
      'image': image,
      'totalRating': totalRating,
      'driverId': driverId,
    };
  }
}
