import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/provider/trashProvider.dart';
import 'package:frontend/widgets/cameraWidget.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CameraDescription>(
        future: initCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final trashProvider = Provider.of<TrashProvider>(context, listen: false);
          return snapshot.hasData
              ? CameraWidget(camera: snapshot.data as CameraDescription, title: "Müll Scannen", provider: trashProvider)
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Future<CameraDescription> initCameras() async {
    final cameras = await availableCameras();
    return cameras[0];
  }
}
