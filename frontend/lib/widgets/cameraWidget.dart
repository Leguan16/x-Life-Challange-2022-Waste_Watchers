import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/provider/providerPattern.dart';

import '../pages/displayPicturePage.dart';

class CameraWidget extends StatefulWidget {

  const CameraWidget({
    super.key,
    required this.camera,
    required this.title,
    required this.provider,
  });

  final CameraDescription camera;
  final String title;
  final ProviderPattern provider;

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withAlpha(0),
        elevation: 0,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPicturePage(
                  imagePath: image.path,
                  provider: widget.provider,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(
          Icons.circle_outlined,
          size: 60,
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(_controller.resolutionPreset.toString());
            final scale = 1 /
                (_controller.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio);
            return Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: CameraPreview(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
