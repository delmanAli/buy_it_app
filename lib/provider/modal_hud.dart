import 'package:flutter/material.dart';

class ModalHud with ChangeNotifier {
  bool isLoading = false;

  changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
