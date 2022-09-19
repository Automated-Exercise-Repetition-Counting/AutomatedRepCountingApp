import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class HelpPages extends StatefulWidget {
  const HelpPages({Key? key}) : super(key: key);

  @override
  State<HelpPages> createState() => _HelpPagesState();
}

class _HelpPagesState extends State<HelpPages> {
  int pageIndex = 0;
  // import vectors to use in the app
  List<String> images = [
    "select_workout.png",
    "time_workouts.png",
    "count_reps.png"
  ];
  List<String> titles = [
    "Select an exercise and the number of reps from the Quick Start page.",
    "Get setup as the timer counts down. Make sure your whole body is visible in the preview!",
    "Complete your repetitions! Your set will automatically complete when you reach your target reps."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox.shrink(),
            buildTitle(context),
            buildHelpPage(context),
            DotsIndicator(
              dotsCount: 3,
              position: pageIndex.toDouble(),
              decorator: DotsDecorator(
                  activeColor: Theme.of(context).colorScheme.onPrimary,
                  color: Theme.of(context).disabledColor),
            ),
          ],
        ),
        Positioned(
          top: 50,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "HOW TO USE",
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Pūioio",
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            textAlign: TextAlign.center,
          ),
        ]);
  }

  Widget buildHelpPage(BuildContext context) {
    return SizedBox.square(
      dimension: MediaQuery.of(context).size.width,
      child: PageView(
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          getHelpPage(context, 0),
          getHelpPage(context, 1),
          getHelpPage(context, 2),
        ],
      ),
    );
  }

  Widget getHelpPage(BuildContext context, int pageIndex) {
    Image image = Image.asset(
      "assets/img/${images[pageIndex]}",
      fit: BoxFit.contain,
    );
    String title = titles[pageIndex];
    return Column(
      children: [
        // vector image
        Expanded(
          child: image,
        ),
        // text
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.125),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
