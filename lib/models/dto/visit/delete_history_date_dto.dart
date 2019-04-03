
class DeleteHistoryDateDto {

  String _userUuid;
  String _teamUuid;
  String _zoneUuid;
  String _visitUuid;
  String _date;

  DeleteHistoryDateDto(this._teamUuid, this._zoneUuid, this._visitUuid,
      this._date);


  String get date => _date;

  String get visitUuid => _visitUuid;

  String get zoneUuid => _zoneUuid;

  String get teamUuid => _teamUuid;

  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }


}