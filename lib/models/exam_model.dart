import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';



class ExamModel {
  final String unitName;
  final String unitCode;
  final DateTime date;
  final String time;
  final String venue;
  final String invigilator;
  final int accentColor;
  final bool reminder;
  final int? reminderSchedule;

  ExamModel({
    required this.unitName,
    required this.unitCode,
    required this.date,
    required this.time,
    required this.venue,
    required this.invigilator,
    required this.accentColor,
    required this.reminder,
    this.reminderSchedule
  });


  
  factory ExamModel.fromSheet(List<Data?> row) {

    return ExamModel(
      accentColor: 0xff050851,
      date: DateTime.parse(row[5]!.value.toString()),
      time: row[6]!.value.toString().toUpperCase(),
      venue: row[10]!.value.toString().toUpperCase(),
      unitCode: row[0]!.value.toString().toUpperCase(),
      unitName: row[1]!.value.toString().toUpperCase(),
      invigilator: row[8]!.value.toString().toUpperCase(),
      reminderSchedule: null,
      reminder: false,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'unitName': unitName,
      'unitCode': unitCode,
      'date': date.toString(),
      'time': time,
      'venue': venue,
      'invigilator': invigilator,
      'accentColor': accentColor,
      'reminder': reminder,
      'reminderSchedule': reminderSchedule,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      unitName: map['unitName'] ?? '',
      unitCode: map['unitCode'] ?? '',
      date: DateTime.parse(map['date'] ?? ''),
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
      invigilator: map['invigilator'] ?? '',
      accentColor: map['accentColor']?.toInt() ?? 0,
      reminder: map['reminder'] ?? false,
      reminderSchedule: map['reminderSchedule'],
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

int get startHour{
  return  int.parse(time.substring(0,2));
}
int get startMinute{
  return  int.parse(time.substring(2,4));
}
  
int get sortIndex {
    int timeValue;
    try {
      timeValue = int.parse(time.substring(5,9));
    } catch (e) {
      timeValue = 0;
    }

    return timeValue+date.day;
  }

}
