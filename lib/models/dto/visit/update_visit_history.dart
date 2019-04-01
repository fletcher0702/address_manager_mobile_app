
class UpdateVisitHistoryDto {

  String _userUuid;
  String _teamUuid;
  String _zoneUuid;
  String _visitUuid;
  String _date;

  UpdateVisitHistoryDto(this._teamUuid, this._zoneUuid);


  set date(String value) {
    _date = value;
  }

  set visitUuid(String value) {
    _visitUuid = value;
  }

  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }

  String get date => _date;

  String get visitUuid => _visitUuid;

  String get zoneUuid => _zoneUuid;

  String get teamUuid => _teamUuid;


}