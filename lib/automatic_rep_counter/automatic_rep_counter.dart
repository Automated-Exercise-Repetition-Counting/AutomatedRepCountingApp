import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise/state_machines/state_machine_result.dart';
import 'exercise/exercise.dart';
import 'hyperparameters.dart';

class AutomaticRepCounter extends ChangeNotifier {
  late final Exercise exercise;
  int _reps = 0;
  int? _lastPDTime;
  bool _isPaused = false;
  AutomaticRepCounter({required this.exercise});

  int get reps => _reps;
  Enum get phase => exercise.currentState;
  bool isInFrame(Pose pose) => exercise.checkInFrame(pose);
  bool get isPaused => _isPaused;

  StateMachineResult updateStateMachine(Pose pose) {
    StateMachineResult result =
        StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    try {
      result = exercise.updateStateMachinePose(pose);
      _lastPDTime = currentTime;
      _isPaused = false;
    } on StateError {
      if (currentTime - (_lastPDTime ?? 0) > noPoseDetectionTimeout) {
        _isPaused = true;
        notifyListeners();
      }
    }
    return result;
  }

  void updateRepCount(List<Pose> poses) {
    for (Pose pose in poses) {
      StateMachineResult result = updateStateMachine(pose);

      if (result.hasChangedPhase) {
        if (result.hasCompletedRep) {
          _reps++;
        }
        notifyListeners();
      }
    }
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    log(e.toString());
  }
}
