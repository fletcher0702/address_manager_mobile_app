import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/controller/visit_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/models/dto/visit/update_visit_dto.dart';
import '../tools/actions.dart';
import '../tools/messages.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:address_manager/tools/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

class HotDialogEdit extends StatefulWidget {

  List<dynamic> teams;
  int selectedTeamIndex;
  int selectedZoneIndex;
  var person;
  Function actionCallBackAfter;

  HotDialogEdit(this.teams,this.selectedTeamIndex,this.selectedZoneIndex,this.person,this.actionCallBackAfter);

  @override
  HotDialogEditState createState() => HotDialogEditState();
}

class HotDialogEditState extends State<HotDialogEdit> {

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  VisitController visitController = VisitController();
  UserController  userController = UserController();


  var selectedZone = '';
  var selectedTeam = '';
  var selectedStatusName ='';
  int _selectedZoneIndex = -1;
  int _selectedTeamIndex = -1;
  int _selectedStatusIndex = -1;

  final visitNameController = TextEditingController();
  final visitAddressController = TextEditingController();
  final visitPhoneNumberController = TextEditingController();
  final visitObservationController = TextEditingController();
  final teamHelper = TeamHelper();

  List<DropdownMenuItem<int>> teamsItems = [];
  List<DropdownMenuItem<int>> zonesItems = [];
  List<DropdownMenuItem<int>> statusItems = [];

  bool firstLaunch = false;
  String errorMessage = '';
  Container errorBox = Container();


  @override
  void initState() {
    super.initState();
    setState(() {
      teamsItems = teamHelper.buildDropDownSelection(widget.teams);
    });
  }

  _getContent(){
    if(widget.selectedTeamIndex!=-1 && widget.selectedZoneIndex!=-1 && !firstLaunch){
      visitNameController.text = widget.person['name'];
      visitAddressController.text = widget.person['address'];
      visitPhoneNumberController.text = widget.person['phoneNumber'];
      selectedStatusName = widget.person['status']['name'];
      var zones = widget.teams[widget.selectedTeamIndex]["zones"];
      var status = widget.teams[widget.selectedTeamIndex]["status"];
      selectedZone = zones[widget.selectedZoneIndex]["name"];
      selectedTeam = widget.teams[widget.selectedTeamIndex]["name"];
      _selectedZoneIndex = widget.selectedZoneIndex;
      _selectedTeamIndex = widget.selectedTeamIndex;
      zonesItems = teamHelper.buildDropDownSelection(zones);
      statusItems = teamHelper.buildDropDownSelection(status);
      firstLaunch = true;
    }

    return Column(
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
                errorBox,
                widget.teams[_selectedTeamIndex]['admin']?TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person,color: green_custom_color,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black)),
                    alignLabelWithHint: true,
                    hintText: 'label',
                    hintStyle:
                    TextStyle(color: Colors.black),
                  ),
                  cursorColor: Colors.black,
                  controller: visitNameController,
                ):Container(),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone,color: Colors.orangeAccent,),focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black)),
                      alignLabelWithHint: true,
                      hintText: 'phone number',
                      hintStyle:
                      TextStyle(color: Colors.black)
                  ),
                  cursorColor: Colors.black,
                  controller: visitPhoneNumberController,
                ),
                widget.teams[_selectedTeamIndex]['admin']?TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.place,color:Colors.blue,),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black)),
                    alignLabelWithHint: true,
                    hintText: 'address',
                    hintStyle:
                    TextStyle(color: Colors.black),
                  ),
                  cursorColor: Colors.black,

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
                ):Container(),
                DateTimePickerFormField(
                  inputType: inputType,
                  format: formats[inputType],
                  editable: editable,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black)),
                      alignLabelWithHint: true,
                      hintText: 'date',
                      hintStyle:
                      TextStyle(color: Colors.black)
                  ),
                  onChanged: (dt) => setState(() => date = dt),
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.note_add,color:Colors.green,),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black)),
                    alignLabelWithHint: true,
                    hintText: 'observation',
                    hintStyle:
                    TextStyle(color: Colors.black),
                  ),
                  cursorColor: Colors.black,

                  controller: visitObservationController,
                ),
                widget.teams[_selectedTeamIndex]['admin']?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.group,color:Colors.brown),
                    SizedBox(width: 10,),
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
                ):Container(),
                widget.teams[_selectedTeamIndex]['admin']?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.place,color:Colors.blue),
                    SizedBox(width: 10,),
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
                ):Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.filter_list,color:Colors.black),
                    SizedBox(width: 10,),
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
                firstLaunch = false;
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
                onPressed: (){

                  if(_selectedTeamIndex == -1 || _selectedZoneIndex == -1 || visitAddressController.text.isEmpty || visitNameController.text.isEmpty){
                    setState(() {
                      errorMessage = 'Please make sure no field is empty...';
                      errorBox = UIHelper.errorMessageWidget(errorMessage, updateErrorMessage);
                    });
                  }else{
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(SUCCESS_UPDATE,ERROR_UPDATE,editPerson,UPDATE_ACTION,widget.actionCallBackAfter)));
                  }
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

  }

  editPerson() async{
    var userCredentials = await userController.getCredentials();
    String userUuid = userCredentials['uuid'].toString();
    String name = visitNameController.text;
    String address = visitAddressController.text;
    String phoneNumber = visitPhoneNumberController.text;
    String visitUuid = widget.person['uuid'];
    String teamUuid = widget.teams[_selectedTeamIndex]["uuid"];
    String zoneUuid = widget.teams[_selectedTeamIndex]["zones"][_selectedZoneIndex]["uuid"];
    String statusUuid = _selectedStatusIndex!=-1?widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]["uuid"]:widget.person['status']['uuid'];
    UpdateVisitDto visitDto = UpdateVisitDto(userUuid,teamUuid,zoneUuid,visitUuid,statusUuid,name,address,phoneNumber);
    visitDto.date = date.toString();
    visitDto.observation = visitObservationController.text;

    print('Before update request');
    return visitController.updateVisit(visitDto);
  }

  updateErrorMessage(){
    setState(() {
      errorBox = Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
