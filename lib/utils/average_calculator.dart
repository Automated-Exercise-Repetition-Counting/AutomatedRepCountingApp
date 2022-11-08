import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseAverageCalculator {
  double x = 0;
  double y = 0;
  double z = 0;
  final AverageCalculator xAverageCalculator = AverageCalculator();
  final AverageCalculator yAverageCalculator = AverageCalculator();
  final AverageCalculator zAverageCalculator = AverageCalculator();

  PoseLandmark getAverageLandmark(PoseLandmark poseLandmark) {
    xAverageCalculator.add(poseLandmark.x);
    yAverageCalculator.add(poseLandmark.y);
    zAverageCalculator.add(poseLandmark.z);

    x = xAverageCalculator.getAverage();
    y = yAverageCalculator.getAverage();
    z = zAverageCalculator.getAverage();

    PoseLandmark poseLandmarkAverage = PoseLandmark(
      x: x,
      y: y,
      z: z,
      type: poseLandmark.type,
      likelihood: poseLandmark.likelihood,
    );

    return poseLandmarkAverage;
  }
}

class AverageCalculator {
  static const int _maxValues = 20;
  static const int _smoothing = 30;
  final List<double> _values = [];
  double? prevEMA;

  AverageCalculator();

  void add(double value) {
    _values.add(value);
    if (_values.length > _maxValues) {
      _values.removeAt(0);
    }
  }

  double _getSMA() {
    double sum = 0;
    for (double value in _values) {
      sum += value;
    }
    return sum / _values.length;
  }

  double _getEMA() {
    double avg = 0;
    if (prevEMA == null) {
      avg = _getSMA();
    } else {
      double k = _smoothing / (_values.length + 1);
      avg = _values.last * k + prevEMA! * (1 - k);
    }
    prevEMA = avg;
    return avg;
  }

  double getAverage() {
    if (_values.isEmpty) {
      return 0;
    }
    if (_values.length < _maxValues) {
      return _getSMA();
    }
    return _getEMA();
  }
}
