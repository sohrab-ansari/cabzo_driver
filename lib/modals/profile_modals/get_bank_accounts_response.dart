// class GetBankAccountsResponse {
//   bool? success;
//   String? message;
//   int? count;
//   List<BankAccount>? data;

//   GetBankAccountsResponse({
//     this.success,
//     this.message,
//     this.count,
//     this.data,
//   });

//   factory GetBankAccountsResponse.fromJson(Map<String, dynamic> json) {
//     return GetBankAccountsResponse(
//       success: json['success'],
//       message: json['message'],
//       count: json['count'],
//       data: json['data'] != null
//           ? List<BankAccount>.from(
//               json['data'].map((x) => BankAccount.fromJson(x)))
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'count': count,
//       'data': data?.map((x) => x.toJson()).toList(),
//     };
//   }
// }

// class BankAccount {
//   String? id;
//   Driver? driverId;
//   String? bankName;
//   String? accountNumber;
//   String? ifscCode;
//   String? accountHolderName;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;

//   BankAccount({
//     this.id,
//     this.driverId,
//     this.bankName,
//     this.accountNumber,
//     this.ifscCode,
//     this.accountHolderName,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory BankAccount.fromJson(Map<String, dynamic> json) {
//     return BankAccount(
//       id: json['_id'],
//       driverId: json['driverId'] != null
//           ? Driver.fromJson(json['driverId'])
//           : null,
//       bankName: json['bankName'],
//       accountNumber: json['accountNumber'],
//       ifscCode: json['ifscCode'],
//       accountHolderName: json['accountHolderName'],
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : null,
//       v: json['__v'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'driverId': driverId?.toJson(),
//       'bankName': bankName,
//       'accountNumber': accountNumber,
//       'ifscCode': ifscCode,
//       'accountHolderName': accountHolderName,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       '__v': v,
//     };
//   }
// }

// class Driver {
//   String? id;
//   String? phone;
//   String? name;

//   Driver({
//     this.id,
//     this.phone,
//     this.name,
//   });

//   factory Driver.fromJson(Map<String, dynamic> json) {
//     return Driver(
//       id: json['_id'],
//       phone: json['phone'],
//       name: json['name'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'phone': phone,
//       'name': name,
//     };
//   }
// }

class GetBankAccountsResponse {
  bool? success;
  String? message;
  int? count;
  List<BankAccount>? data;

  GetBankAccountsResponse({this.success, this.message, this.count, this.data});

  static GetBankAccountsResponse fromJson(Map<String, dynamic> json) {
    return GetBankAccountsResponse(
      success: json['success'],
      message: json['message'],
      count: (json['count'] as num?)?.toInt(),
      data: json['data'] != null
          ? List<BankAccount>.from(
              json['data'].map((x) => BankAccount.fromJson(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'count': count,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class BankAccount {
  String? id;
  Driver? driverId;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  String? type;
  String? upiId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  BankAccount({
    this.id,
    this.driverId,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.type,
    this.upiId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  static BankAccount fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'],
      driverId: json['driverId'] != null
          ? Driver.fromJson(json['driverId'])
          : null,
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      accountHolderName: json['accountHolderName'],
      type: json['type'],
      upiId: json['upiId'],
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
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'accountHolderName': accountHolderName,
      'type': type,
      'upiId': upiId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Driver {
  String? id;
  String? phone;
  String? name;

  Driver({this.id, this.phone, this.name});

  static Driver fromJson(Map<String, dynamic> json) {
    return Driver(id: json['_id'], phone: json['phone'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'phone': phone, 'name': name};
  }
}
