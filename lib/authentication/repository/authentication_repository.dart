import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:starterapp/authentication/models/error_response.dart';
import 'package:starterapp/authentication/models/models.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<dynamic> login(String email, String password);
  Future<void> signOut();
  Future<dynamic> register(String email, String password);

}

class AuthenticationRepository extends AuthenticationService {
  static const String baseUrl = "https://reqres.in";
  Map<String, String> headers = {"Content-type": "application/json",
    "charset":"UTF-8"};
  final key = 'current_user';

  //get user data from preference
  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(key);
    Map<String, dynamic> userMapString =  (userString !=null)? json.decode(userString) : null;
    return User.fromJson(userMapString);

  }

  // make POST request to login
  @override
  Future<dynamic> login(String email, String password) async {
    final uri = Uri.parse(baseUrl + '/api/login');
    var reqBody = {};
    reqBody["email"] = email;
    reqBody["password"] = password;
    String reqBodyJson = jsonEncode(reqBody);
    try {
      print("reqBody ${reqBodyJson}");
      Response response = await http.post(uri, headers: headers, body: reqBodyJson);
      print("reponse ${response.body}");
      if(response.statusCode == 200) {
        final loginReponse = LoginResponse.fromJson(jsonDecode(response.body));
        print("loginResponse ${loginReponse.toString()}");
        User user = User(name: 'Mr Eve Holt', email: email, token: loginReponse.token);
        saveUser(user);
        return user;
      }else{
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }

    }catch(e){
      print("exception $e");
      throw e;
    }
  }

  // make POST request to register
  @override
  Future<dynamic> register(String email, String password) async {
    final registerUri = Uri.parse(baseUrl + '/api/register');
    var reqBody = {};
    reqBody["email"] = email;
    reqBody["password"] = password;
    String reqBodyJson = jsonEncode(reqBody);
    try {
      print("reqBody ${reqBodyJson}");
      Response response = await http.post(registerUri, headers: headers, body: reqBodyJson);
      print("reponse ${response.body}");
      if(response.statusCode == 200){
        final signUpReponse = SignUpResponse.fromJson(jsonDecode(response.body));
        print("signUpResponse ${signUpReponse.toString()}");
        int userId = signUpReponse.id;
        print("userId ${userId}");
        final getUserUri = Uri.parse(baseUrl + '/api/users/${userId}');
        Response rep = await http.get(getUserUri, headers: headers);
        print("rep ${rep.body.toString()}");
        final getUserReponse = GetUserResponse.fromJson(jsonDecode(rep.body));
        User user = User(name: '${getUserReponse.data!.firstName} ${getUserReponse.data!.lastName}' , email:
        '${getUserReponse.data!.email}', token: signUpReponse.token);
        print('user $user');
        saveUser(user);
        return user;
      }else{
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
        return errorResponse;
      }

    }catch(e){
      return ErrorResponse(error: e.toString());//get exception as error response
    }
  }

  //remove user data in sign out
  @override
  Future<void> signOut() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  //save user data to preference
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(user));
  }


}
