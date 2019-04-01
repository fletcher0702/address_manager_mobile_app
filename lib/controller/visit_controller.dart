import 'dart:convert';

import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/models/dto/visit/delete_visit_dto.dart';
import 'package:address_manager/models/dto/visit/update_visit_dto.dart';
import 'package:address_manager/models/dto/visit/update_visit_history.dart';
import 'package:address_manager/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';

import '../models/visit.dart';
import '../routes/routes.dart';
import '../services/visit_service.dart';

class VisitController {
  VisitService visitService = VisitService();
  UserService userService = UserService();
  UserController userController = UserController();
  Dio dio = Dio();

  createVisit(Visit visit) async {
    if (visit.teamUuid.isEmpty ||
        visit.name.isEmpty ||
        visit.address.isEmpty ||
        visit.statusUuid.isEmpty ||
        visit.zoneUuid.isEmpty) return false;

    var response = await http
        .post(CREATE_VISIT_HTTP_ROUTE,
        headers: header,
        body: json.encode({
          'teamUuid': visit.teamUuid,
          'zoneUuid': visit.zoneUuid,
          'name': visit.name,
          'address': visit.address,
          'phoneNumber': visit.phoneNumber,
          'statusUuid': visit.statusUuid,
          'observation':visit.observation,
          'date':visit.date
        }))
        .then((res) => res);

    return jsonDecode(response.body);
  }

  updateVisit(UpdateVisitDto visit) async {
    var response = await http
        .patch(UPDATE_VISIT_HTTP_ROUTE, headers: header ,body: jsonEncode({'userUuid': visit.userUuid,'teamUuid':visit.teamUuid,'zoneUuid':visit.zoneUuid,'visitUuid':visit.visitUuid,'name': visit.name, 'address': visit.address,'phoneNumber':visit.phoneNumber,'statusUuid': visit.statusUuid, 'date':visit.date,'observation':visit.observation}))
        .then((res) => res);

    print('after server response...');

    return jsonDecode(response.body);
  }

  updateVisitHistory(UpdateVisitHistoryDto visit) async {

    var credentials = await userController.getCredentials();
    visit.userUuid = credentials['uuid'];
    var response = await http
        .patch(UPDATE_VISIT_HISTORY_HTTP_ROUTE, headers: header ,body: jsonEncode({'userUuid': visit.userUuid,'teamUuid':visit.teamUuid,'zoneUuid':visit.zoneUuid,'visitUuid':visit.visitUuid,'date':visit.date}))
        .then((res) => res);

    print('response : '+jsonDecode(response.body).toString());

    return jsonDecode(response.body);
  }

  findVisitsByZoneId(zoneId) async {
    return await visitService.findAllByZoneId(zoneId);
  }

  deleteOne(DeleteVisitDto visitDto) async {

    try{

      var rq = http.Request('DELETE', Uri.parse(DELETE_VISIT_HTTP_ROUTE));
      rq.headers.putIfAbsent('Content-Type', ()=>header['Content-Type']);
      rq.body = jsonEncode({'userUuid': visitDto.userUuid,'zoneUuid':visitDto.zoneUuid,'visitUuid':visitDto.visitUuid });

      var response = await http.Client().send(rq).then((response)=> response);
      return response.stream;

    }catch(e){
      print(e);
    }

  }

  getId(ObjectId obj) {
    return obj.toString().substring(10, 34);
  }

  findAll() {
//    return visitService.f
  }
}
