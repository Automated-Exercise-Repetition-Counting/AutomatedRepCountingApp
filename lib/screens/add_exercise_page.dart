import 'package:flutter/material.dart';
import 'package:puioio/widgets/exercise_carousel.dart';
import 'package:puioio/widgets/incrementer.dart';
import 'package:puioio/widgets/title_block.dart';
import '../models/index.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  AddExercisePageState createState() => AddExercisePageState();
}

class AddExercisePageState extends State<AddExercisePage> {
  final Index _reps = Index();
  late final Index exerciseIndex;

  @override
  void initState() {
    super.initState();
    _reps.set(1);
    exerciseIndex = Index();
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
      const Text('Select a number of reps', style: TextStyle(fontSize: 16)),
      Incrementer(reps: _reps),
      const Padding(
        padding: EdgeInsets.only(bottom: 30),
      ),
    ]);
  }
}
