import '../exercise_state_machine.dart';
import '../state_machine_result.dart';
import '../vertical_exercise_phase.dart';

import '../../movement_phase.dart';

class PullUpStateMachine extends ExerciseStateMachine {
  PullUpStateMachine() : super(VerticalExercisePhase.bottom);

  @override
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (currentState) {
      case VerticalExercisePhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = VerticalExercisePhase.ascending;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.ascending:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = VerticalExercisePhase.top;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = VerticalExercisePhase.descending;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.descending:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = VerticalExercisePhase.bottom;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(
        hasChangedPhase: hasChangedPhase, hasCompletedRep: hasCompletedRep);
  }
}
