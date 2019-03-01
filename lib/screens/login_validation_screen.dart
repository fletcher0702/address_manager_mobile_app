import 'package:flutter/material.dart';
import '../controller/visit_controller.dart';
import '../controller/user_controller.dart';
import '../components/loader.dart';
class LoginValidationScreen extends StatefulWidget {
  final String id;
  final String originalZoneId;

  LoginValidationScreen(this.id,this.originalZoneId);

  @override
  _LoginValidationScreenState createState() => _LoginValidationScreenState();
}

class _LoginValidationScreenState extends State<LoginValidationScreen> {

  VisitController visitController = VisitController();
  bool userLoggedToggle = false;

  loginRequest()async{
    if(!userLoggedToggle){
      Future.delayed(Duration(seconds: 2), ()async{

        setState(() {
          userLoggedToggle = true;
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    loginRequest();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: userLoggedToggle?IconThemeData(color: Colors.black):null,
      ),
      body: userLoggedToggle?Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Person successfully deleted!', style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),):ColorLoader(),
    );
  }
}
