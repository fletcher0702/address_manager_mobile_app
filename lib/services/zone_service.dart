import 'package:mongo_dart/mongo_dart.dart';
import 'package:synchronized/synchronized.dart';

import '../client/client.dart';
import '../models/zone.dart';

class ZoneService {
  static const COLLECTION = 'zone';
  var lock = Lock();

  void createOne(Zone zone) async {
    Db db = Db(DB);
    await db.open();
    db
        .collection(COLLECTION)
        .insert(
            {'name': zone.name, 'adminId': zone.adminId, 'visits': zone.visits,'latitude':zone.latitude,'longitude':zone.longitude})
        .then((success) => success)
        .catchError((onError) => onError);

    db.close();
  }

  findUserZones(id) async {
    Db db = Db(DB);
    await db.open();

    var zone = await db
        .collection(COLLECTION)
        .findOne({"_id": ObjectId.fromHexString(id)});

    db.close();

    return zone;
  }

  findAll() async {
    Db db = Db(DB);
    await db.open();

    var zones;
    await lock.synchronized(() async {
      zones = await db.collection(COLLECTION).find().toList();
    });

    db.close();

    return zones;
  }
}
