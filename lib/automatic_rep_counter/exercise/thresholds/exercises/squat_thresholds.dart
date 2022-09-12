import 'dart:developer';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:vector_math/vector_math.dart';

import '../joint.dart';
import '../thresholds.dart';
import '../../movement_phase.dart';
import '../../../hyperparameters.dart';

class SquatThresholds extends Thresholds {
  /// Internal angle of the hip, knee, and ankle
  static const num _lowerThreshold = squatLowerAngle * degrees2Radians;
  static const num _upperThreshold = squatUpperAngle * degrees2Radians;
  late Joint _leftKnee;
  late Joint _rightKnee;
  Joint? _prevLeftKnee;
  Joint? _prevRightKnee;

  @override
  MovementPhase getMovementPhase(Pose pose) {
    _leftKnee = Joint(
        joint: PoseLandmarkType.leftKnee,
        start: PoseLandmarkType.leftHip,
        end: PoseLandmarkType.leftAnkle,
        pose: pose);
    double leftKneeAngle = _leftKnee.angle;

    _rightKnee = Joint(
        joint: PoseLandmarkType.rightKnee,
        start: PoseLandmarkType.rightHip,
        end: PoseLandmarkType.rightAnkle,
        pose: pose);
    double rightKneeAngle = _rightKnee.angle;

    if (_prevLeftKnee == null || _prevRightKnee == null) {
      _prevLeftKnee = _leftKnee;
      _prevRightKnee = _rightKnee;
      return MovementPhase.top;
    }

    checkForJumping();

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
  void checkForJumping() {
    double leftDistance =
        (_leftKnee.startVector - _prevLeftKnee!.startVector).length;
    double rightDistance =
        (_rightKnee.startVector - _prevRightKnee!.startVector).length;

    if (leftDistance > jumpThresholdPD || rightDistance > jumpThresholdPD) {
      log("Jumping detected with LD: $leftDistance, RD: $rightDistance");
      throw StateError('Jumping detected');
    }
  }
}
