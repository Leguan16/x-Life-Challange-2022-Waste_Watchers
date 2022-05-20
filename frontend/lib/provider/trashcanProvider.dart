import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/domain/API_URL.dart';
import 'package:frontend/provider/providerPattern.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../simplified_uri.dart';

class TrashCanProvider with ChangeNotifier, ProviderPattern {
  static final String URL = API_URL.getURL() + "/trashcans";

  List<LatLng> _trashCans =[];

  late LatLng currentLocation;

  Future<Response> postImage(File image, String email, LatLng point) async {
    final files = <http.MultipartFile>[];

    files.add(http.MultipartFile.fromBytes('image', image.readAsBytesSync(),
        filename: image.path));

    final request = http.MultipartRequest("POST", Uri.parse(URL));

    request.files.addAll(files);

    final Map<String, String> body = {
      "longitude": point.longitude.toString(),
      "latitude": point.latitude.toString(),
      "email": email
    };

    request.fields.addAll(body);

    var streamedResponse = await request.send();

    return await http.Response.fromStream(streamedResponse);
  }

  Future<String> loadCurrentLocation(Future<LatLng?> Function() getCurrentLocation) async {
    if(_trashCans.isNotEmpty) {
      Future.value("locations already fetched");
    }

    LatLng? possibleLocation = await getCurrentLocation();


    if(possibleLocation == null) {
      return Future.value("Location is null");
    }

    currentLocation = possibleLocation;

    return Future.value("Success");
  }

  Future<String> loadTrashCans(Future<LatLng?> Function() getCurrentLocation) async {
    final LatLng? latLng = await getCurrentLocation();
    if(latLng == null){
      return Future.value("Location is null");
    }
    final url = Uri.parse('$URL/trashcansByLocation?longitude=' +
        latLng.longitude.toString() +
        '&latitude=' +
        latLng.latitude.toString() +
        '&radius=1');

    try {

      print(url);
      final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

      final response = await http.get(url, headers: headers);

      if (response.body == "null") {
        return Future.value("couldn't find Trashcans");
      }

      var decode = jsonDecode(response.body) as List<dynamic>;

      decode.forEach((element) {
        _trashCans.add(LatLng(element['image']['latitude'], element['image']['longitude']));
      });

      _trashCans.add(latLng);
      notifyListeners();
      return Future.value("");
    } catch (error) {
      return Future.value("Error");
    }
  }

  List<LatLng> getTrashCans() {
    return _trashCans;
  }

  @override
  Future<String> submit(LatLng point, String email, File image) async{
    final resp = await postImage(image, email, point);
    print(resp.reasonPhrase);

    if (resp.statusCode == 200) {
      return Future.value("");
    }

    return Future.value(resp.body);
  }

  @override
  String getName() {
    return "Mülltonne hinzufügen";
  }


}
