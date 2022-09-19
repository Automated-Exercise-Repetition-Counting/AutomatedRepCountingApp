import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/models/workout_model.dart';

final List<WorkoutModel> createdWorkouts = [];

final legDay = WorkoutModel(
    workoutTitle: "Leg Day",
    workoutSubtitle: "3 sets | 23 reps",
    exerciseList: <ExerciseModel>[
      ExerciseModel(exercise: SquatExercise(), reps: 10),
      ExerciseModel(exercise: SquatExercise(), reps: 8),
      ExerciseModel(exercise: SquatExercise(), reps: 5),
    ],
    workoutImg: "assets/img/Leg-workout.png",
    numberOfStars: 3);

final pullDay = WorkoutModel(
    workoutTitle: "Pull Day",
    workoutSubtitle: "3 sets | 24 reps",
    exerciseList: <ExerciseModel>[
      ExerciseModel(exercise: PullUpExercise(), reps: 8),
      ExerciseModel(exercise: PullUpExercise(), reps: 8),
      ExerciseModel(exercise: PullUpExercise(), reps: 8),
    ],
    workoutImg: "assets/img/Pull-workout.png",
    numberOfStars: 5);

final pushDay = WorkoutModel(
    workoutTitle: "Toned Arms",
    workoutSubtitle: "3 sets | 30 reps",
    exerciseList: <ExerciseModel>[
      ExerciseModel(exercise: PushUpExercise(), reps: 10),
      ExerciseModel(exercise: PushUpExercise(), reps: 10),
      ExerciseModel(exercise: PushUpExercise(), reps: 10),
    ],
    workoutImg: "assets/img/Arm-workout.png",
    numberOfStars: 4);
