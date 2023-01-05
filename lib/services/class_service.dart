import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:overlay_support/overlay_support.dart';


class ClassTimeTableService{
  final BuildContext context;
  final String? day;
  final AppState state;
  ClassTimeTableService({required this.context,this.day, required this.state});
  final db = Localstore.instance;

  static const String tableCollection = 'tableCollection';


  Future<void> saveTableDetails({required String name,required String period,required String course})async{
         await db
        .collection(tableCollection)
        .doc('classTimetable')
        .set({
          'name':name,
          'period':period,
          'course':course,
          'date':DateTime.now().millisecondsSinceEpoch
        });
  }
  Future<TimeTable> getClassTimetable(){
    return db.collection(tableCollection)
    .doc('classTimetable')
    .get().then((value) => TimeTable.fromMap(value!));
  }
  Future<bool> tableExists()async{
      var value = await db.collection(tableCollection)
      .doc('classTimetable').get();
      return value!=null;
    }
  ///Save  a record
 
  Future<bool> saveClassTimeTable({required String tableName,required String period, required List<UnitClass> units, required String course}) async {
    bool returnValue = true;
    debugPrint(units[0].toString());
    try{

        for (var _unit in units) {
          if(!await saveUnit(_unit)){
            throw Error();
          }
     }
     await saveTableDetails(name: tableName,course: course, period:period);
      toast('Timetable saved');
      returnValue = true;
    }catch(e){    
    toast('Sorry,a timetable erorr occurred');
      returnValue = false;
    }
    await LocalData().setNotFirst();
    return returnValue;
  }

  Future<bool> saveUnit(UnitClass unit)async{
    debugPrint(unit.toString());
        try{
        await db
        .collection(state.currentClassTt!)
        .doc(unit.unitCode)
        .set(unit.toMap());
      
      return true;
    }catch(e){    
     toast('An error occurred');
     debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteUnit(UnitClass unit)async{
    try{
    await  db
        .collection(state.currentClassTt!)
        .doc(unit.unitCode)
        .delete();
        return true;
    }catch(e){
      toast('Sorry an error occurred');
      return false;
    }
  }

  Future<bool> editRecord({required UnitClass record}) async {
    bool returnValue = true;
    try{
        await db
        .collection(state.currentClassTt!)
        .doc(record.unitCode)
        .set(record.toMap());
     
      toast('Class details updated');
      returnValue = true;
    }catch(e){    
      toast(e.toString());
    //  toast('An error occurred');
     
      returnValue = false;
    }
    return returnValue;
  }

  ///Get record list
  Stream<List<UnitClass>> get unitsStream {

    return db.collection(state.currentClassTt!)
    .stream
        
        .where((r) => day!=null?r['day']==day:true)
        
    .map(recordList);
  }
  Future<List<UnitClass>> unitsFuture() {

    return db.collection(state.currentClassTt!)
      
        .get()
        .then((value) => recordList(value!));

  }
  Stream<int> get unitsCount{

        return db.collection(state.currentClassTt!)
    .stream
        
    .map(unitCountMap);
  }
  int unitCountMap(Map<String, dynamic> query){
       try{
    final item = UnitClass.fromMap(query);
    Iterable<UnitClass> record = _records.where((r) => r.unitCode==item.unitCode);
    if(record.isEmpty){
      _records.add(item);
    }else{
      _records.remove(record.first);
      _records.add(item);
    }
    return _records.length;
    }catch(e){
      print(e.toString());
      return 0;
    } 
  }


    List<UnitClass>_records = [];
    ///Yield the list from stream
  List<UnitClass> recordList(Map<String, dynamic> query) {
   
    try{
    final item = UnitClass.fromMap(query);
    Iterable<UnitClass> record = _records.where((r) => r.unitCode==item.unitCode);
    if(record.isEmpty){
      _records.add(item);
    }else{
      _records.remove(record.first);
      _records.add(item);
    }
_records.sort((a,b)=>a.sortIndex.compareTo(b.sortIndex));
    return _records;
    }catch(e){
  
      return [];
    }

  }

    //upcoming
  Stream<UnitClass> get upcomingClass {
    return db.collection(state.currentClassTt!)
    .stream
    .map(upcomingList);
  }
  List<UnitClass> upcomingRecords = [];
  UnitClass upcomingList(Map<String, dynamic> query) {

    final item = UnitClass.fromMap(query);
    upcomingRecords.add(item);
    upcomingRecords.sort((a,b)=>a.sortIndex.compareTo(b.sortIndex));
    UnitClass result = upcomingRecords.firstWhere((r) => r.sortIndex>Time.timeIndex,orElse: ()=>upcomingRecords.first);

    return result;
  }

  Future reScanClassTt(AppState state)async{
    try{
    List<UnitClass> units = await unitsFuture();

    for (UnitClass unit in units){
      await deleteUnit(unit);
    }
  state.changeMode(AppMode.none);

    Navigator.pop(context);
    Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => const ScanScreen()));
  
    }catch(e){
      toast('An error occurred');
      debugPrint(e.toString());
    }

  }
}