import 'package:flutter/material.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/screens/start_workout_page.dart';
import 'package:puioio/widgets/star_rating.dart';

class HomeWorkoutCard extends StatelessWidget {
  const HomeWorkoutCard(
      {Key? key,
      required this.workoutTitle,
      required this.workoutSubtitle,
      required this.exerciseList,
      this.workoutImg,
      this.numberOfStars})
      : super(key: key);
  final String workoutTitle;
  final String workoutSubtitle;
  final List<ExerciseModel> exerciseList;
  final String? workoutImg;
  final int? numberOfStars;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartWorkoutPage(
                      workoutTitle: workoutTitle, exerciseList: exerciseList)));
        },
        child: Container(
          width: 315,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            numberOfStars == null
                                ? StarRating(
                                    numberOfFilledStars: numberOfStars!)
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                              child: Text(workoutTitle,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(7, 5, 0, 0),
                                child: Text(workoutSubtitle,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))),
                          ]))),
              workoutImg!.isEmpty
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        workoutImg!,
                        width: 200,
                      ))
            ],
          ),
        ));
  }
}
