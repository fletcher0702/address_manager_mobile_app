import 'dart:convert';

import 'package:address_manager/models/dto/user/update_user_password_dto.dart';
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

            var emailResponse = await http
                .get(USER_BASE_URL+uuid,
                headers: header,)
                .then((res) => res);
            var res = jsonDecode(emailResponse.body);
            if(res['exist']){

              await userService.createUserCredentialsPreferences(uuid, jwt,res['email']);
              return true;

            }

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
            var jwt = jsonResponse["jwt"].toString();
            var uuid = jsonResponse["uuid"].toString();
            var emailResponse = await http
                .get(USER_BASE_URL+uuid,
              headers: header,)
                .then((res) => res);
            var res = jsonDecode(emailResponse.body);
            if(res['exist']){
              await userService.createUserCredentialsPreferences(uuid, jwt,res['email']);
              return true;
            }
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
    return false;
  }

  Future<dynamic> updatePassword(UpdateUserPasswordDto userPasswordDto) async {
    Map credentials = await userService.getPreferences();

    userPasswordDto.userUuid = credentials['uuid'];
    var response = await http
        .patch(UPDATED_PASSWORD_HTTP_ROUTE,
        headers: header,
        body: json.encode({
          "userUuid": userPasswordDto.userUuid,
          "oldPassword": userPasswordDto.oldPassword,
          "newPassword": userPasswordDto.newPassword
        }))
        .then((res) => res);

    return jsonDecode(response.body);
  }

  setDefaultTeam(teamUuid){
    return userService.createDefaultTeamCredentialPreferences(teamUuid);
  }

  getCredentials(){
    return userService.getPreferences();
  }

  destroyCredentials(){
    userService.destroyCredentials();
  }
}
