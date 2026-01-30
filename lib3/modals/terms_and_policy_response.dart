class Termsandpolicyresponse {
  bool? success;
  String? message;
  Data? data;

  Termsandpolicyresponse({
    this.success,
    this.message,
    this.data,
  });

  factory Termsandpolicyresponse.fromJson(Map<String, dynamic> json) =>
      Termsandpolicyresponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  String? id;
  String? companyName;
  String? address;
  String? contactNumber;
  String? whatsappNumber;
  String? privacyPolicy;
  String? termAndCondition;
  String? helpandSupport;
  String? aboutUs;
  String? supportEmail;
  String? description;
  String? logo;
  String? favIcon;
  String? website;
  String? timing;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? driverCommision;

  Data({
    this.id,
    this.companyName,
    this.address,
    this.contactNumber,
    this.whatsappNumber,
    this.privacyPolicy,
    this.termAndCondition,
    this.helpandSupport,
    this.aboutUs,
    this.supportEmail,
    this.description,
    this.logo,
    this.favIcon,
    this.website,
    this.timing,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.driverCommision,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        companyName: json["companyName"],
        address: json["address"],
        contactNumber: json["contactNumber"],
        whatsappNumber: json["whatsappNumber"],
        privacyPolicy: json["privacyPolicy"],
        termAndCondition: json["termAndCondition"],
        helpandSupport: json["helpandSupport"],
        aboutUs: json["aboutUs"],
        supportEmail: json["supportEmail"],
        description: json["description"],
        logo: json["logo"],
        favIcon: json["favIcon"],
        website: json["website"],
        timing: json["timing"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        driverCommision: json["driverCommision"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "companyName": companyName,
        "address": address,
        "contactNumber": contactNumber,
        "whatsappNumber": whatsappNumber,
        "privacyPolicy": privacyPolicy,
        "termAndCondition": termAndCondition,
        "helpandSupport": helpandSupport,
        "aboutUs": aboutUs,
        "supportEmail": supportEmail,
        "description": description,
        "logo": logo,
        "favIcon": favIcon,
        "website": website,
        "timing": timing,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "driverCommision": driverCommision,
      };
}