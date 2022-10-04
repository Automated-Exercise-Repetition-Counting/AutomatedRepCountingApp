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

List<String> videos = [
  // // 'Pushup1/',
  // 'Pushup10/',
  // 'Pushup11/',
  // // 'Pushup12/',
  // 'Pushup13/',
  // 'Pushup14/',
  // 'Pushup15/',
  // 'Pushup16/',
  // 'Pushup17/',
  // 'Pushup18/',
  // 'Pushup19/',
  'Pushup2/',
  'Pushup20/',
  'Pushup21/',
  'Pushup22/',
  'Pushup23/',
  'Pushup24/',
  'Pushup25/',
  'Pushup26/',
  'Pushup27/',
  // 'Pushup28/',
  'Pushup29/',
  'Pushup3/',
  'Pushup30/',
  'Pushup4/',
  'Pushup5/',
  'Pushup6/',
  'Pushup7/',
  'Pushup8/',
  'Pushup9/',
];

List<int> frames = [
  // // 2187,
  // 884,
  // 355,
  // // 2477,
  // 106,
  // 471,
  // 138,
  // 864,
  // 280,
  // 288,
  // 744,
  370,
  408,
  725,
  252,
  867,
  327,
  529,
  859,
  854,
  // 6621,
  462,
  399,
  129,
  360,
  378,
  522,
  743,
  450,
  401,
];
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final directory = await getApplicationDocumentsDirectory();

//   String pathPrefix = "assets/test/Squat/";

//   String video = "Squat7/";

//   int numFrames = 364;

//   print("FOR VIDEO: " + video);
//   await testVideo(pathPrefix + video, numFrames, directory);
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();

  String pathPrefix = "assets/test/PushUps/";

  for (int i = 0; i < videos.length; i++) {
    print("FOR VIDEO: " + videos[i]);
    await testVideo(pathPrefix + videos[i], frames[i], directory);
  }
  print("DONE!");
}

Future<void> testVideo(String path, int numImages, Directory directory) async {
  AutomaticRepCounter _repCounter =
      AutomaticRepCounter(exercise: PushUpExercise());

  for (int i = 0; i < numImages; i++) {
    // if (i % 50 == 0) {
    //   print("Frame: " + i.toString());
    // }
    try {
      String pathSuffix = i.toString().padLeft(4, '0');
      String imagePath = path + pathSuffix + ".jpg";

      final content = await rootBundle.load(imagePath);
      var file = File("${directory.path}/$pathSuffix.jpg");
      // await file.create();
      await file.writeAsBytes(content.buffer.asUint8List());

      InputImage _inputImage = InputImage.fromFilePath(file.path);
      List<Pose> _poses = await _poseDetector.processImage(_inputImage);
      _repCounter.updateRepCount(_poses, OpticalFlowDirection.none);
    } on Exception {
      print("Error on frame: " + i.toString());
    }
  }

  print("PATH: $path - number of reps: ${_repCounter.reps}");
}
