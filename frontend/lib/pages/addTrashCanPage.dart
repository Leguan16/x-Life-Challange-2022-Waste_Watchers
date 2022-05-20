import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/provider/trashcanProvider.dart';
import 'package:provider/provider.dart';

import '../widgets/cameraWidget.dart';

class AddTrashcanPage extends StatelessWidget {
  const AddTrashcanPage({Key? key}) : super(key: key);
  static final String route = "/add-trash-can-page";

  @override
  Widget build(BuildContext context) {
    final trashCanProvider = Provider.of<TrashCanProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<CameraDescription>(
        future: initCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return snapshot.hasData
              ? CameraWidget(camera: snapshot.data as CameraDescription, title: "Mülltonne hinzufügen", provider: trashCanProvider)
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
