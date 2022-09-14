import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/exercise_carousel.dart';
import 'package:puioio/widgets/title_block.dart';
import '../models/exercise_index.dart';
import 'set_up_phone_page.dart';

class QuickStartPage extends StatefulWidget {
  const QuickStartPage({Key? key}) : super(key: key);

  @override
  QuickStartPageState createState() => QuickStartPageState();
}

class QuickStartPageState extends State<QuickStartPage> {
  final List<Exercise> _exerciseTypes = [
    SquatExercise(),
    PullUpExercise(),
    PushUpExercise()
  ];
  var _reps = 1;
  late final ExerciseIndex _exerciseIndex;

  @override
  void initState() {
    super.initState();
    _exerciseIndex = ExerciseIndex();
    _exerciseIndex.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TitleBlock(
            title: 'Quick Start',
            subtitle: 'Choose an Exercise',
          ),
          ExerciseCarousel(exerciseIndex: _exerciseIndex),
          buildRepSetter(),
        ],
      ),
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
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: AppButton(
          buttonText: 'Begin',
          buttonTextColor: Colors.white,
          buttonColor: Theme.of(context).colorScheme.primary,
          callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SetUpPage(
                        reps: _reps,
                        exerciseType: _exerciseTypes[
                            _exerciseIndex.getChosenExerciseIndex],
                      )),
            );
          },
        ),
      ),
    ]);
  }
}
