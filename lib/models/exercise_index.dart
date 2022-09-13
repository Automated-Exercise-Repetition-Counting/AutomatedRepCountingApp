import 'package:flutter/material.dart';

class ExerciseIndex extends ChangeNotifier {
  int _chosenExerciseIndex = 0;

  int get getChosenExerciseIndex => _chosenExerciseIndex;

  void set(int index) {
    _chosenExerciseIndex = index;
    notifyListeners();
  }
}
