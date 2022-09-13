import 'package:flutter/material.dart';
import 'package:puioio/widgets/exercise_carousel.dart';
import 'package:puioio/widgets/title_block.dart';

import '../models/exercise_index.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  AddExercisePageState createState() => AddExercisePageState();
}

class AddExercisePageState extends State<AddExercisePage> {
  var _reps = 1;
  late final ExerciseIndex exerciseIndex;

  @override
  void initState() {
    super.initState();
    exerciseIndex = ExerciseIndex();
    exerciseIndex.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(30), child: buildAppBar())),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 30),
          const TitleBlock(
              title: 'Add Exercise', subtitle: 'Choose an Exercise'),
          ExerciseCarousel(exerciseIndex: exerciseIndex),
          buildRepSetter(),
          const SizedBox(height: 50),
        ],
      ),
    );
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
            child: const Text('Save',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget buildRepSetter() {
    return Column(children: [
      Text('Select a number of reps',
          style: Theme.of(context).textTheme.subtitle2),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove),
              iconSize: 30,
              onPressed: () {
                setState(() {
                  if (_reps > 1) {
                    _reps -= 1;
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('$_reps',
                  style: const TextStyle(color: Colors.black, fontSize: 44)),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 30,
              onPressed: () {
                setState(() {
                  _reps += 1;
                });
              },
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 30),
      ),
    ]);
  }
}
