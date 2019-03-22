
class UpdateStatusDto {

    String _userUuid;
    String _teamUuid;
    String _statusUuid;
    String _name;
    num _color;

    UpdateStatusDto(this._teamUuid, this._statusUuid);


    num get color => _color;

    String get name => _name;

    String get statusUuid => _statusUuid;

    String get teamUuid => _teamUuid;

    String get userUuid => _userUuid;

    set userUuid(String value) {
      _userUuid = value;
    }

    set color(num value) {
      _color = value;
    }

    set name(String value) {
      _name = value;
    }


}
