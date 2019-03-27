import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class HotDialogZoneEdit extends StatefulWidget {

  List<dynamic> teams;
  final zone ;
  int selectedTeamIndex;
  HotDialogZoneEdit(this.teams,this.selectedTeamIndex,this.zone);

  @override
  _HotDialogZoneEditState createState() => _HotDialogZoneEditState();
}

class _HotDialogZoneEditState extends State<HotDialogZoneEdit> {

  final TeamHelper teamHelper = TeamHelper();
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

  _getContent(){

    return
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Team : ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
