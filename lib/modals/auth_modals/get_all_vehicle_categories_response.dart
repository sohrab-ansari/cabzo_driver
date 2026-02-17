class GetAllVehicleCategoriesResponse {
  bool? success;
  String? message;
  List<Datum>? data;
  Pagination? pagination;

  GetAllVehicleCategoriesResponse({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetAllVehicleCategoriesResponse.fromJson(Map<String, dynamic> json) => 
    GetAllVehicleCategoriesResponse(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null 
          ? [] 
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      pagination: json["pagination"] == null 
          ? null 
          : Pagination.fromJson(json["pagination"]),
    );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null 
        ? [] 
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  String? id;
  String? cityId;
  String? name;
  String? image;
  int? minimumPrice;
  int? baseFare;
  bool? disable;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Datum({
    this.id,
    this.cityId,
    this.name,
    this.image,
    this.minimumPrice,
    this.baseFare,
    this.disable,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    cityId: json["cityId"],
    name: json["name"],
    image: json["image"],
    minimumPrice: json["minimumPrice"],
    baseFare: json["baseFare"],
    disable: json["disable"],
    createdAt: json["createdAt"] == null 
        ? null 
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null 
        ? null 
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "cityId": cityId,
    "name": name,
    "image": image,
    "minimumPrice": minimumPrice,
    "baseFare": baseFare,
    "disable": disable,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? pages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    pages: json["pages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
    "pages": pages,
  };
}