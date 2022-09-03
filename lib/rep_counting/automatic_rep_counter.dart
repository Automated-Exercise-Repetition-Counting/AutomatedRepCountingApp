import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_ml_kit_example/utils/thresholds.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import './exercise_type.dart';
import './movement_phase.dart';

class AutomaticRepCounter extends ChangeNotifier {
  static const windowSize = 10;

  final ExerciseType exerciseType;
  final Queue<MovementPhase> prevMovementPhase = Queue<MovementPhase>();
  final Map<MovementPhase, int> movementCounts = HashMap<MovementPhase, int>();

  int _reps = 0;
  MovementPhase _avgMovementPhase = MovementPhase.top;

  AutomaticRepCounter({required this.exerciseType});

  int get reps => _reps;

  void updateRepCount(List<Pose> poses) async {
    for (Pose pose in poses) {
      MovementPhase latestPhase = _threshold(pose);
      _changePhaseAndCountReps(latestPhase);
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
    movementCounts[latestPhase] = (movementCounts[latestPhase] ?? 0) + 1;
    if (prevMovementPhase.length <= windowSize) {
      // insufficient values to safely detect movement phase. return.
      return;
    }

    MovementPhase earliestPhase = prevMovementPhase.removeFirst();
    movementCounts[earliestPhase] = movementCounts.containsKey(earliestPhase)
        ? movementCounts[earliestPhase]! - 1
        : 0;

    MovementPhase newAvgMvmtPhase = _get_avgMovementPhase();

    if (newAvgMvmtPhase != _avgMovementPhase) {
      if (newAvgMvmtPhase == MovementPhase.top) {
        _reps++;
      }
      notifyListeners();
    }

    _avgMovementPhase = newAvgMvmtPhase;
  }

  MovementPhase _get_avgMovementPhase() {
    int topCount = movementCounts.containsKey(MovementPhase.top)
        ? movementCounts[MovementPhase.top]!
        : 0;
    int bottomCount = movementCounts.containsKey(MovementPhase.bottom)
        ? movementCounts[MovementPhase.bottom]!
        : 0;

    if (topCount > bottomCount) {
      return MovementPhase.top;
    } else if (topCount < bottomCount) {
      return MovementPhase.bottom;
    } else {
      return MovementPhase.top;
    }
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    print(e);
  }
}
