class BankAccountAddResp {
  bool? success;
  String? message;
  BankAccountData? data;

  BankAccountAddResp({
    this.success,
    this.message,
    this.data,
  });

  factory BankAccountAddResp.fromJson(Map<String, dynamic> json) {
    return BankAccountAddResp(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? BankAccountData.fromJson(json['data'])
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

class BankAccountData {
  String? driverId;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  BankAccountData({
    this.driverId,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory BankAccountData.fromJson(Map<String, dynamic> json) {
    return BankAccountData(
      driverId: json['driverId'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      accountHolderName: json['accountHolderName'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'accountHolderName': accountHolderName,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
