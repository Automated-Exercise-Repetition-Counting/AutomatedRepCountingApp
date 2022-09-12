import 'movement_phase.dart';
import 'state_machines/exercise_state_machine.dart';
import 'state_machines/state_machine_result.dart';
import 'thresholds/thresholds.dart';
import '../optical_flow/optical_flow_calculator.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../hyperparameters.dart';

abstract class Exercise {
  final ExerciseStateMachine _exerciseStateMachine;
  final Thresholds _thresholds;
  int _unconfidenceCount = 0;

  Exercise(this._exerciseStateMachine, this._thresholds);

  Enum get currentState => _exerciseStateMachine.currentState;

  StateMachineResult updateStateMachine(
      Pose pose, OpticalFlowDirection flowDirection) {
    StateMachineResult result = StateMachineResult(false, false);
    try {
      result = updateStateMachinePose(pose);
      _unconfidenceCount = 0;
    } on StateError {
      if (_unconfidenceCount > switchToOFThreshold &&
          flowDirection != OpticalFlowDirection.none) {
        result = updateStateMachineOF(flowDirection);
        _unconfidenceCount = 0;
      }
      _unconfidenceCount++;
    }
    return result;
  }

  StateMachineResult updateStateMachinePose(Pose pose) {
    MovementPhase latestPhase = _thresholds.getMovementPhase(pose);
    return _exerciseStateMachine.getStateMachineResultPD(latestPhase);
  }

  StateMachineResult updateStateMachineOF(OpticalFlowDirection direction) {
    return _exerciseStateMachine.getStateMachineResultOF(direction);
  }
}
