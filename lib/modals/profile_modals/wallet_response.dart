// wallet_response.dart

class WalletResponse {
  bool? success;
  String? message;
  WalletData? data;

  WalletResponse({
    this.success,
    this.message,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? WalletData.fromJson(json['data'])
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

class WalletData {
  String? walletId;
  double? walletBalance;
  double? availableBalance;
  double? pendingWithdrawals;
  double? minimumBalanceForOrder;
  double? totalExpenses;
  double? driverDebtBalance;

  WalletData({
    this.walletId,
    this.walletBalance,
    this.availableBalance,
    this.pendingWithdrawals,
    this.minimumBalanceForOrder,
    this.totalExpenses,
    this.driverDebtBalance,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      walletId: json['walletId'],
      walletBalance: (json['walletBalance'] as num?)?.toDouble(),
      availableBalance: (json['availableBalance'] as num?)?.toDouble(),
      pendingWithdrawals:
          (json['pendingWithdrawals'] as num?)?.toDouble(),
      minimumBalanceForOrder:
          (json['minimumBalanceForOrder'] as num?)?.toDouble(),
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
      driverDebtBalance: (json['driverDebtBalance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'walletBalance': walletBalance,
      'availableBalance': availableBalance,
      'pendingWithdrawals': pendingWithdrawals,
      'minimumBalanceForOrder': minimumBalanceForOrder,
      'totalExpenses': totalExpenses,
      'driverDebtBalance': driverDebtBalance,
    };
  }
}
