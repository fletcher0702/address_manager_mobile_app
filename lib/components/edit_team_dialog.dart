
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/models/dto/team/delete_team_dto.dart';
import 'package:flutter/material.dart';

class EditTeamDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EditTeamDialogState();

}

class EditTeamDialogState extends State<EditTeamDialog> {

  TeamController teamController = TeamController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  showDeleteDialog(context, team, action) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
                  team['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            children: <Widget>[
              Center(
                  child: Text(
                    'Are you sure ?',
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

                        //TODO: Animation transition
                        action();
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
        });
  }

}