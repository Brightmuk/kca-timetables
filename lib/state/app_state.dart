import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppMode{examTimetable, classTimetable, none}

class MyAppState extends ChangeNotifier{

  AppMode mode = AppMode.none;
  bool get isClassMode=>mode==AppMode.classTimetable;

  String? currentClassTt;
  String? currentExamTt;

  late InterstitialAd _interstitialAd;

  void loadInterstitialAd(){
        InterstitialAd.load(
        adUnitId: "ca-app-pub-1360540534588513/8322258866",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(

          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
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
      _interstitialAd.show();
      loadInterstitialAd();
  }

  void showInterstitialAd()async{
     SharedPreferences _prefs = await SharedPreferences.getInstance();
    int showAdInterval = _prefs.getInt('showAdInterval')??0;

    debugPrint("Determining if to load Ad at: "+showAdInterval.toString());

    if(showAdInterval<4){
      _prefs.setInt('showAdInterval', showAdInterval+=1);
    }else{
      _prefs.setInt('showAdInterval', 0);
      _interstitialAd.show();
      loadInterstitialAd();
    }
  }


  Future<void> init()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? md =_prefs.getString('mode');
    currentClassTt=_prefs.getString('currentClassTt');
    currentExamTt=_prefs.getString('currentExamTt');
    loadInterstitialAd();
    if(md=='AppMode.classTimetable'){
      mode=AppMode.classTimetable;
    }else if(md=='AppMode.examTimetable'){
      mode=AppMode.examTimetable;
    }else{
      mode=AppMode.none;
    }
    debugPrint("Initialsed app state!");
    notifyListeners();
  }
  
}