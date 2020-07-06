

import 'package:geolocator/geolocator.dart';

/*
  * @class LocationService
  * @desc  This class holds functions to handle device location services.
*/
class LocationService{
  final _geolocator = Geolocator();

  /*
   * @desc  Returns current location of device.
   * @returns position - a Position object representing current location of device.
   */
  Future<Position> getCurrentLocation() {
    return  _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
  }

   /*
   * @desc  Returns status of location service of device.
   * @returns true, if location service is on, and false if its off.
   */
  Future<bool> checkLocationService() async {

    return await _geolocator.isLocationServiceEnabled();
  }
}