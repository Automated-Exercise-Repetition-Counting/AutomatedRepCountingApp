import 'package:flutter/material.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/title_block.dart';
import 'package:puioio/data/workout_data.dart';
import 'package:puioio/widgets/workout_card_.dart';
import '../widgets/add_workout_dialog.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  WorkoutState createState() => WorkoutState();
}

class WorkoutState extends State<WorkoutPage> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PuioioAppBar.getAppBar(context, Colors.transparent),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Column(children: [
                const TitleBlock(
                  title: 'Workouts',
                  subtitle: '',
                ),
                buildCreateWorkout(context),
                const SizedBox(height: 20),
                Column(
                    children: createdWorkouts
                        .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: WorkoutCard(
                                notifyParent: refresh,
                                workout: e,
                                onTap: () {
                                  createdWorkouts.remove(e);
                                  setState(() {});
                                })))
                        .toList()),
                const SizedBox(height: 100)
              ])),
        ));
  }

  Future<String?> openDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddWorkoutDialog();
      });

  Widget buildCreateWorkout(BuildContext context) {
    return Stack(children: [
      Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [
                        0,
                        0.5,
                        0.5
                      ]),
                ),
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Center(
                        child: IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () async {
                        openDialog(context);
                      },
                    ))),
              ))),
      Center(
          child: Container(
              width: 300,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2)),
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15.0, 0, 5.0),
                    child: Text(
                      'Create a new workout',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'You can create and edit your own workout by choosing from various exercises.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        )),
                  )
                ],
              )))
    ]);
  }
}
