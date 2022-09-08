import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:native_opencv/native_opencv.dart';

class OpticalFlowCalculator {
  NativeOpencv? _nativeOpencv;

  Float32List? detect(CameraImage image) {
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
      _nativeOpencv!
          .initCalculator(image.width, image.height, yBuffer, uBuffer, vBuffer);
      return null;
    } else {
      Float32List res = _nativeOpencv!.opticalFlowIteration(
          image.width, image.height, yBuffer, uBuffer, vBuffer);
      return res;
    }
  }
}
