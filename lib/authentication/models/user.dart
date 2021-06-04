import 'package:meta/meta.dart';

class User {
  final String name;
  final String email;
  String? token;

  User({required this.name, required this.email, token});

  @override
  String toString() => 'User { name: $name, email: $email}';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name']?? '', email: json['email']?? '', token: json['token']?? '');
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'email': this.email,
    'token': this.token,
  };
}
