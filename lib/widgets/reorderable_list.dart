import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: [
        for (int index = 0; index < exerciseList.length; index += 1)
          Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      exerciseList.remove(exerciseList[index]);
                      setState(() {});
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: ListTile(
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/img/${exerciseList[index].exercise.name}.png',
                          height: 150,
                        )),
                    tileColor: Colors.white,
                    title: Text(exerciseList[index].exercise.name,
                        style: const TextStyle(fontSize: 20)),
                    subtitle: Text('${exerciseList[index].reps} reps'),
                    trailing: ReorderableDragStartListener(
                        index: index, child: const Icon(Icons.drag_handle)),
                    contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
              )),
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
