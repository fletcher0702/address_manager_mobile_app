import 'package:address_manager/components/edit_person_dialog.dart';
import 'package:address_manager/components/edit_team_dialog.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/dialog_helper.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/team/delete_team_dto.dart';
import 'package:address_manager/models/dto/team/update_team_dto.dart';
import 'package:flutter/material.dart';
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

  String selectedTeam = '';

  int _selectedTeamIndex;


  @override
  void dispose() {
    super.dispose();
    statusNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: SingleChildScrollView(
        child: Column(

          children: [
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
    editTeamDialogState.showDeleteDialog(context, widget.teams[_selectedTeamIndex], deleteAction);
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
