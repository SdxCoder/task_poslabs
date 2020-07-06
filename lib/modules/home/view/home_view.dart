import 'package:client/core/shared_service/auth_service.dart';
import 'package:client/modules/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong/latlong.dart';

import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async => await model.getCurrentLocation(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
          actions: [
            IconButton(
              icon: Icon(FontAwesome.sign_out),
              onPressed: () {
                Modular.get<AuthService>().signOut();
              },
            )
          ],
        ),
        body:model.isBusy ? Offstage(): Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child:  FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center:   LatLng(model.position.latitude, model.position.longitude),
                    zoom: 5.0,
                    
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      tileProvider: NonCachingNetworkTileProvider(),
                    ),
                     MarkerLayerOptions(
                       markers: [
                       Marker(
                         width: 16,
                         height: 30,
                         point: LatLng(model.position.latitude, model.position.longitude),
                        builder: (context){
                          return Icon(FontAwesome.map_marker, color: Colors.red,);
                        }
                       ),
                       
                     ]),
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                            points: model.routeCovered,
                            strokeWidth: 4.0,
                            color: Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(children: [
                RaisedButton(
                  child: Text('Start route'),
                  onPressed: ()async {
                   await model.navigateOnRoute();
                    model.currentPosition.listen((currentPosition) {
                      _animatedMapMove(currentPosition, 5);
                     });
                  },
                ),
                 RaisedButton(
                  child: Text('fingure'),
                  onPressed: ()async {
                    Modular.get<AuthService>().authenticateWithTouchID();
                  },
                ),
             
              ])
            ],
          ),
        ),
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
