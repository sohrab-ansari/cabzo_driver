import 'dart:convert';

OtpverifyRes otpverifyResFromJson(String str) =>
    OtpverifyRes.fromJson(json.decode(str));

String otpverifyResToJson(OtpverifyRes data) =>
    json.encode(data.toJson());

class OtpverifyRes {
  bool? success;
  String? message;
  String? error; // ✅ IMPORTANT
  String? token;
  Driver? driver;

  OtpverifyRes({
    this.success,
    this.message,
    this.error,
    this.token,
    this.driver,
  });

  factory OtpverifyRes.fromJson(Map<String, dynamic> json) {
    return OtpverifyRes(
      success: json["success"],
      message: json["message"],
      error: json["error"], // ✅ handle error case
      token: json["token"],
      driver:
          json["driver"] != null ? Driver.fromJson(json["driver"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "error": error,
        "token": token,
        "driver": driver?.toJson(),
      };
}

class Driver {
  String? id;
  String? name;
  String? phone;
  String? imageVerificationStatus;
  String? email;
  bool? isProfileCompleted;

  Driver({
    this.id,
    this.name,
    this.phone,
    this.imageVerificationStatus,
    this.email,
    this.isProfileCompleted,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["id"],
        name: json["name"], // may be null
        phone: json["phone"],
        imageVerificationStatus: json["imageVerificationStatus"],
        email: json["email"], // may be null
        isProfileCompleted: json["isProfileCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "imageVerificationStatus": imageVerificationStatus,
        "email": email,
        "isProfileCompleted": isProfileCompleted,
      };
}
