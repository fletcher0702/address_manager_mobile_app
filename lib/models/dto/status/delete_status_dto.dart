
class DeleteStatusDto {

  String _userUuid;
  String _teamUuid;
  String _statusUuid;

  DeleteStatusDto(this._teamUuid, this._statusUuid);

  String get statusUuid => _statusUuid;

  String get teamUuid => _teamUuid;

  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }


}