import 'package:flutter/material.dart';

class Index extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void set(int index) {
    _index = index;
    notifyListeners();
  }
}
