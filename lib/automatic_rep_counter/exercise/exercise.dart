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
    StateMachineResult result =
        StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    try {
      result = _updateStateMachinePose(pose, flowDirection);
      _unconfidenceCount = 0;
    } on StateError {
      if (_unconfidenceCount > switchToOFThreshold &&
          flowDirection != OpticalFlowDirection.none) {
        result = _updateStateMachineOF(flowDirection);
        _unconfidenceCount = 0;
      } else {
        _unconfidenceCount++;
      }
    }
    return result;
  }

  StateMachineResult _updateStateMachinePose(
      Pose pose, OpticalFlowDirection flowDirection) {
    MovementPhase latestPhase = _thresholds.getMovementPhase(pose);
    StateMachineResult result =
        _exerciseStateMachine.getStateMachineResultPD(latestPhase);
    _exerciseStateMachine.opticalFlowDirection = flowDirection;
    return result;
  }

  StateMachineResult _updateStateMachineOF(OpticalFlowDirection direction) {
    return _exerciseStateMachine.getStateMachineResultOF(direction);
  }
}
