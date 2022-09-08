import 'dart:collection';

import './vertical_exercise_phase.dart';
import '../movement_phase.dart';
import 'state_machine_result.dart';

abstract class ExerciseStateMachine {
  static const _windowSize = 3;
  VerticalExercisePhase currentState;
  final Queue<MovementPhase> _prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> _movementCounts = HashMap<MovementPhase, int>();

  ExerciseStateMachine(this.currentState);

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase);

  StateMachineResult getStateMachineResult(MovementPhase latestPhase) {
    _prevMovementPhase.addLast(latestPhase);

    if (_prevMovementPhase.length <= _windowSize) {
      // insufficient values to safely detect movement phase. return.
      return StateMachineResult(false, false);
    }

    _prevMovementPhase.removeFirst();

    MovementPhase newAvgMvmtPhase = _getAvgMovementPhase();
    return movementPhaseStateMachine(newAvgMvmtPhase);
  }

  MovementPhase _getAvgMovementPhase() {
    _movementCounts.clear();
    _prevMovementPhase.forEach((phase) {
      _movementCounts[phase] = _movementCounts[phase] ?? 0 + 1;
    });

    // return the movement phase with the max count
    return _movementCounts.entries
        .reduce((e1, e2) => e1.value > e2.value ? e1 : e2)
        .key;
  }
}
