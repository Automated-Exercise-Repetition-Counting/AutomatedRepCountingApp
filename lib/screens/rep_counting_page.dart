import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import '../rep_counting/automatic_rep_counter.dart';
import '../rep_counting/exercise_type.dart';
import '../rep_counting/movement_phase.dart';
import '../vision_detector_views/pose_detector_view.dart';
import 'results.dart';

class RepCountingPage extends StatefulWidget {
  RepCountingPage(
      {Key? key,
      required this.exerciseName,
      required this.reps,
      required this.exerciseType})
      : super(key: key);
  final String exerciseName;
  final int reps;
  final ExerciseType exerciseType;

  @override
  RepCountingPageState createState() => RepCountingPageState();
}

class RepCountingPageState extends State<RepCountingPage> {
  late final AutomaticRepCounter _repCounter;
  late CountdownController countdownController;
  static const _maxSeconds = 10;
  int _seconds = _maxSeconds;
  int _countedReps = 0;
  Timer? timer;
  late bool _isRunning;

  @override
  void initState() {
    super.initState();
    _repCounter = AutomaticRepCounter(exerciseType: ExerciseType.squat);
    _repCounter.addListener(() {
      setState(() {});
    });
    startTimer();
    _isRunning = true;
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 1)
          _seconds--;
        else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _countedReps = _repCounter.reps;
    return Scaffold(
        body: Stack(
      children: [
        PoseDetectorView(repCounter: _repCounter),
        buildTimer(),
        Visibility(
          visible: !_isRunning,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
            child: Column(
              children: <Widget>[
                buildButtons(),
                const Spacer(),
                buildDisplay(),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget buildTimer() {
    _isRunning = timer == null ? false : timer!.isActive;
    return Visibility(
      visible: _isRunning,
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.5),
        body: Center(
          child: Text(
            '${_seconds}',
            style: TextStyle(fontSize: 100, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.6),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.6),
          child: IconButton(
            icon: const Icon(Icons.check),
            iconSize: 25,
            color: Colors.black,
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultsPage(
                          exerciseName: widget.exerciseName,
                          desiredReps: widget.reps,
                          countedReps: _countedReps,
                          exerciseType: widget.exerciseType)),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildDisplay() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        width: 380,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(_countedReps.toString(),
                    style: Theme.of(context).textTheme.headline2),
                Text('out of ${widget.reps}',
                    style: Theme.of(context).textTheme.subtitle2),
                Text(
                  "Movement Phase: ${_repCounter.avgMovementPhase == MovementPhase.top ? "Top" : "Bottom"}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ]),
        ),
      ),
    );
  }
}
