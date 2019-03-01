import 'package:flutter/material.dart';
import '../routes/routes.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.home),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HOME_ROUTE);
                    },
                    child: Text('Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.place),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ZONE_PANEL_ROUTE);
                    },
                    child: Text('Zone Panel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.group),
                  FlatButton(
                    onPressed: () {Navigator.pushNamed(context, TEAM_PANEL_ROUTE);},
                    child: Text('Team Panel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.person),
                  FlatButton(
                    onPressed: () {Navigator.pushNamed(context, VISITS_PANEL_ROUTE);},
                    child: Text('Visits Panel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.settings),
                  FlatButton(
                    onPressed: () => {},
                    child: Text('Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}