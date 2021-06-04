import 'package:equatable/equatable.dart';

class Post extends Equatable{
  final int userId;
  final int id;
  final String body;
  final String title;

  Post({required this.userId,required this.id,required this.title,required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
    userId: json['userId'],
    id: json['id'],
    title: json['title'],
    body: json['body']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }

  @override
  List<Object> get props => [userId, id, body, title];

}