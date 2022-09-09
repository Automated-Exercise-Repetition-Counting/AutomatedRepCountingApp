import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../movement_phase.dart';

abstract class Thresholds {
  // Minimum likelihood of a keypoint being in the image
  static const double minLikelihood = 0.9;

  /// Returns the movement phase of the current frame based on the detections.
  MovementPhase getMovementPhase(Pose pose);
}
