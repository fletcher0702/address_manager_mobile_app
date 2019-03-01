import 'package:geocoder/geocoder.dart';

class AddressHelper {
  static getAddressCoordinates(address) async {
    var addressCoordinates =
        await Geocoder.local.findAddressesFromQuery(address);
    return addressCoordinates.first;
  }
}
