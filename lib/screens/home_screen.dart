import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/screens/add_person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  TeamHelper teamHelper = TeamHelper();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();

  // Toggles trackers
  bool mapToggle = false;
  bool teamToggle = false;
  bool activeBottomSheet = false;
  bool visitsToggle = false;
  bool markersToggle = false;

  var zones;
  var visits;
  List<dynamic> teamsElements = [];
  List<dynamic> visitsElements = [];
  List<dynamic> zonesElements = [];
  List<dynamic> statusElements = [];
  List<DropdownMenuItem<int>> teams = [];
  List<DropdownMenuItem<int>> locations = [];
  List<DropdownMenuItem<int>> status = [];
  List<Marker> markersList = [];
  String selectedZone;
  String selectedStatus;
  String selectedTeam;
  int _selectedZoneIndex;
  int _selectedStatusIndex;
  int _selectedTeamIndex;
  List<double> currentLocation = [48.864716, 2.349014];


  void loadTeams() {
    teamController.findAll().then((data){
      setState(() {
        teamsElements = data;
        teamToggle = true;
        teams = teamHelper.buildDropDownSelection(teamsElements);
      });
    });
  }
  /*
  Fetch data from API
  * */
  void loadZones() async {
    setState(() {
        locations.clear();
        locations = teamHelper.buildDropDownSelection(zones);
        status = teamHelper.buildDropDownSelection(statusElements);
    });
  }

  loadMarkers(visitsElements) async {

      List<Marker> tmpMarkers = [];
      visitsElements.forEach((visit) {
        Marker marker = Marker(
          height: 80.0,
          width: 80.0,
          point: LatLng(visit['latitude'], visit['longitude']),
          builder: (context) {
            Color color = colorType(visit);
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
                                      color: color,
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
                                            context, teamsElements,_selectedTeamIndex,
                                            _selectedZoneIndex,visit, () {
                                          loadTeams();
                                        });
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
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.place,
                                              color: color,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              visit['address'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                            visit['status']['name'],
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
                        color: color,
                      ),
                    ),
                    Icon(
                      Icons.place,
                      color: color,
                      size: 40,
                    ),
                    Positioned(
                      top: 8,
                      left: 15,
                      child: Text(
                        visit['name'],
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

        tmpMarkers.add(marker);
      });

      setState(() {
        markersList = tmpMarkers;
      });
  }

  loadMarkersByStatus(visitsElements,type) async {

      markersList.clear();
      List<Marker> tmpMarkers = [];
      visitsElements.forEach((visit) {

        print('visit uuid '+ visit['status']['uuid']);
        print('type uuid '+ type);
        if(visit['status']['uuid'].toString()==type.toString()){
          print('Equals');
          Marker marker = Marker(
            height: 80.0,
            width: 80.0,
            point: LatLng(visit['latitude'], visit['longitude']),
            builder: (context) {
              Color color = colorType(visit);
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
                                        color: color,
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
                                              context, teamsElements,_selectedTeamIndex,
                                              _selectedZoneIndex,visit, () {
                                            loadTeams();
                                          });
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
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.place,
                                                color: color,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                visit['address'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
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
                                              visit['status']['name'],
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
                          color: color,
                        ),
                      ),
                      Icon(
                        Icons.place,
                        color: color,
                        size: 40,
                      ),
                      Positioned(
                        top: 8,
                        left: 15,
                        child: Text(
                          visit['name'],
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

          tmpMarkers.add(marker);
        }else print('Not Equals');

      });

      setState(() {
        markersList = tmpMarkers;
      });
  }

  void initState() {
    super.initState();
    loadTeams();
    mapToggle = true;
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
                              selectedStatus ='';
                              _selectedTeamIndex = value;
                              selectedTeam = teamsElements[value]['name'];
                              zones = teamsElements[value]["zones"];
                              statusElements = teamsElements[value]["status"];
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
                loadTeams();
                loadMarkers(
                    teamsElements[_selectedTeamIndex]["zones"][_selectedZoneIndex]["visits"]);
              },

            ),
            IconButton(
              icon: Icon(Icons.person_add, size: 25,),
              color: green_custom_color,
              onPressed: () {
                if (selectedZone != null && selectedTeam != null) {
                  print('selected team test : ' + _selectedTeamIndex.toString());
                  print('selected zone test : ' + _selectedZoneIndex.toString());
                  addPersonDialog
                      .dialog(context, teamsElements,_selectedTeamIndex,
                      _selectedZoneIndex, () {
                        loadTeams();
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
                          items: locations,
                          onChanged: (value) {
                            setState(() {

                              _selectedZoneIndex = value;
                              print('selected zone index : ' + _selectedZoneIndex.toString());
                              selectedZone = zones[value]['name'];
                              currentLocation[0] = zones[value]['latitude'];
                              currentLocation[1] = zones[value]['longitude'];
                              loadMarkers(zones[value]["visits"]);
                            });
                          },
                        ),
                      ),
                      Icon(Icons.filter_list),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: selectedStatus != null
                              ? Text(selectedStatus,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center)
                              : Text(''),
                          elevation: 0,
                          items: status,
                          onChanged: (value) {
                            setState(() {
                              _selectedStatusIndex = value;
                              selectedStatus = statusElements[value]['name'];
                              currentLocation[0] = zones[_selectedZoneIndex]['latitude'];
                              currentLocation[1] = zones[_selectedZoneIndex]['longitude'];
                              loadMarkersByStatus(zones[_selectedZoneIndex]["visits"],statusElements[_selectedStatusIndex]['uuid']);
                            });
                          },
                        ),
                      ),
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
                          center: LatLng(
                              currentLocation[0], currentLocation[1]),
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                            "https://api.tiles.mapbox.com/v4/"
                                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                            additionalOptions: {
                              'accessToken':
                              DotEnv().env['MapBoxApiKey'],
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
                                                      context, teamsElements,_selectedTeamIndex,
                                                      _selectedZoneIndex,visitsElements[index], () {
                                                    loadTeams();
                                                  });
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

  Color colorType(element) {
    Color res = Color(element['status']['color']);
    return res;
  }
}
