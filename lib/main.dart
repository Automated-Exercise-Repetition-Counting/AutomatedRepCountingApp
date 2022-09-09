import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:native_opencv/native_opencv.dart';
import 'package:puioio/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/vision_detector_views/pose_detector_view.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AutomaticRepCounter _repCounter;

  final nativeOpenCv = NativeOpencv();

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
        title: const Text('Google ML Kit Demo App'),
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
                  child: const Text("Squats")),
              ElevatedButton(
                  onPressed: () => startNewActivity(PullUpExercise()),
                  child: const Text("Pull Ups")),
              ElevatedButton(
                  onPressed: () => startNewActivity(PushUpExercise()),
                  child: const Text("Push Ups")),
              ElevatedButton(
                  onPressed: () =>
                      log('--> OpenCV Version: ${nativeOpenCv.cvVersion()}'),
                  child: const Text("OpenCV")),
            ],
          ),
        ),
      ),
    );
  }
}
