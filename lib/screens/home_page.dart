import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:puioio/widgets/app_bar.dart';
import 'package:puioio/widgets/home_workout_card.dart';
import 'package:puioio/data/workout_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PuioioAppBar.getAppBar(context, Colors.transparent),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              buildHeader(),
              buildContentBox(context),
            ])));
  }

  Widget buildHeader() {
    return SizedBox(
      child: Image.asset("assets/img/Home-banner.png", height: 170),
    );
  }

  Widget buildContentBox(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('Kia ora!',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w500))),
            const SizedBox(
              height: 30,
            ),
            buildWorkout(context),
            const SizedBox(
              height: 150,
            ),
          ],
        ));
  }

  Widget buildWorkout(BuildContext context) {
    final CarouselController _controller = CarouselController();
    final workoutList = [legDay, pullDay, pushDay];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text('Recommended Workouts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
              height: 220, viewportFraction: 0.9, enableInfiniteScroll: false),
          items: workoutList
              .map(
                (workout) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: HomeWorkoutCard(
                      workoutTitle: workout.workoutTitle,
                      workoutSubtitle: workout.workoutSubtitle,
                      exerciseList: workout.exerciseList,
                      workoutImg: workout.workoutImg,
                      numberOfStars: workout.numberOfStars),
                ),
              )
              .toList(),
          carouselController: _controller,
        ),
      ],
    );
  }
}
