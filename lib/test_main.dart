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

List<String> squatVideos = [
  // 'Squat1/',
  // 'Squat10/',
  // 'Squat11/',
  // 'Squat12/',
  // 'Squat13/',
  // 'Squat14/',
  // 'Squat15/',
  // 'Squat16/',
  // 'Squat17/',
  // 'Squat18/',
  // 'Squat19/',
  // 'Squat20/',
  // 'Squat21/',
  // 'Squat22/',
  // 'Squat23/',
  // 'Squat24/',
  // 'Squat25/',
  // 'Squat26/',
  // 'Squat27/',
  // 'Squat28/',
  // 'Squat29/',
  // 'Squat3/',
  // 'Squat30/',
  // 'Squat4/',
  'Squat5/',
  'Squat7/',
  'Squat8/',
  'Squat9/',
];

List<int> squatFrames = [
  // 418,
  // 93,
  // 302,
  // 219,
  // 445,
  // 480,
  // 192,
  // 314,
  // 115,
  // 697,
  // 1884,
  // 134,
  // 851,
  // 2147,
  // 447,
  // 215,
  // 716,
  // 1335,
  // 945,
  // 28,
  // 293,
  // 365,
  // 711,
  // 217,
  416,
  365,
  382,
  696,
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

  String pathPrefix = "assets/test/Squat/";

  final videos = squatVideos;
  final numFrames = squatFrames;

  for (int i = 0; i < videos.length; i++) {
    print("FOR VIDEO: " + videos[i]);
    await testVideo(pathPrefix + videos[i], numFrames[i], directory);
  }
}

Future<void> testVideo(String path, int numImages, Directory directory) async {
  AutomaticRepCounter _repCounter =
      AutomaticRepCounter(exercise: SquatExercise());

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
