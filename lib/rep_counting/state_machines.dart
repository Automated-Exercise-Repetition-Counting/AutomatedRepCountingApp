import 'package:google_ml_kit_example/rep_counting/state_machine_result.dart';

import 'movement_phase.dart';
import 'exercise_type.dart';

class ExerciseStateMachine {
  final ExerciseType exerciseType;
  late Enum _currentState;

  ExerciseStateMachine({required this.exerciseType}) {
    switch (exerciseType) {
      case ExerciseType.squat:
        _currentState = SquatPhase.top;
        break;
    }
  }

  Enum get currentState => _currentState;

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    switch (exerciseType) {
      case ExerciseType.squat:
        return _squatStateMachine(newAvgMovementPhase);
    }
  }

  StateMachineResult _squatStateMachine(MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (_currentState) {
      case SquatPhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          _currentState = SquatPhase.desc;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          _currentState = SquatPhase.bottom;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          _currentState = SquatPhase.asc;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          _currentState = SquatPhase.top;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(hasChangedPhase, hasCompletedRep);
  }
}
