import 'package:address_manager/components/hot_dialog_add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../helpers/team_helper.dart';
import '../models/visit.dart';
import '../screens/add_person_validation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddPersonDialog extends StatefulWidget {
  @override
  AddPersonDialogState createState() => AddPersonDialogState();
}

class AddPersonDialogState extends State<AddPersonDialog> {

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
  var selectedTeam = '';
  var selectedStatusName ='';
  int _selectedZoneIndex;
  int _selectedTeamIndex;
  int _selectedStatusIndex;

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
      context, teams,selectedTeamIndex,selectedZoneIndex, actionCallBackAfter) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            HotDialogAdd(teams,selectedTeamIndex,selectedZoneIndex,actionCallBackAfter),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
