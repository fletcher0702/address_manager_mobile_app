import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tools/colors.dart';

class HotDialogStatus extends StatefulWidget {

  List<dynamic> teams;
  int selectedTeamIndex;
  Function actionCallBackAfter;

  HotDialogStatus(this.teams,this.selectedTeamIndex,this.actionCallBackAfter);

  @override
  _HotDialogStatusState createState() => _HotDialogStatusState();
}

class _HotDialogStatusState extends State<HotDialogStatus> {

  var selectedTeam = '';
  var selectedStatusName ='';
  int _selectedTeamIndex;
  final teamHelper = TeamHelper();
  final statusNameController = TextEditingController();
  TeamController teamController = TeamController();

  List<Widget> selectedTeamStatus = [];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  List<DropdownMenuItem<int>> teamsItems = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      teamsItems = teamHelper.buildDropDownSelection(widget.teams);
    });
  }


  @override
  void dispose() {
    super.dispose();
    statusNameController.dispose();
  }

  void changeColor(Color color){
    setState(() {
      pickerColor = color;
    });
  }

  void pickerAction(){
    setState(() {
      currentColor = pickerColor;
    });
    Navigator.of(context).pop();
  }

  _getContent(){

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.group,color:Colors.brown),
              SizedBox(width: 5,),
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
                    setState(() {
                      selectedTeam = widget.teams[value]['name'];
                      _selectedTeamIndex= value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.color_lens,color:pickerColor),
                onPressed: (){
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Center(child: Text('Choose status color',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                        content: SingleChildScrollView(
                          child:  ColorPicker(
                              pickerColor: pickerColor,
                              enableLabel: true,
                              pickerAreaHeightPercent: 0.8,
                              onColorChanged: changeColor
                          ),
                        ),
                        actions: <Widget>[
                          IconButton(icon: Icon(Icons.colorize,color: pickerColor,), onPressed: pickerAction)
                        ],
                      )
                  );
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black)),
                      alignLabelWithHint: true,
                      hintText: 'New, Visit..',
                      hintStyle:
                      TextStyle(color: Colors.black)),
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: statusNameController,
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center
            ,
            children: <Widget>[
              FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('CANCEL',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),color: green_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),
              SizedBox(width: 10,),
              FlatButton(onPressed: (){

                if(statusNameController.text.isNotEmpty){
                  Status status = Status(widget.teams[_selectedTeamIndex]["uuid"],statusNameController.text,pickerColor.value);
                  teamController.createStatus(status);
                }

              }, child: Text('SAVE',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              )),color: green_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),

            ],
          )

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}