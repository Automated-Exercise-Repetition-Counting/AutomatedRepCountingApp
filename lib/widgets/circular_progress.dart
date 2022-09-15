import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgress extends StatefulWidget {
  const CircularProgress(
      {Key? key,
      required this.countedReps,
      required this.desiredReps,
      required this.exerciseName})
      : super(key: key);
  final int countedReps;
  final int desiredReps;
  final String exerciseName;

  @override
  CircularProgressState createState() => CircularProgressState();
}

class CircularProgressState extends State<CircularProgress> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: widget.countedReps / widget.desiredReps,
      progressColor: Theme.of(context).colorScheme.primary,
      animationDuration: 2,
      radius: 130.0,
      lineWidth: 20.0,
      animation: true,
      center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(widget.countedReps.toString(),
                style:
                    const TextStyle(fontSize: 66, fontWeight: FontWeight.w400)),
            Text('out of ${widget.desiredReps}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey)),
          ]),
      footer: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child:
              Text(widget.exerciseName, style: const TextStyle(fontSize: 28))),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
