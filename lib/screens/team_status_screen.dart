import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/components/hot_dialog_status.dart';
import 'package:address_manager/components/hot_dialog_status_update.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/status/delete_status_dto.dart';
import 'package:address_manager/models/dto/status/update_status_dto.dart';
import 'package:address_manager/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tools/colors.dart';


// ignore: must_be_immutable
class TeamStatusScreen extends StatefulWidget {

  List<dynamic> teams;

  TeamStatusScreen(this.teams);

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
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  String selectedTeam = '';

  int _selectedTeamIndex;
  int _selectedStatusIndex;


  @override
  void initState() {
    super.initState();
    setState(() {
      teamsItems = teamHelper.buildDropDownSelection(widget.teams);
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
                    List<DropdownMenuItem<int>> teamsItems = teamHelper.buildDropDownSelection(widget.teams);
                    statusNameController.text = '';
                    showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Center(child: Text('Add Status',style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),)),
                          content: SingleChildScrollView(
                            child: HotDialogStatus(widget.teams,_selectedTeamIndex,(){}),

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
                      selectedTeam = widget.teams[value]['name'];
                      _selectedTeamIndex= value;
                      selectedTeamStatus = [];
                      setState(() {
                        selectedTeamStatus = buildStatusDescription();
                      });
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,top: 20.0),
              child: Text('Status',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Divider(color: Colors.black,height: 3,indent: 20),
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

  buildStatusDescription(){

    List<Widget> rows = [];
    var team = widget.teams[_selectedTeamIndex];
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
          IconButton(icon: Icon(Icons.edit,color: Colors.deepOrangeAccent,size: 18,), onPressed: (){
            _selectedTeamIndex = widget.teams.indexOf(team);
            _selectedStatusIndex = status.indexOf(statusItem);
            statusNameController.text = widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['name'];
            Color selectedStatusColor = Color(widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['color']);
            pickerColor = selectedStatusColor;
            showDialog(
                context: context,
                child: AlertDialog(
                  title: Center(child: Text('Edit Status',style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),)),
                  content: SingleChildScrollView(
                    child: HotDialogStatusUpdate(widget.teams, _selectedTeamIndex,_selectedStatusIndex,(){}),

                  ),
                )
            );
          }),
          IconButton(icon: Icon(Icons.clear,color: Colors.red,size: 18), onPressed: (){
            _selectedTeamIndex = widget.teams.indexOf(team);
            _selectedStatusIndex = status.indexOf(statusItem);
            editTeamDialogState.showDeleteDialog(context, statusItem, deleteStatus);
          })
        ],

      )
      );
      rows.add(row);

    });

    return rows;
  }

  updateStatus(){
    String teamUuid = widget.teams[_selectedTeamIndex]['uuid'];
    String statusUuid = widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['uuid'];

    UpdateStatusDto updateStatusDto = UpdateStatusDto(teamUuid,statusUuid);
    updateStatusDto.name = statusNameController.text;
    updateStatusDto.color = pickerColor.value;
    teamController.updateStatus(updateStatusDto);
  }

  deleteStatus(){
    String teamUuid = widget.teams[_selectedTeamIndex]['uuid'];
    String statusUuid = widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['uuid'];
    DeleteStatusDto deleteStatusDto = DeleteStatusDto(teamUuid,statusUuid);
    teamController.deleteStatus(deleteStatusDto);
  }
}
