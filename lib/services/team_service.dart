import 'package:mongo_dart/mongo_dart.dart';

import '../client/client.dart';
import '../models/team.dart';

class TeamService {
  static const COLLECTION = 'team';

  void createOne(Team team) async {
    Db db = Db(DB);
    await db.open();

    db
        .collection(COLLECTION)
        .insert({'name': team.name, 'adminUuid': team.adminUuid,})
        .then((success) => success)
        .catchError((onError) => onError);

    db.close();
  }
}
