import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puioio/icons/custom_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RestPage extends StatefulWidget {
  const RestPage(
      {Key? key,
      required this.exerciseName,
      required this.desiredReps,
      required this.countedReps})
      : super(key: key);
  final String exerciseName;
  final int desiredReps;
  final int countedReps;

  @override
  RestState createState() => RestState();
}

class RestState extends State<RestPage> {
  int _maxSeconds = 60;
  int _seconds = 60;
  late bool isRunning;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    isRunning = true;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        isRunning = true;
        if (_seconds > 0) {
          _seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(
            height: 20,
          ),
          buildTimer(),
          const SizedBox(height: 50),
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
                isRunning
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
            const SizedBox(height: 15),
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
                Text('NEXT 1/3',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary)),
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
                                  Text(widget.exerciseName,
                                      style: const TextStyle(
                                          fontSize: 36,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                  Text('${widget.desiredReps} reps',
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
