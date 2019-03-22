import 'dart:convert';

import 'package:address_manager/models/dto/status/delete_status_dto.dart';
import 'package:address_manager/models/dto/status/update_status_dto.dart';
import 'package:address_manager/models/dto/team/delete_team_dto.dart';
import 'package:address_manager/models/dto/team/update_team_dto.dart';
import 'package:address_manager/models/status.dart';
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

  Future<dynamic> updateOne(UpdateTeamDto team) async {
    var credentials = await userController.getCredentials();
    team.userUuid = credentials["uuid"];
    var response = await http
        .patch(UPDATE_TEAM_HTTP_ROUTE, headers: header ,body: jsonEncode({'name': team.name, 'teamUuid': team.teamUuid ,'userUuid': team.userUuid}))
        .then((res) => res);

    return jsonDecode(response.body);

  }

  Future<dynamic> deleteOne(DeleteTeamDto team) async {

    try{
      var credentials = await userController.getCredentials();
      team.userUuid = credentials["uuid"];
      var rq = http.Request('DELETE', Uri.parse(DELETE_TEAM_HTTP_ROUTE));
      rq.headers.putIfAbsent('Content-Type', ()=>header['Content-Type']);
      rq.body = jsonEncode({'userUuid': team.userUuid,'teamUuid':team.teamUuid});

      var response = await http.Client().send(rq).then((response)=> response);
      return response.stream;

    }catch(e){
      print(e);
    }

  }

  Future<dynamic> createStatus(Status status) async {
    var credentials = await userController.getCredentials();
    var response = await http
        .post(CREATE_TEAM_STATUS_HTTP_ROUTE, headers: header ,body: jsonEncode({'userUuid': credentials["uuid"], 'teamUuid': status.teamUuid, 'status':[{'name':status.name,'color':status.color}]}))
        .then((res) => res);

    print(jsonEncode(response.body));

    return jsonDecode(response.body);

  }

  Future<dynamic> invitePeople(teamUuid,tags) async {
    var credentials = await userController.getCredentials();
    var response = await http
        .post(INVITE_USERS_TEAM_HTTP_ROUTE, headers: header ,body: jsonEncode({'emails': tags,'teamUuid': teamUuid ,'userUuid': credentials['uuid']}))
        .then((res) => res);

    return jsonDecode(response.body);

  }

  Future<dynamic> deleteStatus(DeleteStatusDto status) async {

    //TODO : Check if admin of the Team
    try{
      var credentials = await userController.getCredentials();
      status.userUuid = credentials["uuid"];
      var rq = http.Request('DELETE', Uri.parse(DELETE_TEAM_STATUS_HTTP_ROUTE));
      rq.headers.putIfAbsent('Content-Type', ()=>header['Content-Type']);
      rq.body = jsonEncode({'userUuid': status.userUuid,'teamUuid':status.teamUuid, 'statusUuid':status.statusUuid});

      var response = await http.Client().send(rq).then((response)=> response);
      return response.stream;

    }catch(e){
      print(e);
    }

  }

  Future<dynamic> updateStatus(UpdateStatusDto status) async {
    var credentials = await userController.getCredentials();
    status.userUuid = credentials["uuid"];
    var response = await http
        .patch(UPDATE_TEAM_STATUS_HTTP_ROUTE, headers: header ,body: jsonEncode({'status': {'name': status.name, 'color': status.color},'statusUuid':status.statusUuid, 'teamUuid': status.teamUuid ,'userUuid': status.userUuid}))
        .then((res) => res);

    return jsonDecode(response.body);

  }

}