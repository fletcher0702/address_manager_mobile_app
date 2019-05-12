
import 'package:flutter/material.dart';
import 'package:address_manager/tools/messages.dart';

class CopyrightScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('TERMS OF USE', style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Text(TERMS_OF_USE,style: TextStyle(
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 30,),
              Text('COPYRIGHT',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 20,),
              Text(COPYRIGHT,style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );
  }
}
