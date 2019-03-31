import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter/material.dart';

import '../components/edit_person_dialog.dart';
import '../components/loader.dart';
import 'package:address_manager/screens/add_person_dialog.dart';
import '../components/panel_app_bar.dart';
import '../components/side_menu.dart';
import '../controller/visit_controller.dart';
import '../controller/zone_controller.dart';
import '../screens/add_person_dialog.dart';
import '../tools/colors.dart';

class VisitPanelScreen extends StatefulWidget {
  @override
  VisitPanelScreenState createState() => VisitPanelScreenState();
}

class VisitPanelScreenState extends State<VisitPanelScreen> {
  BuildContext context;
  VisitController visitController = VisitController();
  ZoneController zoneController = ZoneController();
  final teamController = TeamController();
  final teamHelper = TeamHelper();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();
  var visits;
  var zones;
  List<dynamic> teams;

  var selectedZone;
  var selectedTeam;

  var teamToAddInto;
  var zoneToAddInto;
  bool zoneToggle = false;
  bool visitToggle = false;
  bool onChangedZoneToggle = false;
  bool teamToggle = false;
  List<DropdownMenuItem<dynamic>> locations = [];
  List<DropdownMenuItem> teamsDropDownItems = List<DropdownMenuItem>();
  List<dynamic> zonesElements = [];
  List<dynamic> visitsElements = [];
  List<Widget> visitsRows = [];
  int _selectedZoneIndex = -1;
  int _selectedTeamIndex = -1;
  String _currentTeamUuidForReload = '';
  String _currentZoneUuidForReload = '';



  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  loadTeams(){
    teamController.findAll().then((res) {

      setState(() {
        teams = res;
        teamsDropDownItems = teamHelper.buildDropDownSelection(teams);
        teamToggle = true;
        if(_currentZoneUuidForReload.isNotEmpty && _currentTeamUuidForReload.isNotEmpty){
          refreshVisits();
        }
      });

    });
  }

  addVisit() {
    addPersonDialog.dialog(this.context, teams, _selectedTeamIndex,_selectedZoneIndex, loadTeams);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Visits Panel', Icons.person_add, addVisit,loadTeams),
        preferredSize: Size(double.infinity, 50.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group, color: Colors.brown),
                SizedBox(width: 5,),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: selectedTeam != null
                        ? Text(selectedTeam,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    elevation: 0,
                    items: teamToggle ? teamsDropDownItems : [],
                    onChanged: (value) async {
                      setState(() {
                        onChangedZoneToggle = true;
                        selectedTeam = teams[value]['name'];
                        _selectedTeamIndex = value;
                        selectedZone = '';
                        _currentTeamUuidForReload = teams[value]['uuid'];
                        _currentZoneUuidForReload = '';
                        locations = teamHelper.buildDropDownSelection(
                            teams[value]['zones']);

                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, color: Colors.blue),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: selectedZone != null
                        ? Text(selectedZone,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    elevation: 0,
                    items: locations,
                    onChanged: (value) async {
                      setState(() {
                        onChangedZoneToggle = true;
                        selectedZone =
                        teams[_selectedTeamIndex]["zones"][value]['name'];
                        _selectedZoneIndex = value;
                        visitsElements = teams[_selectedTeamIndex]["zones"][value]['visits'];
                        _currentZoneUuidForReload = teams[_selectedTeamIndex]["zones"][value]['uuid'];
                        buildVisitsList(context);
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0,right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: visitsRows,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildVisitsList(context) {
    visitsRows.clear();
    visitsElements.forEach((element) {
      SingleChildScrollView row = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(top: 5,bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.person_pin, color: green_custom_color,),
              SizedBox(width: 10,),
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            element['name'],
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          ),

                          IconButton(icon: Icon(Icons.edit, color: Colors.orangeAccent, size: 15 ), onPressed: (){
                            editPersonDialog.dialog(context, teams,_selectedTeamIndex,
                                _selectedZoneIndex,element, loadTeams);
                          }),
                          IconButton(icon: Icon(Icons.delete, color: Colors.red,size: 15), onPressed: (){editPersonDialog.showDeleteDialog(context,element,teams[_selectedTeamIndex]["zones"][_selectedZoneIndex]["uuid"]);})
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,child: Text(element['address'])),
                    Text(element['status']['name']),
                    Padding(
                      padding: EdgeInsets.only(top:5.0),
                      child: Container(color: Colors.black,height: 1,width: double.maxFinite,),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      );

      visitsRows.add(row);
    });
  }

  refreshVisits() {
    teams.forEach((t){

      if(t['uuid'].toString()==_currentTeamUuidForReload){
        List<dynamic> zones = t['zones'];

        zones.forEach((z){

          if(z['uuid'].toString() == _currentZoneUuidForReload){
            visitsElements = z['visits'];
            buildVisitsList(context);
          }
        });
      }

    });
  }
}
