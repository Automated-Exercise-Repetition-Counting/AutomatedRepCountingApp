import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise/state_machines/state_machine_result.dart';
import 'exercise/exercise.dart';
import 'optical_flow/optical_flow_calculator.dart';

class AutomaticRepCounter extends ChangeNotifier {
  late final Exercise exercise;
  int _reps = 0;
  AutomaticRepCounter({required this.exercise});

  int get reps => _reps;
  Enum get phase => exercise.currentState;

  void updateRepCount(List<Pose> poses, OpticalFlowDirection flowDirection) {
    for (Pose pose in poses) {
      StateMachineResult result =
          exercise.updateStateMachine(pose, flowDirection);

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
