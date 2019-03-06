import 'package:mongo_dart/mongo_dart.dart';
import 'package:synchronized/synchronized.dart';

import '../models/visit.dart';
import '../services/zone_service.dart';
import '../client/client.dart';

class VisitService {
  static const COLLECTION = 'visit';
  static const ZONE_COLLECTION = 'zone';
  ZoneService zoneService = ZoneService();

  void createOne(Visit visit) async {
    Db db = Db(DB);
    await db.open();

    db
        .collection(COLLECTION)
        .insert({
          'userUuid': visit.teamUuid,
          'name': visit.name,
          'address': visit.address,
          'phoneNumber': visit.phoneNumber,
          'zoneUuid': visit.zoneUuid,
          'status': visit.status,
        })
        .then((success) => success)
        .catchError((onError) => onError);

    var createdVisit = await db.collection(COLLECTION).find().last;
    var zone = await zoneService.findUserZones(visit.zoneUuid);
    var visitId = getId(createdVisit['_id']);
    zone['visits'] == null
        ? zone['visits'] = [visitId]
        : zone['visits'].add(visitId);
    await db.collection(ZONE_COLLECTION).save(zone);
    db.close();
//    _db.collection(COLLECTION).add({
//      'name': visit.name,
//      'address': visit.address,
//      'phoneNumber': visit.phoneNumber,
//      'zoneId': visit.zoneId,
//      'status': visit.status,
//      'location': GeoPoint(visit.latitude, visit.longitude)
//    }).then((res) {
//      print('Visit creadted');
//    }).catchError((onError) => print(onError));

  }

  getId(obj) {
    return obj.toString().substring(10, 34);
  }

  void updateOne(id, Visit visit, originalZoneId) async {
    Db db = Db(DB);
    await db.open();

    var visitToUpdate = await findOne(id);
    String toUpdateZoneId = visit.zoneUuid;
    var originalZone = await zoneService.findUserZones(originalZoneId);

    if (toUpdateZoneId != originalZoneId) {
      print('Original : '+ toUpdateZoneId);
      print('Changed : '+ originalZoneId);

      if (originalZone['visits'] != null) {
        originalZone['visits'].remove(getId(visitToUpdate['_id']));
        var newZone = await zoneService.findUserZones(toUpdateZoneId);
        if(newZone['visits']!=null){
          newZone['visits'].add(getId(visitToUpdate['_id']));
        }else newZone['visits'] = [getId(visitToUpdate['_id'])];

        await db.collection(ZONE_COLLECTION).save(originalZone);
        await db.collection(ZONE_COLLECTION).save(newZone);
      }
    }

    visitToUpdate['name'] = visit.name;
    visitToUpdate['address'] = visit.address;
    visitToUpdate['zoneUuid'] = visit.zoneUuid;
    visitToUpdate['phoneNumber'] = visit.phoneNumber;
    visitToUpdate['status'] = visit.status;
    await db.collection(COLLECTION).save(visitToUpdate);

    db.close();
  }

  findOne(id) async {
    Db db = Db(DB);

    await db.open();

    var visit = await db
        .collection(COLLECTION)
        .findOne({"_id": ObjectId.fromHexString(id)});

    return visit;
  }

  findAllByZoneId(zoneId) async {
    Db db = Db(DB);
    await db.open();
    var lock = Lock();
    var visits;

    await lock.synchronized(() async {
      visits =
          await db.collection(COLLECTION).find({"zoneId": zoneId}).toList();
    });
    db.close();

    return visits;
  }

  deleteOne(id, zoneId) async {
    Db db = Db(DB);
    await db.open();

    var zone = await zoneService.findUserZones(zoneId);

    zone['visits'].remove(id);

    await db.collection(ZONE_COLLECTION).save(zone);

    await db.collection(COLLECTION).remove({'_id': ObjectId.fromHexString(id)});

    db.close();
  }
}
