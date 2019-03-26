import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/status/update_status_dto.dart';
import 'package:address_manager/models/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../tools/colors.dart';

class HotDialogStatusUpdate extends StatefulWidget {

  List<dynamic> teams;
  int selectedTeamIndex;
  int selectedStatusIndex;
  Function actionCallBackAfter;

  HotDialogStatusUpdate(this.teams,this.selectedTeamIndex,this.selectedStatusIndex,this.actionCallBackAfter);

  @override
  _HotDialogStatusUpdateState createState() => _HotDialogStatusUpdateState();
}

class _HotDialogStatusUpdateState extends State<HotDialogStatusUpdate> {

  var selectedTeam = '';
  var selectedStatusName ='';
  final teamHelper = TeamHelper();
  final statusNameController = TextEditingController();
  TeamController teamController = TeamController();

  List<Widget> selectedTeamStatus = [];
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  List<DropdownMenuItem<int>> teamsItems = [];

  Color selectedStatusColor;


  @override
  void initState() {
    super.initState();
    setState(() {
      teamsItems = teamHelper.buildDropDownSelection(widget.teams);
      pickerColor = Color(widget.teams[widget.selectedTeamIndex]['status'][widget.selectedStatusIndex]['color']);
      statusNameController.text = widget.teams[widget.selectedTeamIndex]['status'][widget.selectedStatusIndex]['name'];
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
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center
            ,
            children: <Widget>[
              FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text('CANCEL',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),color: orange_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),
              SizedBox(width: 10,),
              FlatButton(onPressed: updateStatus, child: Text('UPDATE',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              )),color: orange_custom_color,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),),

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

  updateStatus(){
    String teamUuid = widget.teams[widget.selectedTeamIndex]['uuid'];
    String statusUuid = widget.teams[widget.selectedTeamIndex]["status"][widget.selectedStatusIndex]['uuid'];

    print('team uuid : ' + teamUuid);
    print('status uuid : ' + statusUuid);
    UpdateStatusDto updateStatusDto = UpdateStatusDto(teamUuid,statusUuid);
    updateStatusDto.name = statusNameController.text;
    updateStatusDto.color = pickerColor.value;
    teamController.updateStatus(updateStatusDto).then((res){
      print(res);
    });
  }
}
