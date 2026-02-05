import 'dart:convert';

class GetAllsubVehicleCategoriesResponse {
  bool? success;
  String? message;
  List<Datum>? data;
  Pagination? pagination;

  GetAllsubVehicleCategoriesResponse({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory GetAllsubVehicleCategoriesResponse.fromJson(Map<String, dynamic> json) => 
      GetAllsubVehicleCategoriesResponse(
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
  Datum? vehicleCategoryId;
  String? name;
  String? image;
  int? minimumPrice;
  int? baseFare;
  bool? disable;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic cityId;

  Datum({
    this.id,
    this.vehicleCategoryId,
    this.name,
    this.image,
    this.minimumPrice,
    this.baseFare,
    this.disable,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.cityId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        vehicleCategoryId: json["vehicleCategoryId"] == null 
            ? null 
            : Datum.fromJson(json["vehicleCategoryId"]),
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
        cityId: json["cityId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "vehicleCategoryId": vehicleCategoryId?.toJson(),
        "name": name,
        "image": image,
        "minimumPrice": minimumPrice,
        "baseFare": baseFare,
        "disable": disable,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "cityId": cityId,
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

// Example usage:
void main() {
  // Parse JSON string to object
  String jsonString = '{"success":true,"message":"Success","data":[{"_id":"1","name":"Sedan","minimumPrice":100}],"pagination":{"total":10,"page":1,"limit":10,"pages":1}}';
  
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  GetAllsubVehicleCategoriesResponse response = GetAllsubVehicleCategoriesResponse.fromJson(jsonMap);
  
  print('Success: ${response.success}');
  print('First item name: ${response.data?[0].name}');
  
  // Convert object back to JSON
  Map<String, dynamic> backToJson = response.toJson();
  print('Back to JSON: ${jsonEncode(backToJson)}');
}