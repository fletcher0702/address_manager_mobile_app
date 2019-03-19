
class UpdateZoneDto {

  String _userUuid;
  String _teamUuid;
  String _zoneUuid;
  String _name;
  String _address;

  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }

  String get teamUuid => _teamUuid;

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get zoneUuid => _zoneUuid;

  set zoneUuid(String value) {
    _zoneUuid = value;
  }

  set teamUuid(String value) {
    _teamUuid = value;
  }


}