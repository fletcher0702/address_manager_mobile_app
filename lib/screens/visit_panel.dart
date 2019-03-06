import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter/material.dart';

import '../components/edit_person_dialog.dart';
import '../components/loader.dart';
import '../components/panel_app_bar.dart';
import '../components/side_menu.dart';
import '../controller/visit_controller.dart';
import '../controller/zone_controller.dart';
import '../screens/add_person_dialog.dart';
import '../tools/colors.dart';

class VisitPanelScreen extends StatefulWidget {
  @override
  VisitPanelScreenState createState() => VisitPanelScreenState();
}

class VisitPanelScreenState extends State<VisitPanelScreen> {
  BuildContext context;
  VisitController visitController = VisitController();
  ZoneController zoneController = ZoneController();
  final teamController = TeamController();
  final teamHelper = TeamHelper();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();
  var visits;
  var zones;
  var teams;

  var selectedZone;
  bool zoneToggle = false;
  bool visitToggle = false;
  bool onChangedZoneToggle = false;
  bool teamToggle = false;
  List<DropdownMenuItem<dynamic>> locations = [];
  List<DropdownMenuItem> teamsDropDownItems = List<DropdownMenuItem>();
  List<dynamic> zonesElements = [];
  List<dynamic> visitsElements = [];
  List<Widget> visitsRows = [];
  int _selectedZoneIndex;


  @override
  void initState() {
    super.initState();
    teamController.findAll().then((res) {
      teams = res;
      teamsDropDownItems = teamHelper.buildDropDownSelection(teams);
      teamToggle = true;
    });
  }

  addVisit() {
    addPersonDialog.dialog(context, zonesElements, _selectedZoneIndex, (){});
  }

  void loadZones() async {
    zones = zoneController.findAll();
    zones.then((zonesItems) {
      setState(() {
        if (!zoneToggle) {
          zonesItems.forEach((zone) async {
            DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
              child: Text(
                zone['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              value: zonesItems.indexOf(zone),
            );
            locations.add(dropdownMenuItem);
            zonesElements.add(zone);
          });
          zoneToggle = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    loadZones();
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Visits Panel', Icons.person_add, addVisit),
        preferredSize: Size(double.infinity, 50.0),
      ),
      body: SingleChildScrollView(
        child: zoneToggle
            ? Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, color: Colors.blue),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: selectedZone != null
                        ? Text(selectedZone,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    elevation: 0,
                    items: zoneToggle ? locations : [],
                    onChanged: (value) async {
                      setState(() {
                        onChangedZoneToggle = true;
                        selectedZone = zonesElements[value]['name'];
                        _selectedZoneIndex = value;
                        String selectedId = zoneController.getId(
                            zonesElements[_selectedZoneIndex]["_id"]);
                        var visits = visitController
                            .findVisitsByZoneId(selectedId);
                        visits.then((visitsEl) {
                          onChangedZoneToggle = false;
                          visitsElements = visitsEl;
                          buildVisitsList(context);
                        });
                      });
                    },
                  ),
                ),
              ],
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, color: Colors.blue),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: selectedZone != null
                        ? Text(selectedZone,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center)
                        : Text(''),
                    elevation: 0,
                    items: zoneToggle ? locations : [],
                    onChanged: (value) async {
                      setState(() {
                        onChangedZoneToggle = true;
                        selectedZone = zonesElements[value]['name'];
                        _selectedZoneIndex = value;
                        String selectedId = zoneController.getId(
                            zonesElements[_selectedZoneIndex]["_id"]);
                        var visits = visitController
                            .findVisitsByZoneId(selectedId);
                        visits.then((visitsEl) {
                          onChangedZoneToggle = false;
                          visitsElements = visitsEl;
                          buildVisitsList(context);
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: !onChangedZoneToggle?visitsRows:[Padding(
                    padding: EdgeInsets.only(top:MediaQuery.of(context).size.height-600),
                    child: Center(child: ColorLoader(),),
                  )],
                ),
              ),
            )
          ],
        )
            : ColorLoader(),
      ),
    );
  }

  buildVisitsList(context) {
    visitsRows.clear();
    visitsElements.forEach((element) {
      Row row = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person_pin, color: green_custom_color,),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                element['name'],
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
              ),
              Text(element['address']),
              Text(element['status']),
            ],
          ),
          Scrollable(
              viewportBuilder: (context,viewport){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.edit, color: Colors.orangeAccent, ), onPressed: (){
                      editPersonDialog.dialog(context, zonesElements, _selectedZoneIndex, element);
                    }),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: (){editPersonDialog.showDeleteDialog(context,element);})
                  ],
                );
              })
        ],
      );

      visitsRows.add(row);
    });
  }
}
