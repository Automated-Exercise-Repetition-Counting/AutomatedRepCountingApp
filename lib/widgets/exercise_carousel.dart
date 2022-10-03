import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/pull_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/push_up_exercise.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercises/squat_exercise.dart';
import 'package:puioio/models/index.dart';
import 'indicator.dart';

class ExerciseCarousel extends StatefulWidget {
  const ExerciseCarousel({Key? key, required this.exerciseIndex})
      : super(key: key);
  final Index exerciseIndex;

  @override
  ExerciseCarouselState createState() => ExerciseCarouselState();
}

class ExerciseCarouselState extends State<ExerciseCarousel> {
  final CarouselController _controller = CarouselController();
  final List<Exercise> _exerciseTypes = [
    SquatExercise(),
    PullUpExercise(),
    PushUpExercise()
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SingleChildScrollView(
        child: CarouselSlider(
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  widget.exerciseIndex.set(index);
                });
              },
              enlargeCenterPage: true,
              viewportFraction: 0.6,
              height: 220),
          items: _exerciseTypes
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
                        child: Image.asset('assets/img/${item.name}.png',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 35),
                                child: Text(item.name.toString(),
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
          child: Indicator(
              dotsCount: _exerciseTypes.length, index: widget.exerciseIndex)),
    ]);
  }
}
