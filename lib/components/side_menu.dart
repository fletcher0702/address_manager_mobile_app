import 'package:flutter/material.dart';
import '../routes/routes.dart';
import '../controller/user_controller.dart';

class SideMenu extends StatelessWidget {
  final userController = UserController();
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
                  Icon(Icons.home, color: Colors.green),
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
                  Icon(Icons.place, color:Colors.blue),
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
                  Icon(Icons.group, color: Colors.brown),
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
                  Icon(Icons.person,color: Colors.orange),
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
                  Icon(Icons.pie_chart,color:Colors.indigo),
                  FlatButton(
                    onPressed: () => {},
                    child: Text('Statistics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.settings,color:Colors.grey),
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
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.close,color:Colors.red),
                  FlatButton(
                    onPressed: () async {
                      await userController.destroyCredentials();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, LOGIN_ROUTE);
                    },
                    child: Text('Log out',
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