class AddMoneyWalletResponse {
  bool? success;
  String? message;
  AddMoneyData? data;

  AddMoneyWalletResponse({
    this.success,
    this.message,
    this.data,
  });

  factory AddMoneyWalletResponse.fromJson(Map<String, dynamic> json) {
    return AddMoneyWalletResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? AddMoneyData.fromJson(json['data'])
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


class AddMoneyData {
  String? orderId;
  String? amount;
  String? currency;
  String? razorpayKeyId;

  AddMoneyData({
    this.orderId,
    this.amount,
    this.currency,
    this.razorpayKeyId,
  });

  factory AddMoneyData.fromJson(Map<String, dynamic> json) {
    return AddMoneyData(
      orderId: json['orderId'],
      amount: json['amount'],
      currency: json['currency'],
      razorpayKeyId: json['razorpayKeyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'razorpayKeyId': razorpayKeyId,
    };
  }
}
