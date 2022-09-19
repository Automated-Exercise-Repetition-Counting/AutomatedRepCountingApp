import 'package:flutter/material.dart';
import 'package:puioio/models/index.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/app_button.dart';
import 'package:puioio/widgets/indicator.dart';
import 'package:puioio/widgets/workout_result_page_two.dart';
import 'package:puioio/widgets/workout_result_page_one.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';

class FinishedWorkoutPage extends StatefulWidget {
  FinishedWorkoutPage({Key? key, this.workoutTracker}) : super(key: key);
  WorkoutTracker? workoutTracker;

  @override
  FinishedWorkoutState createState() => FinishedWorkoutState();
}

class FinishedWorkoutState extends State<FinishedWorkoutPage> {
  final Index _activePage = Index();
  @override
  Widget build(BuildContext context) {
    final PageController _controller = PageController();

    final completedExercises = widget.workoutTracker?.completedExerciseList;
    final int numOfExercises = completedExercises!.length;
    List<Widget> _pages = [
      PageOne(workoutTracker: widget.workoutTracker),
    ];

    for (int i = 0; i < numOfExercises; i += 3) {
      _pages.add(PageTwo(
          exerciseList: completedExercises.getRange(
              i, i + 3 > numOfExercises ? numOfExercises : i + 3)));
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PuioioAppBar.getAppBar(context, Colors.transparent),
        body: Center(
            child: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _activePage.set(index));
                },
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _pages[index % _pages.length];
                },
              )),
          Padding(
              padding: const EdgeInsets.only(top: 350),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Indicator(
                      dotsCount: _pages.length,
                      index: _activePage,
                    ),
                    const SizedBox(height: 30, width: double.infinity),
                    AppButton(
                        buttonText: 'Done',
                        buttonTextColor: Colors.white,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        callback: () => {Navigator.pop(context)})
                  ])),
        ])));
  }
}
