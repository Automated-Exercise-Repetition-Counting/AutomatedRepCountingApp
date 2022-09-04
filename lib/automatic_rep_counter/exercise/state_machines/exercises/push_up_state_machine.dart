import '../exercise_state_machine.dart';
import '../state_machine_result.dart';

import '../../movement_phase.dart';

enum PushUpPhase { top, desc, bottom, asc }

class PushUpStateMachine extends ExerciseStateMachine {
  PushUpStateMachine() : super(PushUpPhase.top);

  @override
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (currentState) {
      case PushUpPhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = PushUpPhase.desc;
          hasChangedPhase = true;
        }
        break;
      case PushUpPhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = PushUpPhase.bottom;
          hasChangedPhase = true;
        }
        break;
      case PushUpPhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = PushUpPhase.asc;
          hasChangedPhase = true;
        }
        break;
      case PushUpPhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = PushUpPhase.top;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(hasChangedPhase, hasCompletedRep);
  }
}
