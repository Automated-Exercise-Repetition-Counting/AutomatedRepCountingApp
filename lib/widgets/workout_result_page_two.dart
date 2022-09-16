import 'package:flutter/material.dart';
import 'package:puioio/models/exercise_model.dart';
import 'package:puioio/widgets/title_block.dart';

class PageTwo extends StatelessWidget {
  PageTwo({Key? key, this.exerciseList}) : super(key: key);
  Iterable<ExerciseModel>? exerciseList;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const TitleBlock(title: 'Workout', subtitle: 'Summary'),
      const SizedBox(height: 20),
      SizedBox(
          width: 300,
          child: Column(
              children: exerciseList!
                  .map((item) => Card(
                      color: Colors.transparent,
                      elevation: 0,
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/img/${item.exercise.name}.png')),
                          tileColor: Colors.white,
                          title: Text(item.exercise.name,
                              style: const TextStyle(fontSize: 24)),
                          trailing: Column(
                            children: [
                              Text('${item.reps}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w500)),
                              const Text('Reps',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 15, 20, 15))))
                  .toList()))
    ]));
  }
}
