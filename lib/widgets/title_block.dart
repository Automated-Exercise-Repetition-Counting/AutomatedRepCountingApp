import 'package:flutter/material.dart';

class TitleBlock extends StatelessWidget {
  const TitleBlock({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
