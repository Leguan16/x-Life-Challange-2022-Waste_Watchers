import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class GPSProvider with ChangeNotifier {
  bool loading = false;

  final Location _location = Location();
  LatLng? currentLocation;

  Future<LatLng?> getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    var location = await _location.getLocation();
    currentLocation = LatLng(location.latitude as double, location.longitude as double);
    print(location.latitude.toString() + " " + location.longitude.toString());
    return currentLocation;
  }
}
