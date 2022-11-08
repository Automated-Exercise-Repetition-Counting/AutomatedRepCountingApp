import 'dart:collection';

import 'state_machine_result.dart';
import 'vertical_exercise_phase.dart';
import '../movement_phase.dart';
import '../../hyperparameters.dart';

abstract class ExerciseStateMachine {
  VerticalExercisePhase currentState;
  final Queue<MovementPhase> _prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> _movementCounts = HashMap<MovementPhase, int>();

  ExerciseStateMachine(this.currentState);

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase);

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
