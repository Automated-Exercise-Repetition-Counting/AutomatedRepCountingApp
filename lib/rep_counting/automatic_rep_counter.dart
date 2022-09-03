import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_ml_kit_example/rep_counting/thresholds.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import './exercise_type.dart';
import './movement_phase.dart';

class AutomaticRepCounter extends ChangeNotifier {
  static const windowSize = 3;

  final ExerciseType exerciseType;
  final Queue<MovementPhase> prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> movementCounts = HashMap<MovementPhase, int>();
  SquatPhase _currentState = SquatPhase.top;

  int _reps = 0;
  AutomaticRepCounter({required this.exerciseType});

  int get reps => _reps;
  SquatPhase get phase => _currentState;

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
    prevMovementPhase.addLast(latestPhase);

    if (prevMovementPhase.length <= windowSize) {
      // insufficient values to safely detect movement phase. return.
      return;
    }

    prevMovementPhase.removeFirst();

    MovementPhase newAvgMvmtPhase = _getAvgMovementPhase();
    _movementPhaseStateMachine(newAvgMvmtPhase);
  }

  MovementPhase _getAvgMovementPhase() {
    movementCounts.clear();
    prevMovementPhase.forEach((element) {
      movementCounts[element] = movementCounts[element] ?? 0 + 1;
    });

    // return the movement phase with the max count
    return movementCounts.entries
        .reduce((e1, e2) => e1.value > e2.value ? e1 : e2)
        .key;
  }

  void _movementPhaseStateMachine(MovementPhase newAvgMovementPhase) {
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
          _reps++;
          notifyListeners();
        }
        break;
    }
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    print(e);
  }
}
