class Team {
  String _name;
  String _adminUuid;

  Team(this._name);

  String get adminUuid => _adminUuid;

  String get name => _name;

  set adminUuid(String value) {
    _adminUuid = value;
  }


}
