import 'dart:async';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppMode{examTimetable, classTimetable, none}

class MyAppState extends ChangeNotifier{

  AppMode _mode = AppMode.none;
  
  AppMode get appMode =>_mode;
  bool get isClassMode =>_mode==AppMode.classTimetable;

  String? currentClassTt;
  String? currentExamTt;

  MyAppState(){
    init();
  }
  

  void reload(){
    notifyListeners();
  }
  String get modeStr=> _mode==AppMode.classTimetable?'Class timetable':'Exam timetable';

  void changeMode(AppMode newMode)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
     
      _mode=newMode;
      _prefs.setString('mode', _mode.toString());
      
      if(_mode!=AppMode.none){
        toast('Changed to $modeStr mode');
      }
    
    notifyListeners();
  }

  void setCurrentExamTt(String currentTt)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('currentExamTt', currentTt);
    currentExamTt=currentTt;
  }
  void setCurrentClassTt(String currentTt)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('currentClassTt', currentTt);
    currentClassTt=currentTt;
  }



  Future<void> init()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? md =_prefs.getString('mode');
    currentClassTt=_prefs.getString('currentClassTt');
    currentExamTt=_prefs.getString('currentExamTt');
    
    if(md=='AppMode.classTimetable'){
      _mode=AppMode.classTimetable;
    }else if(md=='AppMode.examTimetable'){
      _mode=AppMode.examTimetable;
    }else{
      _mode=AppMode.none;
    }

    debugPrint("Mode:  $appMode");
    notifyListeners();
  }
  
}