import 'package:address_manager/components/hot_dialog_invitation.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/auth_helper.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter_tags/input_tags.dart';
import 'package:flutter/material.dart';
import '../tools/colors.dart';

class TeamInvitationScreen extends StatefulWidget {

  List<dynamic> teams;

  TeamInvitationScreen(this.teams);

  @override
  _TeamInvitationScreenState createState() => _TeamInvitationScreenState();
}

class _TeamInvitationScreenState extends State<TeamInvitationScreen> {

  List<String> _tags = [];
  TeamHelper teamHelper = TeamHelper();
  TeamController teamController = TeamController();
  List<DropdownMenuItem<int>> teamsItems;
  List<dynamic> selectedTeamMembers = [];
  List<dynamic> teamsAllowed = [];
  String selectedTeam = '';
  int _selectedTeamIndex;
  int _selectedMemberIndex;


  @override
  void initState() {
  super.initState();
  setState(() {
    teamsAllowed = teamHelper.getAllowTeams(widget.teams);
    teamsItems = teamHelper.buildDropDownSelection(teamsAllowed);
  });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                onPressed: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: AlertDialog(
                        title: Center(child: Text('Add People',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                        content: SingleChildScrollView(
                          child: HotDialogInvitation(widget.teams),

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
                    selectedTeam = teamsAllowed[value]['name'];
                    _selectedTeamIndex= value;
                    selectedTeamMembers = [];
                    setState(() {
                      selectedTeamMembers = buildMembersDescription();
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20,top: 20.0),
            child: Text('Members',style: TextStyle(
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
              children: selectedTeamMembers.length==0?[Center(child: Text('Empty... Please invite members or select a team...',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),),)]:selectedTeamMembers,
            ),
          )
        ],
      ),
    );
  }

  buildMembersDescription(){

    List<Widget> rows = [];
    var team = widget.teams[_selectedTeamIndex];
    List<dynamic> users = team["users"];

    users.forEach((user){

      Padding row  = Padding(padding: EdgeInsets.only(top: 1,bottom: 1),child:
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(

          children: <Widget>[
            Container(
              height: 20,
              width: 20,
              child: Icon(Icons.mail_outline),

            ),
            SizedBox(width: 20,),
            Text(user['uuid'],style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
            IconButton(icon: Icon(Icons.clear,color: Colors.red,size: 18), onPressed: (){
              _selectedTeamIndex = widget.teams.indexOf(team);
              _selectedMemberIndex = users.indexOf(user);
//            editTeamDialogState.showDeleteDialog(context, statusItem, deleteStatus);
            })
          ],

        ),
      )
      );
      rows.add(row);

    });

    return rows;
  }
}
