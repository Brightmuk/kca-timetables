import 'package:shared_preferences/shared_preferences.dart';

class LocalData{

  static const firstTime = 'isFirstTime';

  Future<bool> isFirstTime()async{
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getBool(firstTime)??true;
  }
  Future<void> setNotFirst()async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(firstTime, false);
  }
}