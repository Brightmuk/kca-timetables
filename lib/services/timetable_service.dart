import 'package:excel_reader/models/record_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:overlay_support/overlay_support.dart';


class TimeTableService{
  final BuildContext context;
  final String? day;
  TimeTableService({required this.context,this.day});
  final db = Localstore.instance;

  static const String recordCollection = 'recordCollection';

  ///Save  a record
  ///
  Future<bool> saveTimeTable({required List<Record> records, required String course}) async {
    bool returnValue = true;

    try{
        for (var r in records) {
         Record _record = r.copyWith(course: course);
          await db
        .collection(recordCollection)
        .doc(_record.unitCode)
        .set(_record.toMap());
     }
      toast('Timetable saved');
      returnValue = true;
    }catch(e){    
     toast('An error occurred');
      returnValue = false;
    }
    LocalData().setNotFirst();
    return returnValue;
  }

  Future<bool> editRecord({required Record record}) async {
    bool returnValue = true;
    try{
        await db
        .collection(recordCollection)
        .doc(record.unitCode)
        .set(record.toMap());
     
      toast('Record saved');
      returnValue = true;
    }catch(e){    
     toast('An error occurred');
      returnValue = false;
    }
    return returnValue;
  }

  ///Get record list
  Stream<List<Record>> get recordsStream {
    return db.collection(recordCollection).stream
    .where((r) => day!=null?r['day']==day:true)
    .map(recordList);
  }

    List<Record>_records = [];
    ///Yield the list from stream
  List<Record> recordList(Map<String, dynamic> query) {
    final item = Record.fromMap(query);
    Iterable<Record> record = _records.where((r) => r.unitCode==item.unitCode);
    if(record.isEmpty){
      _records.add(item);
    }else{
      _records.remove(record.first);
      _records.add(item);
    }
_records.sort((a,b)=>a.sortIndex.compareTo(b.sortIndex));
    return _records;
  }

}