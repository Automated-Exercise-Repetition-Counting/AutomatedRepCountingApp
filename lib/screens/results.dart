import 'package:flutter/material.dart';
import 'package:google_ml_kit_example/rep_counting/exercise_type.dart';
import '../widgets/circular_progress_with_image.dart';
import 'home_page.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage(
      {Key? key,
      required this.desiredReps,
      required this.countedReps,
      required this.exerciseType})
      : super(key: key);
  final int desiredReps;
  final int countedReps;
  final ExerciseType exerciseType;

  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 20.0),
            child: Text(
              'Ka pai!',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          CircularProgressWithImage(
              countedReps: widget.countedReps,
              desiredReps: widget.desiredReps,
              exerciseType: widget.exerciseType.toString()),
          Column(children: <Widget>[
            Text('Number of reps counted',
                style: Theme.of(context).textTheme.headline6),
            Text(widget.countedReps.toString(),
                style: Theme.of(context).textTheme.headline2),
            Text('out of ${widget.desiredReps}',
                style: Theme.of(context).textTheme.subtitle2),
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500),
                  primary: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(80, 10, 80, 10)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(title: 'Home page')),
                );
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    ));
  }
}
