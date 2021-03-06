import 'package:address_manager/components/loader.dart';
import 'package:address_manager/components/team_description.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/dialog_helper.dart';
import 'package:address_manager/models/team.dart';
import 'package:address_manager/screens/team_invitation_screen.dart';
import 'package:address_manager/screens/team_status_screen.dart';
import 'package:flutter/material.dart';

import '../tools/colors.dart';
import '../components/panel_app_bar_with_tabs.dart';
import '../components/side_menu.dart';


class TeamPanelScreen extends StatefulWidget {
  @override
  TeamPanelScreenState createState() => TeamPanelScreenState();


}

class TeamPanelScreenState extends State<TeamPanelScreen> {

  BuildContext context;
  TextEditingController teamNameController = TextEditingController();
  TeamController teamController = TeamController();
  List<Widget> teamsWidgetsList = List<Widget>();
  var teams = [];

  bool teamToggle = false;


  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  loadTeams(){
    teamController.findAll().then((res) {
      teams = res;
      setState(() {
        teamToggle = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    teamNameController.dispose();
  }

  saveAction() {
    Team team = Team(teamNameController.text);
    teamNameController.clear();
    return teamController.createOne(team);
  }

  createTeam(){
    List<Widget> content = [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: teamNameController,
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
        this.context, 'Add Team', content, saveAction,true,loadTeams);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        drawer: SideMenu(),
        appBar: PreferredSize(
            child: PanelAppBarWithTabs('Team Panel', Icons.group_add, createTeam,
                [
                  Tab(icon: Icon(Icons.group, color: Colors.brown,)),
                  Tab(icon: Icon(Icons.person_outline,color: green_custom_color,)),
                  Tab(icon: Icon(Icons.filter_list,color: Colors.black,)),
                ],loadTeams),
            preferredSize: Size(double.infinity, 90.0)
        ),
        body: TabBarView(children: [
          Padding(
            child: teamToggle ? TeamDescription(teams,loadTeams) : ColorLoader(), padding: EdgeInsets.only(top: 30, left: 20),
          ),
          teamToggle ?TeamInvitationScreen(teams):Container(),
          teamToggle ?TeamStatusScreen():Container(),
        ])
      ),
    );
  }

}