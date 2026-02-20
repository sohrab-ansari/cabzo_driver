// class NotificationResponse {
//   bool? success;
//   String? message;
//   List<Notification>? data;

//   NotificationResponse({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory NotificationResponse.fromJson(Map<String, dynamic> json) {
//     return NotificationResponse(
//       success: json['success'],
//       message: json['message'],
//       data: json['data'] != null
//           ? List<Notification>.from(
//               json['data'].map((x) => Notification.fromJson(x)))
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.map((x) => x.toJson()).toList(),
//     };
//   }
// }

// class Notification {
//   String? id;
//   String? title;
//   String? body;
//   User? userModel;
//   bool? seen;
//   String? topic;
//   String? createdAt;
//   String? updatedAt;
//   int? v;
//   dynamic data;

//   Notification({
//     this.id,
//     this.title,
//     this.body,
//     this.userModel,
//     this.seen,
//     this.topic,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.data,
//   });

//   factory Notification.fromJson(Map<String, dynamic> json) {
//     return Notification(
//       id: json['_id'],
//       title: json['title'],
//       body: json['body'],
//       userModel: json['userModel'] != null
//           ? User.fromJson(json['userModel'])
//           : null,
//       seen: json['seen'],
//       topic: json['topic'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       v: json['__v'],
//       data: json['data'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': title,
//       'body': body,
//       'userModel': userModel?.toJson(),
//       'seen': seen,
//       'topic': topic,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       '__v': v,
//       'data': data,
//     };
//   }
// }

// class User {
//   String? id;
//   String? name;
//   int? phone;

//   User({
//     this.id,
//     this.name,
//     this.phone,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       name: json['name'],
//       phone: json['phone'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'phone': phone,
//     };
//   }
// }

// Rename Notification to NotificationItem to avoid conflict
class NotificationResponse {
  bool? success;
  String? message;
  List<NotificationItem>? data;

  NotificationResponse({this.success, this.message, this.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<NotificationItem>.from(
              json['data'].map((x) => NotificationItem.fromJson(x)),
            )
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

// Changed from Notification to NotificationItem
class NotificationItem {
  String? id;
  String? title;
  String? body;
  User? userModel;
  bool? seen;
  String? topic;
  String? createdAt;
  String? updatedAt;
  int? v;
  dynamic data;

  NotificationItem({
    this.id,
    this.title,
    this.body,
    this.userModel,
    this.seen,
    this.topic,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.data,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      userModel:
          json['userModel'] != null && json['userModel'] is Map<String, dynamic>
          ? User.fromJson(json['userModel'])
          : null,
      seen: json['seen'],
      topic: json['topic'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'body': body,
      'userModel': userModel?.toJson(),
      'seen': seen,
      'topic': topic,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'data': data,
    };
  }
}

class User {
  String? id;
  String? name;
  int? phone;

  User({this.id, this.name, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['_id'], name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'phone': phone};
  }
}
