import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/components/hot_dialog_status.dart';
import 'package:address_manager/components/hot_dialog_status_update.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/status/delete_status_dto.dart';
import 'package:address_manager/models/dto/status/update_status_dto.dart';
import 'package:flutter/material.dart';

import '../tools/colors.dart';


// ignore: must_be_immutable
class TeamStatusScreen extends StatefulWidget {

  @override
  _TeamStatusScreenState createState() => _TeamStatusScreenState();
}

class _TeamStatusScreenState extends State<TeamStatusScreen> {

  BuildContext context;
  final statusNameController = TextEditingController();
  TeamHelper teamHelper = TeamHelper();
  TeamController teamController = TeamController();
  TextEditingController teamEditNameController = TextEditingController();
  EditTeamDialogState editTeamDialogState = EditTeamDialogState();
  List<DropdownMenuItem<int>> teamsItems;
  List<Widget> selectedTeamStatus = [];
  List<dynamic> teams = [];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  String _currentTeamUuidForRefresh = '';

  String selectedTeam = '';

  int _selectedTeamIndex = -1;
  int _selectedStatusIndex = -1;


  @override
  void initState() {
    super.initState();

    teamController.findAll().then((data) {
      teams = data;
      setState(() {
        teamsItems = teamHelper.buildDropDownSelection(teams);
      });
    });
  }

  void changeColor(Color color){
    setState(() {
      pickerColor = color;
    });
  }

  void pickerAction(){
    setState(() {
      currentColor = pickerColor;
    });
    Navigator.of(context).pop();
  }

  afterAction() async {
    teamController.findAll().then((data) {
      teams = data;

      setState(() {
        if (_currentTeamUuidForRefresh.isNotEmpty) {
          teams.forEach((t) {
            if (t['uuid'].toString() == _currentTeamUuidForRefresh) {
              selectedTeamStatus = buildStatusDescription(t);
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Add Status',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle,color: green_custom_color),
                  onPressed: (){
                    statusNameController.text = '';
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Center(child: Text('Add Status',style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),)),
                          content: SingleChildScrollView(
                            child: HotDialogStatus(
                                teams, _selectedTeamIndex, afterAction),

                          ),
                        )
                    );
                  },
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group,color: Colors.brown,),
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
                      selectedTeam = teams[value]['name'];
                      _selectedTeamIndex= value;
                      _currentTeamUuidForRefresh = teams[value]['uuid'];
                      selectedTeamStatus = [];
                      setState(() {
                        selectedTeamStatus =
                            buildStatusDescription(teams[value]);
                      });
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: 20.0),
              child: Text('Status',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Divider(color: Colors.black,height: 3,indent: MediaQuery.of(context).size.width*0.05),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: selectedTeamStatus.length==0?[Center(child: Text('Empty... Please create status or select team...',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),)]:selectedTeamStatus,
              ),
            )

          ],
        ),
      ),
    );
  }

  buildStatusDescription(team) {

    List<Widget> rows = [];
    List<dynamic> status = team["status"];

    status.forEach((statusItem){

      Padding row  = Padding(padding: EdgeInsets.only(top: 1,bottom: 1),child:
      Row(

        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(statusItem["color"]),),

          ),
          SizedBox(width: 20,),
          Text(statusItem['name'],style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
          team['admin']?Row(
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit,color: Colors.deepOrangeAccent,size: 18,), onPressed: (){
                _selectedTeamIndex = teams.indexOf(team);
                _selectedStatusIndex = status.indexOf(statusItem);
                statusNameController.text = teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['name'];
                Color selectedStatusColor = Color(teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['color']);
                pickerColor = selectedStatusColor;
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Center(child: Text('Edit Status',style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),)),
                      content: SingleChildScrollView(
                        child: HotDialogStatusUpdate(teams, _selectedTeamIndex,_selectedStatusIndex,afterAction),

                      ),
                    )
                );
              }),
              IconButton(icon: Icon(Icons.clear,color: Colors.red,size: 18), onPressed: (){
                _selectedTeamIndex = teams.indexOf(team);
                _selectedStatusIndex = status.indexOf(statusItem);
                editTeamDialogState.showDeleteDialog(context, statusItem, deleteStatus,afterAction);
              })
            ],
          ):Row(),
        ],

      )
      );
      rows.add(row);

    });

    return rows;
  }

  deleteStatus(){
    String teamUuid = teams[_selectedTeamIndex]['uuid'];
    String statusUuid = teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['uuid'];
    DeleteStatusDto deleteStatusDto = DeleteStatusDto(teamUuid,statusUuid);
    return teamController.deleteStatus(deleteStatusDto);
  }
}
