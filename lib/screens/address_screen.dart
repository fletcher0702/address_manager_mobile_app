import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressScreen extends StatefulWidget {
  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
//  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 30,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            child: ListView(

              children: dummyList(),
            ),
          ),
        ],
      ));
  }


  List<Widget> dummyList(){

    List<Widget> dummys = List<Widget>();

    for(int i=0;i<10;i++){
      ListTile listTile = ListTile(
        leading: Icon(Icons.add),
        title: Text('${i.toString()}'),
      );
      dummys.add(listTile);
    }

    return dummys;

  }
}
