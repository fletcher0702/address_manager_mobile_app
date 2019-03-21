import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/status/delete_status_dto.dart';
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
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  String selectedTeam = '';

  int _selectedTeamIndex;
  int _selectedStatusIndex;

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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Add status',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle,color: green_custom_color),
                onPressed: (){
                  List<DropdownMenuItem<int>> teamsItems = teamHelper.buildDropDownSelection(widget.teams);
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Center(child: Text('Add Status',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                        content: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.group,color:Colors.brown),
                                  SizedBox(width: 5,),
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
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.color_lens,color:pickerColor),
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          child: AlertDialog(
                                            title: Center(child: Text('Choose status color',style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),)),
                                            content: SingleChildScrollView(
                                              child:  ColorPicker(
                                                  pickerColor: Colors.blue,
                                                  enableLabel: true,
                                                  pickerAreaHeightPercent: 0.8,
                                                  onColorChanged: changeColor
                                              ),
                                            ),
                                            actions: <Widget>[
                                              IconButton(icon: Icon(Icons.colorize,color: pickerColor,), onPressed: pickerAction)
                                            ],
                                          )
                                      );
                                    },
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.filter_list,
                                            color: Colors.black,
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          alignLabelWithHint: true,
                                          hintText: 'New, Visit..',
                                          hintStyle:
                                          TextStyle(color: Colors.black)),
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      controller: statusNameController,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center
                                ,
                                children: <Widget>[
                                  FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('CANCEL',style: TextStyle(
                                      color: Colors.white
                                  ),),color: green_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),
                                  SizedBox(width: 10,),
                                  FlatButton(onPressed: (){

                                    if(statusNameController.text.isNotEmpty){
                                      Status status = Status(widget.teams[_selectedTeamIndex]["uuid"],statusNameController.text,pickerColor.value);
                                      teamController.createStatus(status);
                                    }

                                  }, child: Text('SAVE',style: TextStyle(
                                      color: Colors.white
                                  )),color: green_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),

                                ],
                              )

                            ],
                          ),

                        ),
                        actions: <Widget>[

                        ],
                      )
                  );
                },
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
              children: buildStatusDescription(),
            ),
          )

        ],
      ),
    );
  }

  buildStatusDescription(){

    List<Widget> rows = [];

    widget.teams.forEach((team){

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
              //              editTeamDialogState.showDeleteDialog(context, status, (){});
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

    });

    return rows;
  }



  deleteStatus(){
    String teamUuid = widget.teams[_selectedTeamIndex]['uuid'];
    String statusUuid = widget.teams[_selectedTeamIndex]["status"][_selectedStatusIndex]['uuid'];
    print('Team Uuid : '+teamUuid );
    print('Status Uuid : '+statusUuid);
    DeleteStatusDto deleteStatusDto = DeleteStatusDto(teamUuid,statusUuid);
    teamController.deleteStatus(deleteStatusDto);
  }
}
