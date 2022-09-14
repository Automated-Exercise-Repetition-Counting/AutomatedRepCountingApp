import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:lottie/lottie.dart';

import 'package:puioio/automatic_rep_counter/optical_flow/optical_flow_calculator.dart';
import 'package:puioio/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:puioio/automatic_rep_counter/exercise/exercise.dart';
import 'package:puioio/vision_detector_views/camera_view.dart';
import 'package:puioio/vision_detector_views/painters/pose_painter.dart';
import 'package:puioio/utils/utils.dart';

import 'results_page.dart';

class RepCountingPage extends StatefulWidget {
  const RepCountingPage(
      {Key? key, required this.reps, required this.exerciseType})
      : super(key: key);
  final int reps;
  final Exercise exerciseType;

  @override
  RepCountingPageState createState() => RepCountingPageState();
}

class RepCountingPageState extends State<RepCountingPage> {
  late final AutomaticRepCounter _repCounter;
  static const _maxSeconds = 10;
  int _seconds = _maxSeconds;
  Timer? timer;

  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  final OpticalFlowCalculator _opticalFlowCalculator =
      OpticalFlowCalculator(yOnly: true);
  OpticalFlowDirection _flowDirection = OpticalFlowDirection.none;
  bool _isInFrame = true;

  bool get _timerActive => timer?.isActive ?? true;

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
  }

  @override
  void deactivate() {
    _canProcess = false;
    super.deactivate();
  }

  @override
  void activate() {
    _canProcess = true;
    super.activate();
  }

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_seconds > 1) {
          _seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void goBack() {
    stopTimer();
    Navigator.pop(context);
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
                      buildDisplay(),
                    ],
                  ),
                ),
        ],
      )));

  Widget buildTimer() {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
            padding: EdgeInsets.symmetric(vertical: 20),
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
                fontWeight: FontWeight.w300,
                height: 1.2),
          )),
        ]),
      )),
    );
  }

  void completeExercise() {
    _canProcess = false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ResultsPage(
              exerciseName: widget.exerciseType.name,
              desiredReps: widget.reps,
              countedReps: _repCounter.reps)),
    );
  }

  Widget buildButtons() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.6),
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
          backgroundColor: Colors.white.withOpacity(0.6),
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
          color: Colors.white.withOpacity(0.6),
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
                          fontSize: 40,
                          fontWeight: FontWeight.w300)),
                  Text(
                    _repCounter.phase.titleName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            const Spacer(),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_repCounter.reps.toString(),
                      style: Theme.of(context).textTheme.headline3),
                  Text('out of ${widget.reps}',
                      style: Theme.of(context).textTheme.subtitle2),
                ]),
          ]),
        )),
      ),
    );
  }

  Future<void> processImage(
      InputImage inputImage, CameraImage? cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    if (cameraImage != null) {
      OpticalFlowDirection newDirection = _opticalFlowCalculator.determineFlow(
          cameraImage, inputImage.inputImageData!.imageRotation.rawValue);
      _flowDirection = newDirection;
    }

    if (mounted) {
      if (!_timerActive) {
        _repCounter.updateRepCount(
          poses,
          _flowDirection,
        );

        if (_repCounter.reps >= widget.reps) {
          completeExercise();
        }
      }
      if (poses.isNotEmpty) {
        _isInFrame = _repCounter.isInFrame(poses.first);
      }
      setState(() {});
    }
    _isBusy = false;
  }
}
