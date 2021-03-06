import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../controller/visit_controller.dart';
import '../components/loader.dart';
class AddPersonValidationScreen extends StatefulWidget {
  final Visit visit;
  Function _callBackEnd;

  AddPersonValidationScreen(this.visit,this._callBackEnd);

  @override
  _AddPersonValidationScreenState createState() => _AddPersonValidationScreenState();
}

class _AddPersonValidationScreenState extends State<AddPersonValidationScreen> {

  VisitController visitController = VisitController();
  bool visitRegisterToggle = false;

  registerVisit()async{
    if(!visitRegisterToggle){
      Future.delayed(Duration(seconds: 2), ()async{
        var response = await visitController.createVisit(widget.visit);

        if(response['created']){
          setState(() {
            widget._callBackEnd();
            visitRegisterToggle = true;
          });
        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    registerVisit();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: visitRegisterToggle?IconThemeData(color: Colors.black):null,
      ),
      body: visitRegisterToggle?Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Person successfully register', style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),):ColorLoader(),
    );
  }
}
