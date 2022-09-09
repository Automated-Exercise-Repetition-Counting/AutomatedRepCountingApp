import 'package:flutter/material.dart';
import '../screens/new_workout.dart';

class AddWorkoutDialog extends StatefulWidget {
  @override
  AddWorkoutDialogState createState() => AddWorkoutDialogState();
}

class AddWorkoutDialogState extends State<AddWorkoutDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: <Widget>[
          Padding(padding: const EdgeInsets.all(5), child: buildButtons()),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Create a',
                  style: TextStyle(color: Colors.white, fontSize: 20))),
          Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text('Workout',
                  style: TextStyle(color: Colors.white, fontSize: 36))),
          buildTextField(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.close),
          iconSize: 25,
          color: Colors.white,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.check),
          iconSize: 25,
          color: Colors.white,
          onPressed: () {
            controller.text.isEmpty
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewWorkoutPage(workoutTitle: controller.text)),
                  );
          },
        ),
      ],
    );
  }

  Widget buildTextField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: TextField(
          controller: controller,
          maxLength: 20,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(
              counterStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: InputBorder.none,
              hintText: 'Workout Title',
              hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: 24)),
        ));
  }
}
