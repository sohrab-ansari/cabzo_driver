class ReviewRatingResponse {
  bool? success;
  String? message;
  List<ReviewRating>? data;

  ReviewRatingResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ReviewRatingResponse.fromJson(Map<String, dynamic> json) {
    return ReviewRatingResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<ReviewRating>.from(
              json['data'].map((x) => ReviewRating.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class ReviewRating {
  String? id;
  String? orderId;
  User? user;
  String? driverId;
  String? experienceType;
  String? experienceDescription;
  int? rating;

  ReviewRating({
    this.id,
    this.orderId,
    this.user,
    this.driverId,
    this.experienceType,
    this.experienceDescription,
    this.rating,
  });

  factory ReviewRating.fromJson(Map<String, dynamic> json) {
    return ReviewRating(
      id: json['_id'],
      orderId: json['orderId'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      driverId: json['driverId'],
      experienceType: json['expreienceType'],
      experienceDescription: json['exprerienceDescription'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'userId': user?.toJson(),
      'driverId': driverId,
      'expreienceType': experienceType,
      'exprerienceDescription': experienceDescription,
      'rating': rating,
    };
  }
}

class User {
  String? id;
  String? name;
  int? phone;

  User({
    this.id,
    this.name,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
    };
  }
}
