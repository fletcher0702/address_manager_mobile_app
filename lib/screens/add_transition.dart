
import 'package:flutter/material.dart';
import '../components/loader.dart';

class AddTransition extends StatefulWidget {

  String _success;
  String _error;
  Function _action;
  String _typeOfAction;


  AddTransition(this._success, this._error, this._action,this._typeOfAction);

  @override
  _AddTransitionState createState() => _AddTransitionState();
}

class _AddTransitionState extends State<AddTransition> {

  Widget content;
  var response;
  bool result;
  bool processEnded = false;

  @override
  void initState() {
    super.initState();
      Future.delayed(Duration(seconds: 2), ()async{
        response = await widget._action();
        String type = '';
        switch(widget._typeOfAction){
          case 'create':
            type = 'created';
            break;
          case 'update':
            type = 'updated';
            break;
          case 'delete':
            type = 'deleted';
            break;
          default:
            type = 'unknow';
            break;
        }
        result = response[type];
        Container container = Container(
          child: Center(
            child: Text(result?widget._success:widget._error,
              style: TextStyle(
                  color: result?Colors.green:Colors.red,
                  fontSize: 25
              ),
            ),
          ),
        );
        setState(() {
          content = container;
          processEnded = true;
        });
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: processEnded?content:ColorLoader(),
    );
  }
}
