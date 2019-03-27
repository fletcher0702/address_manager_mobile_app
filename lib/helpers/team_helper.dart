
import 'package:address_manager/controller/team_controller.dart';
import 'package:flutter/material.dart';

class TeamHelper {

  final teamController = TeamController();
  List<dynamic> teamsElements = [];
  List<DropdownMenuItem> teams = [];
  bool teamToggle = false;

  Future<List<DropdownMenuItem>> loadTeams() async {
    if (!teamToggle) {
      List<DropdownMenuItem> tmpList = [];
      teamController.findAll().then((res) {
        teamToggle = true;
        teamsElements = res;

        teamsElements.forEach((team) {
          DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
            child: Text(
              team['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
              textAlign: TextAlign.center,
            ),
            value: teamsElements.indexOf(team),
          );
          tmpList.add(dropdownMenuItem);

        });
      });
      return tmpList;
    }
  }

  List<DropdownMenuItem<int>> buildDropDownSelection(elements) {

      List<DropdownMenuItem<int>> tmpList = [];

      for(int i=0;i<elements.length;i++){
        DropdownMenuItem<int> dropdownMenuItem = DropdownMenuItem(
          child: Text(
            elements[i]['name'],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
            textAlign: TextAlign.center,
          ),
          value: i,
        );
        tmpList.add(dropdownMenuItem);

      }

      return tmpList;
  }

  getAllowTeams(List<dynamic> teams){

    List<dynamic> res = [];

    teams.forEach((t){

      if(t['admin']) res.add(t);
    });

    return res;
  }


}