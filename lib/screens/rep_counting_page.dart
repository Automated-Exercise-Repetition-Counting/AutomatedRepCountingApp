import 'package:flutter/material.dart';
import '../rep_counting/automatic_rep_counter.dart';
import '../rep_counting/exercise_type.dart';
import '../rep_counting/movement_phase.dart';
import '../vision_detector_views/pose_detector_view.dart';
import 'results.dart';

class CameraPage extends StatefulWidget {
  CameraPage({Key? key, required this.reps, required this.exerciseType})
      : super(key: key);
  final int reps;
  final ExerciseType exerciseType;

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  late final AutomaticRepCounter _repCounter;
  int _countedReps = 0;

  @override
  void initState() {
    super.initState();
    _repCounter = AutomaticRepCounter(exerciseType: ExerciseType.squat);
    _repCounter.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _countedReps = _repCounter.reps;
    return Scaffold(
        body: Stack(
      children: [
        // cameraWidget(context),
        PoseDetectorView(repCounter: _repCounter),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      iconSize: 30,
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultsPage(
                                    desiredReps: widget.reps,
                                    countedReps: _countedReps,
                                    exerciseType: widget.exerciseType)),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Container(
                  width: 380,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(_countedReps.toString(),
                              style: Theme.of(context).textTheme.headline2),
                          Text('out of ${widget.reps}',
                              style: Theme.of(context).textTheme.subtitle2),
                          Text(
                            "Movement Phase: ${_repCounter.avgMovementPhase == MovementPhase.top ? "Top" : "Bottom"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
