import 'package:google_ml_kit_example/rep_counting/movement_phase.dart';
import 'package:google_ml_kit_example/rep_counting/state_machine_result.dart';

abstract class ExerciseStateMachine {
  Enum currentState;
  ExerciseStateMachine(Enum this.currentState);

  /// A state machine that returns true if a rep has been completed.
  /// Returns false if no rep has been completed.
  StateMachineResult movementPhaseStateMachine(
      MovementPhase newAvgMovementPhase);
}
