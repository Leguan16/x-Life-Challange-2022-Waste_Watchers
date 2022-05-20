import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/addTrashCanPage.dart';
import 'package:frontend/pages/cameraPage.dart';
import 'package:frontend/pages/insertIpPage.dart';
import 'package:frontend/provider/gpsProvider.dart';
import 'package:frontend/provider/trashProvider.dart';
import 'package:frontend/pages/homePage.dart';
import 'package:frontend/provider/trashcanProvider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TrashProvider>(create: (_) => TrashProvider()),
        ChangeNotifierProvider<GPSProvider>(create: (_) => GPSProvider()),
        ChangeNotifierProvider<TrashCanProvider>(
            create: (_) => TrashCanProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          HomePage.route: (context) => const HomePage(),
          AddTrashcanPage.route: (context) => const AddTrashcanPage(),
          InsertIpPage.route: (context) => const InsertIpPage()
        },
        initialRoute: InsertIpPage.route,
      ),
    );
  }
}
