import 'package:flutter/material.dart';
import '../tools/colors.dart';

class TeamDescription extends StatefulWidget {

  final List<dynamic> teams;

  TeamDescription(this.teams);

  @override
  TeamDescriptionState createState() => TeamDescriptionState();
}

class TeamDescriptionState extends State<TeamDescription> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20,right: 20),
      child: SingleChildScrollView(
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Invite person(s)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person_add,color: green_custom_color),
                  onPressed: (){},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildDescription(),
            ),
          ],
        ),
      ),
    );
  }

  _buildDescription(){
    List<Widget> content = [];
    widget.teams.forEach((team){

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
              IconButton(icon: Icon(Icons.edit, color: Colors.orange,size: 18,), onPressed: (){}),
              IconButton(icon: Icon(Icons.close, color: Colors.red,size: 18,), onPressed: (){}),
            ],
          )
        ],
      );
      Divider divider = Divider(color: Colors.black,height: 5,);

      List<dynamic> zones = team["zones"];
      List<Widget> rows = [];
      zones.forEach((zone){
        Padding row = Padding(padding: EdgeInsets.only(bottom: 5),child: Row(
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
                Text(zone['visits'].length.toString() + ' address', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),)
              ],
            )
          ],
        ));
        rows.add(row);
      });
      Padding wrapper = Padding(padding: EdgeInsets.only(top:10,bottom: 10),child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rows,
      ));
      content.add(title);
      content.add(divider);
      content.add(wrapper);

    });
    return content;
  }
}
