import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:overlay_support/overlay_support.dart';


class ExamService{

  final BuildContext context;
  final String? day;
  MyAppState state;
  ExamService({required this.context,this.day ,required this.state});

  final db = Localstore.instance;

  static const String tableCollection = 'tableCollection';


  Future<void> saveExamDetails({required String name,required String period,required String course})async{
         await db
        .collection(tableCollection)
        .doc('examTimetable')
        .set({
          'name':name,
          'period':period,
          'course':course,
          'date':DateTime.now().millisecondsSinceEpoch
        });
  }
  Future<TimeTable> getExamTimetable(){
    return db.collection(tableCollection)
    .doc('examTimetable')
    .get().then((value) => TimeTable.fromMap(value!));
  }
Future<bool> tableExists()async{
    var value = await db.collection(tableCollection)
    .doc('examTimetable').get();
    return value!=null;
  }

  ///Save  a record
 
  Future<bool> saveExamTimeTable({required String tableName,required String period, required List<ExamModel> exams, required String course}) async {
    bool returnValue = true;

    try{

        for (var _exam in exams) {
          
          if(!await saveExam(_exam)){
            throw Error();
          }
     }
     await saveExamDetails(name: tableName,course: course, period:period);
      toast('Exam table saved');
      returnValue = true;
    }catch(e){    
     toast(e.toString());
      returnValue = false;
    }
    await LocalData().setNotFirst();
    return returnValue;
  }

  Future<bool> saveExam(ExamModel exam)async{
        try{
        await db
        .collection(state.currentExamTt!)
        .doc(exam.unitCode)
        .set(exam.toMap());
    
      return true;
    }catch(e){    
     toast('An error occurred');
      return false;
    }
  }

  Future<bool> deleteExam(ExamModel exam)async{
    try{
    await  db
        .collection(state.currentExamTt!)
        .doc(exam.unitCode)
        .delete();
        return true;
    }catch(e){
      toast('Sorry an eror occurred');
      return false;
    }
  }

  Future<bool> editExam({required ExamModel exam}) async {
    bool returnValue = true;
    try{
        await db
        .collection(state.currentExamTt!)
        .doc(exam.unitCode)
        .set(exam.toMap());
     
      toast('Exam details updated');
      returnValue = true;
    }catch(e){    
      toast(e.toString());
    //  toast('An error occurred');
     
      returnValue = false;
    }
    return returnValue;
  }

  ///Get record list
  Stream<List<ExamModel>> get examsStream {

    return db.collection(state.currentExamTt!)
    .stream
    .map(examList);
  }
  Stream<int> get examsCount {

    return db.collection(state.currentExamTt!)
    .stream
    .map(examsCountMap);
  }
  Future<List<ExamModel>> examsFuture() {

    return db.collection(state.currentExamTt!)
    
        .get()
        
        .then((value) => examList(value!));

  }


    List<ExamModel> _records = [];
    ///Yield the list from stream
  List<ExamModel> examList(Map<String, dynamic> query) {
    try{
    final item = ExamModel.fromMap(query);
    Iterable<ExamModel> record = _records.where((r) => r.unitCode==item.unitCode);
    if(record.isEmpty){
      _records.add(item);
    }else{
      _records.remove(record.first);
      _records.add(item);
    }
_records.sort((a,b)=>a.date.compareTo(b.date));
    return _records;
    }catch(e){
      print(e.toString());
      return [];
    }

  }

int examsCountMap(Map<String, dynamic> query) {
    try{
    final item = ExamModel.fromMap(query);
    Iterable<ExamModel> record = _records.where((r) => r.unitCode==item.unitCode);
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


}