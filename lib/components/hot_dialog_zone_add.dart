

import 'package:address_manager/controller/zone_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import '../tools/colors.dart';
import 'package:address_manager/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class HotDialogZoneAdd extends StatefulWidget {

  List<dynamic> teams;
  int selectedTeamIndex;
  HotDialogZoneAdd(this.teams,this.selectedTeamIndex);

  @override
  _HotDialogZoneAddState createState() => _HotDialogZoneAddState();
}

class _HotDialogZoneAddState extends State<HotDialogZoneAdd> {

  final TeamHelper teamHelper = TeamHelper();
  final zoneController = ZoneController();
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<DropdownMenuItem> teamsDropdown = [];
  int _selectedTeamIndex;
  String teamToAddInto = '';
  bool firstLaunch = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      if(widget.selectedTeamIndex!=-1){
        _selectedTeamIndex = widget.selectedTeamIndex;
        teamToAddInto = widget.teams[widget.selectedTeamIndex]['name'];
      }
      teamsDropdown = teamHelper.buildDropDownSelection(teamHelper.getAllowTeams(widget.teams));
    });
  }

  @override
  void dispose() {
    super.dispose();
    zoneAddressController.dispose();
    zoneNameController.dispose();
  }

  saveAction() {
    Zone zone = Zone(zoneNameController.text,widget.teams[_selectedTeamIndex]["uuid"],zoneAddressController.text);
    zoneController.createOne(zone);
  }

  _getContent(){

    return
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
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
                    onPressed: saveAction,
                    child: Text('SAVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    color: green_custom_color),
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
                  color: green_custom_color,
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
