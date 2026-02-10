class AddMoneyWalletResponse {
  bool? success;
  String? message;
  AddMoneyData? data;

  AddMoneyWalletResponse({this.success, this.message, this.data});

  factory AddMoneyWalletResponse.fromJson(Map<String, dynamic> json) {
    return AddMoneyWalletResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? AddMoneyData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class AddMoneyData {
  String? orderId;
  int? amount; // Changed to int to match API response
  String? currency;
  String? razorpayKeyId;

  AddMoneyData({this.orderId, this.amount, this.currency, this.razorpayKeyId});

  factory AddMoneyData.fromJson(Map<String, dynamic> json) {
    // Handle amount which can come as int or double from API
    int? parsedAmount;
    if (json['amount'] != null) {
      if (json['amount'] is int) {
        parsedAmount = json['amount'];
      } else if (json['amount'] is double) {
        parsedAmount = (json['amount'] as double).toInt();
      } else if (json['amount'] is String) {
        parsedAmount = int.tryParse(json['amount']);
      }
    }

    return AddMoneyData(
      orderId: json['orderId']?.toString(),
      amount: parsedAmount,
      currency: json['currency']?.toString(),
      razorpayKeyId: json['razorpayKeyId']?.toString(),
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
