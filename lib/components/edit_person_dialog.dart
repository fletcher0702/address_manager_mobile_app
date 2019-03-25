import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/visit/delete_visit_dto.dart';
import 'package:address_manager/models/dto/visit/update_visit_dto.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../controller/visit_controller.dart';
import '../models/visit.dart';
import '../screens/delete_person_validation.dart';
import '../screens/edit_person_validation.dart';

class EditPersonDialog extends StatefulWidget {
  @override
  EditPersonDialogState createState() => EditPersonDialogState();
}

class EditPersonDialogState extends State<EditPersonDialog> {
  VisitController visitController = VisitController();
  UserController  userController = UserController();

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
  int _selectedZoneIndex;
  var selectedType;
  var selectedTeam = '';
  var selectedStatusName ='';
  int _selectedTeamIndex;
  int _selectedStatusIndex=-1;
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
      context, teams,selectedTeamIndex,selectedZoneIndex,person, actionCallBackAfter) async {

    List<DropdownMenuItem<int>> teamsItems = teamHelper.buildDropDownSelection(teams);
    List<DropdownMenuItem<int>> zonesItems = [];
    List<DropdownMenuItem<int>> statusItems = [];
    if(selectedTeamIndex!=-1 && selectedZoneIndex!=-1){
      visitNameController.text = person['name'];
      visitAddressController.text = person['address'];
      visitPhoneNumberController.text = person['phoneNumber'];
      selectedStatusName = person['status']['name'];
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
                      'Edit Person',
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
              children: <Widget>[
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
                  color: Colors.deepOrangeAccent,
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {

                      print('update request ! ');
                      var userCredntials = await userController.getCredentials();
                      String userUuid = userCredntials['uuid'].toString();
                      String name = visitNameController.text;
                      String address = visitAddressController.text;
                      String phoneNumber = visitPhoneNumberController.text;
                      String visitUuid = person['uuid'];
                      String teamUuid = teams[_selectedTeamIndex]["uuid"];
                      String zoneUuid = teams[_selectedTeamIndex]["zones"][_selectedZoneIndex]["uuid"];
                      String statusUuid = _selectedStatusIndex!=-1?teams[_selectedTeamIndex]["status"][_selectedStatusIndex]["uuid"]:person['status']['uuid'];
                      UpdateVisitDto visitDto = UpdateVisitDto(userUuid,teamUuid,zoneUuid,visitUuid,statusUuid,name,address,phoneNumber);

                      visitController.updateVisit(visitDto);
//                      Navigator.pop(context);
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  AddPersonValidationScreen(visit)));
                    },
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.deepOrangeAccent),

              ],
            ),
          ],
        );
      },
    );
  }

  showDeleteDialog(context, element,zoneUuid) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
              element['name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            children: <Widget>[
              Center(
                  child: Text(
                'Are you sure ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FlatButton(
                      onPressed: () async {
                        var userCredentials = await userController.getCredentials();
                        DeleteVisitDto visitDto = DeleteVisitDto(userCredentials['uuid'],zoneUuid,element['uuid']);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DeletePersonValidationScreen(
                                        visitDto)));
                      },
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
