
class UnInviteUserDto {

  String _userUuid;
  String _teamUuid;
  String _email;

  String get userUuid => _userUuid;

  String get teamUuid => _teamUuid;

  String get email => _email;

  set userUuid(String value) {
    _userUuid = value;
  }

  set teamUuid(String value) {
    _teamUuid = value;
  }

  set email(String value) {
    _email = value;
  }


}