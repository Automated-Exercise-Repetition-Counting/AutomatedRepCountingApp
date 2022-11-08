import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:puioio/automatic_rep_counter/exercise/state_machines/vertical_exercise_phase.dart';
import 'package:puioio/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/screens/finished_workout_page.dart';
import 'package:puioio/screens/rest_page.dart';
import 'package:puioio/utils/average_calculator.dart';
import 'package:puioio/vision_detector_views/camera_view.dart';
import 'package:puioio/vision_detector_views/painters/pose_painter.dart';
import 'package:puioio/workout_tracker/workout_tracker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'results_page.dart';
import 'package:wakelock/wakelock.dart';

class RepCountingPage extends StatefulWidget {
  RepCountingPage(
      {Key? key,
      required this.reps,
      required this.exerciseType,
      this.workoutTracker})
      : super(key: key);
  final int reps;
  final Exercise exerciseType;
  WorkoutTracker? workoutTracker;

  @override
  RepCountingPageState createState() => RepCountingPageState();
}

class RepCountingPageState extends State<RepCountingPage> {
  late final AutomaticRepCounter _repCounter;
  static const _maxSeconds = 10;
  int _seconds = _maxSeconds;
  Timer? countdownTimer;
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  late String elapsedTime;

  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  bool _isInFrame = true;

  bool get _timerActive => countdownTimer?.isActive ?? true;

  int phaseIndex = 0;
  List<VerticalExercisePhase> allPhases = [];
  final Map<PoseLandmarkType, PoseAverageCalculator> _poseAverageCalculators = {
    for (var e in PoseLandmarkType.values) e: PoseAverageCalculator()
  };

