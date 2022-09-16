import 'package:flutter/material.dart';
import 'package:puioio/icons/custom_icons.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';

class FinishedWorkoutPage extends StatelessWidget {
  FinishedWorkoutPage({Key? key, this.workoutTracker}) : super(key: key);
  WorkoutTracker? workoutTracker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 100,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      CustomIcons.dumbbell,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    )),
                Text('Pūioio',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 25))
              ]),
            ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [Text('TO DO')])));
  }
}
