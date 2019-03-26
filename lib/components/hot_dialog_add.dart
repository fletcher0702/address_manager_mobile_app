import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/visit.dart';
import 'package:address_manager/screens/add_person_validation.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

class HotDialogAdd extends StatefulWidget {

  List<dynamic> teams;
  int selectedTeamIndex;
  int selectedZoneIndex;
  Function actionCallBackAfter;

  HotDialogAdd(this.teams,this.selectedTeamIndex,this.selectedZoneIndex,this.actionCallBackAfter);

  @override
  _HotDialogAddState createState() => _HotDialogAddState();
}

class _HotDialogAddState extends State<HotDialogAdd> {

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;


  var selectedZone = '';
  var selectedTeam = '';
  var selectedStatusName ='';
  int _selectedZoneIndex;
  int _selectedTeamIndex;
  int _selectedStatusIndex;

  final visitNameController = TextEditingController();
  final visitAddressController = TextEditingController();
  final visitPhoneNumberController = TextEditingController();
  final teamHelper = TeamHelper();

  List<DropdownMenuItem<int>> teamsItems = [];
  List<DropdownMenuItem<int>> zonesItems = [];
  List<DropdownMenuItem<int>> statusItems = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      teamsItems = teamHelper.buildDropDownSelection(widget.teams);
    });
  }

  _getContent(){
    if(widget.selectedTeamIndex!=-1 && widget.selectedZoneIndex!=-1){
      _selectedTeamIndex = widget.selectedTeamIndex;
      _selectedZoneIndex = widget.selectedZoneIndex;
      var zones = widget.teams[_selectedTeamIndex]["zones"];
      var status = widget.teams[_selectedTeamIndex]["status"];
      selectedZone = zones[_selectedZoneIndex]["name"];
      selectedTeam = widget.teams[_selectedTeamIndex]["name"];
      _selectedZoneIndex = _selectedZoneIndex;
      _selectedTeamIndex = _selectedTeamIndex;
      zonesItems = teamHelper.buildDropDownSelection(zones);
      statusItems = teamHelper.buildDropDownSelection(status);
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Text(
              'Add Person',
              style: TextStyle(
                  fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
              ),
              controller: visitNameController,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone),
              ),
              controller: visitPhoneNumberController,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.place),
              ),
              controller: visitAddressController,
              onTap: () async {
                Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: DotEnv().env['GApiKey'],
                    mode: Mode.fullscreen,
                    language: "fr",
                    components: [Component(Component.country, "fr")]);
                visitAddressController.text =
                p != null ? p.description : '';
              },
            ),
            DateTimePickerFormField(
              inputType: inputType,
              format: formats[inputType],
              editable: editable,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today)
              ),
              onChanged: (dt) => setState(() => date = dt),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Team : ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: teamsItems,
                    hint: Text(selectedTeam,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    onChanged: (value) {
                      setState(() {
                        selectedTeam = widget.teams[value]['name'];
                        _selectedTeamIndex= value;
                        selectedZone = '';
                        zonesItems = teamHelper.buildDropDownSelection(widget.teams[_selectedTeamIndex]["zones"]);
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Zone : ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: zonesItems,
                    hint: Text(selectedZone,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    onChanged: (value) {
                      setState(() {
                        selectedZone = widget.teams[_selectedTeamIndex]["zones"][value]['name'];
                        _selectedZoneIndex = value;
                        statusItems = teamHelper.buildDropDownSelection(widget.teams[_selectedTeamIndex]['status']);
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status : ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: statusItems,
                    hint: selectedStatusName != null
                        ? Text(selectedStatusName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatusIndex = value;
                        selectedStatusName = widget.teams[_selectedTeamIndex]["status"][value]["name"];
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    zonesItems = [];
                    statusItems = [];
                    teamsItems = [];
                    selectedZone = '';
                    selectedTeam = '';
                    selectedStatusName ='';
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Color.fromRGBO(46, 204, 113, 1),
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {

                      String name = visitNameController.text;
                      String address = visitAddressController.text;
                      String phoneNumber = visitPhoneNumberController.text;
                      String teamUuid = widget.teams[_selectedTeamIndex]["uuid"];
                      String zoneUuid = widget.teams[_selectedTeamIndex]["zones"][_selectedZoneIndex]["uuid"];
                      String statusUuid = widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]["uuid"];
                      Visit visit = Visit(teamUuid,name, address, zoneUuid, statusUuid);

                      if (phoneNumber.isNotEmpty)
                        visit.phoneNumber = phoneNumber;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPersonValidationScreen(visit,widget.actionCallBackAfter)));
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Color.fromRGBO(46, 204, 113, 1)),
              ],
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
