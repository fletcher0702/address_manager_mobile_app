import 'dart:convert';

import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/models/dto/zone/delete_zone_dto.dart';
import 'package:address_manager/models/dto/zone/update_zone_dto.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';

import '../models/zone.dart';
import '../routes/routes.dart';
import '../services/zone_service.dart';


class ZoneController {
  final zoneService = ZoneService();
  final userController = UserController();
  final header = {"Content-Type": "application/json;charset=utf-8"};

  createOne(Zone zone) async {
    if (zone.teamUuid.isNotEmpty && zone.name.isNotEmpty) {
      var credentials = await userController.getCredentials();
      zone.userUuid = credentials['uuid'];
      var response = await http
          .post(CREATE_ZONE_HTTP_ROUTE, headers: header,
          body: jsonEncode({
            'name': zone.name,
            'userUuid': zone.userUuid,
            'teamUuid': zone.teamUuid,
            'address': zone.address
          }))
          .then((res) => res);

      return jsonDecode(response.body);
    }
  }

  updateOne(UpdateZoneDto zone) async {
    if (zone.teamUuid.isNotEmpty && zone.name.isNotEmpty) {
      var credentials = await userController.getCredentials();
      zone.userUuid = credentials['uuid'];
      print('Update request!');
      var response = await http
          .patch(UPDATE_ZONE_HTTP_ROUTE, headers: header,
          body: jsonEncode({
            'name': zone.name,
            'userUuid': zone.userUuid,
            'teamUuid': zone.teamUuid,
            'zoneUuid': zone.zoneUuid,
            'address': zone.address
          }))
          .then((res) => res);

      print('End updated!');

      return jsonDecode(response.body);
    }
  }

  deleteOne(DeleteZoneDto zone) async {
    try{
      var credentials = await userController.getCredentials();
      zone.userUuid = credentials["uuid"];
      var rq = http.Request('DELETE', Uri.parse(DELETE_ZONE_HTTP_ROUTE));
      rq.headers.putIfAbsent('Content-Type', ()=>header['Content-Type']);
      rq.body = jsonEncode({'userUuid': zone.userUuid,'teamUuid':zone.teamUuid, 'zoneUuid':zone.zoneUuid});

      var response = await http.Client().send(rq).then((response)=> response);
      return response.stream.bytesToString().then((body)=>jsonDecode(body));

    }catch(e){
      print(e);
    }

  }

  findOne(id) async {
    return await zoneService.findUserZones(id);
  }

  findAll() async {
    var zones = await zoneService.findAll();
    return zones;
  }

  getId(ObjectId obj) {
    return obj.toString().substring(10,34);
  }
}
