import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:puioio/icons/custom_icons.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/title_block.dart';
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
                children: [
              Stack(alignment: Alignment.topCenter, children: [
                const TitleBlock(
                    title: 'Congratulations!',
                    subtitle: 'Ngā mihi nui ki a koe!'),
                Positioned(
                    top: 100,
                    child:
                        Lottie.asset('assets/lottie/trophy.json', height: 200)),
                Lottie.asset('assets/lottie/confetti.json', height: 300),
              ]),
              SizedBox(
                  width: 200,
                  height: 60,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [
                          Text('${workoutTracker?.workoutLength}',
                              style: const TextStyle(fontSize: 32)),
                          const Text('Sets',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey))
                        ]),
                        const VerticalDivider(color: Colors.grey),
                        Column(children: [
                          Text(
                              '${workoutTracker?.countedReps}/${workoutTracker?.desiredReps}',
                              style: const TextStyle(
                                  fontSize: 32, letterSpacing: 1)),
                          const Text('Reps',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey))
                        ])
                      ])),
              AppButton(
                  buttonText: 'Done',
                  buttonTextColor: Colors.white,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  callback: () => {Navigator.pop(context)}),
              const SizedBox(height: 50),
            ])));
  }
}
