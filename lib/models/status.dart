
class Status {

  String _teamUuid;
  String _name;
  num _color;

  Status(this._teamUuid, this._name, this._color);

  num get color => _color;

  String get name => _name;

  String get teamUuid => _teamUuid;


}