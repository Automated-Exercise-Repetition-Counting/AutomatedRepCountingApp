import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  const StarRating({Key? key, required this.numberOfFilledStars})
      : super(key: key);
  final int numberOfFilledStars;

  @override
  Widget build(BuildContext context) {
    final List<int> stars = [1, 2, 3, 4, 5];
    return Row(
      children: stars
          .map((e) => e <= numberOfFilledStars
              ? Icon(Icons.star_rounded,
                  color: Theme.of(context).colorScheme.primary)
              : const Icon(Icons.star_rounded, color: Colors.grey))
          .toList(),
    );
  }
}
