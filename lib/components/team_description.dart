import 'package:address_manager/components/edit_person_dialog.dart';
import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/dialog_helper.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/team/delete_team_dto.dart';
import 'package:address_manager/models/dto/team/update_team_dto.dart';
import 'package:address_manager/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tools/colors.dart';

class TeamDescription extends StatefulWidget {

  final List<dynamic> teams;

  TeamDescription(this.teams);

  @override
  TeamDescriptionState createState() => TeamDescriptionState();
}

class TeamDescriptionState extends State<TeamDescription> {

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


  @override
  void dispose() {
    super.dispose();
    statusNameController.dispose();
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
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: SingleChildScrollView(
        child: Column(

          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Invite person(s)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person_add,color: green_custom_color),
                  onPressed: (){},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildDescription(),
            ),
          ],
        ),
      ),
    );
  }

  _buildDescription(){
    List<Widget> content = [];
    widget.teams.forEach((team){

      Row title = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(team['name'],
            style: TextStyle(
                fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(icon: Icon(Icons.edit, color: Colors.orange,size: 18,), onPressed: (){
                _selectedTeamIndex = widget.teams.indexOf(team);
                editTeam();
              }),
              IconButton(icon: Icon(Icons.close, color: Colors.red,size: 18,), onPressed: (){
                _selectedTeamIndex = widget.teams.indexOf(team);
                deleteTeam();

              }),
            ],
          )
        ],
      );
      Divider divider = Divider(color: Colors.black,height: 5,);

      List<dynamic> zones = team["zones"];
      List<Widget> rows = [];
      zones.forEach((zone){
        Padding row = Padding(padding: EdgeInsets.only(bottom: 5),child: Row(
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
                Text(zone['visits'].length.toString() + ' address', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
              ],
            )
          ],
        ));
        rows.add(row);
      });
      Padding wrapper = Padding(padding: EdgeInsets.only(top:10,bottom: 10),child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rows,
      ));
      content.add(title);
      content.add(divider);
      content.add(wrapper);

    });
    return content;
  }

  editTeam(){
    teamEditNameController.text = widget.teams[_selectedTeamIndex]['name'];
    List<Widget> content = [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: teamEditNameController,
              decoration: InputDecoration(
                  hasFloatingPlaceholder: true,
                  prefixIcon: Icon(Icons.group, color: Colors.brown,),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black)),
                  alignLabelWithHint: true,
                  hintText: 'Name'
              ),
            ),
          ],
        ),
      )
    ];
    DialogHelperState.showDialogBox(
        this.context, 'Edit Team', content, editAction,false);
  }

  deleteTeam(){
    editTeamDialogState.showDeleteDialog(context, widget.teams[_selectedTeamIndex], deleteAction());
  }

  editAction(){
    UpdateTeamDto team = UpdateTeamDto(widget.teams[_selectedTeamIndex]['uuid'],teamEditNameController.text);
    teamController.updateOne(team);
    teamEditNameController.clear();
  }

  deleteAction(){
    DeleteTeamDto team = DeleteTeamDto(widget.teams[_selectedTeamIndex]['uuid']);
    teamController.deleteOne(team);
  }
}
