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
          currentState = VerticalExercisePhase.asc;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = VerticalExercisePhase.top;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = VerticalExercisePhase.desc;
          hasChangedPhase = true;
        }
        break;
      case VerticalExercisePhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = VerticalExercisePhase.bottom;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(hasChangedPhase, hasCompletedRep);
  }
}
