import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/auth_helper.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:address_manager/tools/colors.dart';
import 'package:address_manager/tools/messages.dart';
import 'package:address_manager/tools/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/input_tags.dart';

class HotDialogInvitation extends StatefulWidget {

  final List<dynamic> teams;
  HotDialogInvitation(this.teams);

  @override
  _HotDialogInvitationState createState() => _HotDialogInvitationState();
}

class _HotDialogInvitationState extends State<HotDialogInvitation> {

  List<dynamic> teamsAllowed = [];
  List<String> _tags = [];
  TeamHelper teamHelper = TeamHelper();
  TeamController teamController = TeamController();
  List<DropdownMenuItem<int>> teamsItems;
  List<dynamic> selectedTeamMembers = [];
  String selectedTeam = '';
  String errorMessage = '';
  int _selectedTeamIndex = -1;
  int _selectedMemberIndex;
  Container errorBox = Container();


  @override
  void initState() {
    super.initState();
    teamsAllowed = teamHelper.getAllowTeams(widget.teams);
    teamsItems = teamHelper.buildDropDownSelection(teamsAllowed);
  }

  _getContent(){

    return Column(
      children: <Widget>[
        errorBox,
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
                  setState(() {
                    selectedTeam = teamsAllowed[value]['name'];
                    _selectedTeamIndex= value;
                  });
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
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTransition(SUCCESS_INVITATION_CREATION,ERROR_INVITATION_CREATION,_sendInvitation,INVITE_ACTION,(){})) );
                }else{
                  setState(() {
                    errorMessage = 'Error bad email syntax...';
                    errorBox = UIHelper.errorMessageWidget(errorMessage,updateUI);
                  });
                }
              }else{
                setState(() {
                  errorMessage = 'Select valid team...';
                  errorBox = UIHelper.errorMessageWidget(errorMessage,updateUI);
                });
              }


            })
          ],
        )


      ],
    );
  }

  bool _validateTags(){

    bool res = true;
    _tags.forEach((person){
      if(!AuthHelper.isEmail(person)) res = false;
    });

    return res && _tags.isNotEmpty;
  }

  updateUI(){
    setState(() {
      errorBox = Container();
    });
  }

  _sendInvitation() async {
    return teamController.invitePeople(teamsAllowed[_selectedTeamIndex]['uuid'], _tags);
  }

  _errorMessageWidget(errorMessage){

    Container c = Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),

      ),
      height: 30,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            SizedBox(width: 10,),
            Row(
              children: <Widget>[
                Text(errorMessage,style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,

                ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(icon: Icon(Icons.clear, color: Colors.white,size: 15,), onPressed: (){
                  setState(() {
                    errorBox = Container();
                  });
                }),
              ],
            )
          ],
        ),
      ),
    );

    return c;
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
