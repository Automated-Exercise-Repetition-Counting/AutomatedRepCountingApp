import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise/state_machines/state_machine_result.dart';
import 'exercise/exercise.dart';
import 'optical_flow/optical_flow_calculator.dart';

class AutomaticRepCounter extends ChangeNotifier {
  late final Exercise exercise;
  final int _unconfidenceCountThreshold = 10;

  int _reps = 0;
  int _unconfidenceCount = 0;
  AutomaticRepCounter({required this.exercise});

  int get reps => _reps;
  Enum get phase => exercise.currentState;

  void updateRepCount(List<Pose> poses, OpticalFlowDirection flowDirection) {
    for (Pose pose in poses) {
      StateMachineResult result;
      try {
        result = exercise.updateStateMachinePose(pose);
        _unconfidenceCount = 0;
      } on StateError {
        if (_unconfidenceCount > _unconfidenceCountThreshold) {
          if (flowDirection == OpticalFlowDirection.none) {
            return;
          }
          result = exercise.updateStateMachineOF(flowDirection);
          _unconfidenceCount = 0;
        } else {
          _unconfidenceCount++;
          return;
        }
      }

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
