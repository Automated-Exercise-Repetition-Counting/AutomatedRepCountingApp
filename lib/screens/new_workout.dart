import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'home_nav.dart';

class NewWorkoutPage extends StatefulWidget {
  const NewWorkoutPage({Key? key, required this.workoutTitle})
      : super(key: key);
  final String workoutTitle;

  @override
  NewWorkoutPageState createState() => NewWorkoutPageState();
}

class NewWorkoutPageState extends State<NewWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(children: [
        Padding(padding: const EdgeInsets.only(top: 50), child: buildTitle()),
        Text(widget.workoutTitle,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300)),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              Lottie.asset("assets/lottie/workout_empty.json", width: 250),
              const Text("Your workout is empty")
            ])),
        Padding(padding: const EdgeInsets.only(top: 50), child: buildButton()),
      ])),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        'New Workout',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          side: BorderSide(
              width: 3, color: Theme.of(context).colorScheme.primary)),
      onPressed: () {
        // TO DO: Add route to add exercise page
      },
      child: const Text('Add Exercise', style: TextStyle(fontSize: 20)),
    );
  }

  Widget buildAppBar() {
    return Row(
      children: <Widget>[
        TextButton(
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeNav(currentIndex: 2)),
              );
            }),
        const Spacer(),
        TextButton(
            child: const Text('Save',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNav(currentIndex: 2)));
            }),
      ],
    );
  }
}
