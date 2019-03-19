

class DeleteZoneDto {

  String _userUuid;
  String _teamUuid;
  String _zoneUuid;

  DeleteZoneDto(this._teamUuid, this._zoneUuid);

  set userUuid(String value) {
    _userUuid = value;
  }

  String get zoneUuid => _zoneUuid;

  String get teamUuid => _teamUuid;

  String get userUuid => _userUuid;


}