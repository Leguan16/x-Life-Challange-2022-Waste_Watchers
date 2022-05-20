import 'dart:io';

import 'package:latlong2/latlong.dart';

abstract class ProviderPattern{
  Future<String> submit(LatLng point, String email, File image);
  String getName();
}