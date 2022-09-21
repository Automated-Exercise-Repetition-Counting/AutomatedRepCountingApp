import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';
import 'rep_counting_page.dart';

class SetUpPage extends StatelessWidget {
  SetUpPage(
      {Key? key,
      required this.reps,
      required this.exerciseType,
      this.workoutTracker})
      : super(key: key);
  final int reps;
  final Exercise exerciseType;
  WorkoutTracker? workoutTracker;

  final List<String> messages = [
    'You will have 10s to get into position',
    'Position yourself away from the phone so your whole body is visible',
    'For every rep you perform, the display with update your count',
    'You will also be able to see what ‘phase’ of the exercise movement you are in',
    'If you finish before the desired number of reps are achieved, press the tick icon'
  ];

  final List<IconData> icons = [
    Icons.timer_10,
    Icons.accessibility,
    Icons.exposure_plus_1,
    Icons.swap_vert,
    Icons.check_rounded
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 20, 50, 100),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Get your phone into position',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    decoration: TextDecoration.none),
              ),
              const Spacer(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Iterable<int>.generate(messages.length)
                      .toList()
                      .map((index) => Column(
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Icon(icons[index],
                                      color: Colors.white, size: 34),
                                ),
                                Flexible(
                                  child: Text(
                                    messages[index],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 20)
                            ],
                          ))
                      .toList()),
              const Spacer(),
              AppButton(
                  buttonText: "I'm ready!",
                  buttonTextColor: Colors.black,
                  buttonColor: Colors.white,
                  callback: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RepCountingPage(
                                  reps: reps,
                                  exerciseType: exerciseType,
                                  workoutTracker: workoutTracker,
                                )),
                      )),
            ]),
      ),
    );
  }
}
