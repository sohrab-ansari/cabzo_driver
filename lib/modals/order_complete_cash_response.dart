class Ordercompletecashresponse {
  bool? success;
  String? message;
  Data? data;

  Ordercompletecashresponse({
    this.success,
    this.message,
    this.data,
  });

  factory Ordercompletecashresponse.fromJson(Map<String, dynamic> json) {
    return Ordercompletecashresponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
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

class Data {
  String? orderId;
  double? amount;
  Transaction? transaction;

  Data({
    this.orderId,
    this.amount,
    this.transaction,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      orderId: json['orderId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'transaction': transaction?.toJson(),
    };
  }
}

class Transaction {
  String? userId;
  String? orderId;
  String? title;
  String? description;
  double? amount;
  String? type;
  String? transactionType;
  String? status;
  String? category;
  String? paymentMethod;
  int? discountAmount;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Transaction({
    this.userId,
    this.orderId,
    this.title,
    this.description,
    this.amount,
    this.type,
    this.transactionType,
    this.status,
    this.category,
    this.paymentMethod,
    this.discountAmount,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json['userId'] as String?,
      orderId: json['orderId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      type: json['type'] as String?,
      transactionType: json['transactionType'] as String?,
      status: json['status'] as String?,
      category: json['category'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      discountAmount: json['discountAmount'] as int?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'transactionType': transactionType,
      'status': status,
      'category': category,
      'paymentMethod': paymentMethod,
      'discountAmount': discountAmount,
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}