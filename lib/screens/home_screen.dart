import 'package:address_manager/components/hot_dialog_history.dart';
import 'package:address_manager/components/input_tag.dart';
import 'package:address_manager/components/map_widget.dart';
import 'package:address_manager/controller/user_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:address_manager/models/dto/visit/delete_history_date_dto.dart';
import 'package:address_manager/models/dto/visit/update_visit_history.dart';
import 'package:address_manager/screens/add_person_dialog.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:address_manager/tools/actions.dart';
import 'package:address_manager/tools/messages.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
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

  List<Widget> _zonesTagsWidget = [];
  BuildContext context;
  final userController = UserController();
  ZoneController zoneController = ZoneController();
  VisitController visitController = VisitController();
  TeamController teamController = TeamController();
  TeamHelper teamHelper = TeamHelper();
  EditPersonDialogState editPersonDialog = EditPersonDialogState();
  AddPersonDialogState addPersonDialog = AddPersonDialogState();
  MapController mapController;
  FlutterMapWidget flutterMapWidget;

  // Toggles trackers
  bool firstLaunch = true;
  bool mapToggle = false;
  bool teamToggle = false;

  var zones;
  var visits;
  List<dynamic> teamsElements = [];
  List<dynamic> visitsElements = [];
  List<dynamic> zonesElements = [];
  List<dynamic> statusElements = [];
  List<DropdownMenuItem<int>> teams = [];
  List<DropdownMenuItem<int>> visitsDropDown = [];
  List<DropdownMenuItem<int>> locations = [];
  List<DropdownMenuItem<int>> status = [];
  List<Marker> markersList = [];
  String selectedZone = '';
  String selectedStatus;
  String selectedTeam ='';
  String selectedVisitName = '';
  int _selectedZoneIndex=-1;
  int _selectedStatusIndex = -1;
  int _selectedTeamIndex=-1;
  var _selectedDate;
  String _selectedVisitUuid = '';
  String _currentTeamUuidAfterCallBackReload = '';
  String _currentZoneUuidAfterCallBackReload = '';

  DeleteHistoryDateDto historyDto;
  List<double> currentLocation = [48.864716, 2.349014];

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  void initState() {
    super.initState();
    loadTeams();
    mapController = MapController();
    flutterMapWidget = FlutterMapWidget();
    mapToggle = true;
  }

  loadDefaultTeam() async {

    var userCredentials = await userController.getCredentials();
    teamsElements.forEach((t) {
      if (t['uuid'] == userCredentials['teamUuid']) {
        setState(() {
          _currentTeamUuidAfterCallBackReload = t['uuid'];
          _selectedTeamIndex = teamsElements.indexOf(t);
          selectedTeam = t['name'];
          zones = t['zones'];
          statusElements = t['status'];
          loadZones();
          firstLaunch = false;
        });
      }
    }
    );
  }


  loadTeams() {
    teamController.findAll().then((data){
      setState(() {
        teamsElements = data;
        if(firstLaunch) loadDefaultTeam();
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

  updateHistory(visits){
    showDialog(context: context,builder: (context){
      UpdateVisitHistoryDto visitDto = UpdateVisitHistoryDto(teamsElements[_selectedTeamIndex]['uuid'],teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['uuid']);
      return HotDialogAddHistory(visitDto,visits,loadTeams);
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
            List<dynamic> conflicts = _conflictsAddress(
                visit['address'], visitsElements);
            return Center(
              child: IconButton(
                onPressed: () {
                  visitsElements =
                  teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['visits'];
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return DefaultTabController(length: 2, child: TabBarView(children: [
                          SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: conflicts.length > 1 ? _visitsDescription(
                                  conflicts) : Column(
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
                                                context, teamsElements,
                                                _selectedTeamIndex,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
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
                                                visit['phoneNumber'] != null
                                                    ? visit['phoneNumber']
                                                    : 'Not provided',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.filter_list,
                                                  color: Colors.black),
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
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.note,
                                                  color:visit['observation']!=null? Colors.green:Colors.redAccent),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                visit['observation']!=null?visit['observation']:'No Observation',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:50.0),
                                    child: Container(
                                      child: Text('Swipe to see history',style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('History',style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25
                                      ),
                                      ),
                                     SizedBox(width: 20,),
                                     Container(
                                       height: 35,
                                       width: 35,
                                       decoration: BoxDecoration(
                                         color: Colors.green,
                                         shape: BoxShape.circle,
                                       ),
                                       child: Stack(
                                         children: <Widget>[
                                           Positioned(child: Icon(Icons.add,size: 15,color: Colors.white,),left: 19,top: 2,),
                                           Positioned(child: IconButton(icon: Icon(Icons.calendar_today,color: Colors.white,size: 12,), onPressed: (){
                                             updateHistory(conflicts);
                                           }))
                                         ],
                                       ),
                                     )
                                    ],
                                  ),
                                ),
                                _buildHistory(conflicts)
                              ],
                            ),
                          ),

                        ]));
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
                      child: Text(conflicts.length.toString()
                        ,
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

      _zonesTagsWidget.forEach((zoneTag){

        Tag t = zoneTag as Tag;
        List<dynamic> visitsElements = t.content['visits'];
        visitsElements.forEach((visit) {
          if(visit['status']['uuid'].toString()==type.toString()){
            Marker marker = Marker(
              height: 80.0,
              width: 80.0,
              point: LatLng(visit['latitude'], visit['longitude']),
              builder: (context) {
                Color color = colorType(visit);
                List<dynamic> conflicts = _conflictsAddress(
                    visit['address'], visitsElements);
                return Center(
                  child: IconButton(
                    onPressed: () {
                      visitsElements =
                      teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['visits'];
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return DefaultTabController(length: 2, child: TabBarView(children: [
                              SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: conflicts.length > 1 ? _visitsDescription(
                                      conflicts) : Column(
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
                                                    context, teamsElements,
                                                    _selectedTeamIndex,
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
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
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
                                                    visit['phoneNumber'] != null
                                                        ? visit['phoneNumber']
                                                        : 'Not provided',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.filter_list,
                                                      color: Colors.black),
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
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.note,
                                                      color:visit['observation']!=null? Colors.green:Colors.redAccent),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    visit['observation']!=null?visit['observation']:'No Observation',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top:50.0),
                                        child: Container(
                                          child: Text('Swipe to see history',style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold
                                          ),),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text('History',style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25
                                          ),
                                          ),
                                          SizedBox(width: 20,),
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(child: Icon(Icons.add,size: 15,color: Colors.white,),left: 19,top: 2,),
                                                Positioned(child: IconButton(icon: Icon(Icons.calendar_today,color: Colors.white,size: 12,), onPressed: (){
                                                  updateHistory(conflicts);
                                                }))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    _buildHistory(conflicts)
                                  ],
                                ),
                              ),

                            ]));
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
                          child: Text(_currentConflictsSize(conflicts).toString()
                            ,
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

      });

      setState(() {
        markersList = tmpMarkers;
        flutterMapWidget.state.updateMarkers(markersList, LatLng(currentLocation[0],currentLocation[1]), 13.0);
      });
  }

  loadMarkersWithMultipleZones(){
    List<Marker> tmpMarkers = [];

    _zonesTagsWidget.forEach((z){

      Tag t = z as Tag;
      List<dynamic> visitsElements = t.content['visits'];
      visitsElements.forEach((visit) {
        Marker marker = Marker(
          height: 80.0,
          width: 80.0,
          point: LatLng(visit['latitude'], visit['longitude']),
          builder: (context) {
            Color color = colorType(visit);
            List<dynamic> conflicts = _conflictsAddress(
                visit['address'], visitsElements);
            return Center(
              child: IconButton(
                onPressed: () {
                  visitsElements =
                  teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['visits'];
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return DefaultTabController(length: 2, child: TabBarView(children: [
                          SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: conflicts.length > 1 ? _visitsDescription(
                                  conflicts) : Column(
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
                                                context, teamsElements,
                                                _selectedTeamIndex,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
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
                                                visit['phoneNumber'] != null
                                                    ? visit['phoneNumber']
                                                    : 'Not provided',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.filter_list,
                                                  color: Colors.black),
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
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.note,
                                                  color:visit['observation']!=null? Colors.green:Colors.redAccent),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                visit['observation']!=null?visit['observation']:'No Observation',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:50.0),
                                    child: Container(
                                      child: Text('Swipe to see history',style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('History',style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25
                                      ),
                                      ),
                                      SizedBox(width: 20,),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(child: Icon(Icons.add,size: 15,color: Colors.white,),left: 19,top: 2,),
                                            Positioned(child: IconButton(icon: Icon(Icons.calendar_today,color: Colors.white,size: 12,), onPressed: (){
                                              updateHistory(conflicts);
                                            }))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _buildHistory(conflicts)
                              ],
                            ),
                          ),

                        ]));
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
                      child: Text(conflicts.length.toString()
                        ,
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
    });


  }

  _refreshMarkersAfterAdd(){
    teamsElements.forEach((team){
      if(team['uuid'].toString()==_currentTeamUuidAfterCallBackReload){
        List<dynamic> tmpZones = team["zones"];
        tmpZones.forEach((z){
          _zonesTagsWidget.forEach((zoTag){

            Tag t = zoTag as Tag;
            if(z['uuid'].toString()==t.content['uuid'].toString()){
              t.content = z;
            }
          });
           setState(() {
             _selectedTeamIndex = teamsElements.indexOf(team);
             _selectedZoneIndex = tmpZones.indexOf(z);
             zones = team['zones'];
             visitsElements = zones[_selectedZoneIndex]['visits'];
             loadZones();
           });
        });

        setState(() {
          loadMarkersWithMultipleZones();
          flutterMapWidget.state.updateMarkers(markersList, LatLng(currentLocation[0], currentLocation[1]), 12.0);
        });
      }
    });
  }

  _conflictsAddress(address, List<dynamic> visits) {
    List<dynamic> visitsConflicts = [];

    visits.forEach((v) {
      if (v['address'].toString() == address) visitsConflicts.add(v);
    });

    return visitsConflicts;
  }

  _currentConflictsSize(List<dynamic>visits){
    int counter = 0 ;

    visits.forEach((v){

      if(v['status']['uuid']==teamsElements[_selectedTeamIndex]['status'][_selectedStatusIndex]['uuid']) counter+=1;

    });

    return counter;
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
          title: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.group,
                      color: Colors.brown,
                    ),
                    SizedBox(width: 5),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint:Text(selectedTeam,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center)
                        ,
                        elevation: 0,
                        items: teams,
                        onChanged: (value) {
                          setState(() {
                            selectedZone = '';
                            selectedStatus = '';
                            _selectedTeamIndex = value;
                            selectedTeam = teamsElements[value]['name'];
                            _currentTeamUuidAfterCallBackReload =
                            teamsElements[value]['uuid'];
                            _currentZoneUuidAfterCallBackReload = '';
                            zones = teamsElements[value]["zones"];
                            statusElements = teamsElements[value]["status"];
                            status.clear();
                            _zonesTagsWidget.clear();
                            markersList.clear();
                            flutterMapWidget.state.updateMarkers(markersList, LatLng(currentLocation[0],currentLocation[1]), 13.0);
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
                      icon: Icon(
                        Icons.refresh, size: 25, color: Colors.orangeAccent,),
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
                              this.context, teamsElements, -1,
                              -1, loadTeams);
                        }
                    )
                  ],
                )
              ],
            ),
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
                      hint: Text(selectedZone,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
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
                          _buildZoneTag(zones[value]);
                          loadMarkersWithMultipleZones();
                          flutterMapWidget.state.updateMarkers(markersList,LatLng(currentLocation[0], currentLocation[1]),13.0);
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
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _zonesTagsWidget,
              ),
            ),
            SizedBox(height: 10,),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 120 ,
                width: double.infinity,
                child: mapToggle && teamToggle
                    ? flutterMapWidget
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

  _visitsDescription(List<dynamic> visits) {
    List<Widget> description = [];

    Padding address = Padding(padding: EdgeInsets.only(left:10,right: 10,top: 10), child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.place, color: Colors.blue,),
          SizedBox(width: 10,),
          Text(visits[0]['address'], style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),)
        ],
      ),
    ),);
    description.add(address);
    List<dynamic> tmpVisitsFiltered = [];
    if(_selectedStatusIndex!=-1){
      String currentStatus = teamsElements[_selectedTeamIndex]['status'][_selectedStatusIndex]['uuid'];

      int size = visits.length;
      for(int i=0;i<size;i++){
        if(visits[i]['status']['uuid']==currentStatus){
          tmpVisitsFiltered.add(visits[i]);
        }
      }

      for(int i=0;i<size;i++){
        if(visits[i]['status']['uuid']!=currentStatus){
          tmpVisitsFiltered.add(visits[i]);
        }
      }
    }else tmpVisitsFiltered = visits;

    tmpVisitsFiltered.forEach((v) {
      Color color = colorType(v);
      Padding visitAddress = Padding(
        padding: EdgeInsets.only(top: 5.0),
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
                v['name'],
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
                    context, teamsElements, _selectedTeamIndex,
                    _selectedZoneIndex, v,
                    loadTeams);
              },
              color: orange_custom_color,
            ),
          ],
        ),
      );

      Container c = Container(
        child: Padding(
          padding: EdgeInsets.only(
              left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                    v['phoneNumber'] != null
                        ? v['phoneNumber']
                        : 'Not provided',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.filter_list,
                      color: Colors.black),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    v['status']['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.note,
                      color: v['observation']!=null?Colors.green:Colors.redAccent),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    v['observation']!=null?v['observation']:'No observation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Divider(color: Colors.black, indent: 20, height: 10,)
            ],
          ),
        ),
      );
      description.add(visitAddress);
      description.add(c);
    });

    Column visitsDescription = Column(
      children: description,
    );

    return visitsDescription;
  }

  _buildHistory(List<dynamic>visits) {

    List<Widget> datesWidget = [];

    visits.forEach((visit){

      Row name = Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left:8.0),
            child: Text(visit['name']+ ' :',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
          ),

        ],
      );
      datesWidget.add(name);
      if(visit['history']!=null && visit['history']['dates']!=null){

        List<dynamic> dates = visit['history']['dates'];


        dates.forEach((d){

          if(d.toString().isNotEmpty){
            Row r = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(d,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),),
                IconButton(icon: Icon(Icons.clear, color: Colors.red,), onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Center(
                              child: Text(
                                d,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          children: <Widget>[
                            Center(
                                child: Text(
                                  'Are you sure ?',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                )),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      historyDto = DeleteHistoryDateDto(teamsElements[_selectedTeamIndex]['uuid'],teamsElements[_selectedTeamIndex]['zones'][_selectedZoneIndex]['uuid'],visit['uuid'],d);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddTransition(SUCCESS_DELETE,ERROR_DELETE,_deleteDateInHistory,DELETE_ACTION,loadTeams)));
                                    },
                                    child: Text(
                                      'DELETE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                }),
              ],
            );
            datesWidget.add(r);
          }

        });
        Padding d = Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.15,right:  MediaQuery.of(context).size.width*0.02),child: Divider(
          color: Colors.black,
          height: 2,
        ));
        datesWidget.add(d);

      }else datesWidget.add(Center(
        child: Text('Empty...',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),),
      ));
    });

    Column c =  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: datesWidget,
    );
    return c;
  }

  _deleteDateInHistory() async {
    return visitController.deleteHistoryDate(historyDto);
  }

  _buildZoneTag(zoneEl){
    if(!stillPresent(zoneEl)){
      Tag t = Tag(Colors.blue,zoneEl,_removeTag);
      _zonesTagsWidget.add(t);
    }
  }
  _removeTag(Tag t){
    setState(() {
      selectedStatus ='';
      String tmpDeletedZoneName = t.content['name'];
      _zonesTagsWidget.remove(t);
      if(_zonesTagsWidget.length==0){
        selectedZone = '';
        markersList = [];
        status.clear();
        currentLocation[0] =48.864716;
        currentLocation[1] = 2.349014;
      }else{
        if(tmpDeletedZoneName.toString()==selectedZone){
          Tag tmp = _zonesTagsWidget[0];
          currentLocation[0] = tmp.content['latitude'];
          currentLocation[1] = tmp.content['longitude'];
          selectedZone = tmp.content['name'];
        }
      }
    });
    loadMarkersWithMultipleZones();
    flutterMapWidget.state.updateMarkers(markersList,LatLng(currentLocation[0], currentLocation[1]),13.0);
  }

  stillPresent(zoneEl){

    bool res = false;
    _zonesTagsWidget.forEach((z){
      Tag t = z as Tag;

      if(t.content['uuid'].toString()==zoneEl['uuid'].toString()) res =true;
    });

    return res;
  }


}
