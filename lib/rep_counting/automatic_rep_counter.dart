import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise_type.dart';
import 'movement_phase.dart';
import 'state_machine_result.dart';
import 'state_machines.dart';
import 'thresholds.dart';

class AutomaticRepCounter extends ChangeNotifier {
  static const _windowSize = 3;

  final ExerciseType exerciseType;
  final Queue<MovementPhase> _prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> _movementCounts = HashMap<MovementPhase, int>();
  late final ExerciseStateMachine _exerciseStateMachine;

  int _reps = 0;
  AutomaticRepCounter({required this.exerciseType}) {
    _exerciseStateMachine = ExerciseStateMachine(
      exerciseType: exerciseType,
    );
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
    _prevMovementPhase.addLast(latestPhase);

    if (_prevMovementPhase.length <= _windowSize) {
      // insufficient values to safely detect movement phase. return.
      return;
    }

    _prevMovementPhase.removeFirst();

    MovementPhase newAvgMvmtPhase = _getAvgMovementPhase();
    StateMachineResult result =
        _exerciseStateMachine.movementPhaseStateMachine(newAvgMvmtPhase);

    if (result.hasChangedPhase) {
      if (result.hasCompletedRep) {
        _reps++;
      }
      notifyListeners();
    }
  }

  MovementPhase _getAvgMovementPhase() {
    _movementCounts.clear();
    _prevMovementPhase.forEach((phase) {
      _movementCounts[phase] = _movementCounts[phase] ?? 0 + 1;
    });

    // return the movement phase with the max count
    return _movementCounts.entries
        .reduce((e1, e2) => e1.value > e2.value ? e1 : e2)
        .key;
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    print(e);
  }
}
