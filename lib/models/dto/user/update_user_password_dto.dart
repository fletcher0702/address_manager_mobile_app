
class UpdateUserPasswordDto {

  String _userUuid;
  String _oldPassword;
  String _newPassword;

  UpdateUserPasswordDto(this._oldPassword, this._newPassword);

  String get newPassword => _newPassword;

  String get oldPassword => _oldPassword;

  String get userUuid => _userUuid;

  set userUuid(String value) {
    _userUuid = value;
  }


}