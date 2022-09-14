import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              const SizedBox(
                height: 80,
              ),
              buildHeader(),
              buildContentBox(),
            ])));
  }

  Widget buildHeader() {
    return SizedBox(
      child: Image.asset("assets/img/Home-banner.png", height: 170),
    );
  }

  Widget buildContentBox() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kia ora!',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 20,
                ),
                buildWorkout(),
                const SizedBox(
                  height: 100,
                ),
              ],
            )));
  }

  Widget buildWorkout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recommended Workout',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Container(
          width: 315,
          height: 180,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Legs Killer',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text('3 exercises | 9 sets',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))),
                          ]))),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    "assets/img/Leg-workout.png",
                    width: 220,
                  ))
            ],
          ),
        )
      ],
    );
  }
}
