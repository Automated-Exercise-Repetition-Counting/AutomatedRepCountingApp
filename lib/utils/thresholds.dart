import 'dart:math';

import 'package:automated_repetition_counting/rep_counting/movement_phase.dart';
import 'package:automated_repetition_counting/rep_counting/movenet_keypoints.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Thresholds {
  /// Returns the movement phase of the current frame based on the detections.
  static MovementPhase thresholdSquat(Pose pose) {
    List<num> kneeAngles = _squatAngles(pose);
    num leftKneeAngle = kneeAngles[0];
    num rightKneeAngle = kneeAngles[1];

    // internal angle of the left hip, left knee, and left ankle
    num hipKneeAnkleAngleInternalThreshold = 110 * pi / 180; // 180-70 degrees

    if (leftKneeAngle < hipKneeAnkleAngleInternalThreshold &&
        rightKneeAngle < hipKneeAnkleAngleInternalThreshold) {
      return MovementPhase.bottom;
    } else {
      return MovementPhase.top;
    }
  }

  /// Returns the angles of the left and right knees,
  /// in the format [leftKneeAngle, rightKneeAngle].
  static List<double> _squatAngles(Pose pose) {
    if (pose.landmarks.isEmpty) {
      throw Exception('No pose detected');
    }
    try {
      PoseLandmark leftKnee = pose.landmarks[MovenetKeypoints.leftKnee]!;
      PoseLandmark rightKnee = pose.landmarks[MovenetKeypoints.rightKnee]!;
      PoseLandmark leftAnkle = pose.landmarks[MovenetKeypoints.leftAnkle]!;
      PoseLandmark rightAnkle = pose.landmarks[MovenetKeypoints.rightAnkle]!;
      PoseLandmark leftHip = pose.landmarks[MovenetKeypoints.leftHip]!;
      PoseLandmark rightHip = pose.landmarks[MovenetKeypoints.rightHip]!;
      // Calculate the angle between the left hip, left knee, and left ankle
      double leftHipKneeAnkleAngle =
          _lawOfCosines(leftKnee, leftHip, leftAnkle);

      // Calculate the angle between the right hip, right knee, and right ankle
      double rightHipKneeAnkleAngle =
          _lawOfCosines(rightKnee, rightHip, rightAnkle);
      return [leftHipKneeAnkleAngle, rightHipKneeAnkleAngle];
    } catch (NullThrownError) {
      throw Exception('Unable to calculate pose location');
    }
  }

  /// Calculates the angle between three points,
  /// as per https://stackoverflow.com/a/1211243/16521305
  static double _lawOfCosines(
      PoseLandmark middlePose, PoseLandmark endPose, PoseLandmark endPose2) {
    double p12 = _distanceBetweenPoints(
        middlePose.x, middlePose.y, endPose.x, endPose.y);
    double p13 = _distanceBetweenPoints(
        middlePose.x, middlePose.y, endPose2.x, endPose2.y);
    double p23 =
        _distanceBetweenPoints(endPose.x, endPose.y, endPose2.x, endPose2.y);

    // returns the dot product of the two vectors
    num numerator = pow(p12, 2) + pow(p13, 2) - pow(p23, 2);
    double denominator = 2 * p12 * p13;

    return acos(numerator / denominator);
  }

  /// Calculates the distance between two points.
  static double _distanceBetweenPoints(x1, y1, x2, y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }
}
