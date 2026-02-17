class GetByCategoryResponse {
  bool? success;
  String? message;
  List<GetByCategoryQuestion>? questions;
  int? count;

  GetByCategoryResponse({
    this.success, 
    this.message,
    this.questions,
    this.count,
  });

  factory GetByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return GetByCategoryResponse(
      success: json['success'],
      message: json['message'],
      count: json['count'],
      questions: json['data'] != null
          ? (json['data'] as List)
              .map((item) => GetByCategoryQuestion.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': questions?.map((question) => question.toJson()).toList(),
      'count': count,
    };
  }
}

class GetByCategoryQuestion {
  String? id;
  CategoryDetails? category;
  String? question;
  String? answer;
  int? v;

  GetByCategoryQuestion({
    this.id,
    this.category,
    this.question,
    this.answer,
    this.v,
  });

  factory GetByCategoryQuestion.fromJson(Map<String, dynamic> json) {
    return GetByCategoryQuestion(
      id: json['_id'],
      category: json['category'] != null
          ? CategoryDetails.fromJson(json['category'])
          : null,
      question: json['question'],
      answer: json['answer'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category?.toJson(),
      'question': question,
      'answer': answer,
      '__v': v,
    };
  }
}

class CategoryDetails {
  String? id;
  String? name;
  String? image;

  CategoryDetails({
    this.id,
    this.name,
    this.image,
  });

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}