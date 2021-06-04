import 'package:meta/meta.dart';

class LoginResponse{
  String? token;

  LoginResponse({token});

  @override
  String toString() => 'LoginReponse { token: $token}';

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}
