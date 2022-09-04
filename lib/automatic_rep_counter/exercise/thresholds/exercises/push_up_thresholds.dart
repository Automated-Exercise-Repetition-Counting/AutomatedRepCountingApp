import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../thresholds.dart';
import '../../movement_phase.dart';

class PushUpThresholds extends Thresholds {
  /// Internal angle of the hip, knee, and ankle
  static const num _lowerThreshold = 1.74533; // (100) * (pi / 180);
  static const num _upperThreshold = 2.61799; // (180-30) * (pi / 180);

  @override
  MovementPhase getMovementPhase(Pose pose) {
    List<num> elbowAngles = getAngles(pose);
    num leftElbowAngle = elbowAngles[0];
    num rightElbowAngle = elbowAngles[1];

    if (leftElbowAngle > _upperThreshold && rightElbowAngle > _upperThreshold) {
      // top
      return MovementPhase.top;
    } else if (leftElbowAngle < _lowerThreshold &&
        rightElbowAngle < _lowerThreshold) {
      // bottom
      return MovementPhase.bottom;
    } else {
      // intermediate
      return MovementPhase.intermediate;
    }
  }

  @override
  List<double> getAngles(Pose pose) {
    if (pose.landmarks.isEmpty) {
      throw Exception('No pose detected');
    }
    try {
      PoseLandmark leftElbow =
          pose.landmarks[PoseLandmarkType.leftElbow] as PoseLandmark;
      PoseLandmark rightElbow =
          pose.landmarks[PoseLandmarkType.rightElbow] as PoseLandmark;
      PoseLandmark leftWrist =
          pose.landmarks[PoseLandmarkType.leftWrist] as PoseLandmark;
      PoseLandmark rightWrist =
          pose.landmarks[PoseLandmarkType.rightWrist] as PoseLandmark;
      PoseLandmark leftShoulder =
          pose.landmarks[PoseLandmarkType.leftShoulder] as PoseLandmark;
      PoseLandmark rightShoulder =
          pose.landmarks[PoseLandmarkType.rightShoulder] as PoseLandmark;

      if (!confidenceCheck([
        leftElbow,
        rightElbow,
        leftWrist,
        rightWrist,
        leftShoulder,
        rightShoulder
      ])) {
        throw StateError('Pose confidence too low');
      }
      // Calculate the angle between the left hip, left knee, and left ankle
      double leftElbowAngle = lawOfCosines(leftElbow, leftShoulder, leftWrist);

      // Calculate the angle between the right hip, right knee, and right ankle
      double rightElbowAngle =
          lawOfCosines(rightElbow, rightShoulder, rightWrist);
      return [leftElbowAngle, rightElbowAngle];
    } on TypeError {
      throw StateError('Insufficient pose information');
    }
  }
}
