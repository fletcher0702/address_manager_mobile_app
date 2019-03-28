import 'package:address_manager/controller/zone_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/helpers/ui_helper.dart';
import 'package:address_manager/models/dto/zone/update_zone_dto.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import '../tools/messages.dart';
import '../tools/actions.dart';

class HotDialogZoneEdit extends StatefulWidget {

  List<dynamic> teams;
  final zone ;
  int selectedTeamIndex;
  Function callBackAfterProcess;
  HotDialogZoneEdit(this.teams,this.selectedTeamIndex,this.zone,this.callBackAfterProcess);

  @override
  _HotDialogZoneEditState createState() => _HotDialogZoneEditState();
}

class _HotDialogZoneEditState extends State<HotDialogZoneEdit> {

  final TeamHelper teamHelper = TeamHelper();
  final zoneController = ZoneController();
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<DropdownMenuItem> teamsDropdown = [];
  int _selectedTeamIndex = -1;
  String teamToAddInto = '';
  bool firstLaunch = false;
  String errorMessage = '';
  Container errorBox = Container();

  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedTeamIndex = widget.selectedTeamIndex;
      teamsDropdown = teamHelper.buildDropDownSelection(widget.teams);
      zoneNameController.text = widget.zone['name'];
      teamToAddInto = widget.teams[widget.selectedTeamIndex]['name'];
      zoneAddressController.text = widget.zone['address'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    zoneAddressController.dispose();
    zoneNameController.dispose();
  }

  editAction(){
    UpdateZoneDto updateZoneDto = UpdateZoneDto();
    updateZoneDto.name = zoneNameController.text;
    updateZoneDto.teamUuid = widget.teams[_selectedTeamIndex]["uuid"];
    updateZoneDto.zoneUuid = widget.zone['uuid'];
    updateZoneDto.address = zoneAddressController.text;
    zoneController.updateOne(updateZoneDto);

  }

  updateMessageError(){
    setState(() {
      errorBox = Container();
    });

  }

  _getContent(){

    return
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            errorBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group,color: Colors.brown,),
                SizedBox(width: 10,),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: teamsDropdown,
                    hint: Text(teamToAddInto,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        ,
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamIndex = value;
                        teamToAddInto = widget.teams[value]['name'];
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: zoneNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.place, color: Colors.blue),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black)),
                alignLabelWithHint: true,
                hintText: 'Name',
              ),
              cursorColor: Colors.black,
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.find_replace, color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black)),
                alignLabelWithHint: true,
                hintText: 'Location',
              ),
              cursorColor: Colors.black,
              controller: zoneAddressController,
              onTap: () async {
                Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: DotEnv().env['GApiKey'],
                    mode: Mode.fullscreen,
                    logo: Text(''),
                    hint: "Location...",
                    language: "fr",
                    components: [Component(Component.country, "fr")]);
                zoneAddressController.text =
                p != null ? p.description : '';
              },
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: (){

                      if(_selectedTeamIndex==-1){
                        setState(() {
                          errorMessage = 'Please select a valid team...';
                          errorBox = UIHelper.errorMessageWidget(errorMessage, updateMessageError);
                        });
                      }else{

                        if(zoneNameController.text.isEmpty || zoneAddressController.text.isEmpty){

                          setState(() {
                            errorMessage = 'Please fill all the fields...';
                            errorBox = UIHelper.errorMessageWidget(errorMessage, updateMessageError);
                          });

                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(SUCCESS_UPDATE,ERROR_UPDATE,editAction,UPDATE_ACTION,widget.callBackAfterProcess)));
                        }

                      }


                    },
                    child: Text('UPDATE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    color: Colors.deepOrangeAccent),
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
                  color: Colors.deepOrangeAccent,
                ),
              ],
            ),
          ],
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
