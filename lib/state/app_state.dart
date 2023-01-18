import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppMode{examTimetable, classTimetable, none}

class AppState extends ChangeNotifier{

  AppMode mode = AppMode.none;
  bool get isClassMode=>mode==AppMode.classTimetable;

  String? currentClassTt;
  String? currentExamTt;

  late AdmobInterstitial interstitialAd;
  int showInterval=0;

  AppState(){
    init();
    Admob.requestTrackingAuthorization();
    loadInterstitialAd();
  }
  void loadInterstitialAd(){
    interstitialAd = AdmobInterstitial(
      adUnitId: "ca-app-pub-1360540534588513/8322258866",
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        
        debugPrint("Loading ad with: "+ args.toString());
      },
    );
    interstitialAd.load();
  }
  

  void reload(){
    notifyListeners();
  }
  String get modeStr=> mode==AppMode.classTimetable?'Class timetable':'Exam timetable';

  void changeMode(AppMode newMode)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    
      mode=newMode;
      _prefs.setString('mode', mode.toString());
      if(mode!=AppMode.none){
        toast('Changed to '+modeStr+' mode');
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

  void instantInterstitialShow(){
      interstitialAd.show();
      loadInterstitialAd();
  }

  void showInterstitialAd(){
    debugPrint("Determining if to load Ad at: "+showInterval.toString());
    if(showInterval<4){
      showInterval+=1;
    }else{
      showInterval=0;
      interstitialAd.show();
      loadInterstitialAd();
    }
  }


  void init()async{
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  String? md =_prefs.getString('mode');
  currentClassTt=_prefs.getString('currentClassTt');
  currentExamTt=_prefs.getString('currentExamTt');

  if(md=='AppMode.classTimetable'){
    mode=AppMode.classTimetable;
  }else if(md=='AppMode.examTimetable'){
    mode=AppMode.examTimetable;
  }else{
    mode=AppMode.none;
  }
  notifyListeners();
  }
  
}