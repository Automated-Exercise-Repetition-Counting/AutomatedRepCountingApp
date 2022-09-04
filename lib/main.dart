import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:google_ml_kit_example/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/exercise/exercise.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:google_ml_kit_example/vision_detector_views/pose_detector_view.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AutomaticRepCounter _repCounter;

  @override
  void initState() {
    super.initState();
  }

  void initRepCounter(Exercise exercise) {
    _repCounter = AutomaticRepCounter(exercise: exercise);
    _repCounter.addListener(() {
      setState(() {});
    });
  }

  void startNewActivity(Exercise exercise) {
    initRepCounter(exercise);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoseDetectorView(
          repCounter: _repCounter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google ML Kit Demo App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () => startNewActivity(SquatExercise()),
                  child: Text("Squats")),
              ElevatedButton(
                  onPressed: () => startNewActivity(PullUpExercise()),
                  child: Text("Pull Ups")),
              ElevatedButton(
                  onPressed: () => startNewActivity(PushUpExercise()),
                  child: Text("Push Ups")),
            ],
          ),
        ),
      ),
    );
  }
}
