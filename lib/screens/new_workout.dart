import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/data/workout_data.dart';
import 'package:puioio/models/workout_model.dart';
import 'package:puioio/screens/add_exercise_page.dart';
import 'package:puioio/screens/home_nav.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/reorderable_list.dart';

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
    exerciseList = <ExerciseModel>[];
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
            const SizedBox(height: 10),
            exerciseList.isEmpty
                ? buildEmptyAnimation()
                : SizedBox(
                    height: 400,
                    child: ReorderableExerciseList(exerciseList: exerciseList)),
            const SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: AppButton(
                  buttonText: 'Add Exercise',
                  buttonTextColor: Colors.white,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  callback: () async {
                    final addedExercise = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddExercisePage()));
                    exerciseList.add(addedExercise);
                    setState(() {});
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
    int count = 0;
    return Row(
      children: <Widget>[
        TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            }),
        const Spacer(),
        TextButton(
            child: const Text('Save',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              if (exerciseList.isEmpty) {
                showDialog(
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 10),
                              child: const Text(
                                "You need to add an exercise to save a workout",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30,
                                //color: primaryColor,
                                child: Text(
                                  "OKAY",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    context: context);
              } else {
                createdWorkouts.add(WorkoutModel(
                    workoutTitle: widget.workoutTitle,
                    workoutSubtitle: "${exerciseList.length} sets",
                    exerciseList: exerciseList));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNav(currentIndex: 2)),
                );
              }
            }),
      ],
    );
  }
}
