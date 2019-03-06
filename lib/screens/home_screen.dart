import 'package:address_manager/screens/add_person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../components/edit_person_dialog.dart';
import '../components/side_menu.dart';
import '../controller/team_controller.dart';
import '../controller/visit_controller.dart';
import '../controller/zone_controller.dart';
import '../tools/colors.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  BuildContext context;
  ZoneController zoneController = ZoneController();
  VisitController visitController = VisitController();
  TeamController teamController = TeamController();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();

  var currentLocation;

  // Toggles trackers
  bool mapToggle = false;
  bool teamToggle = false;
  bool zoneToggle = false;
  bool activeBottomSheet = false;
  bool visitsToggle = false;
  bool markersToggle = false;

  var zones;
  var visits;
  List<dynamic> teamsElements = [];
  List<dynamic> visitsElements = [];
  List<dynamic> zonesElements = [];
  List<DropdownMenuItem<dynamic>> teams = [];
  List<DropdownMenuItem<dynamic>> locations = [];
  List<Marker> markersList = [];
  String selectedZone;
  String selectedTeam;
  int _selectedZoneIndex;
  int _selectTeamIndex;


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
  /*
  Fetch data from API
  * */
  void loadZones() async {
    setState(() {
      if (teamToggle) {
        locations.clear();
        zones.forEach((zone) {
            DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
              child: Text(
                zone['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
                textAlign: TextAlign.center,
              ),
              value: zones.indexOf(zone),
            );
            locations.add(dropdownMenuItem);
          });
          zoneToggle = true;
        }
    });
  }

  loadMarkers(visitsElements) async {
    setState(() {
      markersList.clear();
      visitsElements.forEach((visit) {
        Marker marker = Marker(
          height: 80.0,
          width: 80.0,
          point: LatLng(visit['latitude'], visit['longitude']),
          builder: (context) {
            return Center(
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 300,
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person_pin,
                                      color: Colors.blue,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        visit['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        editPersonDialog.dialog(
                                            context,
                                            zonesElements,
                                            _selectedZoneIndex,
                                            visit);
                                      },
                                      color: orange_custom_color,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 40),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.place,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              visit['address'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color:
                                                Color.fromRGBO(46, 204, 113, 1),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            visit['phoneNumber'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.help,
                                              color: Color.fromRGBO(
                                                  255, 87, 0, 1)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            visit['status'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                icon: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      left: 15,
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(
                      Icons.place,
                      color: Colors.blue,
                      size: 40,
                    ),
                    Positioned(
                      top: 8,
                      left: 15,
                      child: Text(
                        (visitsElements.indexOf(visit) + 1).toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );

        markersList.add(marker);
      });
    });
  }

  void initState() {
    super.initState();
    mapToggle = true;
    loadTeams();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideMenu(),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 50),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.group,
                        color: Colors.brown,
                      ),
                      SizedBox(width: 5),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: selectedTeam != null
                              ? Text(selectedTeam,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center)
                              : Text(''),
                          elevation: 0,
                          items: teams,
                          onChanged: (value) {
                            setState(() {
                              selectedZone = '';
                              _selectTeamIndex = value;
                              selectedTeam = teamsElements[value]['name'];
                              zones = teamsElements[value]["zones"];
                              loadZones();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              icon: Icon(Icons.refresh, size: 25, color: Colors.orangeAccent,),
              color: green_custom_color,
              onPressed: () async {
                teamToggle = false;
                loadTeams();

                print(
                    teamsElements[_selectTeamIndex]["zones"][_selectedZoneIndex]["visits"]);
                loadMarkers(
                    teamsElements[_selectTeamIndex]["zones"][_selectedZoneIndex]["visits"]);
              },

            ),
            IconButton(
              icon: Icon(Icons.person_add, size: 25,),
              color: green_custom_color,
              onPressed: () {
                if (selectedZone != null && selectedTeam != null) {
                  addPersonDialog
                      .dialog(context, teamsElements[_selectTeamIndex],
                      _selectedZoneIndex, () {
                        print('Person added !');
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          children: <Widget>[
                            Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Please select a zone...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                )),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 80.0, right: 80.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'OKAY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 25),
                                ),
                                color: green_custom_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            )
                          ],
                        );
                      });
                }
              },
              iconSize: 30.0,
            )
          ],
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 570,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.place,
                        color: Color.fromRGBO(52, 152, 219, 1),
                      ),
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
                          items: teamToggle ? locations : [],
                          onChanged: (value) {
                            setState(() {
                              _selectedZoneIndex = value;
                              selectedZone = zones[value]['name'];
                              loadMarkers(zones[value]["visits"]);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  child: SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 200,
                    width: double.infinity,
                    child: Center(
                      child: mapToggle
                          ? FlutterMap(
                        options: MapOptions(
                          zoom: 14, //48.864716, 2.349014 Paris
                          center: LatLng(48.864716, 2.349014),
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                            "https://api.tiles.mapbox.com/v4/"
                                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                            additionalOptions: {
                              'accessToken':
                              'pk.eyJ1IjoiZmxldGNoZXIiLCJhIjoiY2pycmw2dWh0MXY5NjQ0cGoxMTdpdHl2eiJ9.0qePOdg3vPbQi_VVA5DL1g',
                              'id': 'mapbox.streets',
                            },
                          ),
                          MarkerLayerOptions(
                            markers: markersList,
                          ),
                        ],
                      )
                          : Center(
                        child: Text('Loading Map...Please Wait...'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: FlatButton(
                      child: Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      color: Color.fromRGBO(46, 204, 113, 1),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 800,
                                  child: visitsElements.length == 0
                                      ? Center(
                                    child: Text(
                                        'Empty...Please add some persons or change the zone...'),
                                  )
                                      : ListView.builder(
                                      itemCount: visitsElements.length,
                                      itemBuilder: (ctx, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: ListTile(
                                            leading: IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Color.fromRGBO(
                                                      255, 87, 0, 1),
                                                ),
                                                onPressed: () {
                                                  editPersonDialog.dialog(
                                                      context,
                                                      zonesElements,
                                                      _selectedZoneIndex,
                                                      visitsElements[index]);
                                                }),
                                            title: Text(
                                              visitsElements[index]['name'],
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(visitsElements[index]
                                                ['address']),
                                                Text(visitsElements[index]
                                                ['status'])
                                              ],
                                            ),
                                            onTap: () {},
                                          ),
                                        );
                                      }),
                                ),
                              );
                            });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
