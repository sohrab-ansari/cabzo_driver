class TransactionsResponse {
  bool? success;
  String? message;
  List<TransactionData>? data;
  Pagination? pagination;

  TransactionsResponse({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<TransactionData>.from(
              json['data'].map((x) => TransactionData.fromJson(x)),
            )
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}



class TransactionData {
  String? id;
  DriverId? driverId;
  String? orderId;
  String? title;
  String? description;
  double? amount;
  String? type;
  String? transactionType;
  String? status;
  String? category;
  String? paymentMethod;
  String? transactionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  TransactionData({
    this.id,
    this.driverId,
    this.orderId,
    this.title,
    this.description,
    this.amount,
    this.type,
    this.transactionType,
    this.status,
    this.category,
    this.paymentMethod,
    this.transactionId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['_id'],
      driverId:
          json['driverId'] != null ? DriverId.fromJson(json['driverId']) : null,
      orderId: json['orderId'],
      title: json['title'],
      description: json['description'],
      amount: (json['amount'] as num?)?.toDouble(),
      type: json['type'],
      transactionType: json['transactionType'],
      status: json['status'],
      category: json['category'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: (json['__v'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverId': driverId?.toJson(),
      'orderId': orderId,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'transactionType': transactionType,
      'status': status,
      'category': category,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}


class DriverId {
  String? id;
  String? phone;
  String? email;
  String? name;

  DriverId({
    this.id,
    this.phone,
    this.email,
    this.name,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) {
    return DriverId(
      id: json['_id'] ?? json['id'],
      phone: json['phone'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'phone': phone,
      'email': email,
      'name': name,
    };
  }
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

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'pages': pages,
    };
  }
}
