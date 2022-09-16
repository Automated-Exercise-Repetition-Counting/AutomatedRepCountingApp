import 'package:flutter/material.dart';
import 'package:puioio/icons/custom_icons.dart';
import 'package:puioio/widgets/circular_progress.dart';
import 'home_nav.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage(
      {Key? key,
      required this.exerciseName,
      required this.desiredReps,
      required this.countedReps})
      : super(key: key);
  final String exerciseName;
  final int desiredReps;
  final int countedReps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.fromLTRB(80, 10, 80, 10)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeNav(currentIndex: 1)));
                  },
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}
