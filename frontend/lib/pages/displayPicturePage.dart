import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/pages/homePage.dart';
import 'package:frontend/provider/providerPattern.dart';
import 'package:provider/provider.dart';

import '../provider/gpsProvider.dart';

class DisplayPicturePage extends StatefulWidget {
  final String imagePath;
  final ProviderPattern provider;

  const DisplayPicturePage(
      {super.key, required this.imagePath, required this.provider});

  @override
  State<DisplayPicturePage> createState() => _DisplayPicturePageState();
}

class _DisplayPicturePageState extends State<DisplayPicturePage> {
  bool pictureReady = false;

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    var image = File(widget.imagePath);
    return Scaffold(
      appBar: AppBar(title: Text(widget.provider.getName())),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: pictureReady
          ? Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                autofocus: true,
                controller: emailController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    fillColor: Colors.white.withOpacity(0.3),
                    filled: true,
                    labelText: "E-Mail",
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () =>
                          submit(widget.imagePath, emailController.text),
                    )),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.refresh,
                    size: 50,
                  ),
                ),
                IconButton(
                  onPressed: () => usePicture(),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 50,
                  ),
                )
              ],
            ),
      body: Center(
        child: SingleChildScrollView(
          child: Image.file(
            image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  usePicture() {
    setState(() {
      pictureReady = true;
    });
  }

  submit(String imagePath, String email) async {
    if (email.isEmpty) {
      scaffoldMessage("Email-Adresse benötigt");
      return;
    }
    final position = await Provider.of<GPSProvider>(context, listen: false)
        .getCurrentLocation();
    if (position == null) {
      scaffoldMessage("Position konnte nicht abgerufen werden");
      return;
    }
    final String response =
        await widget.provider.submit(position, email, File(imagePath));
    if (response.isNotEmpty) {
      scaffoldMessage(response);
      return;
    }

    scaffoldMessage("Erfolgreich gesendet");

    Navigator.of(context).pushNamedAndRemoveUntil(HomePage.route,
            (route) => route.settings.name == HomePage.route);
  }

  void scaffoldMessage(String string) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          string,
          style: const TextStyle(color: Colors.amber),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.black54,
      ),
    );
  }
}
