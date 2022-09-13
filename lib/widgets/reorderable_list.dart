import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ReorderableExerciseList extends StatefulWidget {
  const ReorderableExerciseList({Key? key, required this.exerciseList})
      : super(key: key);
  final List<ExerciseModel> exerciseList;

  @override
  ReorderableExerciseListState createState() => ReorderableExerciseListState();
}

class ReorderableExerciseListState extends State<ReorderableExerciseList> {
  @override
  Widget build(BuildContext context) {
    List<ExerciseModel> exerciseList = widget.exerciseList;
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: [
        for (int index = 0; index < exerciseList.length; index += 1)
          Column(key: Key('$index'), children: [
            ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                        'assets/img/${exerciseList[index].exercise.name}.png')),
                tileColor: Colors.white,
                title: Text(exerciseList[index].exercise.name),
                subtitle: Text('${exerciseList[index].reps} reps'),
                trailing: const Icon(Icons.drag_handle),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                contentPadding: const EdgeInsets.all(10)),
            const SizedBox(
              height: 10,
            )
          ]),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          final ExerciseModel item = exerciseList.removeAt(oldIndex);
          exerciseList.insert(newIndex, item);
        });
      },
    );
  }
}
