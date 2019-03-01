
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/team_panel.dart';
import 'screens/visit_panel.dart';
import 'screens/zone_panel_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Address Manager',
    initialRoute: LOGIN_ROUTE,
    theme: ThemeData(fontFamily: 'Montserrat'),
    routes: {
      LOGIN_ROUTE: (context) => LoginScreen(),
      SIGN_UP_ROUTE: (context) => SignUpScreen(),
      HOME_ROUTE: (context) => Home(),
      ZONE_PANEL_ROUTE: (context) => ZonePanelScreen(),
      TEAM_PANEL_ROUTE: (context) => TeamPanelScreen(),
      VISITS_PANEL_ROUTE: (context) => VisitPanelScreen(),
    },
  ));
}
