import 'package:flutter/material.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/screens/set_up_phone_page.dart';
import 'package:puioio/widgets/reorderable_list.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';

class StartWorkoutPage extends StatelessWidget {
  const StartWorkoutPage(
      {Key? key, required this.workoutTitle, required this.exerciseList})
      : super(key: key);
  final String workoutTitle;
  final List<ExerciseModel> exerciseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: buildAppBar(context))),
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(height: 50),
            buildTitle(context),
            const SizedBox(height: 50),
            SizedBox(
                height: 400,
                child: ReorderableExerciseList(exerciseList: exerciseList)),
          ])),
        ));
  }

  Widget buildTitle(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          'Start Workout',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Text(workoutTitle,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300)),
    ]);
  }

  Widget buildAppBar(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            }),
        const Spacer(),
        TextButton(
            child: const Text('Start',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SetUpPage(
                          reps: exerciseList[0].reps,
                          exerciseType: exerciseList[0].exercise,
                          workoutTracker:
                              WorkoutTracker(exerciseList: exerciseList))));
            }),
      ],
    );
  }
}
