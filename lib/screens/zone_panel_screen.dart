import 'package:flutter/material.dart';

import '../components/panel_app_bar.dart';
import '../components/side_menu.dart';
import '../components/loader.dart';
import '../controller/zone_controller.dart';
import '../helpers/dialog_helper.dart';
import '../models/zone.dart';
import 'package:address_manager/tools/const.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class ZonePanelScreen extends StatefulWidget {
  @override
  ZonePanelScreenState createState() => ZonePanelScreenState();
}

class ZonePanelScreenState extends State<ZonePanelScreen> {
  final zoneController = ZoneController();
  BuildContext context;
  var zones;
  final zoneNameController = TextEditingController();
  final zoneAddressController = TextEditingController();
  List<Widget> _zonesList = List<Widget>();
  bool zoneToggle = false;
  bool activeDetails = false;

  @override
  void dispose() {
    zoneNameController.dispose();
    zoneAddressController.dispose();
    super.dispose();
  }

  saveAction() {
    Zone zone = Zone(zoneNameController.text,'toto');
    zoneController.createOne(zone, zoneAddressController.text);
    zoneNameController.clear();
  }

  addZone() {
    List<Widget> content = [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: zoneNameController,
              decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                labelText: 'Name',
                prefixIcon: Icon(Icons.place)
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.find_replace),
                labelText: 'Location'
              ),
              controller: zoneAddressController,
              onTap: () async {
                Prediction p = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: kGoogleApiKey,
                    mode: Mode.overlay,
                    language: "fr",
                    components: [Component(Component.country, "fr")]);
                zoneAddressController.text =
                p != null ? p.description : '';
              },
            )
          ],
        ),
      )
    ];

    DialogHelperState.showDialogBox(
        this.context, 'Add Zone', content, saveAction);
  }

  @override
  Widget build(BuildContext context) {
    zones = zoneController.findAll();
    zonesListElements(zones);
    this.context = context;
    return Scaffold(
      drawer: SideMenu(),
      appBar: PreferredSize(
        child: PanelAppBar('Zone Panel', Icons.add_location, addZone),
        preferredSize: Size(double.infinity, 100.0),
      ),
      body: Center(
        child: zoneToggle? ListView(
          children: _zonesList,
          scrollDirection: Axis.vertical,
        ): ColorLoader()
      ),
    );
  }

  zonesListElements(zonesData) {
    zonesData.then((val) {
      setState(() {
        zones = val;
        if (!zoneToggle) {
          zones.forEach((zoneItem) {
            ListTile listTile = ListTile(
              leading: Icon(Icons.place, color: Colors.blue,size: 30,),
              title: Text(
                '${zoneItem['name']}'
                ,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              subtitle: zoneItem['visits']!=null?Text('${zoneItem['visits'].length} visit(s)'):Text('Empty'),
              onTap: (){
//                Navigator.push(context, MaterialPageRoute(builder: (context)=>ZoneDetailScreen(zoneItem)));
              showModalBottomSheet(context: context, builder: (ctx){
                return Container(
                  height: 300,
                  width: double.infinity,
                );
              });
              },

            );

            zoneToggle = true;
            _zonesList.add(listTile);
          });
        }
      });
    });
  }
}
