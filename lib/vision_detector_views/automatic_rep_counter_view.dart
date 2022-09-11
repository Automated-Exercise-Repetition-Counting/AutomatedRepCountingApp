import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:puioio/automatic_rep_counter/automatic_rep_counter.dart';
import 'package:puioio/automatic_rep_counter/optical_flow/optical_flow_calculator.dart';

import 'camera_view.dart';
import 'painters/pose_painter.dart';

class AutomaticRepCounterView extends StatefulWidget {
  final AutomaticRepCounter repCounter;
  const AutomaticRepCounterView({Key? key, required this.repCounter})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AutomaticRepCounterViewState();
}

class _AutomaticRepCounterViewState extends State<AutomaticRepCounterView> {
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
    return Stack(
      children: <Widget>[
        CameraView(
          customPaint: _customPaint,
          text: _text,
          onImage: (InputImage inputImage, {CameraImage? cameraImage}) {
            processImage(inputImage, cameraImage);
          },
        ),
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
