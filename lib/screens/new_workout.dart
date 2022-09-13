import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/screens/add_exercise_page.dart';
import 'package:puioio/widgets/app_button.dart';
// import 'package:puioio/widgets/reorderable_list.dart';

import 'home_nav.dart';

class NewWorkoutPage extends StatefulWidget {
  const NewWorkoutPage({Key? key, required this.workoutTitle})
      : super(key: key);
  final String workoutTitle;

  @override
  NewWorkoutPageState createState() => NewWorkoutPageState();
}

class NewWorkoutPageState extends State<NewWorkoutPage> {
  late List<ExerciseModel> exerciseList;

  @override
  void initState() {
    super.initState();
    exerciseList = <ExerciseModel>[
      ExerciseModel(exercise: SquatExercise(), reps: 10),
      ExerciseModel(exercise: PullUpExercise(), reps: 10),
      ExerciseModel(exercise: PushUpExercise(), reps: 10),
      ExerciseModel(exercise: SquatExercise(), reps: 10),
      ExerciseModel(exercise: PullUpExercise(), reps: 10),
      ExerciseModel(exercise: PushUpExercise(), reps: 10),
      ExerciseModel(exercise: SquatExercise(), reps: 10),
      ExerciseModel(exercise: PullUpExercise(), reps: 10),
      ExerciseModel(exercise: PushUpExercise(), reps: 10)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(30), child: buildAppBar())),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            buildTitle(),
            buildEmptyAnimation(),
            const SizedBox(height: 50),
            // SizedBox(
            //     height: 300,
            //     child: ReorderableExerciseList(exerciseList: exerciseList)),
            Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: AppButton(
                  buttonText: 'Add Exercise',
                  buttonTextColor: Colors.white,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddExercisePage()));
                  },
                )),
          ])),
    );
  }

  Widget buildTitle() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          'New Workout',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Text(widget.workoutTitle,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300)),
    ]);
  }

  Widget buildEmptyAnimation() {
    return Column(children: [
      Lottie.asset("assets/lottie/workout_empty.json", width: 250),
      const Text("Your workout is empty")
    ]);
  }

  Widget buildAppBar() {
    return Row(
      children: <Widget>[
        TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }),
        const Spacer(),
        TextButton(
            child: const Text('Save',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }),
      ],
    );
  }
}
