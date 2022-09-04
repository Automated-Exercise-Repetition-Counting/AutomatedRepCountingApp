import '../exercise_state_machine.dart';
import '../state_machine_result.dart';

import '../../movement_phase.dart';

enum PullUpPhase { bottom, asc, top, desc }

class PullUpStateMachine extends ExerciseStateMachine {
  PullUpStateMachine() : super(PullUpPhase.bottom);

  @override
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (currentState) {
      case PullUpPhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = PullUpPhase.asc;
          hasChangedPhase = true;
        }
        break;
      case PullUpPhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = PullUpPhase.top;
          hasChangedPhase = true;
        }
        break;
      case PullUpPhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = PullUpPhase.desc;
          hasChangedPhase = true;
        }
        break;
      case PullUpPhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = PullUpPhase.bottom;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(hasChangedPhase, hasCompletedRep);
  }
}
