import 'dart:convert';
import 'dart:io';
//import 'dart:js_util/js_util_wasm.dart';

import 'package:flutter/material.dart';
import 'package:frontend/provider/providerPattern.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../domain/API_URL.dart';

class TrashProvider with ChangeNotifier, ProviderPattern{
  static final String URL = API_URL.getURL() + "/scan";


  @override
  Future<String> submit(LatLng point, String email, File image) async{
    final resp = await postImage(image, email, point);

    if (resp.statusCode == 200) {
      return Future.value("");
    }

    return Future.value(resp.body);
  }

  Future<Response> postImage(File image, String email, LatLng point) async {
    final files = <http.MultipartFile>[];

    final url = URL + "?latitude=" + point.latitude.toString() + "&longitude=" + point.longitude.toString() + "&email=" + email;

    files.add(http.MultipartFile.fromBytes('image', image.readAsBytesSync(),
        filename: image.path));

    final request = http.MultipartRequest("POST", Uri.parse(url));

    request.files.addAll(files);

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);
    print(response);
    return response;
  }

  @override
  String getName() {
    return "Müll melden";
  }

}