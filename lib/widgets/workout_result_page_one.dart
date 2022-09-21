import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:puioio/widgets/title_block.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';

class PageOne extends StatelessWidget {
  PageOne({Key? key, this.workoutTracker}) : super(key: key);
  WorkoutTracker? workoutTracker;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Stack(alignment: Alignment.topCenter, children: [
        const TitleBlock(
            title: 'Congratulations!', subtitle: 'Ngā mihi nui ki a koe!'),
        Positioned(
            top: 100,
            child: Lottie.asset('assets/lottie/trophy.json', height: 200)),
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
                      style: TextStyle(fontSize: 16, color: Colors.grey))
                ]),
                const VerticalDivider(color: Colors.grey),
                Column(children: [
                  Text(
                      '${workoutTracker?.countedReps}/${workoutTracker?.desiredReps}',
                      style: const TextStyle(fontSize: 32, letterSpacing: 1)),
                  const Text('Reps',
                      style: TextStyle(fontSize: 16, color: Colors.grey))
                ])
              ])),
    ]));
  }
}
