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
    "select_workout.svg",
    "time_workout.svg",
    "count_reps.svg"
  ];
  List<String> titles = [
    "Select an exercise and the number of reps from the Quick Start page.",
    "Get setup as the timer counts down. Make sure your whole body is visible in the preview!",
    "Complete your repetitions! Your set will automatically complete when you reach your target reps."
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context),
        buildHelpPage(context, pageIndex),
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "HOW TO USE",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          Text(
            "Pūioio",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ]);
  }

  Widget buildHelpPage(BuildContext context, int pageIndex) {
    return Expanded(
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
      "assets/vectors/${images[pageIndex]}",
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
        Text(title, style: Theme.of(context).textTheme.bodyText1),
      ],
    );
  }
}
