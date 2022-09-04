import '../exercise.dart';
import '../state_machines/exercises/squat_state_machine.dart';
import '../thresholds/exercises/squat_thresholds.dart';

class SquatExercise extends Exercise {
  SquatExercise() : super(SquatStateMachine(), SquatThresholds());
}
