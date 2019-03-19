
class UpdateTeamDto {

  String _userUuid;
  String _teamUuid;
  String _name;

  UpdateTeamDto(this._teamUuid, this._name);


  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }

  String get teamUuid => _teamUuid;

  String get name => _name;


}