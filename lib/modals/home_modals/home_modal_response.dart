class HomeModalResponse {
  bool? success;
  String? message;
  Driver? driver;
  DocumentSubmission? documentSubmission;
  TodayStats? todayStats;

  HomeModalResponse({
    this.success,
    this.message,
    this.driver,
    this.documentSubmission,
    this.todayStats,
    GetAllVehicleCategoriesresponse,
  });

  factory HomeModalResponse.fromJson(Map<String, dynamic> json) {
    return HomeModalResponse(
      success: json['success'],
      message: json['message'],
      driver: json['data'] != null && json['data']['driver'] != null
          ? Driver.fromJson(json['data']['driver'])
          : null,
      documentSubmission:
          json['data'] != null && json['data']['documentSubmission'] != null
          ? DocumentSubmission.fromJson(json['data']['documentSubmission'])
          : null,
      todayStats: json['data'] != null && json['data']['todayStats'] != null
          ? TodayStats.fromJson(json['data']['todayStats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'driver': driver?.toJson(),
        'documentSubmission': documentSubmission?.toJson(),
        'todayStats': todayStats?.toJson(),
      },
    };
  }
}

class Driver {
  String? id;
  String? name;
  String? image;
  bool? isOnline;
  String? verificationStatus;
  String? imageVerificationStatus;
  bool? willGetOrder;

  Driver({
    this.id,
    this.name,
    this.image,
    this.isOnline,
    this.verificationStatus,
    this.imageVerificationStatus,
    this.willGetOrder,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isOnline: json['isOnline'],
      verificationStatus: json['verificationStatus'],
      imageVerificationStatus: json['imageVerificationStatus'],
      willGetOrder: json['willGetOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'isOnline': isOnline,
      'verificationStatus': verificationStatus,
      'imageVerificationStatus': imageVerificationStatus,
      'willGetOrder': willGetOrder,
    };
  }
}

class DocumentSubmission {
  bool? isPending;
  String? status;
  String? message;

  DocumentSubmission({this.isPending, this.status, this.message});

  factory DocumentSubmission.fromJson(Map<String, dynamic> json) {
    return DocumentSubmission(
      isPending: json['isPending'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'isPending': isPending, 'status': status, 'message': message};
  }
}

class TodayStats {
  Earnings? earnings;
  Rides? rides;

  TodayStats({this.earnings, this.rides});

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      earnings: json['earnings'] != null
          ? Earnings.fromJson(json['earnings'])
          : null,
      rides: json['rides'] != null ? Rides.fromJson(json['rides']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'earnings': earnings?.toJson(), 'rides': rides?.toJson()};
  }
}

class Earnings {
  double? total;
  double? cash;
  double? online;

  Earnings({this.total, this.cash, this.online});

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      total: (json['total'] as num?)?.toDouble(),
      cash: (json['cash'] as num?)?.toDouble(),
      online: (json['online'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'cash': cash, 'online': online};
  }
}

class Rides {
  int? total;
  int? completed;
  int? cancelled;

  Rides({this.total, this.completed, this.cancelled});

  factory Rides.fromJson(Map<String, dynamic> json) {
    return Rides(
      total: json['total'],
      completed: json['completed'],
      cancelled: json['cancelled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'completed': completed, 'cancelled': cancelled};
  }
}