  @override
  void initState() {
    super.initState();
    _repCounter = AutomaticRepCounter(exercise: widget.exerciseType);
    _repCounter.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    startTimer();
    getPhases();
    // The following line will enable the Android and iOS wakelock.
    Wakelock.enable();
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    // The next line disables the wakelock again.
    Wakelock.disable();
    super.dispose();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          stopTimer();
          stopWatchTimer.onStartTimer();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      countdownTimer?.cancel();
    });
  }

  void goBack() {
    stopTimer();
    stopWatchTimer.onStopTimer();
    Navigator.pop(context);
  }

  void getPhases() {
    for (var phase in VerticalExercisePhase.values) {
      allPhases.add(phase);
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        goBack();
        return false;
      },
      child: Scaffold(
          body: Stack(
        children: [
          CameraView(
            customPaint: _customPaint,
            onImage: (InputImage inputImage, {CameraImage? cameraImage}) {
              processImage(inputImage, cameraImage);
            },
          ),
          (_repCounter.isPaused || !_isInFrame) && !_timerActive
              ? buildCountingPaused()
              : const SizedBox.shrink(),
          _timerActive
              ? buildTimer()
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0),
                  child: Column(
                    children: <Widget>[
                      buildButtons(),
                      const Spacer(),
                      buildPhaseIndicator(),
                      const Spacer(),
                      buildDisplay(),
                    ],
                  ),
                ),
        ],
      )));

  Widget buildPhaseIndicator() {
    for (var phase in allPhases) {
      if (_repCounter.phase == phase) {
        phase.index == 3 ? phaseIndex = 1 : phaseIndex = phase.index;
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Visibility(
          visible: _isInFrame,
          child: StepsIndicator(
              selectedStep: phaseIndex,
              nbSteps: 3,
              isHorizontal: false,
              lineLength: 100,
              undoneLineThickness: 3,
              doneLineThickness: 5,
              unselectedStepSize: 20,
              selectedStepSize: 30,
              doneStepSize: 20,
              selectedStepBorderSize: 3,
              selectedStepColorOut: Colors.white,
              selectedStepColorIn: Colors.white,
              selectedStepWidget: CircleAvatar(
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              unselectedStepColorIn: Colors.white,
              unselectedStepColorOut: Colors.white,
              unselectedStepBorderSize: 3,
              undoneLineColor: Colors.white,
              doneLineColor: Colors.white,
              doneStepColor: Colors.white))
    ]);
  }

  Widget buildTimer() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Ready in',
              style: TextStyle(fontSize: 36, color: Colors.white)),
          Text(
            '$_seconds',
            style: const TextStyle(fontSize: 136, color: Colors.white),
          ),
          !_isInFrame
              ? const SizedBox(
                  width: 250,
                  child: Text(
                    'Make sure your whole body is in frame!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        height: 1.2),
                  ),
                )
              : const SizedBox.shrink()
        ]),
      ),
    );
  }

  Widget buildCountingPaused() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
      child: Center(
          child: SizedBox(
        width: 250,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Stack(alignment: AlignmentDirectional.center, children: [
            const Icon(Icons.accessibility_rounded,
                color: Colors.white, size: 150),
            Lottie.asset("assets/lottie/scan.json", width: 150)
          ]),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("We've lost you!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
          const Flexible(
              child: Text(
            'Make sure your whole body is in frame, and the workout will automatically continue',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                height: 1.2),
          )),
        ]),
      )),
    );
  }

  Widget buildStopwatch() {
    return StreamBuilder<int>(
      stream: stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data;
        final minutes = StopWatchTimer.getDisplayTimeMinute(value!);
        final seconds = StopWatchTimer.getDisplayTimeSecond(value);
        final milliseconds = StopWatchTimer.getDisplayTimeMillisecond(value);
        elapsedTime = '$minutes:$seconds.$milliseconds';
        return Text(
          elapsedTime,
          style: const TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w400),
        );
      },
    );
  }

  void completeExercise() {
    _canProcess = false;
    stopWatchTimer.onStopTimer();
    widget.workoutTracker?.completedExercise(_repCounter.reps);
    (widget.workoutTracker != null)
        ? (widget.workoutTracker!.nextExercise())
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RestPage(
                        exerciseName: widget.exerciseType.name,
                        desiredReps: widget.reps,
                        countedReps: _repCounter.reps,
                        workoutTracker: widget.workoutTracker)),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FinishedWorkoutPage(
                          workoutTracker: widget.workoutTracker,
                        )))
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ResultsPage(
                    exerciseName: widget.exerciseType.name,
                    desiredReps: widget.reps,
                    countedReps: _repCounter.reps,
                    timeElapsed: elapsedTime)),
          );
  }

  Widget buildButtons() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              goBack();
            },
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(Icons.check),
            iconSize: 25,
            color: Colors.black,
            onPressed: completeExercise,
          ),
        ),
      ],
    );
  }

  Widget buildDisplay() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        width: 380,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.exerciseType.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.w500)),
                  // Text(
                  // _repCounter.phase.titleName,
                  //   style: const TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 5),
                  buildStopwatch(),
                ]),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(_repCounter.reps.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 76,
                          fontWeight: FontWeight.w400)),
                  Text(' / ${widget.reps}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w600)),
                ]),
          ]),
        )),
      ),
    );
  }

  Pose calculateWeightedAvg(Pose pose) {
    // performed weighted average of keypoints
    Map<PoseLandmarkType, PoseLandmark> landmarks = {};
    for (PoseLandmarkType landmarkType in PoseLandmarkType.values) {
      landmarks[landmarkType] = _poseAverageCalculators[landmarkType]!
          .getAverageLandmark(pose.landmarks[landmarkType]!);
    }
    Pose weightedPose = Pose(landmarks: landmarks);
    return weightedPose;
  }

  Future<void> processImage(
      InputImage inputImage, CameraImage? cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final poses = await _poseDetector.processImage(inputImage);
    final List<Pose> weightedAvgPoses = [];

    for (Pose pose in poses) {
      weightedAvgPoses.add(calculateWeightedAvg(pose));
    }

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(
          weightedAvgPoses,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }

    if (mounted) {
      if (!_timerActive) {
        _repCounter.updateRepCount(
          weightedAvgPoses,
        );

        if (_repCounter.reps >= widget.reps) {
          completeExercise();
        }
      }
      if (weightedAvgPoses.isNotEmpty) {
        _isInFrame = _repCounter.isInFrame(weightedAvgPoses.first);
      }
      setState(() {});
    }
    _isBusy = false;
  }
}
