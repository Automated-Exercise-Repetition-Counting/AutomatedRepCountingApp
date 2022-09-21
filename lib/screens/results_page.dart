import 'package:flutter/material.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/circular_progress.dart';
import 'home_nav.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage(
      {Key? key,
      required this.exerciseName,
      required this.desiredReps,
      required this.countedReps,
      required this.timeElapsed})
      : super(key: key);
  final String exerciseName;
  final int desiredReps;
  final int countedReps;
  final String timeElapsed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PuioioAppBar.getAppBar(context, Colors.transparent, false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Ka pai!',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Well done!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              const SizedBox(height: 10),
              CircularProgress(
                  countedReps: countedReps,
                  desiredReps: desiredReps,
                  exerciseName: exerciseName),
              Text(timeElapsed, style: const TextStyle(fontSize: 16)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: AppButton(
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonText: 'Done',
                  buttonTextColor: Colors.white,
                  callback: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomeNav(currentIndex: 1)));
                  },
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}
