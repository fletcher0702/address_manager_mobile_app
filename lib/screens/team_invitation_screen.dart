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
  String selectedTeam = '';
  int _selectedTeamIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                  List<DropdownMenuItem<int>> teamsItems = teamHelper.buildDropDownSelection(widget.teams);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      child: AlertDialog(
                        title: Center(child: Text('Add People',style: TextStyle(
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


                                ],
                              ),
                              InputTags(
                                  tags: _tags,
                                  onDelete: (tag){
                                    print('deleted '+ tag);
                                  },
                                  onInsert: (tag){
                                    print(tag);
                                  },
                                columns: 2,
                                  ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(icon: Icon(Icons.cancel,color: Colors.red,), onPressed: (){
                                    _tags.clear();
                                    _selectedTeamIndex = -1;
                                    Navigator.pop(context);
                                  }),
                                  SizedBox(width: 20,),
                                  IconButton(icon: Icon(Icons.send,color: green_custom_color,), onPressed: (){

                                    bool validTags = _validateTags();

                                    if(_selectedTeamIndex!=-1){
                                      if(validTags && _selectedTeamIndex!=-1){
                                        teamController.invitePeople(widget.teams[_selectedTeamIndex]['uuid'], _tags);
                                      }else{
                                        // TODO: UI validation
                                        print('Invalid email in your selection...');
                                      }
                                    }else{
                                      // TODO: UI validation
                                      print('Select a team...!');
                                    }


                                  })
                                ],
                              )


                            ],
                          ),

                        ),
                      )
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validateTags(){

    bool res = true;
    _tags.forEach((person){
      if(!AuthHelper.isEmail(person)) res = false;
    });

    return res;
  }
}
