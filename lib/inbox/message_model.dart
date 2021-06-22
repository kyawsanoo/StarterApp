import 'package:meta/meta.dart';
import 'dart:convert';

class FirebaseMessageModel {
  final String uuid;
  final String title;
  final String description;
  final int isRead;
  final String otp;
  final String image;
  final String promotionPageUrl;

  FirebaseMessageModel({required this.uuid, required this.title, required this.description, required this.isRead, required this.otp, required this.image, required this.promotionPageUrl});

  factory FirebaseMessageModel.fromRawJson(String str) => FirebaseMessageModel._fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(_toJson());

  factory FirebaseMessageModel._fromJson(Map<String, dynamic> json) => FirebaseMessageModel(
    uuid: json['uuid'],
    title: json['title'],
    description: json['description'],
    isRead: json['is_read'],
    otp: json['otp'],
    image: json['image'],
    promotionPageUrl: json['promotionPageUrl'],
  );


  Map<String, dynamic> _toJson() => {
    'uuid':uuid,
    'title': title,
    'description': description,
    'is_read': isRead,
    'otp':otp,
    'image': image,
    'promotionPageUrl':promotionPageUrl,
  };

  Map<String, dynamic> toMap() {
    return {'uuid': uuid, 'title': title,  'description': description, 'is_read' : isRead, 'otp': otp, 'image' :image,
    'promotionPageUrl': promotionPageUrl};
  }


}