import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:puioio/automatic_rep_counter/exercise/movement_phase.dart';
import '../automatic_rep_counter/automatic_rep_counter.dart';
import '../automatic_rep_counter/exercise/exercise.dart';
import '../vision_detector_views/automatic_rep_counter_view.dart';
import 'home_nav.dart';
import 'results_page.dart';

class RepCountingPage extends StatefulWidget {
  const RepCountingPage(
      {Key? key,
      required this.exerciseName,
      required this.reps,
      required this.exerciseType})
      : super(key: key);
  final String exerciseName;
  final int reps;
  final Exercise exerciseType;

  @override
  RepCountingPageState createState() => RepCountingPageState();
}

class RepCountingPageState extends State<RepCountingPage> {
  late final AutomaticRepCounter _repCounter;
  late AutomaticRepCounterView _repCounterView;
  late CountdownController countdownController;
  static const _maxSeconds = 10;
  int _seconds = _maxSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _repCounter = AutomaticRepCounter(exercise: widget.exerciseType);
    _repCounter.addListener(() {
      setState(() {});
    });
    _repCounterView =
        AutomaticRepCounterView(repCounter: _repCounter, canCount: false);
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  bool _timerIsRunning() => timer != null && timer!.isActive;

  void stopTimer() {
    timer?.cancel();
    setState(() {
      _repCounterView =
          AutomaticRepCounterView(repCounter: _repCounter, canCount: false);
    });
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
          _repCounterView,
          buildTimer(),
          Visibility(
            visible: !_timerIsRunning(),
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
    return Visibility(
      visible: _timerIsRunning(),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.5),
        body: Center(
          child: Text(
            '$_seconds',
            style: const TextStyle(fontSize: 100, color: Colors.black),
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
                          countedReps: _repCounter.reps)),
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
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w300)),
                  Text(
                    "Movement Phase: ${_repCounter.phase.name}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            const Spacer(),
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
