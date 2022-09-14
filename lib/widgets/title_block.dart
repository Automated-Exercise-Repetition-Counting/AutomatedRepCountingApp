import 'package:flutter/material.dart';

class TitleBlock extends StatefulWidget {
  const TitleBlock({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  final String title;
  final String subtitle;

  @override
  TitleBlockState createState() => TitleBlockState();
}

class TitleBlockState extends State<TitleBlock> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Text(
          widget.subtitle,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
