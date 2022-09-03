import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromRGBO(81, 191, 192, 1),
              secondary: const Color.fromRGBO(81, 191, 192, 0.3)),
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const HomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}
