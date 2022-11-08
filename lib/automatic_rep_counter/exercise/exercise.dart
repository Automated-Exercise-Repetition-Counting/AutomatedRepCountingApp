import 'movement_phase.dart';
import 'state_machines/exercise_state_machine.dart';
import 'state_machines/state_machine_result.dart';
import 'thresholds/thresholds.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class Exercise {
  final ExerciseStateMachine _exerciseStateMachine;
  final Thresholds _thresholds;
  final String _name = "";

  Exercise(this._exerciseStateMachine, this._thresholds);

  Enum get currentState => _exerciseStateMachine.currentState;
  String get name => _name;

  bool checkInFrame(Pose pose) {
    try {
      _thresholds.getMovementPhase(pose);
      return true;
    } on StateError {
      return false;
    }
  }

  StateMachineResult updateStateMachinePose(Pose pose) {
    MovementPhase latestPhase = _thresholds.getMovementPhase(pose);
    StateMachineResult result =
        _exerciseStateMachine.getStateMachineResultPD(latestPhase);
    return result;
  }
}
