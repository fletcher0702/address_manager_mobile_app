import 'package:address_manager/controller/visit_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/models/dto/visit/update_visit_history.dart';
import 'package:address_manager/models/visit.dart';
import 'package:address_manager/tools/colors.dart';
import '../tools/actions.dart';
import '../tools/messages.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';

class HotDialogAddHistory extends StatefulWidget {

  UpdateVisitHistoryDto visitHistoryDto;
  List<dynamic> visitsElements;
  Function _actionCallBackAfter;

  HotDialogAddHistory(this.visitHistoryDto,this.visitsElements,this._actionCallBackAfter);

  @override
  _HotDialogAddHistoryState createState() => _HotDialogAddHistoryState();
}

class _HotDialogAddHistoryState extends State<HotDialogAddHistory> {

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  TeamHelper teamHelper = TeamHelper();
  VisitController visitController = VisitController();
  String selectedVisitName = '';
  List<dynamic> visits = [];
  var _selectedVisit;
  List<DropdownMenuItem<int>> visitsDropDown = [];


  @override
  void initState() {
  super.initState();
  setState(() {
    visits = widget.visitsElements;
    visitsDropDown = teamHelper.buildDropDownSelection(visits);
  });
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  updateAction(){
    widget.visitHistoryDto.visitUuid = _selectedVisit['uuid'];
    widget.visitHistoryDto.date = date.toString();

    return visitController.updateVisitHistory(widget.visitHistoryDto);
  }

  Widget _getContent() {

    return SimpleDialog(
      title: Center(
        child: Text('Add Date', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
      ),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[

        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.person,color:Colors.green),
                SizedBox(width: 10,),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: visitsDropDown,
                    hint: Text(selectedVisitName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                    onChanged: (value) {
                      setState(() {
                        selectedVisitName = visits[value]['name'];
                        _selectedVisit = visits[value];
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  DateTimePickerFormField(
                    inputType: inputType,
                    format: formats[inputType],
                    editable: editable,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black)),
                        alignLabelWithHint: true,
                        hintText: 'date',
                        hintStyle:
                        TextStyle(color: Colors.black)
                    ),
                    onChanged: (dt) => setState(() => date = dt),
                  ),
                ],
              ),
            )
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
              color: Color.fromRGBO(46, 204, 113, 1),
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: (){

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(SUCCESS_UPDATE,ERROR_UPDATE,updateAction,UPDATE_ACTION,widget._actionCallBackAfter)));

                },
                child: Text('ADD',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
                color: Color.fromRGBO(46, 204, 113, 1)),

          ],
        ),
      ],
    );
  }
}
