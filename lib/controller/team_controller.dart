import 'dart:convert';

import 'package:address_manager/models/team.dart';
import 'package:http/http.dart' as http;
import '../controller/user_controller.dart';
import '../routes/routes.dart';

class TeamController {

  UserController userController = UserController();
  final header = {"Content-Type": "application/json;charset=utf-8"};

  Future<dynamic>findAll() async {
    var credentials = await userController.getCredentials();
    var response = await http
        .get(USER_BASE_URL+credentials["uuid"]+'/teams')
        .then((res) => res);

    return jsonDecode(response.body);
  }

  Future<dynamic> createOne(Team team) async {
    var credentials = await userController.getCredentials();
    team.adminUuid = credentials["uuid"];
    var response = await http
        .post(CREATE_TEAM_HTTP_ROUTE, headers: header ,body: jsonEncode({'name': team.name, 'adminUuid': team.adminUuid}))
        .then((res) => res);

    return jsonDecode(response.body);

  }

}