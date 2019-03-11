import 'package:flutter/material.dart';

class TeamDescription extends StatefulWidget {

  List<dynamic> teams;

  TeamDescription(this.teams);

  @override
  TeamDescriptionState createState() => TeamDescriptionState();
}

class TeamDescriptionState extends State<TeamDescription> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildDescription(),
    );
  }

  _buildDescription(){
    List<Widget> content = [];
    widget.teams.forEach((team){

      Text title = Text(team['name'],
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      );

      List<dynamic> zones = team["zones"];
      List<Widget> rows = [];
      zones.forEach((zone){
        Row row = Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.blue),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(zone['name'], style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                Text(zone['visits'].length + ' visits(s)', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                ),)
              ],
            )
          ],
        );
        rows.add(row);
      });
      Column wrapper = Column(
        children: rows,
      );
      content.add(title);
      content.add(wrapper);

    });
    return content;
  }
}
