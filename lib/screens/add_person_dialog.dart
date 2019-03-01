import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import '../controller/visit_controller.dart';
import '../models/visit.dart';
import '../screens/add_person_validation.dart';
import '../tools/const.dart';

class AddPersonDialog extends StatefulWidget {
  @override
  AddPersonDialogState createState() => AddPersonDialogState();
}

class AddPersonDialogState extends State<AddPersonDialog> {
  var statusType = ['Visit', 'Done', 'Absent', 'New', 'NA'];
  var selectedZone = '';
  int _selectedZoneIndex;
  var selectedType;
  final visitNameController = TextEditingController();
  final visitAddressController = TextEditingController();
  final visitPhoneNumberController = TextEditingController();

  @override
  void dispose() {
    visitAddressController.dispose();
    visitNameController.dispose();
    visitPhoneNumberController.dispose();
    super.dispose();
  }

  Future<bool> dialog(
      context, zones, selectedIndex, actionCallBackAfter) async {
    selectedZone = zones[selectedIndex]['name'];
    _selectedZoneIndex = selectedIndex;
    List<DropdownMenuItem<int>> zonesItems = [];
    zones.forEach((zone) {
      DropdownMenuItem<int> dropdownMenuItem = DropdownMenuItem(
        child: Text(zone['name']),
        value: zones.indexOf(zone),
      );
      zonesItems.add(dropdownMenuItem);
    });

    List<DropdownMenuItem<String>> statusItems = statusType
        .map((status) => DropdownMenuItem(
              child: Text(status),
              value: status,
            ))
        .toList();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Add Person',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: visitNameController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: visitPhoneNumberController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.place),
                      ),
                      controller: visitAddressController,
                      onTap: () async {
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: kGoogleApiKey,
                            mode: Mode.overlay,
                            language: "fr",
                            components: [Component(Component.country, "fr")]);
                        visitAddressController.text =
                            p != null ? p.description : '';
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Zone : ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: zonesItems,
                            hint: Text(selectedZone,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                            onChanged: (value) {
                              selectedZone = zones[value]['name'];
                              _selectedZoneIndex = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Status : ',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: statusItems,
                            hint: selectedType != null
                                ? Text(selectedType,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center)
                                : Text(''),
                            onChanged: (value) {
                              selectedType = value;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              textDirection: TextDirection.rtl,
              children: <Widget>[
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {
                      VisitController visitController = VisitController();

                      String name = visitNameController.text;
                      String address = visitAddressController.text;
                      String phoneNumber = visitPhoneNumberController.text;
                      String zoneId = visitController
                          .getId(zones[_selectedZoneIndex]['_id']);
                      String status = selectedType;
                      Visit visit = Visit('',name, address, zoneId, status);

                      if (phoneNumber.isNotEmpty)
                        visit.phoneNumber = phoneNumber;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPersonValidationScreen(visit)));
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Color.fromRGBO(46, 204, 113, 1)),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Color.fromRGBO(46, 204, 113, 1),
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
