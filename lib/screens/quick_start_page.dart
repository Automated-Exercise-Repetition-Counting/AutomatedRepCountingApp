import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'set_up_phone_page.dart';

class QuickStartPage extends StatefulWidget {
  const QuickStartPage({Key? key}) : super(key: key);

  @override
  QuickStartPageState createState() => QuickStartPageState();
}

class QuickStartPageState extends State<QuickStartPage> {
  final CarouselController _controller = CarouselController();
  final List<String> _exerciseNames = ['Squats', 'Pull-ups', 'Push-ups'];
  final List<Exercise> _exerciseTypes = [
    SquatExercise(),
    PullUpExercise(),
    PushUpExercise()
  ];
  var _reps = 1;
  int _chosenExerciseIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTitle(),
          buildCarousel(),
          buildRepSetter(),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'Quick Start',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Text(
          'Choose an Exercise',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  Widget buildCarousel() {
    return Column(children: [
      SingleChildScrollView(
        child: CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _chosenExerciseIndex = index;
                });
              },
              enlargeCenterPage: true,
              viewportFraction: 0.6,
              height: 220),
          items: _exerciseNames
              .map(
                (item) => ClipRRect(
                  borderRadius: BorderRadius.circular(30), // Image border
                  child: Stack(
                    children: [
                      Container(
                        foregroundDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Color.fromARGB(255, 72, 72, 72)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.2, 0.5, 1],
                          ),
                        ),
                        child: (Image.asset('assets/img/$item.png',
                            width: 250, height: 250, fit: BoxFit.fill)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 35),
                                child: Text(item.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.5,
                                        decoration: TextDecoration.none))),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          carouselController: _controller,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: DotsIndicator(
          dotsCount: 3,
          position: _chosenExerciseIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: Theme.of(context).colorScheme.primary,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
    ]);
  }

  Widget buildRepSetter() {
    return Column(children: [
      Text('Select a number of reps',
          style: Theme.of(context).textTheme.subtitle2),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove),
              iconSize: 30,
              onPressed: () {
                setState(() {
                  if (_reps > 1) {
                    _reps -= 1;
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('$_reps',
                  style: const TextStyle(color: Colors.black, fontSize: 44)),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 30,
              onPressed: () {
                setState(() {
                  _reps += 1;
                });
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: buildButton(),
      ),
    ]);
  }

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.fromLTRB(70, 12, 70, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          side: BorderSide(
              width: 3, color: Theme.of(context).colorScheme.primary)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SetUpPage(
                    exerciseName: _exerciseNames[_chosenExerciseIndex],
                    reps: _reps,
                    exerciseType: _exerciseTypes[_chosenExerciseIndex],
                  )),
        );
      },
      child: const Text('Begin', style: TextStyle(fontSize: 20)),
    );
  }
}
