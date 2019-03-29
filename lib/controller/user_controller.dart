import 'dart:convert';

import 'package:http/http.dart' as http;

import '../routes/routes.dart';
import '../services/user_service.dart';

class UserController {
  UserService userService = UserService();

  final header = {"Content-Type": "application/json;charset=utf-8"};

  Future<bool> login(String email, String password) async {
    var response = await http
        .post(LOGIN_HTTP_ROUTE,
            headers: header,
            body: json.encode({"email": email, "password": password}))
        .then((res) => res);
    if (response.body.toString().isNotEmpty) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        try{
          if(jsonResponse['created']){
            var jwt = jsonResponse["jwt"].toString();
            var uuid = jsonResponse["uuid"].toString();
            await userService.createUserCredentialsPreferences(uuid, jwt);
            return true;
          }
        }catch(e){
          return false;
        }
      }
    }

    return false;
  }

  register(String email, String password) async {
    var response = await http
        .post(SIGN_UP_HTTP_ROUTE,
            headers: header,
            body: json.encode({"email": email, "password": password}))
        .then((res) => res);
    if (response.body.toString().isNotEmpty) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        try{
          if(jsonResponse['created']){
            await userService
                .createUserCredentialsCache(jsonResponse["jwt"].toString());
            return true;
          }
        }catch(e){
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> checkSignIn() async {
    Map credentials = await userService.getPreferences();
    if (credentials!=null) {
      var response = await http.get(ALREADY_SIGNED_HTTP_ROUTE, headers: {
        "authorization": 'Bearer ${credentials['jwt']}'
      }).then((res) => res);
      var json = jsonDecode(response.body);
      return json["valid"] as bool;
    }

    print('Empty Token...');
    return false;
  }

  getCredentials(){
    return userService.getPreferences();
  }

  destroyCredentials(){
    userService.destroyCredentials();
  }
}
