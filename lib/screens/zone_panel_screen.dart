import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/components/hot_dialog_zone_add.dart';
import 'package:address_manager/components/hot_dialog_zone_edit.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/zone/delete_zone_dto.dart';
import 'package:flutter/material.dart';

import '../components/loader.dart';
import '../components/panel_app_bar.dart';
import '../components/side_menu.dart';
import '../controller/zone_controller.dart';
import '../models/zone.dart';

class ZonePanelScreen extends StatefulWidget {
  @override
  ZonePanelScreenState createState() => ZonePanelScreenState();
}

class ZonePanelScreenState extends State<ZonePanelScreen> {
  final TeamHelper teamHelper = TeamHelper();
  EditTeamDialogState editTeamDialogState = EditTeamDialogState();
  final zoneController = ZoneController();
  final teamController = TeamController();
  BuildContext context;
  var zones;
  var selectedTeam;
  var selectedZone;
  var teamToAddInto;
  int _selectedTeamIndex = -1;
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<dynamic> teamsElements = [];
  var teamsData = [];
  List<DropdownMenuItem> teams = [];
  List<Widget> _zoneDescription = List<Widget>();
  bool teamToggle = false;
  String _currentTeamUuidAfterCallBackReload = '';


  @override
  void initState() {
    super.initState();
    loadTeamsData();
  }

  @override
  void dispose() {
    zoneNameController.dispose();
    zoneAddressController.dispose();
    super.dispose();
  }
  loadTeamsData() async {
    teamController.findAll().then((data) {
      setState(() {
        teamsData = teamHelper.getAllowTeams(data);
        teamToggle = true;
        teams = teamHelper.buildDropDownSelection(teamsData);
        if(_currentTeamUuidAfterCallBackReload.isNotEmpty){
          _refreshZones();
        }
      });
    });
  }

  addZone() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            children: <Widget>[
              HotDialogZoneAdd(teamsData,_selectedTeamIndex,loadTeamsData),
            ],

          );
        }
    );
  }

  deleteZoneAction() async{
    DeleteZoneDto deleteZoneDto = DeleteZoneDto(teamsData[_selectedTeamIndex]['uuid'],selectedZone['uuid']);
    return zoneController.deleteOne(deleteZoneDto);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Zone Panel', Icons.add_location, addZone,loadTeamsData),
        preferredSize: Size(double.infinity, 100.0),
      ),
      body: teamToggle ? SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group,color: Colors.brown,),
                SizedBox(width: 5,),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: teams,
                    hint: selectedTeam != null
                        ? Text(selectedTeam,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamIndex = value;
                        selectedTeam = teamsData[value]['name'];
                        _currentTeamUuidAfterCallBackReload =
                        teamsData[value]['uuid'];
                        selectedTeamDescription(teamsData[value]);
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: _zoneDescription,
                ),
              ),
            )

          ],
        ),
      ) : ColorLoader(),
    );
  }


  selectedTeamDescription(team) {
    List<Widget> content = [];
    Row title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(team['name'],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
      ],
    );
    Divider divider = Divider(color: Colors.black, height: 5,);

    List<dynamic> zones = team["zones"];
    List<Widget> rows = [];
    zones.forEach((zone) {
      Padding row = Padding(padding: EdgeInsets.only(bottom: 5), child: Row(
        children: <Widget>[

          Icon(Icons.place, color: Colors.blue),
          SizedBox(width: 3,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(zone['name'], style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              Text(zone['visits'].length.toString() + ' address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
            ],
          ),
          team['admin']?Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit, color: Colors.orange, size: 18,),
                  onPressed: () {
                    showDialog(
                        context: context,
                      barrierDismissible: true,
                      builder: (context){
                          return SimpleDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            children: <Widget>[
                              HotDialogZoneEdit(teamsData,_selectedTeamIndex,zone,loadTeamsData),
                            ],

                          );
                      }
                    );
                  }),
              IconButton(icon: Icon(Icons.close, color: Colors.red, size: 18,),
                  onPressed: () {
                    selectedZone = zone;
                    editTeamDialogState.showDeleteDialog(context, selectedZone, deleteZoneAction,loadTeamsData);
                  }),
            ],
          ):Row(),
        ],
      ));
      rows.add(row);
    });
    Padding wrapper = Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10), child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    ));
    content.add(title);
    content.add(divider);
    content.add(wrapper);
    _zoneDescription = content;
  }

   _refreshZones() {
      teamsData.forEach((t){
        if(t['uuid'].toString()==_currentTeamUuidAfterCallBackReload){
          setState(() {
            selectedTeamDescription(t);
          });
        }
      });
    }
}
