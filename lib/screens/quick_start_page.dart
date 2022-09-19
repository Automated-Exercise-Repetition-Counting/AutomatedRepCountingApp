import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/exercise_carousel.dart';
import 'package:puioio/widgets/incrementer.dart';
import 'package:puioio/widgets/title_block.dart';
import '../models/index.dart';
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
  final Index _reps = Index();
  late final Index _exerciseIndex = Index();

  @override
  void initState() {
    super.initState();
    _reps.set(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PuioioAppBar.getAppBar(context, Colors.transparent),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TitleBlock(
                title: 'Quick Start',
                subtitle: 'Choose an Exercise',
              ),
              ExerciseCarousel(exerciseIndex: _exerciseIndex),
              buildRepSetter(),
              const SizedBox(
                height: 50,
              ),
            ],
          )),
    );
  }

  Widget buildRepSetter() {
    return Column(children: [
      const Text('Select a number of reps', style: TextStyle(fontSize: 16)),
      Incrementer(reps: _reps),
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
                        reps: _reps.index,
                        exerciseType: _exerciseTypes[_exerciseIndex.index],
                      )),
            );
          },
        ),
      ),
    ]);
  }
}
