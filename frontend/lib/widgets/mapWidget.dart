
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/provider/gpsProvider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../provider/trashcanProvider.dart';

class MapWidget extends StatelessWidget {
  final GPSProvider gpsProvider;

  const MapWidget(this.gpsProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trashcanProvider =
    Provider.of<TrashCanProvider>(context, listen: false);
    MapController mapController = MapController();
    return FutureBuilder(
      future: Provider.of<TrashCanProvider>(context, listen: false).loadTrashCans(Provider
        .of<GPSProvider>(context, listen: false)
        .getCurrentLocation),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        //if (snapshot.hasData) /*mapPoints.add(snapshot.data!)*/;
        if (snapshot.hasData) {
          final List<LatLng> mapPoints = trashcanProvider.getTrashCans();
          print(mapPoints);

          return FlutterMap(
            options: MapOptions(
              zoom: 16.0,
              center: gpsProvider.currentLocation,
            ),
            mapController: mapController,
            layers: [
              TileLayerOptions(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return const Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  for (var point in mapPoints) ...[
                    Marker(
                      width: 15.0,
                      height: 15.0,
                      point: point,
                      builder: (ctx) =>
                          Container(
                            decoration: BoxDecoration(
                                color: mapPoints.last != point
                                    ? Colors.red
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(60.0),
                                border:
                                Border.all(color: Colors.white, width: 1)),
                          ),
                    ),
                  ]
                ],
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
