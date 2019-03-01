class Zone {
  final String _name;
  final String _adminId;
  double _latitude;
  double _longitude;
  List<String> _visits;

  Zone(this._name, this._adminId);

  String get name => _name;

  String get adminId => _adminId;

  List<String> get visits => _visits;

  double get latitude => _latitude;

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  set latitude(double value) {
    _latitude = value;
  }


}
