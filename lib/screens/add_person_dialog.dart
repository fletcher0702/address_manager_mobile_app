import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../helpers/team_helper.dart';
import '../models/visit.dart';
import '../screens/add_person_validation.dart';
import '../tools/const.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddPersonDialog extends StatefulWidget {
  @override
  AddPersonDialogState createState() => AddPersonDialogState();
}

class AddPersonDialogState extends State<AddPersonDialog> {
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

  @override
  void dispose() {
    visitAddressController.dispose();
    visitNameController.dispose();
    visitPhoneNumberController.dispose();
    super.dispose();
  }


  Future<bool> dialog(
      context, teams,selectedTeamIndex,selectedZoneIndex, actionCallBackAfter) async {

    List<DropdownMenuItem<int>> teamsItems = teamHelper.buildDropDownSelection(teams);
    List<DropdownMenuItem<int>> zonesItems = [];
    List<DropdownMenuItem<int>> statusItems = [];
    if(selectedTeamIndex!=-1 && selectedZoneIndex!=-1){
      var zones = teams[selectedTeamIndex]["zones"];
      var status = teams[selectedTeamIndex]["status"];
      selectedZone = zones[selectedZoneIndex]["name"];
      selectedTeam = teams[selectedTeamIndex]["name"];
      _selectedZoneIndex = selectedZoneIndex;
      _selectedTeamIndex = selectedTeamIndex;
      zonesItems = teamHelper.buildDropDownSelection(zones);
      statusItems = teamHelper.buildDropDownSelection(status);
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            Padding(
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
                              selectedTeam = teams[value]['name'];
                              _selectedTeamIndex= value;
                              selectedZone = '';
                              zonesItems = teamHelper.buildDropDownSelection(teams[_selectedTeamIndex]["zones"]);
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
                              selectedZone = teams[_selectedTeamIndex]["zones"][value]['name'];
                              _selectedZoneIndex = value;
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
                              _selectedStatusIndex = value;
                              selectedStatusName = teams[_selectedTeamIndex]["status"][value]["name"];
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {

                      String name = visitNameController.text;
                      String address = visitAddressController.text;
                      String phoneNumber = visitPhoneNumberController.text;
                      String teamUuid = teams[_selectedTeamIndex]["uuid"];
                      String zoneUuid = teams[_selectedTeamIndex]["zones"][_selectedZoneIndex]["uuid"];
                      String statusUuid = teams[_selectedTeamIndex]["status"][_selectedStatusIndex]["uuid"];
                      Visit visit = Visit(teamUuid,name, address, zoneUuid, statusUuid);

                      if (phoneNumber.isNotEmpty)
                        visit.phoneNumber = phoneNumber;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPersonValidationScreen(visit)));
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Color.fromRGBO(46, 204, 113, 1)),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Color.fromRGBO(46, 204, 113, 1),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
