import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class FlutterMapWidget extends StatefulWidget {

  FlutterMapWidgetState _state;

  FlutterMapWidgetState get state => _state;

  @override
  FlutterMapWidgetState createState() {

    _state = FlutterMapWidgetState();

    return _state;
  }


}

class FlutterMapWidgetState extends State<FlutterMapWidget> with TickerProviderStateMixin{

  MapController mapController;
  List<Marker> stateMarkers = List();
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  updateMarkers(markers,pos,zoom){
    setState(() {
      stateMarkers.clear();
      stateMarkers.addAll(markers);
    });

    _animatedMapMove(pos, zoom);
  }
  
  moveCamera(){
    mapController.move(LatLng(48.856614,  2.3522219), 12);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          zoom: 14, //48.864716, 2.349014 Paris
          center: LatLng(
              48.864716, 2.349014 ),

        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
            "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
              DotEnv().env['MapBoxApiKey'],
              'id': 'mapbox.streets',
            },
          ),
          MarkerLayerOptions(
            markers: stateMarkers,
          ),
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = new Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = new Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween =
    new Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a new animation controller that has a duration and a TickerProvider.
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      // Note that the mapController.move doesn't seem to like the zoom animation. This may be a bug in flutter_map.
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      print("$status");
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
