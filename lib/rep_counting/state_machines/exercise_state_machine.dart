import 'dart:collection';

import 'package:google_ml_kit_example/rep_counting/movement_phase.dart';
import 'package:google_ml_kit_example/rep_counting/state_machine_result.dart';

abstract class ExerciseStateMachine {
  static const _windowSize = 3;
  Enum currentState;
  final Queue<MovementPhase> _prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> _movementCounts = HashMap<MovementPhase, int>();

  ExerciseStateMachine(Enum this.currentState);

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult _movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase);

  StateMachineResult getStateMachineResult(MovementPhase latestPhase) {
    _prevMovementPhase.addLast(latestPhase);

    if (_prevMovementPhase.length <= _windowSize) {
      // insufficient values to safely detect movement phase. return.
      return StateMachineResult(false, false);
    }

    _prevMovementPhase.removeFirst();

    MovementPhase newAvgMvmtPhase = _getAvgMovementPhase();
    return _movementPhaseStateMachine(newAvgMvmtPhase);
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
