import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/screens/start_workout_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              const SizedBox(
                height: 80,
              ),
              buildHeader(),
              buildContentBox(context),
            ])));
  }

  Widget buildHeader() {
    return SizedBox(
      child: Image.asset("assets/img/Home-banner.png", height: 170),
    );
  }

  Widget buildContentBox(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kia ora!',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 20,
                ),
                buildWorkout(context),
                const SizedBox(
                  height: 150,
                ),
              ],
            )));
  }

  Widget buildWorkout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommended Workout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartWorkoutPage(
                          workoutTitle: "Leg Day",
                          exerciseList: legDayExercises)));
            },
            child: Container(
              width: 315,
              height: 180,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(20.0))),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leg Day',
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text('3 exercises | 9 sets',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))),
                              ]))),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        "assets/img/Leg-workout.png",
                        width: 220,
                      ))
                ],
              ),
            ))
      ],
    );
  }

  final legDayExercises = <ExerciseModel>[
    ExerciseModel(exercise: SquatExercise(), reps: 10),
    ExerciseModel(exercise: SquatExercise(), reps: 8),
    ExerciseModel(exercise: SquatExercise(), reps: 5),
  ];
}
