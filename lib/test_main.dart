import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puioio/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/automatic_rep_counter/optical_flow/optical_flow_calculator.dart';

final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();

  String pathPrefix = "assets/test/Squat/";

  List<String> videos = [
    "Squat1/",
    "Squat2/",
    "Squat3/",
    "Squat4/",
    "Squat8/",
    "Squat9/",
    "Squat15/",
    "Squat23/",
    "Squat25/"
  ];
  List<int> numFrames = [418, 293, 356, 215, 381, 695, 161, 447, 715];

  for (int i = 0; i < videos.length; i++) {
    print("FOR VIDEO: " + videos[i]);
    await testVideo(pathPrefix + videos[i], numFrames[i], directory);
  }
}

Future<void> testVideo(String path, int numImages, Directory directory) async {
  AutomaticRepCounter _repCounter =
      AutomaticRepCounter(exercise: SquatExercise());

  for (int i = 1; i <= numImages; i++) {
    if (i % 50 == 0) {
      print("Frame: " + i.toString());
    }

    String pathSuffix = i.toString().padLeft(4, '0');
    String imagePath = path + pathSuffix + ".jpg";

    final content = await rootBundle.load(imagePath);
    var file = File("${directory.path}/$pathSuffix.jpg");
    // await file.create();
    await file.writeAsBytes(content.buffer.asUint8List());

    InputImage _inputImage = InputImage.fromFilePath(file.path);
    List<Pose> _poses = await _poseDetector.processImage(_inputImage);
    _repCounter.updateRepCount(_poses, OpticalFlowDirection.none);
  }

  print("PATH: $path - number of reps: ${_repCounter.reps}");
}
