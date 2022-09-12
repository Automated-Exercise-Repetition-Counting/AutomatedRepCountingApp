/*
 * Hyperparameters for Automatic Rep Counter
 */

/// number of unconfident pose detections before switching
/// from pose detection to Optical Flow
const int switchToOFThreshold = 10;

/*
 * Pose Detection Hyperparams
 */

/// Minimum likelihood of a keypoint being in the image
const double minPoseLikelihoodPD = 0.9;

/// Sliding window size
const double windowSizePD = 3;

/// Amount of movement between detections to be considered jumping points
double jumpThresholdPD = 100;

/* 
 * Optical Flow Hyperparams
 */

/// number of frames to skip before calculating optical flow
const int msDelayBetweenExecutionsOF = 40;

/// Threshold to classify points as moving
const double movementThresholdOF = 5.0;

/// Sliding window size
const int windowSizeOF = 15;

/*
 * Exercise Hyperparams
 */

/// Pull Up Thresholds
const double squatLowerAngle = 130; // degrees
const double squatUpperAngle = 150; // degrees

/// Pull Up Thresholds
const double pullUpLowerAngle = 100; // degrees
const double pullUpUpperAngle = 150; // degrees

/// Push Up Thresholds
const double pushUpLowerAngle = 130; // degrees
const double pushUpUpperAngle = 150; // degrees
