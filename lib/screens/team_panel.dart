import 'package:flutter/material.dart';

import '../components/side_menu.dart';
import '../components/panel_app_bar.dart';


class TeamPanelScreen extends StatefulWidget {
  @override
  TeamPanelScreenState createState() => TeamPanelScreenState();


}

class TeamPanelScreenState extends State<TeamPanelScreen> {

  createZone(){

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: SideMenu(),
      appBar: PreferredSize(child: PanelAppBar('Team Panel', Icons.group_add, createZone()), preferredSize: Size(double.infinity, 100.0)),

    );
  }

}