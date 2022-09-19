import 'package:puioio/models/exercise_model.dart';

class WorkoutModel {
  final String workoutTitle;
  final String workoutSubtitle;
  final List<ExerciseModel> exerciseList;
  final String workoutImg;
  final int numberOfStars;

  WorkoutModel(
      {required this.workoutTitle,
      required this.workoutSubtitle,
      required this.exerciseList,
      required this.workoutImg,
      required this.numberOfStars});
}
