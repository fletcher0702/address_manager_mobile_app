
import 'package:address_manager/screens/statistics_panel.dart';
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/team_panel.dart';
import 'screens/visit_panel.dart';
import 'screens/zone_panel_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() async{
  await DotEnv().load('.env');
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
      STATISTICS_PANEL_ROUTE: (context) => StatisticsScreen(),
    },
  ));
}
