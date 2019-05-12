
import 'package:flutter/material.dart';
import 'package:address_manager/tools/messages.dart';

class PolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Privacy Policy', style: TextStyle(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Updated May 12, 2019'),
                SizedBox(height: 20,),
                Text(PRIVACY,style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 30,),
                Text('RESPECTING YOUR PRIVACY',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Text(RESPECTING_YOUR_PRIVACY,style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 30,),
                Text('DATA SECURITY AND CONFIDENTIALITY',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),

                Text(DATA_SECURITY_AND_CONFIDENTIALITY),
                SizedBox(height: 30,),
                Text('NOTIFICATION OF CHANGES TO THIS POLICY',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 20,),
                Text(POLICY_UPDATE)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
