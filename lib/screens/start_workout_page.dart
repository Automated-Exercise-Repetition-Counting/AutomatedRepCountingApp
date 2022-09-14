import 'package:flutter/material.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/widgets/reorderable_list.dart';

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage(
      {Key? key, required this.workoutTitle, required this.exerciseList})
      : super(key: key);
  final String workoutTitle;
  final List<ExerciseModel> exerciseList;

  @override
  StartWorkoutPageState createState() => StartWorkoutPageState();
}

class StartWorkoutPageState extends State<StartWorkoutPage> {
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(height: 50),
        buildTitle(),
        const SizedBox(height: 50),
        SizedBox(
            height: 400,
            child: ReorderableExerciseList(exerciseList: widget.exerciseList)),
      ])),
    );
  }

  Widget buildTitle() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Text(
          'Start Workout',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Text(widget.workoutTitle,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300)),
    ]);
  }

  Widget buildAppBar() {
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
              Navigator.pop(context);
            }),
      ],
    );
  }
}
