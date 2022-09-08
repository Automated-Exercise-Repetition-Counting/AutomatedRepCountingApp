import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:google_ml_kit_example/automatic_rep_counter/optical_flow/optical_flow_calculator.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'camera_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  final AutomaticRepCounter repCounter;
  PoseDetectorView({required this.repCounter});
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  late final AutomaticRepCounter _repCounter;
  final OpticalFlowCalculator _opticalFlowCalculator =
      OpticalFlowCalculator(yOnly: true);
  OpticalFlowDirection _flowDirection = OpticalFlowDirection.none;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _repCounter = widget.repCounter;
    _repCounter.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    int reps = _repCounter.reps; // TODO do something with this
    return Stack(
      children: <Widget>[
        CameraView(
          title: 'Pose Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: (InputImage inputImage, {CameraImage? cameraImage}) {
            processImage(inputImage, cameraImage);
          },
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reps: $reps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Squat Phase: ${_repCounter.phase}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text("Flow Direction: $_flowDirection",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  Future<void> processImage(
      InputImage inputImage, CameraImage? cameraImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    if (cameraImage != null) {
      OpticalFlowDirection newDirection = _opticalFlowCalculator.determineFlow(
          cameraImage, inputImage.inputImageData!.imageRotation.rawValue);

      if (newDirection != _flowDirection) {
        setState(() {
          _flowDirection = newDirection;
        });
      }
    }

    _repCounter.updateRepCount(
      poses,
      _flowDirection,
    );
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
