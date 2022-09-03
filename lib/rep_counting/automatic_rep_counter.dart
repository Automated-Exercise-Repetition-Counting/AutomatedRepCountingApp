import 'package:flutter/foundation.dart';
import 'package:google_ml_kit_example/rep_counting/state_machine_result.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise_type.dart';
import 'movement_phase.dart';
import 'state_machines/squat_state_machine.dart';
import 'thresholds.dart';

class AutomaticRepCounter extends ChangeNotifier {
  final ExerciseType exerciseType;
  late final SquatStateMachine _exerciseStateMachine;

  int _reps = 0;
  AutomaticRepCounter({required this.exerciseType}) {
    _exerciseStateMachine = SquatStateMachine();
  }

  int get reps => _reps;
  Enum get phase => _exerciseStateMachine.currentState;

  void updateRepCount(List<Pose> poses) {
    for (Pose pose in poses) {
      try {
        MovementPhase latestPhase = _threshold(pose);
        _changePhaseAndCountReps(latestPhase);
      } on StateError {} // do nothing on StateError
    }
  }

  MovementPhase _threshold(Pose pose) {
    switch (exerciseType) {
      case ExerciseType.squat:
        return Thresholds.thresholdSquat(pose);
    }
  }

  void _changePhaseAndCountReps(MovementPhase latestPhase) {
    StateMachineResult result =
        _exerciseStateMachine.getStateMachineResult(latestPhase);

    if (result.hasChangedPhase) {
      if (result.hasCompletedRep) {
        _reps++;
      }
      notifyListeners();
    }
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    print(e);
  }
}
