import 'package:flutter/material.dart';
import '../controller/visit_controller.dart';
import '../components/loader.dart';
class DeletePersonValidationScreen extends StatefulWidget {
  final visit;

  DeletePersonValidationScreen(this.visit);

  @override
  _DeletePersonValidationScreenState createState() => _DeletePersonValidationScreenState();
}

class _DeletePersonValidationScreenState extends State<DeletePersonValidationScreen> {

  VisitController visitController = VisitController();
  bool visitDeletedToggle = false;

  deletePerson()async{
    if(!visitDeletedToggle){
      Future.delayed(Duration(seconds: 2), ()async{
        var res = await visitController.deleteOne(widget.visit);

          setState(() {
            visitDeletedToggle = true;
          });
//        {
//          //Error UI Handling
//          Navigator.pop(context);
//        }

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    deletePerson();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: visitDeletedToggle?IconThemeData(color: Colors.black):null,
      ),
      body: visitDeletedToggle?Center(child: Padding(
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
