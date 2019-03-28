import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/screens/add_person_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  TeamHelper teamHelper = TeamHelper();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();
  MapController mapController;

  // Toggles trackers
  bool mapToggle = false;
  bool teamToggle = false;

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
  int _selectedZoneIndex=-1;
  int _selectedStatusIndex;
  int _selectedTeamIndex=-1;
  String _currentTeamUuidAfterCallBackReload = '';
  String _currentZoneUuidAfterCallBackReload = '';
  List<double> currentLocation = [48.864716, 2.349014];


  void loadTeams() {
    teamController.findAll().then((data){
      setState(() {
        teamsElements = data;
        teamToggle = true;
        teams = teamHelper.buildDropDownSelection(teamsElements);
        if(_currentTeamUuidAfterCallBackReload.isNotEmpty && _currentZoneUuidAfterCallBackReload.isNotEmpty){
          _refreshMarkersAfterAdd();
        }
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
                  visitsElements =
                  teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['visits'];
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
                                            _selectedZoneIndex, visit,
                                            loadTeams);
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
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
                                            visit['phoneNumber']!=null?visit['phoneNumber']:'Not provided',
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
        if(visit['status']['uuid'].toString()==type.toString()){
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
                            height: 400,
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
                                              _selectedZoneIndex, visit,
                                              loadTeams);
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
    mapController = MapController();
    mapToggle = true;
  }

  _refreshMarkersAfterAdd(){
    teamsElements.forEach((team){
      if(team['uuid'].toString()==_currentTeamUuidAfterCallBackReload){
        List<dynamic> tmpZones = team["zones"];
        tmpZones.forEach((z){
          if(z['uuid'].toString()==_currentZoneUuidAfterCallBackReload){
           setState(() {
             _selectedTeamIndex = teamsElements.indexOf(team);
             _selectedZoneIndex = tmpZones.indexOf(z);
             zones = team['zones'];
             visitsElements = zones[_selectedZoneIndex]['visits'];
             loadZones();
             loadMarkers(z['visits']);
           });
          }
        });
      }
    });
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(),
              Row(
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
                          _currentTeamUuidAfterCallBackReload = teamsElements[value]['uuid'];
                          _currentZoneUuidAfterCallBackReload ='';
                          zones = teamsElements[value]["zones"];
                          statusElements = teamsElements[value]["status"];
                          status.clear();
                          markersList.clear();
                          loadZones();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh, size: 25, color: Colors.orangeAccent,),
                    color: green_custom_color,
                    onPressed: () async {
                      loadTeams();
                    },

                  ),
                  IconButton(
                    icon: Icon(Icons.person_add, size: 25,),
                    color: green_custom_color,
                    onPressed: () {
                        addPersonDialog
                            .dialog(
                            this.context, teamsElements, _selectedTeamIndex,
                            _selectedZoneIndex, loadTeams);
                    }
                  )
                ],
              )
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:  FlatButton(
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
          size: 20,
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
                                  onPressed: () async {
                                    editPersonDialog.dialog(
                                        context, teamsElements,
                                        _selectedTeamIndex,
                                        _selectedZoneIndex,
                                        visitsElements[index], loadTeams);

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
                                  ['status']['name'])
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
        shape: CircleBorder(side: BorderSide(color: Colors.white,width: 2)),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
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
                          selectedZone = zones[value]['name'];
                          selectedStatus ='';
                          _currentZoneUuidAfterCallBackReload = zones[value]['uuid'];
                          currentLocation[0] = zones[value]['latitude'];
                          currentLocation[1] = zones[value]['longitude'];
                          visitsElements = zones[value]["visits"];
                          status = teamHelper.buildDropDownSelection(statusElements);
                          loadMarkers(zones[value]["visits"]);
                          mapController.move(LatLng(currentLocation[0], currentLocation[1]),13);
                        });


                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.filter_list),
                  SizedBox(width: 5,),
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
            SizedBox(height: 25,),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 120 ,
                width: double.infinity,
                child: mapToggle
                    ? FlutterMap(
                  mapController: mapController,
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
              )
            )
          ],
        ),
      ),
    );
  }

  Color colorType(element) {
    Color res = Color(element['status']['color']);
    return res;
  }
}
