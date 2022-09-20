import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/home_nav.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromRGBO(81, 191, 192, 1),
              secondary: const Color.fromRGBO(216, 238, 238, 1),
              tertiary: const Color.fromRGBO(0, 141, 141, 1),
              background: const Color.fromARGB(255, 240, 240, 240)),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const HomeNav(),
      debugShowCheckedModeBanner: false,
    );
  }
}
