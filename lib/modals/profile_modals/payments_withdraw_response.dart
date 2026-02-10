
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

  WithdrawData({
    this.amount,
    this.transactionType,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) {
    return WithdrawData(
      amount: json['amount'],
      transactionType: json['transactionType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'transactionType': transactionType,
    };
  }
}