import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/visit.dart';
import '../services/visit_service.dart';
import '../routes/routes.dart';

class VisitController {
  VisitService visitService = VisitService();

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
        }))
        .then((res) => res);
    print(response.body);

    return true;
  }

  updateVisit(id, Visit visit, String originalZoneId) async {
    if (
        visit.teamUuid.isEmpty ||
        visit.name.isEmpty ||
        visit.address.isEmpty ||
        visit.statusUuid.isEmpty ||
        visit.zoneUuid.isEmpty) return false;

    VisitService().updateOne(id, visit, originalZoneId);

    return true;
  }

  findVisitsByZoneId(zoneId) async {
    return await visitService.findAllByZoneId(zoneId);
  }

  deleteOne(id,zoneId){
    return visitService.deleteOne(id, zoneId);
  }

  getId(ObjectId obj) {
    return obj.toString().substring(10, 34);
  }

  findAll() {
//    return visitService.f
  }
}
