
class UpdateVisitDto {


  String _userUuid;
  String _teamUuid;
  String _zoneUuid;
  String _visitUuid;
  String _statusUuid;
  String _name;
  String _address;
  String _phoneNumber;
  String _date;
  String _observation;


  String get date => _date;

  set date(String value) {
    _date = value;
  }

  UpdateVisitDto(this._userUuid, this._teamUuid, this._zoneUuid, this._visitUuid,
      this._statusUuid, this._name, this._address,this._phoneNumber);


  String get address => _address;

  String get phoneNumber => _phoneNumber;

  String get name => _name;

  String get statusUuid => _statusUuid;

  String get visitUuid => _visitUuid;

  String get zoneUuid => _zoneUuid;

  String get teamUuid => _teamUuid;

  String get userUuid => _userUuid;

  String get observation => _observation;

  set observation(String value) {
    _observation = value;
  }


}