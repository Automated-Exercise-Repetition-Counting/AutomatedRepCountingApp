import 'package:flutter/foundation.dart';

extension TitleCaseName on Enum {
  String get titleName =>
      describeEnum(this)[0].toUpperCase() +
      describeEnum(this).substring(1).toLowerCase();
}
