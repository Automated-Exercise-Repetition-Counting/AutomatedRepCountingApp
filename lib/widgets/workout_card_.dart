import 'package:flutter/material.dart';
import 'package:puioio/data/workout_data.dart';
import 'package:puioio/models/workout_model.dart';
import 'package:puioio/screens/start_workout_page.dart';
import 'dart:math';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard(
      {Key? key,
      required this.workout,
      required this.onTap,
      required this.notifyParent})
      : super(key: key);
  final WorkoutModel workout;
  final Function onTap;
  final Function() notifyParent;

  @override
  WorkoutCardState createState() => WorkoutCardState();
}

Random random = Random();
int randomNumber = 1 + random.nextInt(3 - 0);

class WorkoutCardState extends State<WorkoutCard> {
  @override
  Widget build(BuildContext context) {
    WorkoutModel workout = widget.workout;
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartWorkoutPage(
                      workoutTitle: workout.workoutTitle,
                      exerciseList: workout.exerciseList)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Card(
              color: Colors.transparent,
              elevation: 0,
              margin: const EdgeInsets.all(5),
              child: ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('assets/img/$randomNumber.png')),
                  tileColor: Colors.white,
                  title: Text(workout.workoutTitle),
                  subtitle: Text(workout.workoutSubtitle),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      createdWorkouts.remove(workout);
                      widget.notifyParent();
                    },
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5))),
        ));
  }
}
