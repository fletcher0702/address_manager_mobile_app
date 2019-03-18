
class DeleteVisitDto{

  String _userUuid;
  String _zoneUuid;
  String _visitUuid;

  DeleteVisitDto(this._userUuid, this._zoneUuid, this._visitUuid);

  String get visitUuid => _visitUuid;

  String get zoneUuid => _zoneUuid;

  String get userUuid => _userUuid;


}