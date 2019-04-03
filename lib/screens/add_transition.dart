
import 'package:flutter/material.dart';
import '../components/loader.dart';

class AddTransition extends StatefulWidget {

  final String _success;
  final String _error;
  final Function _action;
  final String _typeOfAction;
  final Function _actionCallBackAfterProcess;


  AddTransition(this._success, this._error, this._action,this._typeOfAction,this._actionCallBackAfterProcess);

  @override
  _AddTransitionState createState() => _AddTransitionState();
}

class _AddTransitionState extends State<AddTransition> {

  Widget content;
  var response;
  bool result = false;
  bool processEnded = false;

  @override
  void initState() {
    super.initState();
      Future.delayed(Duration(seconds: 2), ()async{
        response = await widget._action();
        String type = '';
        print(response);
        switch(widget._typeOfAction){
          case 'create':
            type = 'created';
            break;
          case 'invite':
            type = 'email';
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
        try{
          var res = response[type];
          if(res is bool){
            result = response[type];
          }else if(res is List){
            if(res.length==0) result = false;
            else result = true;
          }

        }catch(e){
          result = false;
          print(e);
          print('Please retry within few minutes...We currently working on our server...');
        }

        Container container = Container(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(result?widget._success:widget._error,
                    style: TextStyle(
                        color: result?Colors.green:Colors.red,
                        fontSize: 25
                    ),
                  ),
                  IconButton(icon: Icon(Icons.close,size: 30,), onPressed: (){
                    Navigator.pop(context);
                  },color: Colors.blueGrey,)
                ]
              ),
            ),
          ),
        );
        setState(() {
          content = container;
          widget._actionCallBackAfterProcess();
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
