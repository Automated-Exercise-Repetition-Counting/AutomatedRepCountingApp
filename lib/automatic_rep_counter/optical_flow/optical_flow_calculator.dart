import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:native_opencv/native_opencv.dart';

class OpticalFlowCalculator {
  NativeOpencv? _nativeOpencv;
  final List<OpticalFlowDirection> _directions = [];

  Float32List? _detect(CameraImage image, int rotation) {
    // On Android the image format is YUV and we get a buffer per channel,
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    // the entire image
    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;

    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }
    // make sure we have a detector
    if (_nativeOpencv == null) {
      _nativeOpencv = NativeOpencv();
      _nativeOpencv!.initCalculator(
          image.width, image.height, rotation, yBuffer, uBuffer, vBuffer);
      return null;
    } else {
      Float32List res = _nativeOpencv!.opticalFlowIteration(
          image.width, image.height, rotation, yBuffer, uBuffer, vBuffer);
      return res;
    }
  }

  OpticalFlowDirection determineFlow(CameraImage image, int rotation) {
    Float32List? res = _detect(image, rotation);
    bool invalidResult =
        res == null || res.length != 2 || res[0].isNaN || res[1].isNaN;
    if (invalidResult) {
      return OpticalFlowDirection.none;
    }
    double x = res[0];
    double y = res[1];

    double movementThreshold = 2.0;
    OpticalFlowDirection currentDirection = OpticalFlowDirection.stationary;
    // calculate optical flow

    if (x.abs() > movementThreshold || y.abs() > movementThreshold) {
      if (x.abs() > y.abs()) {
        if (x > 0) {
          currentDirection = OpticalFlowDirection.right;
        } else {
          currentDirection = OpticalFlowDirection.left;
        }
      } else {
        if (y > 0) {
          currentDirection = OpticalFlowDirection.down;
        } else {
          currentDirection = OpticalFlowDirection.up;
        }
      }
    }

    // add to list
    _directions.insert(0, currentDirection);

    Map<OpticalFlowDirection, int> directionCount = {};

    for (OpticalFlowDirection direction in _directions) {
      directionCount[direction] = (directionCount[direction] ?? 0) + 1;
    }

    // remove old directions
    _directions.removeLast();

    // return max direction
    return directionCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

enum OpticalFlowDirection { up, down, left, right, stationary, none }
