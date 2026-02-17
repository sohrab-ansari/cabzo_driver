class Getpromocodedata {
    bool? success;
    List<Datum>? data;
    String? message;

    Getpromocodedata({
        this.success,
        this.data,
        this.message,
    });

    factory Getpromocodedata.fromJson(Map<String, dynamic> json) => Getpromocodedata(
        success: json["success"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    String? id;
    String? code;
    String? description;
    int? discountInPercentage;
    dynamic flatDiscountAmount;
    String? userType;
    int? minAmount;
    int? maxDiscountAmount;
    String? category;
    dynamic cityId;
    DateTime? startDate;
    DateTime? expiryDate;
    bool? disabled;
    int? allowedTimes;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    Datum({
        this.id,
        this.code,
        this.description,
        this.discountInPercentage,
        this.flatDiscountAmount,
        this.userType,
        this.minAmount,
        this.maxDiscountAmount,
        this.category,
        this.cityId,
        this.startDate,
        this.expiryDate,
        this.disabled,
        this.allowedTimes,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        code: json["code"],
        description: json["description"],
        discountInPercentage: json["discountInPercentage"],
        flatDiscountAmount: json["flatDiscountAmount"],
        userType: json["userType"],
        minAmount: json["minAmount"],
        maxDiscountAmount: json["maxDiscountAmount"],
        category: json["category"],
        cityId: json["cityId"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
        disabled: json["disabled"],
        allowedTimes: json["allowedTimes"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "description": description,
        "discountInPercentage": discountInPercentage,
        "flatDiscountAmount": flatDiscountAmount,
        "userType": userType,
        "minAmount": minAmount,
        "maxDiscountAmount": maxDiscountAmount,
        "category": category,
        "cityId": cityId,
        "startDate": startDate?.toIso8601String(),
        "expiryDate": expiryDate?.toIso8601String(),
        "disabled": disabled,
        "allowedTimes": allowedTimes,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}