import 'package:address_manager/components/hot_dialog_invitation.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/team/uninvite_user_dto.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:address_manager/tools/messages.dart';
import 'package:address_manager/tools/actions.dart';
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
  String _selectedTeamUuid ='';
  String _selectedEmail = '';
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
                        title: Center(child: Text('Invite People',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                        content: SingleChildScrollView(
                          child: HotDialogInvitation(widget.teams,refreshMembers),

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
                    _selectedTeamUuid = teamsAllowed[value]['uuid'];
                    _selectedTeamIndex= value;
                    selectedTeamMembers = [];
                    setState(() {
                      selectedTeamMembers = buildMembersDescription(teamsAllowed);
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,top: 20.0),
            child: Text('Members',style: TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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

  buildMembersDescription(teams){

    List<Widget> rows = [];
    var team = getCurrentTeam(teams);
    List<dynamic> users = team["emails"];

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
            Text(user,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),),
            IconButton(icon: Icon(Icons.clear,color: Colors.red,size: 18), onPressed: (){
              _selectedTeamIndex = widget.teams.indexOf(team);
              _selectedMemberIndex = users.indexOf(user);

              showDialog(context: (context),builder: (context){
                return SimpleDialog(
                  title: Center(
                      child: Text(
                        'Are you sure ?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  children: <Widget>[
                    Center(
                        child: Text(
                          user,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            onPressed: () async {
                              _selectedEmail = user;
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(SUCCESS_DELETE,ERROR_DELETE,uninviteUser,UN_INVITE_ACTION,refreshMembers)));
                            },
                            child: Text(
                              'DELETE',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },barrierDismissible: true);

            })
          ],

        ),
      )
      );
      rows.add(row);

    });

    return rows;
  }

  getCurrentTeam(List<dynamic>teams){

    var currentTeam;
    Iterator it = teams.iterator;
    while(it.moveNext()){
      var t = it.current;
      if(t['uuid'].toString() == _selectedTeamUuid){
        currentTeam = t;
        break;
      }
    }
    return currentTeam;

  }

  refreshMembers(){

    teamController.findAll().then((res) {
      teamsAllowed = teamHelper.getAllowTeams(res);
      setState(() {
        selectedTeamMembers=buildMembersDescription(teamsAllowed);
      });
    });
  }

  uninviteUser() async {
    UnInviteUserDto userDto = UnInviteUserDto();

    userDto.teamUuid = widget.teams[_selectedTeamIndex]['uuid'];
    userDto.email = _selectedEmail;

    return teamController.unInvitePeople(userDto);

  }
}
