class VerifyOtpResponse {
  final bool? success;
  final String? orderId;
  final String? message;

  VerifyOtpResponse({this.success, this.orderId, this.message});

  /// FROM JSON
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] as bool?,
      orderId: json['orderId'] as String?,
      message: json['message'] as String?,
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'orderId': orderId, 'message': message};
  }

  /// OPTIONAL (very useful for Cubit/BLoC)
  VerifyOtpResponse copyWith({
    bool? success,
    String? orderId,
    String? message,
  }) {
    return VerifyOtpResponse(
      success: success ?? this.success,
      orderId: orderId ?? this.orderId,
      message: message ?? this.message,
    );
  }
}
