import 'dart:math';

import 'package:google_ml_kit_example/rep_counting/movement_phase.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Thresholds {
  /// Internal angle of the hip, knee, and ankle
  static const num _lowerThreshold = 1.91986; // (180 - 70) * (pi / 180);
  static const num _upperThreshold = 2.61799; // (180-30) * (pi / 180);

  static const double _minConfidence = 0.5;

  /// Returns the movement phase of the current frame based on the detections.
  static MovementPhase thresholdSquat(Pose pose) {
    List<num> kneeAngles = _squatAngles(pose);
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

  /// Returns the angles of the left and right knees,
  /// in the format [leftKneeAngle, rightKneeAngle].
  /// Throws an error if the pose is invalid.
  static List<double> _squatAngles(Pose pose) {
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

      if (!_confidenceCheck(
          [leftKnee, rightKnee, leftAnkle, rightAnkle, leftHip, rightHip])) {
        throw StateError('Pose confidence too low');
      }
      // Calculate the angle between the left hip, left knee, and left ankle
      double leftHipKneeAnkleAngle =
          _lawOfCosines(leftKnee, leftHip, leftAnkle);

      // Calculate the angle between the right hip, right knee, and right ankle
      double rightHipKneeAnkleAngle =
          _lawOfCosines(rightKnee, rightHip, rightAnkle);
      return [leftHipKneeAnkleAngle, rightHipKneeAnkleAngle];
    } on TypeError {
      throw StateError('Insufficient pose information');
    }
  }

  /// Checks the confidence is above the [_minConfidence] threshold
  static bool _confidenceCheck(List<PoseLandmark> landmarks) {
    for (PoseLandmark landmark in landmarks) {
      if (landmark.likelihood < _minConfidence) {
        return false;
      }
    }
    return true;
  }

  /// Calculates the angle between three points,
  /// as per https://stackoverflow.com/a/1211243/16521305
  static double _lawOfCosines(
      PoseLandmark middlePose, PoseLandmark endPose, PoseLandmark endPose2) {
    double p12 = _distanceBetweenPoints(
        middlePose.x, middlePose.y, endPose.x, endPose.y);
    double p13 = _distanceBetweenPoints(
        middlePose.x, middlePose.y, endPose2.x, endPose2.y);
    double p23 =
        _distanceBetweenPoints(endPose.x, endPose.y, endPose2.x, endPose2.y);

    // returns the dot product of the two vectors
    num numerator = pow(p12, 2) + pow(p13, 2) - pow(p23, 2);
    double denominator = 2 * p12 * p13;

    return acos(numerator / denominator);
  }

  /// Calculates the distance between two points.
  static double _distanceBetweenPoints(x1, y1, x2, y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
}
