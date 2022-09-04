import 'dart:math';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../movement_phase.dart';

abstract class Thresholds {
  static const double _minConfidence = 0.5;

  /// Returns the movement phase of the current frame based on the detections.
  MovementPhase getMovementPhase(Pose pose);

  /// Returns the angles of the left and right knees,
  /// in the format [leftKneeAngle, rightKneeAngle].
  /// Throws an error if the pose is invalid.
  List<double> getAngles(Pose pose);

  /// Checks the confidence is above the [_minConfidence] threshold
  bool confidenceCheck(List<PoseLandmark> landmarks) {
    for (PoseLandmark landmark in landmarks) {
      if (landmark.likelihood < _minConfidence) {
        return false;
      }
    }
    return true;
  }

  /// Calculates the angle between three points,
  /// as per https://stackoverflow.com/a/1211243/16521305
  double lawOfCosines(
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
