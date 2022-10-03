import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:puioio/screens/rep_counting_page.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';

class RestPage extends StatefulWidget {
  RestPage(
      {Key? key,
      required this.exerciseName,
      required this.desiredReps,
      required this.countedReps,
      this.workoutTracker})
      : super(key: key);
  final String exerciseName;
  final int desiredReps;
  final int countedReps;
  WorkoutTracker? workoutTracker;

  @override
  RestState createState() => RestState();
}

class RestState extends State<RestPage> {
  int _maxSeconds = 60;
  int _seconds = 60;
  late bool _isRunning;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _isRunning = true;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _isRunning = true;
        if (_seconds > 0) {
          _seconds--;
        } else {
          stopTimer();
          nextExercise();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      _isRunning = false;
    });
    timer?.cancel();
  }

  void nextExercise() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => RepCountingPage(
                  exerciseType: widget.workoutTracker!.exercise,
                  reps: widget.workoutTracker!.reps,
                  workoutTracker: widget.workoutTracker,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: PuioioAppBar.getAppBar(context, Colors.transparent, false),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(15),
            child: AppButton(
                buttonText: 'Skip Rest',
                buttonTextColor: Colors.white,
                buttonColor: Theme.of(context).colorScheme.primary,
                callback: nextExercise)),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(
            height: 20,
          ),
          buildTimer(),
          const SizedBox(height: 30),
          Expanded(child: buildNextContent())
        ]));
  }

  Widget buildTimer() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'REST',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
            const SizedBox(height: 15),
            Text(
              '${(Duration(seconds: _seconds).inMinutes).toString().padLeft(2, '0')}:${(Duration(seconds: _seconds).inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                  fontSize: 80,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      if (_seconds > 15) {
                        setState(() {
                          _seconds = _seconds - 15;
                        });
                      } else {
                        setState(() {
                          _seconds = 0;
                        });
                      }
                    },
                    child: const Text('-15',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500))),
                _isRunning
                    ? IconButton(
                        icon: const Icon(Icons.pause,
                            color: Colors.black, size: 32),
                        onPressed: stopTimer)
                    : IconButton(
                        icon: const Icon(Icons.play_arrow,
                            color: Colors.black, size: 32),
                        onPressed: startTimer),
                GestureDetector(
                    onTap: () {
                      if (_maxSeconds < _seconds + 15) {
                        setState(() {
                          _maxSeconds = _seconds + 15;
                        });
                      }
                      setState(() {
                        _seconds = _seconds + 15;
                      });
                    },
                    child: const Text('+15',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500))),
              ],
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 20.0,
              animateFromLastPercent: true,
              animationDuration: _maxSeconds,
              percent: _seconds / _maxSeconds,
              barRadius: const Radius.circular(16),
              progressColor: Theme.of(context).colorScheme.primary,
            )
          ]),
        ));
  }

  Widget buildNextContent() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0))),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('NEXT',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey)),
                  const SizedBox(width: 10),
                  Text(
                      '${widget.workoutTracker!.index + 1}/${widget.workoutTracker!.workoutLength}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary)),
                ]),
                const SizedBox(height: 20),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/img/${widget.exerciseName}.png",
                                  width: 120)),
                          Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.workoutTracker!.exercise.name,
                                      style: const TextStyle(
                                          fontSize: 36,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Text('${widget.workoutTracker!.reps} reps',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400))
                                ],
                              ))
                        ],
                      ),
                    ]),
              ],
            )));
  }
}
