class FaqsCategoriesResponse {
  bool? success;
  String? message;
  List<FaqsCategory>? categories;

  FaqsCategoriesResponse({
    this.success,
    this.message,
    this.categories,
  });

  factory FaqsCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return FaqsCategoriesResponse(
      success: json['success'],
      message: json['message'],
      categories: json['data'] != null
          ? (json['data'] as List)
              .map((item) => FaqsCategory.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': categories?.map((category) => category.toJson()).toList(),
    };
  }
}

class FaqsCategory {
  String? id;
  String? name;
  String? image;
  bool? disabled;
  int? v;

  FaqsCategory({
    this.id,
    this.name,
    this.image,
    this.disabled,
    this.v,
  });

  factory FaqsCategory.fromJson(Map<String, dynamic> json) {
    return FaqsCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      disabled: json['disabled'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'disabled': disabled,
      '__v': v,
    };
  }
}