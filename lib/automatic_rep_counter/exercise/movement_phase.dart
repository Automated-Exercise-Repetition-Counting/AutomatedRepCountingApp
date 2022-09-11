// Enum class to represent the different movement phases, top and bottom
import 'package:flutter/foundation.dart';

enum MovementPhase {
  top,
  intermediate,
  bottom,
}

extension MovementPhaseExtension on MovementPhase {
  String get name =>
      describeEnum(this)[0].toUpperCase() +
      describeEnum(this).substring(1).toLowerCase();
}
