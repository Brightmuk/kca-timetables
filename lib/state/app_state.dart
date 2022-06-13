import 'dart:async';

import 'package:excel_reader/models/unit_class_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{

  final List<UnitClass> allClasses = [];
  final List<UnitClass> todayClasses = [];
  

  void deleteRecord(String recordId){
    allClasses.removeWhere((r) => r.unitCode==recordId);
    todayClasses.removeWhere((r) => r.unitCode==recordId);
    notifyListeners();
  }
}