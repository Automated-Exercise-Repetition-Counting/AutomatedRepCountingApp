// import 'dart:math' show pi;
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// import '../joint.dart';
// import '../thresholds.dart';
// import '../../movement_phase.dart';
// import '../../../hyperparameters.dart';

// class PullUpThresholds extends Thresholds {
//   /// Internal angle of the hip, knee, and ankle
//   static const num _lowerThreshold = pullUpLowerAngle * (pi / 180);
//   static const num _upperThreshold = pullUpLowerAngle * (pi / 180);

//   @override
//   MovementPhase getMovementPhase(Pose pose) {
//     double leftElbowAngle = Joint(
//             joint: PoseLandmarkType.leftElbow,
//             start: PoseLandmarkType.leftShoulder,
//             end: PoseLandmarkType.leftWrist,
//             pose: pose)
//         .angle;

//     double rightElbowAngle = Joint(
//             joint: PoseLandmarkType.rightElbow,
//             start: PoseLandmarkType.rightShoulder,
//             end: PoseLandmarkType.rightWrist,
//             pose: pose)
//         .angle;

//     if (leftElbowAngle > _upperThreshold && rightElbowAngle > _upperThreshold) {
//       // top
//       return MovementPhase.bottom;
//     } else if (leftElbowAngle < _lowerThreshold &&
//         rightElbowAngle < _lowerThreshold) {
//       // bottom
//       return MovementPhase.top;
//     } else {
//       // intermediate
//       return MovementPhase.intermediate;
//     }
//   }
// }
