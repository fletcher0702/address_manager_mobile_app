import 'package:address_manager/components/loader.dart';
import 'package:address_manager/components/team_description.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/dialog_helper.dart';
import 'package:address_manager/models/team.dart';
import 'package:flutter/material.dart';

import '../components/panel_app_bar.dart';
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
    teamController.createOne(team);
    teamNameController.clear();
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
        this.context, 'Add Team', content, saveAction,true);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(

      drawer: SideMenu(),
      appBar: PreferredSize(
          child: PanelAppBar('Team Panel', Icons.group_add, createTeam),
          preferredSize: Size(double.infinity, 60.0)),
      body: Padding(
        child: teamToggle ? TeamDescription(teams) : ColorLoader(), padding: EdgeInsets.only(top: 30, left: 20),
      ),
    );
  }

}