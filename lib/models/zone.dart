class Zone {
  final String _name;
  String _userUuid;
  final String _teamUuid;
  final String _address;

  Zone(this._name, this._teamUuid,this._address);


  set userUuid(String value) {
    _userUuid = value;
  }


  String get userUuid => _userUuid;

  String get name => _name;

  String get teamUuid => _teamUuid;


  String get address => _address;

}
