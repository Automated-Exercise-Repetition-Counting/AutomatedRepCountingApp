import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:puioio/models/index.dart';

class Indicator extends StatefulWidget {
  const Indicator({Key? key, required this.index, required this.dotsCount})
      : super(key: key);
  final Index index;
  final int dotsCount;

  @override
  IndicatorState createState() => IndicatorState();
}

class IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: widget.dotsCount,
      position: widget.index.index.toDouble(),
      decorator: DotsDecorator(
        activeColor: Theme.of(context).colorScheme.primary,
        size: const Size.square(9.0),
        activeSize: const Size(18.0, 9.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
