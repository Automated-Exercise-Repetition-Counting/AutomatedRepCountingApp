import 'dart:math' show pi;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../joint.dart';
import '../thresholds.dart';
import '../../movement_phase.dart';
import '../../../hyperparameters.dart';

class SquatThresholds extends Thresholds {
  /// Internal angle of the hip, knee, and ankle
  static const num _lowerThreshold = squatLowerAngle * (pi / 180);
  static const num _upperThreshold = squatUpperAngle * (pi / 180);

  @override
  MovementPhase getMovementPhase(Pose pose) {
    double leftKneeAngle = Joint(
            joint: PoseLandmarkType.leftKnee,
            start: PoseLandmarkType.leftHip,
            end: PoseLandmarkType.leftAnkle,
            pose: pose)
        .angle;

    double rightKneeAngle = Joint(
            joint: PoseLandmarkType.rightKnee,
            start: PoseLandmarkType.rightHip,
            end: PoseLandmarkType.rightAnkle,
            pose: pose)
        .angle;

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
}
