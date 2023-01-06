import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:flutter/material.dart';



class ExamModel {
  final String unitName;
  final String unitCode;
  final DateTime date;
  final Time time;
  final String venue;
  final String invigilator;
  final int accentColor;
  final bool reminder;
  final TimeOfDay reminderSchedule;

  ExamModel({
    required this.unitName,
    required this.unitCode,
    required this.date,
    required this.time,
    required this.venue,
    required this.invigilator,
    required this.accentColor,
    required this.reminder,
    required this.reminderSchedule
  });


  
  factory ExamModel.fromSheet(List<Data?> row) {
    try{
    return ExamModel(
      accentColor: 0xff050851,
      date: DateTime.parse(row[5]!=null?row[5]!.value:DateTime.now().toString()),
      time: Time.fromString(row[6]!=null?row[6]!.value:''),
      venue: row[10]!=null? row[10]!.value:'No value',
      unitCode: row[0]!=null?row[0]!.value:'No value',
      unitName: row[1]!=null? row[1]!.value:'No value',
      invigilator: row[8]!=null? row[8]!.value:'No value',
      reminderSchedule: const TimeOfDay(hour: 0,minute: 0),
      reminder: false,
    );
    }catch(e){
      
      debugPrint("Error: "+e.toString());
      return ExamModel.defaultModel("No value", "No value");
     
    }

  }

    factory ExamModel.defaultModel(String unitName, String unitCode) {

    return ExamModel(
      accentColor: 0xff050851,
      date: DateTime.now(),
      time: const Time(end: TimeOfDay(hour: 0,minute: 0),start: TimeOfDay(hour: 0,minute: 0),originalStr: '0.00AM - 0.00AM'),
      venue: "No venue",
      unitCode: unitCode,
      unitName: unitName,
      invigilator: "No invigilator",
      reminderSchedule: const TimeOfDay(hour: 0,minute: 0),
      reminder: false,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'unitName': unitName,
      'unitCode': unitCode,
      'date': date.toString(),
      'time': time.toJson(),
      'venue': venue,
      'invigilator': invigilator,
      'accentColor': accentColor,
      'reminder': reminder,
      'reminderSchedule': TimeOfD.toJson(reminderSchedule),
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      unitName: map['unitName'] ?? '',
      unitCode: map['unitCode'] ?? '',
      date: DateTime.parse(map['date'] ?? ''),
      time: Time.fromJson(map['time'] ?? ''),
      venue: map['venue'] ?? '',
      invigilator: map['invigilator'] ?? '',
      accentColor: map['accentColor']?.toInt() ?? 0,
      reminder: map['reminder'] ?? false,
      reminderSchedule: TimeOfD.fromJson(map['reminderSchedule']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExamModel.fromJson(String source) => ExamModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExamModel(unitName: $unitName, unitCode: $unitCode, date: $date, time: $time, venue: $venue, invigilator: $invigilator, accentColor: $accentColor, reminder: $reminder, reminderSchedule: $reminderSchedule)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ExamModel &&
      other.unitName == unitName &&
      other.unitCode == unitCode &&
      other.date == date &&
      other.time == time &&
      other.venue == venue &&
      other.invigilator == invigilator &&
      other.accentColor == accentColor &&
      other.reminder == reminder &&
      other.reminderSchedule == reminderSchedule;
  }

  @override
  int get hashCode {
    return unitName.hashCode ^
      unitCode.hashCode ^
      date.hashCode ^
      time.hashCode ^
      venue.hashCode ^
      invigilator.hashCode ^
      accentColor.hashCode ^
      reminder.hashCode ^
      reminderSchedule.hashCode;
  }

  
int get sortIndex {
    return time.start.hour+date.day;
  }

}
