import '../tools/actions.dart';
import 'package:address_manager/screens/add_transition.dart';
import 'package:flutter/material.dart';

class DialogHelper extends StatefulWidget{

  @override
  DialogHelperState createState() => DialogHelperState();
}

class DialogHelperState extends State<DialogHelper> {


  static Future<bool> showDialogBox(context, title, content, saveAction,saveBool) {
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTransition('Successfully Added','Error something went wrong...',saveAction,CREATE_ACTION)));

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

