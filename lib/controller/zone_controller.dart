import 'package:mongo_dart/mongo_dart.dart';
import '../models/zone.dart';
import '../services/zone_service.dart';
import 'package:geocoder/geocoder.dart';
import '../helpers/address_helper.dart';


class ZoneController {
  final zoneService = ZoneService();

  createOne(Zone zone, String address) async {
    if (zone.adminId.isNotEmpty && zone.name.isNotEmpty) {

      Address addressCoordinates =
          await AddressHelper.getAddressCoordinates(address);

      zone.latitude = addressCoordinates.coordinates.latitude;
      zone.longitude = addressCoordinates.coordinates.longitude;

      zoneService.createOne(zone);
    }
    return;
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
