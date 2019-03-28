import '../tools/actions.dart';
import '../tools/messages.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:flutter/material.dart';

class DialogHelper extends StatefulWidget{

  @override
  DialogHelperState createState() => DialogHelperState();
}

class DialogHelperState extends State<DialogHelper> {


  static Future<bool> showDialogBox(context, title, content, saveAction,saveBool,actionCallBackAfterProcess) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(
            child: Text(title, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25
            ),),
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[

            Column(
              children: content,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: (){

                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition(saveBool?SUCCESS_CREATION:SUCCESS_UPDATE,saveBool?ERROR_CREATION:ERROR_UPDATE,saveAction,saveBool?CREATE_ACTION:UPDATE_ACTION,actionCallBackAfterProcess)));

                    },
                    child: Text(
                      saveBool?'SAVE':'UPDATE',
                      style: TextStyle(
                        color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    color: saveBool?Color.fromRGBO(46, 204, 113, 1):Colors.deepOrangeAccent),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  color: saveBool?Color.fromRGBO(46, 204, 113, 1):Colors.deepOrangeAccent,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}

