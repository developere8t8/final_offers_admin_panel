import 'package:cloud_firestore/cloud_firestore.dart';

class AdminData {
  String? id;
  bool? active;
  String? email;
  Timestamp? created;
  String? photo;
  String? name;

  AdminData(
      {required this.active,
      required this.created,
      required this.email,
      required this.id,
      required this.photo,
      required this.name});

  AdminData.fromMap(Map<String, dynamic> map) {
    active = map['active'];
    created = map['created'];
    email = map['email'];
    id = map['id'];
    photo = map['photo'];
    name = map['name'];
  }

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'active': active,
      'created': created,
      'email': email,
      'photo': photo,
      'name': name
    };
  }
}
