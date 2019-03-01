
class Visit {

  String _name;
  String _userUuid;
  String _address;
  String _phoneNumber;
  String _zoneUuid;
  String _status;

  Visit(this._userUuid,this._name, this._address,this._zoneUuid, this._status);


  String get userUuid => _userUuid;

  String get status => _status;

  String get zoneUuid => _zoneUuid;

  String get address => _address;

  String get name => _name;

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) => _phoneNumber = value;


}