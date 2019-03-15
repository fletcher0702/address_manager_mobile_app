
class Visit {

  String _name;
  String _teamUuid;
  String _address;
  String _phoneNumber;
  String _zoneUuid;
  String _statusUuid;

  Visit(this._teamUuid,this._name, this._address,this._zoneUuid, this._statusUuid);


  String get teamUuid => _teamUuid;

  String get statusUuid => _statusUuid;

  String get zoneUuid => _zoneUuid;

  String get address => _address;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) => _phoneNumber = value;


}