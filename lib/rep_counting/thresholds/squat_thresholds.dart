import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'thresholds.dart';
import '../movement_phase.dart';

class SquatThresholds extends Thresholds {
  /// Internal angle of the hip, knee, and ankle
  static const num _lowerThreshold = 1.91986; // (180 - 70) * (pi / 180);
  static const num _upperThreshold = 2.61799; // (180-30) * (pi / 180);

  @override
  MovementPhase getMovementPhase(Pose pose) {
    List<num> kneeAngles = getAngles(pose);
    num leftKneeAngle = kneeAngles[0];
    num rightKneeAngle = kneeAngles[1];

    if (leftKneeAngle > _upperThreshold && rightKneeAngle > _upperThreshold) {
      // top
      return MovementPhase.top;
    } else if (leftKneeAngle < _lowerThreshold &&
        rightKneeAngle < _lowerThreshold) {
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
      PoseLandmark leftKnee =
          pose.landmarks[PoseLandmarkType.leftKnee] as PoseLandmark;
      PoseLandmark rightKnee =
          pose.landmarks[PoseLandmarkType.rightKnee] as PoseLandmark;
      PoseLandmark leftAnkle =
          pose.landmarks[PoseLandmarkType.leftAnkle] as PoseLandmark;
      PoseLandmark rightAnkle =
          pose.landmarks[PoseLandmarkType.rightAnkle] as PoseLandmark;
      PoseLandmark leftHip =
          pose.landmarks[PoseLandmarkType.leftHip] as PoseLandmark;
      PoseLandmark rightHip =
          pose.landmarks[PoseLandmarkType.rightHip] as PoseLandmark;

      if (!confidenceCheck(
          [leftKnee, rightKnee, leftAnkle, rightAnkle, leftHip, rightHip])) {
        throw StateError('Pose confidence too low');
      }
      // Calculate the angle between the left hip, left knee, and left ankle
      double leftHipKneeAnkleAngle = lawOfCosines(leftKnee, leftHip, leftAnkle);

      // Calculate the angle between the right hip, right knee, and right ankle
      double rightHipKneeAnkleAngle =
          lawOfCosines(rightKnee, rightHip, rightAnkle);
      return [leftHipKneeAnkleAngle, rightHipKneeAnkleAngle];
    } on TypeError {
      throw StateError('Insufficient pose information');
    }
  }
}
