import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../controller/visit_controller.dart';
import '../components/loader.dart';
class EditPersonValidationScreen extends StatefulWidget {
  final String id;
  final Visit visit;
  final String originalZoneId;

  EditPersonValidationScreen(this.id,this.visit,this.originalZoneId);

  @override
  _EditPersonValidationScreenState createState() => _EditPersonValidationScreenState();
}

class _EditPersonValidationScreenState extends State<EditPersonValidationScreen> {

  VisitController visitController = VisitController();
  bool visitUpdateToggle = false;

  registerVisit()async{
    if(!visitUpdateToggle){
      Future.delayed(Duration(seconds: 2), ()async{
        await visitController.updateVisit(widget.id,widget.visit,widget.originalZoneId);
        setState(() {
          visitUpdateToggle = true;
        });
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
        iconTheme: visitUpdateToggle?IconThemeData(color: Colors.black):null,
      ),
      body: visitUpdateToggle?Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Person successfully updated', style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
      ),):ColorLoader(),
    );
  }
}
