import 'package:flutter/material.dart';
import 'package:frontend/domain/API_URL.dart';
import 'package:frontend/pages/homePage.dart';

class InsertIpPage extends StatelessWidget {
  const InsertIpPage({Key? key}) : super(key: key);
  static final String route = "/insert_IP_Page";

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey();
    TextEditingController ipController = TextEditingController();
    TextEditingController portController = TextEditingController();
    var ipRegEx = RegExp("^(?:[0-9]{1,3}\.){3}[0-9]{1,3}");
    return Scaffold(
      key: key,
      appBar: AppBar(title: Text("IP Adresse und Port des Servers eingeben")),
      body: Form(
          child: Column(
        children: [
          TextFormField(
            controller: ipController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "IP",
            ),
          ),
          TextFormField(
            controller: portController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Port"),
          ),
          ElevatedButton(
            onPressed: () {
              var ip = ipController.text;
              var port = int.tryParse(portController.text);

              if (ip.isEmpty) {
                scaffoldMessage(context, 'Keine IP Adresse');
                return;
              }

              if (port == null) {
                scaffoldMessage(context, 'Kein Port');
                return;
              }

              print(port);

              if(port < 1 && port > 65535) {
                scaffoldMessage(context, 'Falscher Port: ${portController.text}');
                return;
              }

              if (ipRegEx.hasMatch(ip)) {
                API_URL.setUrl(ip, port);
                Navigator.of(context).popAndPushNamed(HomePage.route);
              } else {
                scaffoldMessage(context, 'Falsche IP Adresse: ${ip}');
                return;
              }
            },
            child: Text("Speichern"),
          )
        ],
      )),
    );
  }
}

void scaffoldMessage(BuildContext context, String string) {
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
