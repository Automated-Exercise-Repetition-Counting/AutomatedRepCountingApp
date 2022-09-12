// import 'dart:math' show pi;
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// import '../joint.dart';
// import '../thresholds.dart';
// import '../../movement_phase.dart';
// import '../../../hyperparameters.dart';

// class PushUpThresholds extends Thresholds {
//   /// Internal angle of the hip, knee, and ankle
//   static const num _lowerThreshold = pushUpLowerAngle * (pi / 180);
//   static const num _upperThreshold = pushUpUpperAngle * (pi / 180);

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
//       return MovementPhase.top;
//     } else if (leftElbowAngle < _lowerThreshold &&
//         rightElbowAngle < _lowerThreshold) {
//       // bottom
//       return MovementPhase.bottom;
//     } else {
//       // intermediate
//       return MovementPhase.intermediate;
//     }
//   }
// }
