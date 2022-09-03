import 'movement_phase.dart';
import 'exercise_type.dart';

class ExerciseStateMachine {
  final void Function() notifyListeners;
  final ExerciseType exerciseType;
  late Enum _currentState;

  ExerciseStateMachine(
      {required this.notifyListeners, required this.exerciseType}) {
    switch (exerciseType) {
      case ExerciseType.squat:
        _currentState = SquatPhase.top;
        break;
    }
  }

  Enum get currentState => _currentState;

  bool movementPhaseStateMachine(MovementPhase newAvgMovementPhase) {
    switch (exerciseType) {
      case ExerciseType.squat:
        return _squatStateMachine(newAvgMovementPhase);
    }
  }

  bool _squatStateMachine(MovementPhase newAvgMovementPhase) {
    switch (_currentState) {
      case SquatPhase.top:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          _currentState = SquatPhase.desc;
          notifyListeners();
        }
        break;
      case SquatPhase.desc:
        if (newAvgMovementPhase == MovementPhase.bottom) {
          _currentState = SquatPhase.bottom;
          notifyListeners();
        }
        break;
      case SquatPhase.bottom:
        if (newAvgMovementPhase == MovementPhase.intermediate) {
          _currentState = SquatPhase.asc;
          notifyListeners();
        }
        break;
      case SquatPhase.asc:
        if (newAvgMovementPhase == MovementPhase.top) {
          _currentState = SquatPhase.top;
          notifyListeners();
          return true;
        }
        break;
    }
    return false;
  }
}
