import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  int buttonNavigationBarIndex = 0;

  int get bnbIndex => buttonNavigationBarIndex;

  set bnbIndex(int i){
    buttonNavigationBarIndex = i;
    notifyListeners();
  }
}