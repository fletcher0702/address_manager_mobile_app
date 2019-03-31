import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/models/status.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tools/colors.dart';
import '../tools/messages.dart';
import '../tools/actions.dart';

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
  int _selectedTeamIndex = -1;
  final teamHelper = TeamHelper();
  final statusNameController = TextEditingController();
  TeamController teamController = TeamController();

  List<Widget> selectedTeamStatus = [];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  List<DropdownMenuItem<int>> teamsItems = [];
  List<dynamic> teamsAllowed = [];
  Container errorBox = Container();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      teamsAllowed = teamHelper.getAllowTeams(widget.teams);
      teamsItems = teamHelper.buildDropDownSelection(teamsAllowed);
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

  updateErrorMessage(){
    setState(() {
      errorBox = Container();
    });
  }
  _getContent(){

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          errorBox,
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
                      selectedTeam = teamsAllowed[value]['name'];
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
                      child: SimpleDialog(
                        title: Center(child: Text('Choose status color',style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ColorPicker(
                                pickerColor: pickerColor,
                                enableLabel: true,
                                pickerAreaHeightPercent: 0.8,
                                onColorChanged: changeColor
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(icon: Icon(Icons.colorize,color: pickerColor,), onPressed: pickerAction),
                            ],
                          )
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

                if(statusNameController.text.isNotEmpty && _selectedTeamIndex!=-1){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(SUCCESS_CREATION,ERROR_CREATION,_createStatus,CREATE_ACTION,widget.actionCallBackAfter)));
                }else{
                  errorMessage = 'Select a team or Enter a valid name !';
                  setState(() {
                    errorBox = UIHelper.errorMessageWidget(errorMessage, updateErrorMessage);
                  });
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

  _createStatus(){
    Status status = Status(teamsAllowed[_selectedTeamIndex]["uuid"],statusNameController.text,pickerColor.value);
    return teamController.createStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
