import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'exercise.dart';
import 'state_machines/state_machine_result.dart';

class AutomaticRepCounter extends ChangeNotifier {
  late final Exercise exercise;
  int _reps = 0;
  AutomaticRepCounter({required this.exercise});

  int get reps => _reps;
  Enum get phase => exercise.currentState;

  void updateRepCount(List<Pose> poses) {
    for (Pose pose in poses) {
      try {
        StateMachineResult result = exercise.updateStateMachine(pose);
        if (result.hasChangedPhase) {
          if (result.hasCompletedRep) {
            _reps++;
          }
          notifyListeners();
        }
      } on StateError {} // do nothing on StateError
    }
  }

  // TODO: make better exception function
  void exceptionFn(Object e) {
    print(e);
  }
}
