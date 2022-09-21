import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/models/exercise_model.dart';

class WorkoutTracker extends ChangeNotifier {
  WorkoutTracker({required this.exerciseList});

  final List<ExerciseModel> exerciseList;
  List<ExerciseModel> completedExerciseList = [];
  int index = 0;
  int totalDesiredReps = 0;
  int totalCountedReps = 0;

  List<ExerciseModel> get workout => exerciseList;
  List<ExerciseModel> get completedExercises => completedExerciseList;
  int get reps => exerciseList[index].reps;
  Exercise get exercise => exerciseList[index].exercise;
  int get workoutLength => exerciseList.length;
  int get countedReps => totalCountedReps;
  int get desiredReps => totalDesiredReps;

  bool nextExercise() {
    if (index < exerciseList.length - 1) {
      index++;
      return true;
    }
    return false;
  }

  void completedExercise(int reps) {
    completedExerciseList.add(ExerciseModel(exercise: exercise, reps: reps));
    totalDesiredReps += this.reps;
    totalCountedReps += reps;
  }
}
