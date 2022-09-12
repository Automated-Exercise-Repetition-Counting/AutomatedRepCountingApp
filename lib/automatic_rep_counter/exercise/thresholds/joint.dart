import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:vector_math/vector_math.dart';
import '../../hyperparameters.dart';

class Joint {
  late final PoseLandmark jointPoint;
  late final PoseLandmark startPoint;
  late final PoseLandmark endPoint;
  late final double _angle;
  late final Vector2 _startVector;
  late final Vector2 _endVector;

  double get angle => _angle;
  Vector2 get startVector => _startVector;
  Vector2 get endVector => _endVector;

  Joint(
      {required PoseLandmarkType joint,
      required PoseLandmarkType start,
      required PoseLandmarkType end,
      required Pose pose}) {
    jointPoint = _convertToPoseLandmark(joint, pose);
    startPoint = _convertToPoseLandmark(start, pose);
    endPoint = _convertToPoseLandmark(end, pose);

    _startVector =
        Vector2(jointPoint.x - startPoint.x, jointPoint.y - startPoint.y);
    _endVector = Vector2(jointPoint.x - endPoint.x, jointPoint.y - endPoint.y);
    _angle = _getAngle();
  }

  double _getAngle() {
    // calculate angle between vectors
    return acos(
        startVector.dot(endVector) / (startVector.length * endVector.length));
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

  /// Checks the confidence is above the [minLikelihood] threshold
  /// for the given landmark.
  bool _confidenceCheck(PoseLandmark landmark) {
    return landmark.likelihood >= minPoseLikelihoodPD;
  }
}
