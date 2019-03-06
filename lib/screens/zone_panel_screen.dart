import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/tools/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../components/loader.dart';
import '../components/panel_app_bar.dart';
import '../components/side_menu.dart';
import '../controller/zone_controller.dart';
import '../helpers/dialog_helper.dart';
import '../models/zone.dart';

class ZonePanelScreen extends StatefulWidget {
  @override
  ZonePanelScreenState createState() => ZonePanelScreenState();
}

class ZonePanelScreenState extends State<ZonePanelScreen> {
  final TeamHelper teamHelper = TeamHelper();
  final zoneController = ZoneController();
  final teamController = TeamController();
  BuildContext context;
  var zones;
  var selectedTeam;
  int _selectedTeamIndex;
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<dynamic> teamsElements = [];
  List<DropdownMenuItem> teams = [];
  List<Widget> _zonesList = List<Widget>();
  bool zoneToggle = false;
  bool activeDetails = false;
  bool teamToggle = false;


  @override
  void initState() {
    super.initState();
    teamHelper.loadTeams().then((res) {
      teams = res;
      teamToggle = true;
    });
  }

  @override
  void dispose() {
    zoneNameController.dispose();
    zoneAddressController.dispose();
    super.dispose();
  }

  void loadTeams() async {
    if (!teamToggle) {
      List<DropdownMenuItem> tmpList = [];
      teamController.findAll().then((res) {
        teamToggle = true;
        teamsElements = res;

        teamsElements.forEach((team) {
          DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
            child: Text(
              team['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
              textAlign: TextAlign.center,
            ),
            value: teamsElements.indexOf(team),
          );
          tmpList.add(dropdownMenuItem);
          setState(() {
            teams = tmpList;
          });
        });
      });
    }
  }

  saveAction() {
    Zone zone = Zone(zoneNameController.text,teamsElements[_selectedTeamIndex]["uuid"],zoneAddressController.text);
    zoneController.createOne(zone);
//    zoneNameController.clear();
  }

  addZone() {
    List<Widget> content = [
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
                    items: teamToggle ? teams : [],
                    hint: selectedTeam != null
                        ? Text(selectedTeam,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    onChanged: (value) {
                      _selectedTeamIndex = value;
                      selectedTeam = teamsElements[value]['name'];
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
              controller: zoneAddressController,
              onTap: () async {
                Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: kGoogleApiKey,
                    mode: Mode.fullscreen,
                    logo: Text(''),
                    language: "fr",
                    components: [Component(Component.country, "fr")]);
                zoneAddressController.text =
                p != null ? p.description : '';
              },
            )
          ],
        ),
      )
    ];

    DialogHelperState.showDialogBox(
        this.context, 'Add Zone', content, saveAction);
  }

  @override
  Widget build(BuildContext context) {
    zones = zoneController.findAll();
    zonesListElements(zones);
    this.context = context;
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Zone Panel', Icons.add_location, addZone),
        preferredSize: Size(double.infinity, 100.0),
      ),
      body: Center(
          child: zoneToggle? ListView(
            children: _zonesList,
            scrollDirection: Axis.vertical,
          ): ColorLoader()
      ),
    );
  }

  zonesListElements(zonesData) {
    zonesData.then((val) {
      setState(() {
        zones = val;
        if (!zoneToggle) {
          zones.forEach((zoneItem) {
            ListTile listTile = ListTile(
              leading: Icon(Icons.place, color: Colors.blue,size: 30,),
              title: Text(
                '${zoneItem['name']}'
                ,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              subtitle: zoneItem['visits']!=null?Text('${zoneItem['visits'].length} visit(s)'):Text('Empty'),
              onTap: (){
//                Navigator.push(context, MaterialPageRoute(builder: (context)=>ZoneDetailScreen(zoneItem)));
                showModalBottomSheet(context: context, builder: (ctx){
                  return Container(
                    height: 300,
                    width: double.infinity,
                  );
                });
              },

            );

            zoneToggle = true;
            _zonesList.add(listTile);
          });
        }
      });
    });
  }
}
