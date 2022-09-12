import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../movement_phase.dart';

abstract class Thresholds {
  /// Returns the movement phase of the current frame based on the detections.
  MovementPhase getMovementPhase(Pose pose);

  void checkForJumping();
}
