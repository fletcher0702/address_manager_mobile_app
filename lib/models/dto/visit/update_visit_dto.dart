
class UpdateVisitDto {


  String _userUuid;
  String _teamUuid;
  String _zoneUuid;
  String _visitUuid;
  String _statusUuid;
  String _name;
  String _phoneNumber;

  UpdateVisitDto(this._userUuid, this._teamUuid, this._zoneUuid, this._visitUuid,
      this._statusUuid, this._name, this._phoneNumber);

  String get phoneNumber => _phoneNumber;

  String get name => _name;

  String get statusUuid => _statusUuid;

  String get visitUuid => _visitUuid;

  String get zoneUuid => _zoneUuid;

  String get teamUuid => _teamUuid;

  String get userUuid => _userUuid;


}