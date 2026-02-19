class GetCityByLocationResponse {
  bool? success;
  String? message;
  CityData? data;

  GetCityByLocationResponse({
    this.success,
    this.message,
    this.data,
  });

  factory GetCityByLocationResponse.fromJson(Map<String, dynamic> json) {
    return GetCityByLocationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CityData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CityData {
  Location? location;
  String? id;
  String? name;
  String? state;
  int? radius;
  bool? disabled;
  String? country;
  String? createdAt;
  String? updatedAt;
  int? v;

  CityData({
    this.location,
    this.id,
    this.name,
    this.state,
    this.radius,
    this.disabled,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      id: json['_id'],
      name: json['name'],
      state: json['state'],
      radius: json['radius'],
      disabled: json['disabled'],
      country: json['country'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      '_id': id,
      'name': name,
      'state': state,
      'radius': radius,
      'disabled': disabled,
      'country': country,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'] != null 
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}