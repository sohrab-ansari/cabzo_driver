
// class PaymentsWithdrawResponse {
//   bool? success;
//   String? message;
//   WithdrawData? data;

//   PaymentsWithdrawResponse({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory PaymentsWithdrawResponse.fromJson(Map<String, dynamic> json) {
//     return PaymentsWithdrawResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null
//           ? WithdrawData.fromJson(json['data'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }

// class WithdrawData {
//   num? amount;
//   String? transactionType;

//   WithdrawData({
//     this.amount,
//     this.transactionType,
//   });

//   factory WithdrawData.fromJson(Map<String, dynamic> json) {
//     return WithdrawData(
//       amount: json['amount'],
//       transactionType: json['transactionType'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'amount': amount,
//       'transactionType': transactionType,
//     };
//   }
// }

class PaymentsWithdrawResponse {
  bool? success;
  String? message;
  WithdrawData? data;

  PaymentsWithdrawResponse({
    this.success,
    this.message,
    this.data,
  });

  factory PaymentsWithdrawResponse.fromJson(Map<String, dynamic> json) {
    return PaymentsWithdrawResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? WithdrawData.fromJson(json['data'])
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

class WithdrawData {
  num? amount;
  String? transactionType;
  num? newBalance;
  num? totalExpenses;

  WithdrawData({
    this.amount,
    this.transactionType,
    this.newBalance,
    this.totalExpenses,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) {
    return WithdrawData(
      // Handle amount - convert from String to num
      amount: json['amount'] != null 
          ? _parseToNum(json['amount'])
          : null,
      
      transactionType: json['transactionType'] as String?,
      
      // Handle newBalance if present in response
      newBalance: json['newBalance'] != null 
          ? _parseToNum(json['newBalance'])
          : null,
      
      // Handle totalExpenses if present in response
      totalExpenses: json['totalExpenses'] != null 
          ? _parseToNum(json['totalExpenses'])
          : null,
    );
  }

  // Helper method to safely parse any value to num
  static num? _parseToNum(dynamic value) {
    if (value == null) return null;
    
    if (value is num) {
      return value;
    } else if (value is String) {
      return num.tryParse(value);
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value;
    }
    
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount?.toString(),
      'transactionType': transactionType,
      'newBalance': newBalance?.toString(),
      'totalExpenses': totalExpenses?.toString(),
    };
  }
}