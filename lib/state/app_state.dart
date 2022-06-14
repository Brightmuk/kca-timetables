import 'dart:async';

import 'package:excel_reader/models/unit_class_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{

  void reload(){
    notifyListeners();
  }
  
}