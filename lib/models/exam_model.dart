import 'dart:convert';

import 'package:excel/excel.dart';

class ExamModel {
  final String unitName;
  final String unitCode;
  final String date;
  final String time;
  final String venue;
  final String invigilator;
  final int accentColor;
  final bool reminder;
  final String? reminderSchedule;

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
      date: row[3]!.value.toString().toUpperCase(),
      time: row[4]!.value.toString().toUpperCase(),
      venue: row[7]!.value.toString().toUpperCase(),
      unitCode: row[0]!.value.toString().toUpperCase(),
      unitName: row[1]!.value.toString().toUpperCase(),
      invigilator: row[6]!.value.toString().toUpperCase(),
      reminderSchedule: null,
      reminder: false,
    );
  }



  ExamModel copyWith({
    String? unitName,
    String? unitCode,
    String? date,
    String? time,
    String? venue,
    String? invigilator,
    int? accentColor,
    bool? reminder,
    String? reminderSchedule,
  }) {
    return ExamModel(
      unitName: unitName ?? this.unitName,
      unitCode: unitCode ?? this.unitCode,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      invigilator: invigilator ?? this.invigilator,
      accentColor: accentColor ?? this.accentColor,
      reminder: reminder ?? this.reminder,
      reminderSchedule: reminderSchedule ?? this.reminderSchedule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unitName': unitName,
      'unitCode': unitCode,
      'date': date,
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
      date: map['date'] ?? '',
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
}
