import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/pages/addTrashCanPage.dart';
import 'package:frontend/provider/gpsProvider.dart';
import 'package:frontend/provider/trashcanProvider.dart';
import 'package:frontend/widgets/mapWidget.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final gpsProvider = Provider.of<GPSProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addTrashCan(),
      ),
      body: MapWidget(gpsProvider),
    );
  }

  addTrashCan() {
    Navigator.pushNamed(context, AddTrashcanPage.route);
  }
}
