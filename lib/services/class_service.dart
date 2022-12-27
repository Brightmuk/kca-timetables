import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:overlay_support/overlay_support.dart';


class TimeTableService{
  final BuildContext context;
  final String? day;
  TimeTableService({required this.context,this.day});
  final db = Localstore.instance;

  static const String recordCollection = 'recordCollection';
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

    try{

        for (var _unit in units) {
          await saveUnit(_unit);
     }
     await saveTableDetails(name: tableName,course: course, period:period);
      toast('Timetable saved');
      returnValue = true;
    }catch(e){    
     toast(e.toString());
      returnValue = false;
    }
    await LocalData().setNotFirst();
    return returnValue;
  }

  Future<bool> saveUnit(UnitClass unit)async{
        try{
        await db
        .collection(recordCollection)
        .doc(unit.unitCode)
        .set(unit.toMap());
    
      return true;
    }catch(e){    
     toast('An error occurred');
      return false;
    }
  }

  Future<bool> deleteUnit(UnitClass unit)async{
    try{
    await  db
        .collection(recordCollection)
        .doc(unit.unitCode)
        .delete();
        return true;
    }catch(e){
      toast('Sorry an eror occurred');
      return false;
    }
  }

  Future<bool> editRecord({required UnitClass record}) async {
    bool returnValue = true;
    try{
        await db
        .collection(recordCollection)
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

    return db.collection(recordCollection)
    .stream
        .where((r) => day!=null?r['day']==day:true)
    .map(recordList);
  }
  Future<List<UnitClass>> unitsFuture() {

    return db.collection(recordCollection)
        .get()
        .then((value) => recordList(value!));

  }
  Stream<int> get unitsCount{
        return db.collection(recordCollection)
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
      print(e.toString());
      return [];
    }

  }

    //upcoming
  Stream<UnitClass> get upcomingClass {
    return db.collection(recordCollection)
    .stream
    .map(upcomingList);
  }
      List<UnitClass> upcomingRecords = [];
  UnitClass upcomingList(Map<String, dynamic> query) {

    final item = UnitClass.fromMap(query);
    upcomingRecords.add(item);
    upcomingRecords.sort((a,b)=>a.sortIndex.compareTo(b.sortIndex));
    UnitClass result = upcomingRecords.firstWhere((r) => r.sortIndex>timeIndex,orElse: ()=>upcomingRecords.first);

    return result;
  }

}