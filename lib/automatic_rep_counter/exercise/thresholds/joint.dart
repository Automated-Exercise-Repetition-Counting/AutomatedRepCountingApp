import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'thresholds.dart';

class Joint {
  late final PoseLandmark jointPoint;
  late final PoseLandmark startPoint;
  late final PoseLandmark endPoint;
  late final double _angle;

  double get angle => _angle;

  Joint(
      {required PoseLandmarkType joint,
      required PoseLandmarkType start,
      required PoseLandmarkType end,
      required Pose pose}) {
    this.jointPoint = _convertToPoseLandmark(joint, pose);
    this.startPoint = _convertToPoseLandmark(start, pose);
    this.endPoint = _convertToPoseLandmark(end, pose);
    _angle = _getAngle();
  }

  /// Calculates the angle between three points,
  /// as per https://stackoverflow.com/a/1211243/16521305
  double _getAngle() {
    double p12 = _distanceBetweenPoints(
        jointPoint.x, jointPoint.y, startPoint.x, startPoint.y);
    double p13 = _distanceBetweenPoints(
        jointPoint.x, jointPoint.y, endPoint.x, endPoint.y);
    double p23 = _distanceBetweenPoints(
        startPoint.x, startPoint.y, endPoint.x, endPoint.y);

    // returns the dot product of the two vectors
    num numerator = pow(p12, 2) + pow(p13, 2) - pow(p23, 2);
    double denominator = 2 * p12 * p13;

    return acos(numerator / denominator);
  }

  /// Calculates the distance between two points.
  double _distanceBetweenPoints(x1, y1, x2, y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  /// Converts a PoseLandmarkType to a PoseLandmark.
  PoseLandmark _convertToPoseLandmark(PoseLandmarkType type, Pose pose) {
    try {
      PoseLandmark landmark = pose.landmarks[type] as PoseLandmark;
      if (!_confidenceCheck(landmark)) {
        throw StateError('Pose confidence too low');
      }
      return landmark;
    } on TypeError {
      throw StateError('Insufficient pose information');
    }
  }

  /// Checks the confidence is above the [minConfidence] threshold
  /// for the given landmark.
  bool _confidenceCheck(PoseLandmark landmark) {
    return landmark.likelihood >= Thresholds.minConfidence;
  }
}
