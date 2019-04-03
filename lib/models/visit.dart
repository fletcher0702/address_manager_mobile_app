
class Visit {

  String _name;
  String _teamUuid;
  String _address;
  String _phoneNumber;
  String _zoneUuid;
  String _statusUuid;
  String _date;
  String _observation;

  Visit(this._teamUuid,this._name, this._address,this._zoneUuid, this._statusUuid);


  String get teamUuid => _teamUuid;

  String get statusUuid => _statusUuid;

  String get zoneUuid => _zoneUuid;

  String get address => _address;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  String get observation => _observation;

  String get date => _date;

  set phoneNumber(String value) => _phoneNumber = value;

  set observation(String value) {
    _observation = value;
  }

  set date(String value) {
    _date = value;
  }


}