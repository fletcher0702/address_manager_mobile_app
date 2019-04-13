import 'package:address_manager/components/side_menu.dart';
import 'package:address_manager/controller/team_controller.dart';
import 'package:address_manager/helpers/team_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final TeamController teamController = TeamController();
  final TeamHelper teamHelper = TeamHelper();
  List<dynamic> teams = [];
  List<dynamic> visits = [];
  List<DropdownMenuItem<int>> teamsItems = [];
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  List<CircularStackEntry> data = <CircularStackEntry>[];
  String _holeLabel = '';
  SingleChildScrollView _legend = SingleChildScrollView();
  Column _legendNumber = Column();
  int _selectedTeamIndex;
  String selectedTeam = '';

  @override
  void initState() {
    super.initState();
    loadTeams();
  }
  loadTeams(){
    teamController.findAll().then((res) {
      setState(() {
        teams = res;
        teamsItems = teamHelper.buildDropDownSelection(teams);
      });
    });
  }

  _loadData() {
    List<dynamic> zones = teams[_selectedTeamIndex]["zones"];
    visits.clear();
    _legendNumber = Column();
    zones.forEach((zone) {
      List<dynamic> visitsInZone = zone['visits'];
      visits.addAll(visitsInZone);
    });
    int totalVisit = visits.length;

    if (totalVisit > 0) {
      List<Widget> tmpLegendNumber = [];
      List<dynamic> status = teams[_selectedTeamIndex]['status'];
      Map<String, int> visitsByStatus = Map();
      status.forEach((st) {
        int numberOfVisitsByStatus = 0;
        visits.forEach((v) {
          if (v['status']['uuid'].toString() == st['uuid'].toString()) {
            numberOfVisitsByStatus += 1;
          }
        });
        visitsByStatus.putIfAbsent(st['uuid'], () => numberOfVisitsByStatus);
        Container c = Container(
          width: 20,
          height: 20,
          decoration:
              BoxDecoration(color: Color(st['color']), shape: BoxShape.circle),
        );

        Text title = Text(
          numberOfVisitsByStatus.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        );

        Padding r = Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              c,
              SizedBox(
                width: 5,
              ),
              title
            ],
          ),
        );
        tmpLegendNumber.add(r);
      });

      Column legendNumberRef = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tmpLegendNumber,
      );

      List<CircularSegmentEntry> segments = [];
      visitsByStatus.forEach((hash, value) {
        // Computing legend

        double ratio = (value / totalVisit) * 100.0;
        CircularSegmentEntry segmentEntry =
            CircularSegmentEntry(ratio, getStatusColor(hash));
        segments.add(segmentEntry);
      });
      List<CircularStackEntry> tmp = <CircularStackEntry>[
        new CircularStackEntry(segments)
      ];
      setState(() {
        _legendNumber = legendNumberRef;
        _holeLabel = visits.length.toString();
        data = tmp;
        _chartKey.currentState.updateData(data);
      });
    } else {
      CircularSegmentEntry emptySegment =
          CircularSegmentEntry(100.0, Colors.grey);
      List<CircularStackEntry> empty = <CircularStackEntry>[
        new CircularStackEntry([emptySegment])
      ];
      setState(() {
        _holeLabel = visits.length.toString();
        data = empty;
        _chartKey.currentState.updateData(data);
      });
    }
  }

  Color getStatusColor(statusUuid) {
    List<dynamic> status = teams[_selectedTeamIndex]['status'];
    Color c;
    status.forEach((s) {
      if (s['uuid'].toString() == statusUuid) {
        c = Color(s['color']);
      }
    });

    return c;
  }

  _buildLegend() {
    List<dynamic> statusItems = teams[_selectedTeamIndex]["status"];

    List<Widget> list = [];

    statusItems.forEach((s) {
      Container c = Container(
        width: 20,
        height: 20,
        decoration:
            BoxDecoration(color: Color(s['color']), shape: BoxShape.circle),
      );

      Text title = Text(
        s['name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      );

      Row r = Row(
        children: <Widget>[
          c,
          SizedBox(
            width: 10,
          ),
          title,
          SizedBox(
            width: 10,
          ),
        ],
      );
      list.add(r);
    });

    SingleChildScrollView description = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
    setState(() {
      _legend = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text(
            'Statistics',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent, 
          iconTheme: IconThemeData(color: Colors.grey),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh,color: Colors.orangeAccent,), onPressed: loadTeams)
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.group, color: Colors.brown),
                  SizedBox(
                    width: 5,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: teamsItems,
                      hint: Text(selectedTeam,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center),
                      onChanged: (value) {
                        selectedTeam = teams[value]['name'];
                        _selectedTeamIndex = value;
                        _loadData();
                        _buildLegend();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedCircularChart(
                    key: _chartKey,
                    size: Size(300, 300),
                    initialChartData: data,
                    chartType: CircularChartType.Radial,
                    holeLabel: _holeLabel,
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 40),
                  ),
                  _legendNumber
                ],
              ),
              _legend,
            ]));
  }
}
