import 'dart:convert';

class Getchatidresposne {
  bool? success;
  String? message;
  Data? data;

  Getchatidresposne({this.success, this.message, this.data});

  factory Getchatidresposne.fromJson(Map<String, dynamic> json) {
    return Getchatidresposne(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class Data {
  String? orderId;
  double? amount;
  Transaction? transaction;

  Data({this.orderId, this.amount, this.transaction});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      orderId: json['orderId'],
      amount: json['amount']?.toDouble(),
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
      userId: json['userId'],
      orderId: json['orderId'],
      title: json['title'],
      description: json['description'],
      amount: json['amount']?.toDouble(),
      type: json['type'],
      transactionType: json['transactionType'],
      status: json['status'],
      category: json['category'],
      paymentMethod: json['paymentMethod'],
      discountAmount: json['discountAmount'],
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      v: json['__v'],
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
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
