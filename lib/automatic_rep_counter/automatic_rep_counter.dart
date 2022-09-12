import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise/state_machines/state_machine_result.dart';
import 'exercise/exercise.dart';
import 'optical_flow/optical_flow_calculator.dart';
import 'hyperparameters.dart';

class AutomaticRepCounter extends ChangeNotifier {
  late final Exercise exercise;
  int _reps = 0;
  int _lastPDTime = DateTime.now().millisecondsSinceEpoch;
  bool _isPaused = false;
  AutomaticRepCounter({required this.exercise});

  int get reps => _reps;
  Enum get phase => exercise.currentState;
  bool get isPaused => _isPaused;

  // create a timer
  // when the timer is done, call onTimeout

  StateMachineResult updateStateMachine(
      Pose pose, OpticalFlowDirection flowDirection) {
    StateMachineResult result =
        StateMachineResult(hasChangedPhase: false, hasCompletedRep: false);
    try {
      result = exercise.updateStateMachinePose(pose, flowDirection);
      _lastPDTime = DateTime.now().millisecondsSinceEpoch;
      _isPaused = false;
    } on StateError {
      if (DateTime.now().millisecondsSinceEpoch - _lastPDTime >
          noPoseDetectionTimeout) {
        _isPaused = true;
        notifyListeners();
      } else {
        if (flowDirection != OpticalFlowDirection.none) {
          result = exercise.updateStateMachineOF(flowDirection);
        }
      }
    }
    return result;
  }

  void updateRepCount(List<Pose> poses, OpticalFlowDirection flowDirection) {
    for (Pose pose in poses) {
      StateMachineResult result = updateStateMachine(pose, flowDirection);

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
