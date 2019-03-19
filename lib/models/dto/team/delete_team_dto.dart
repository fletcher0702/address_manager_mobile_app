
class DeleteTeamDto {

    String _userUuid;
    String _teamUuid;

    DeleteTeamDto(this._teamUuid);


    String get userUuid => _userUuid;

    set userUuid(String value) {
      _userUuid = value;
    }

    String get teamUuid => _teamUuid;


}