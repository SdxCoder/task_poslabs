import 'dart:async';

import 'package:client/core/core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:stacked/stacked.dart';

/*
 * @class   HomeViewModel
 * @extends BaseViewModel
 * @desc    This is a model class to manage state of map
 */
class HomeViewModel extends BaseViewModel {
  // dependency injection
  final _notificationService = Modular.get<PushNotificationsService>();
  final _locationService = Modular.get<LocationService>();

  // Route to be drawn on the map
  List<LatLng> _route = [
    LatLng(36.1699, -115.1398),
    LatLng(39.3210, -111.0937),
    LatLng(39.5501, -105.7821),
    LatLng(41.4925, -99.9018),
    LatLng(41.8780, -93.0977),
    LatLng(41.8781, -87.6298),
    LatLng(42.3314, -83.0458),
    LatLng(40.4173, -82.9071),
    LatLng(38.5976, -80.4549),
    LatLng(38.9072, -77.0369),
    LatLng(37.5407, -77.4360),
    LatLng(35.7796, -78.6382),
  ];

  // Route completed so far
  List<LatLng> _routeCovered = [];
  List<LatLng> get routeCovered => _routeCovered;

  Position _position;
  Position get position => _position;

  Timer _timer;
  int _index = 0;

  StreamController<LatLng> _currentPosition = StreamController<LatLng>();
  Stream<LatLng> get currentPosition => _currentPosition.stream;

  /*
   * @desc Consume location service to get current location of device. 
   */
  Future getCurrentLocation() async {
    setBusy(true);
    if (await _locationService.checkLocationService() == false) {
      Future.delayed(Duration(milliseconds: 1));
      await showDialogBox(
          title: "Location", description: "Please turn on location");
    }

      
      _position = await _locationService.getCurrentLocation();
      setBusy(false);
  }

  /*
   * @desc Draws route on the map from las vegas to raleigh,
   *       Updates the current position and route covered every 2 seconds 
   */
  Future navigateOnRoute() async {
    // Show notification that route drawing started.

    _notificationService.showNotification(
        title: "Route Status", body: "Route started");

    // Add device current location geo-point in currentPosition stream as entry point of route.
    _currentPosition.sink.add(LatLng(_position.latitude, _position.longitude));
    _routeCovered.add(LatLng(_position.latitude, _position.longitude));

    /// Adds next geo-point from [_route]  to [_routeCovered] every 2 seconds.
    /// And updates [_currentPosition] stream with latest added geo-point.
    _timer = Timer.periodic(Duration(seconds: 2), (v) {
      _routeCovered.add(_route[_index]);
      _currentPosition.sink.add(_route[_index]);

      /// if [_routeCovered] has all the geo-points added from [_route] excluding entry point.
      /// Then cancel timer and push notification.
      if (_routeCovered.length - 1 < _route.length) {
        _index++;
      } else {
        _timer.cancel();
        // Show notification that route completed.
        _notificationService.showNotification(
            title: "Route Status", body: "Route completed");
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    _currentPosition.close();
    super.dispose();
  }
}
