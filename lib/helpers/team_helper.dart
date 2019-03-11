
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

  List<DropdownMenuItem> buildDropDownSelection(elements) {

      List<DropdownMenuItem> tmpList = [];
        elements.forEach((element) {
          DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
            child: Text(
              element['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
              textAlign: TextAlign.center,
            ),
            value: elements.indexOf(element),
          );
          tmpList.add(dropdownMenuItem);

        });

      return tmpList;
  }


}