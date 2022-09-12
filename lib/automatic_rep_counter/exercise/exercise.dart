import 'movement_phase.dart';
import 'state_machines/exercise_state_machine.dart';
import 'state_machines/state_machine_result.dart';
import 'thresholds/thresholds.dart';
import '../optical_flow/optical_flow_calculator.dart';

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class Exercise {
  final ExerciseStateMachine _exerciseStateMachine;
  final Thresholds _thresholds;

  Exercise(this._exerciseStateMachine, this._thresholds);

  Enum get currentState => _exerciseStateMachine.currentState;

  StateMachineResult updateStateMachine(
      Pose pose, OpticalFlowDirection flowDirection) {
    StateMachineResult result =
        StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    try {
      result = _updateStateMachinePose(pose, flowDirection);
    } on StateError {
      if (flowDirection != OpticalFlowDirection.none) {
        result = _updateStateMachineOF(flowDirection);
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
