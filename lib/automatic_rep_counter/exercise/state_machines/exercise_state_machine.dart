import 'dart:collection';

import 'state_machine_result.dart';
import 'vertical_exercise_phase.dart';
import '../movement_phase.dart';
import '../../hyperparameters.dart';
import '../../optical_flow/optical_flow_calculator.dart';

abstract class ExerciseStateMachine {
  VerticalExercisePhase currentState;
  final Queue<MovementPhase> _prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> _movementCounts = HashMap<MovementPhase, int>();
  OpticalFlowDirection _prevDirection = OpticalFlowDirection.none;

  ExerciseStateMachine(this.currentState);

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase);

  set opticalFlowDirection(OpticalFlowDirection direction) {
    _prevDirection = direction;
  }

  StateMachineResult getStateMachineResultOF(
      OpticalFlowDirection opticalFlowDirection) {
    StateMachineResult result =
        StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    switch (opticalFlowDirection) {
      case OpticalFlowDirection.up:
        if ((_prevDirection == OpticalFlowDirection.stationary ||
                    _prevDirection == OpticalFlowDirection.up) &&
                currentState == VerticalExercisePhase.bottom ||
            currentState == VerticalExercisePhase.asc) {
          result = movementPhaseStateMachine(MovementPhase.intermediate);
        }
        break;
      case OpticalFlowDirection.down:
        if ((_prevDirection == OpticalFlowDirection.stationary ||
                    _prevDirection == OpticalFlowDirection.down) &&
                currentState == VerticalExercisePhase.top ||
            currentState == VerticalExercisePhase.desc) {
          result = movementPhaseStateMachine(MovementPhase.intermediate);
        }
        break;
      case OpticalFlowDirection.stationary:
        bool atBottom = currentState == VerticalExercisePhase.desc &&
                (_prevDirection == OpticalFlowDirection.down ||
                    _prevDirection == OpticalFlowDirection.stationary) ||
            currentState == VerticalExercisePhase.bottom;
        bool atTop = currentState == VerticalExercisePhase.asc &&
                (_prevDirection == OpticalFlowDirection.up ||
                    _prevDirection == OpticalFlowDirection.stationary) ||
            currentState == VerticalExercisePhase.top;

        if (atBottom) {
          result = movementPhaseStateMachine(MovementPhase.bottom);
        } else if (atTop) {
          result = movementPhaseStateMachine(MovementPhase.top);
        }
        break;
      default:
        break;
    }
    _prevDirection = opticalFlowDirection;
    return result;
  }

  StateMachineResult getStateMachineResultPD(MovementPhase latestPhase) {
    _prevMovementPhase.addLast(latestPhase);

    if (_prevMovementPhase.length <= windowSizePD) {
      // insufficient values to safely detect movement phase. return.
      return StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    }

    _prevMovementPhase.removeFirst();

    MovementPhase newAvgMvmtPhase = _getAvgMovementPhase();
    return movementPhaseStateMachine(newAvgMvmtPhase);
  }

  MovementPhase _getAvgMovementPhase() {
    _movementCounts.clear();
    for (var phase in _prevMovementPhase) {
      _movementCounts[phase] = _movementCounts[phase] ?? 0 + 1;
    }

    // return the movement phase with the max count
    return _movementCounts.entries
        .reduce((e1, e2) => e1.value > e2.value ? e1 : e2)
        .key;
  }
}
