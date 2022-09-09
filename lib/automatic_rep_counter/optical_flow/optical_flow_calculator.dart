import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:native_opencv/native_opencv.dart';
import '../hyperparameters.dart';

/// Calculates the optical flow from given [CameraImage]s.
/// The optical flow is calculated using the Lucas-Kanade method.
/// This is achieved through the use of the [NativeOpencv] plugin,
/// which is a wrapper around the OpenCV library.
class OpticalFlowCalculator {
  NativeOpencv? _nativeOpencv;
  final List<OpticalFlowDirection> _directions = [];
  final bool xOnly;
  final bool yOnly;

  bool _canCalculate = true;
  int _lastExecution = DateTime.now().millisecondsSinceEpoch;

  OpticalFlowCalculator({this.yOnly = false, this.xOnly = false}) {
    assert(!(yOnly && xOnly), "Can't set both yOnly and xOnly");
  }

  void dispose() {
    _canCalculate = false;
  }

  /// Calculates the optical flow from the given [CameraImage].
  /// Uses the NativeOpencv plugin to calculate the optical flow.
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

  /// Calculates the optical flow from the given [CameraImage].
  /// Returns the [OpticalFlowDirection] of the movement between the
  /// current and previous [CameraImage].
  /// If the movement is too small or invalid, returns
  /// [OpticalFlowDirection.none].
  OpticalFlowDirection determineFlow(CameraImage image, int rotation) {
    int curTime = DateTime.now().millisecondsSinceEpoch;

    if (curTime - _lastExecution < msDelayBetweenExecutionsOF) {
      return OpticalFlowDirection.none;
    }
    _lastExecution = curTime;

    if (!_canCalculate) {
      return OpticalFlowDirection.none;
    }

    Float32List? res = _detect(image, rotation);
    bool invalidResult = res == null ||
        res.length != 2 ||
        res[0].isNaN ||
        res[1].isNaN ||
        res[0].isInfinite ||
        res[1].isInfinite;
    if (invalidResult) {
      return OpticalFlowDirection.none;
    }
    double x = res[0];
    double y = res[1];

    OpticalFlowDirection currentDirectionX = OpticalFlowDirection.stationary;
    OpticalFlowDirection currentDirectionY = OpticalFlowDirection.stationary;

    if (x.abs() > movementThresholdOF) {
      currentDirectionX =
          x > 0 ? OpticalFlowDirection.right : OpticalFlowDirection.left;
    }

    if (y.abs() > movementThresholdOF) {
      currentDirectionY =
          y > 0 ? OpticalFlowDirection.down : OpticalFlowDirection.up;
    }

    if (xOnly) {
      _directions.add(currentDirectionX);
    } else if (yOnly) {
      _directions.add(currentDirectionY);
    } else if (currentDirectionX != currentDirectionY) {
      if (currentDirectionX == OpticalFlowDirection.stationary) {
        _directions.add(currentDirectionY);
      } else if (currentDirectionY == OpticalFlowDirection.stationary) {
        _directions.add(currentDirectionX);
      } else {
        _directions.add(currentDirectionX);
        _directions.add(currentDirectionY);
      }
    }

    Map<OpticalFlowDirection, int> directionCount = {};

    for (OpticalFlowDirection direction in _directions) {
      directionCount[direction] = (directionCount[direction] ?? 0) + 1;
    }

    if (_directions.length > windowSizeOF) {
      _directions.removeAt(0);
    }

    // return max direction
    return directionCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

enum OpticalFlowDirection { up, down, left, right, stationary, none }
