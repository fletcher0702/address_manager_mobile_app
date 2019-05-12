import 'package:flutter/material.dart';
import '../routes/routes.dart';
import '../controller/user_controller.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final userController = UserController();
  String _userEmail = '';


  @override
  void initState() {
    super.initState();
      getUserCredentials();
  }

  getUserCredentials() async{
    var credentials= await userController.getCredentials();

    setState(() {
      _userEmail = credentials['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.12,
              width: double.infinity,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: <Widget>[
                      SizedBox(width: 8,),
                      Icon(Icons.person_outline, size: 25,color: Colors.white,),
                      SizedBox(width: 15,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(_userEmail,style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.88,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8,bottom: 8,right: 8),
                      child: Column(

                        children: <Widget>[
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:8.0),
                      child: Container(color: Colors.grey,height: 1,width: double.infinity,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
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
                              Icon(Icons.person,color: Colors.orange),
                              FlatButton(
                                onPressed: () {Navigator.pushNamed(context, VISITS_PANEL_ROUTE);},
                                child: Text('Persons Panel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:8.0),
                      child: Container(color: Colors.grey,height: 1,width: double.infinity,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.pie_chart,color:Colors.indigo),
                              FlatButton(
                                onPressed: () {Navigator.pushNamed(context, STATISTICS_PANEL_ROUTE);},
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
                                onPressed: () {Navigator.pushNamed(context, SETTINGS_PANEL_ROUTE);},
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
                        ],
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.only(left:8.0),
                      child: Container(color: Colors.grey,height: 1,width: double.infinity,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.close,color:Colors.red),
                          FlatButton(
                            onPressed: () async {
                              await userController.destroyCredentials();
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, LOGIN_ROUTE);
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
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}