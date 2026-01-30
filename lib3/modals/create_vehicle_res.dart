

class CreateVehicleRes {
  bool? success;
  String? message;
  List<Vehicle>? vehicle;

  CreateVehicleRes({
    this.success,
    this.message,
    this.vehicle,
  });

  factory CreateVehicleRes.fromJson(Map<String, dynamic> json) {
    return CreateVehicleRes(
      success: json['success'],
      message: json['message'],
      vehicle: json['vehicle'] != null
          ? List<Vehicle>.from(
              json['vehicle'].map((x) => Vehicle.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'vehicle': vehicle?.map((x) => x.toJson()).toList(),
    };
  }
}

class Vehicle {
  String? id;
  String? vehicleName;
  String? vehicleNumber;
  String? vehicleType;
  String? vehicleColor;
  String? vehicleModel;
  int? vehicleYear;
  int? vehicleCapacity;
  String? vehicleStatus;
  String? driverId;
  String? createdBy;
  String? createdByModel;
  bool? disable;
  String? verificationStatus;
  String? createdAt;
  String? updatedAt;
  int? v;

  Vehicle({
    this.id,
    this.vehicleName,
    this.vehicleNumber,
    this.vehicleType,
    this.vehicleColor,
    this.vehicleModel,
    this.vehicleYear,
    this.vehicleCapacity,
    this.vehicleStatus,
    this.driverId,
    this.createdBy,
    this.createdByModel,
    this.disable,
    this.verificationStatus,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'],
      vehicleName: json['vehicleName'],
      vehicleNumber: json['vehicleNumber'],
      vehicleType: json['vehicleType'],
      vehicleColor: json['vehicleColor'],
      vehicleModel: json['vehicleModel'],
      vehicleYear: json['vehicleYear'],
      vehicleCapacity: json['vehicleCapacity'],
      vehicleStatus: json['vehicleStatus'],
      driverId: json['driverId'],
      createdBy: json['createdBy'],
      createdByModel: json['createdByModel'],
      disable: json['disable'],
      verificationStatus: json['verificationStatus'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleColor': vehicleColor,
      'vehicleModel': vehicleModel,
      'vehicleYear': vehicleYear,
      'vehicleCapacity': vehicleCapacity,
      'vehicleStatus': vehicleStatus,
      'driverId': driverId,
      'createdBy': createdBy,
      'createdByModel': createdByModel,
      'disable': disable,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

