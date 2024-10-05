import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  void updateProfile(){
    notifyListeners();
  }
}