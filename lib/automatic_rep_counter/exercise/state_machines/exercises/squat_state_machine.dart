import '../exercise_state_machine.dart';
import '../state_machine_result.dart';

import '../../movement_phase.dart';

enum SquatPhase { top, desc, bottom, asc }

class SquatStateMachine extends ExerciseStateMachine {
  SquatStateMachine() : super(SquatPhase.top);

  @override
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase) {
    bool hasCompletedRep = false;
    bool hasChangedPhase = false;

    switch (currentState) {
      case SquatPhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = SquatPhase.desc;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          currentState = SquatPhase.bottom;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          currentState = SquatPhase.asc;
          hasChangedPhase = true;
        }
        break;
      case SquatPhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          currentState = SquatPhase.top;
          hasChangedPhase = hasCompletedRep = true;
        }
        break;
    }
    return StateMachineResult(hasChangedPhase, hasCompletedRep);
  }
}
