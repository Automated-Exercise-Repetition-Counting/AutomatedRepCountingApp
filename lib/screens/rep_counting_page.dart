import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import '../rep_counting/automatic_rep_counter.dart';
import '../rep_counting/exercise_type.dart';
import '../rep_counting/movement_phase.dart';
import '../vision_detector_views/pose_detector_view.dart';
import 'home_nav.dart';
import 'results_page.dart';

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

  void goBack() {
    setState(() {
      stopTimer();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeNav(currentIndex: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        goBack();
        return false;
      },
      child: Scaffold(
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
      )));

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
              goBack();
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
                          countedReps: _repCounter.reps,
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
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.exerciseName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w300)),
                  Text(
                    "Movement Phase: ${_repCounter.avgMovementPhase == MovementPhase.top ? "Top" : "Bottom"}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            Spacer(),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_repCounter.reps.toString(),
                      style: Theme.of(context).textTheme.headline3),
                  Text('out of ${widget.reps}',
                      style: Theme.of(context).textTheme.subtitle2),
                ]),
          ]),
        )),
      ),
    );
  }
}
