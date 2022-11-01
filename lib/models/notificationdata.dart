import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsData {
  String? id;
  String? message;
  String? msgid;
  Timestamp? date;
  Timestamp? schulded;

  NotificationsData(
      {required this.id,
      required this.message,
      required this.msgid,
      required this.date,
      required this.schulded});

  NotificationsData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    message = map['message'];
    msgid = map['msgid'];
    date = map['date'];
    schulded = map['schulded'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'message': message, 'msgid': msgid, 'date': date, 'schulded': schulded};
  }
}

class UserNotification {
  String? id;
  String? message;
  String? msgid;
  bool? status;
  Timestamp? date;

  UserNotification(
      {required this.date,
      required this.id,
      required this.message,
      required this.msgid,
      required this.status});
  UserNotification.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    id = map['id'];
    message = map['message'];
    msgid = map['msgid'];
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'message': message, 'msgid': msgid, 'status': status};
  }
}
