import '../exercise_state_machine.dart';
import '../state_machine_result.dart';
import '../vertical_exercise_phase.dart';

import '../../movement_phase.dart';

class PushUpStateMachine extends ExerciseStateMachine {
  PushUpStateMachine() : super(VerticalExercisePhase.top);

  @override
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (currentState) {
      case VerticalExercisePhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = VerticalExercisePhase.descending;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.descending:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = VerticalExercisePhase.bottom;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = VerticalExercisePhase.ascending;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.ascending:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = VerticalExercisePhase.top;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(
        hasChangedPhase: hasChangedPhase, hasCompletedRep: hasCompletedRep);
  }
}
