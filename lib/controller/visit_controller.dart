import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import '../models/visit.dart';
import '../services/visit_service.dart';
import '../routes/routes.dart';

class VisitController {
  VisitService visitService = VisitService();

  createVisit(Visit visit) async {
    if (visit.userUuid.isEmpty ||
        visit.name.isEmpty ||
        visit.address.isEmpty ||
        visit.status.isEmpty ||
        visit.zoneUuid.isEmpty) return false;


//    VisitService().createOne(visit);

    var response = await http
        .post(USER_BASE_URL+visit.userUuid+'/create',
        headers: header,
        body: json.encode({
          'userUuid': visit.userUuid,
          'name': visit.name,
          'address': visit.address,
          'phoneNumber': visit.phoneNumber,
          'zoneUuid': visit.zoneUuid,
          'status': visit.status,
        }))
        .then((res) => res);
    print(response.body);

    return true;
  }

  updateVisit(id, Visit visit, String originalZoneId) async {
    if (
        visit.userUuid.isEmpty ||
        visit.name.isEmpty ||
        visit.address.isEmpty ||
        visit.status.isEmpty ||
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
