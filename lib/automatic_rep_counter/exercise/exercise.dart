import 'movement_phase.dart';
import 'state_machines/exercise_state_machine.dart';
import 'state_machines/squat_state_machine.dart';
import 'state_machines/state_machine_result.dart';
import 'thresholds/squat_thresholds.dart';
import 'thresholds/thresholds.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class Exercise {
  final ExerciseStateMachine _exerciseStateMachine;
  final Thresholds _thresholds;

  Exercise(this._exerciseStateMachine, this._thresholds);

  Enum get currentState => _exerciseStateMachine.currentState;

  StateMachineResult updateStateMachine(Pose pose) {
    MovementPhase latestPhase = _thresholds.getMovementPhase(pose);
    return _exerciseStateMachine.getStateMachineResult(latestPhase);
  }
}

class SquatExercise extends Exercise {
  SquatExercise() : super(SquatStateMachine(), SquatThresholds());
}
