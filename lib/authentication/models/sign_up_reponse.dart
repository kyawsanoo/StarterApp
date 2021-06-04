import 'package:meta/meta.dart';

class SignUpResponse{
  int id;
  String token;

  SignUpResponse({required this.id, required this.token});

  @override
  String toString() => 'SignUpReponse { id: ${this.id.toString()}, token: ${this.token}}';

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(id: json['id'], token: json['token']);
  }
}
