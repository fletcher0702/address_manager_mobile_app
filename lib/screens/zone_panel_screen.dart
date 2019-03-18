import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  var teamToAddInto;
  int _selectedTeamIndex = -1;
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<dynamic> teamsElements = [];
  var teamsData = [];
  List<DropdownMenuItem> teams = [];
  List<Widget> _zoneDescription = List<Widget>();
  bool zoneToggle = false;
  bool teamToggle = false;


  @override
  void initState() {
    super.initState();

    teamController.findAll().then((data) {

      setState(() {
        teamsData = data;
        teams = teamHelper.buildDropDownSelection(teamsData);
        teamToggle = true;
      });

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
    Zone zone = Zone(zoneNameController.text,teamsData[_selectedTeamIndex]["uuid"],zoneAddressController.text);
    zoneController.createOne(zone);
  }

  addZone() {
    teamToAddInto = selectedTeam;
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
                    hint: teamToAddInto != null
                        ? Text(teamToAddInto,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeamIndex = value;
                        teamToAddInto = teamsData[value]['name'];
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
      )
    ];

    DialogHelperState.showDialogBox(
        this.context, 'Add Zone', content, saveAction);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Zone Panel', Icons.add_location, addZone),
        preferredSize: Size(double.infinity, 100.0),
      ),
      body: teamToggle ? Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.group,color: Colors.brown,),
              SizedBox(width: 5,),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: teamToggle?teams:[],
                  hint: selectedTeam != null
                      ? Text(selectedTeam,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center)
                      : Text(''),
                  onChanged: (value) {
                    setState(() {
                      _selectedTeamIndex = value;
                      selectedTeam = teamsData[value]['name'];
                      selectedTeamDescription(teamsData[value]);
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: _zoneDescription,
              ),
            ),
          )

        ],
      ) : ColorLoader(),
    );
  }


  selectedTeamDescription(team) {
    List<Widget> content = [];
    Row title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(team['name'],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit, color: Colors.orange, size: 18,),
                onPressed: () {}),
            IconButton(icon: Icon(Icons.close, color: Colors.red, size: 18,),
                onPressed: () {}),
          ],
        )
      ],
    );
    Divider divider = Divider(color: Colors.black, height: 5,);

    List<dynamic> zones = team["zones"];
    List<Widget> rows = [];
    zones.forEach((zone) {
      Padding row = Padding(padding: EdgeInsets.only(bottom: 5), child: Row(
        children: <Widget>[

          Icon(Icons.place, color: Colors.blue),
          SizedBox(width: 3,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(zone['name'], style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              Text(zone['visits'].length.toString() + ' address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
            ],
          )
        ],
      ));
      rows.add(row);
    });
    Padding wrapper = Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10), child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    ));
    content.add(title);
    content.add(divider);
    content.add(wrapper);
    _zoneDescription = content;
  }
}
