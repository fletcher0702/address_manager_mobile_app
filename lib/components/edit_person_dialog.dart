import 'package:address_manager/components/hot_dialog_edit.dart';
import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/visit_controller.dart';
import '../tools/actions.dart';
import '../tools/messages.dart';

class EditPersonDialog extends StatefulWidget {
  @override
  EditPersonDialogState createState() => EditPersonDialogState();
}

class EditPersonDialogState extends State<EditPersonDialog> {
  VisitController visitController = VisitController();
  UserController  userController = UserController();

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  var selectedZone = '';
  var selectedType;
  var selectedTeam = '';
  var selectedStatusName ='';
  final visitNameController = TextEditingController();
  final visitAddressController = TextEditingController();
  final visitPhoneNumberController = TextEditingController();
  final teamHelper = TeamHelper();

  @override
  void dispose() {
    visitAddressController.dispose();
    visitNameController.dispose();
    visitPhoneNumberController.dispose();
    super.dispose();
  }

  Future<bool> dialog(
      context, teams,selectedTeamIndex,selectedZoneIndex,person, actionCallBackAfter) async {

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            HotDialogEdit(teams,selectedTeamIndex,selectedZoneIndex,person,actionCallBackAfter),
          ],
        );
      },
    );
  }

  showDeleteDialog(context, element,action,callBackActionAfterProcess) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Center(
                child: Text(
              element['name'],
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
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddTransition(SUCCESS_DELETE,ERROR_DELETE,action,DELETE_ACTION,callBackActionAfterProcess)));
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
