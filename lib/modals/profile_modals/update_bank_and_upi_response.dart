class UpdateBankAndUpiResponse {
  bool? success;
  String? message;
  BankAndUpiData? data;

  UpdateBankAndUpiResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UpdateBankAndUpiResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBankAndUpiResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? BankAndUpiData.fromJson(json['data'])
          : null,
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

class BankAndUpiData {
  String? id;
  String? driverId;
  String? type;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? upiId;
  String? createdAt;
  String? updatedAt;
  int? v;

  BankAndUpiData({
    this.id,
    this.driverId,
    this.type,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.upiId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BankAndUpiData.fromJson(Map<String, dynamic> json) {
    return BankAndUpiData(
      id: json['_id'],
      driverId: json['driverId'],
      type: json['type'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      accountHolderName: json['accountHolderName'],
      upiId: json['upiId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'driverId': driverId,
      'type': type,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'accountHolderName': accountHolderName,
      'upiId': upiId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}