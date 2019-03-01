class Team {
  String _name;
  String _code;
  String _adminId;
  List<String> _users;

  Team(this._name, this._code, this._adminId);

  String get adminId => _adminId;

  String get code => _code;

  String get name => _name;

  List<String> get users => _users;
}
