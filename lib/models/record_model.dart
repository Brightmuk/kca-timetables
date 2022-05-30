import 'dart:convert';

import 'package:excel/excel.dart';

class Record {
  final String day;
  final String? course;
  final String time;
  final String venue;
  final String unitCode;
  final String unitName;
  final String lecturer;
  final bool reminder;
  final int? reminderSchedule;
  final String? classLink;
  final String? meetingPassCode;
  final String? meetingId;

  Record({
    required this.day,
    this.course,
    required this.time,
    required this.venue,
    required this.unitCode,
    
    required this.unitName,
    required this.lecturer,
    required this.reminder,
    this.reminderSchedule,
    this.classLink,
    this.meetingPassCode,
    this.meetingId,
  });

  String get id{
    return unitCode+day;
  }
  ///According to the timetables, the order of fields is day,time, room
  ///unit code,unit name,lecturer so  we assume it will always be the case
  ///therefore the index is relatively constant

  factory Record.fromSheet(List<Data?> row, int dayIndex) {
    return Record(
      day: row[dayIndex]!.value.toString().toUpperCase(),
      course:null,
      time: row[dayIndex + 1]!.value.toString().toUpperCase(),
      venue: row[dayIndex + 2]!.value.toString().toUpperCase(),
      unitCode: row[dayIndex + 3]!.value.toString().toUpperCase(),
      unitName: row[dayIndex + 4]!.value.toString().toUpperCase(),
      lecturer: row[dayIndex + 5]!.value.toString().toUpperCase(),
      meetingId: null,
      reminderSchedule: null,
      meetingPassCode: null,
      classLink: null,
      reminder: false,
    );
  }


  int get sortIndex {
    int timeValue;
    try {
      timeValue = int.parse(time.split('-')[0]);
    } catch (e) {
      timeValue = 0;
    }

    switch (day) {
      case 'MONDAY':
        return 10000 + timeValue;
      case 'TUESDAY':
        return 20000 + timeValue;
      case 'WEDNESDAY':
        return 30000 + timeValue;
      case 'THURSDAY':
        return 40000 + timeValue;
      case 'FRIDAY':
        return 50000 + timeValue;
      case 'SATURDAY':
        return 60000 + timeValue;
      default:
        return 0 + timeValue;
    }
  }


  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'course': course,
      'time': time,
      'venue': venue,
      'unitCode': unitCode,
      'unitName': unitName,
      'lecturer': lecturer,
      'reminder': reminder,
      'reminderSchedule': reminderSchedule,
      'classLink': classLink,
      'meetingPassCode': meetingPassCode,
      'meetingId': meetingId,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      day: map['day'] ?? '',
      course: map['course'],
      time: map['time'] ?? '',
      venue: map['venue'] ?? '',
      unitCode: map['unitCode'] ?? '',
      unitName: map['unitName'] ?? '',
      lecturer: map['lecturer'] ?? '',
      reminder: map['reminder'] ?? false,
      reminderSchedule: map['reminderSchedule']?.toInt(),
      classLink: map['classLink'],
      meetingPassCode: map['meetingPassCode'],
      meetingId: map['meetingId'],
    );
  }

  Record copyWith({
    String? day,
    String? course,
    String? time,
    String? venue,
    String? unitCode,
    String? unitName,
    String? lecturer,
    bool? reminder,
    int? reminderSchedule,
    String? classLink,
    String? meetingPassCode,
    String? meetingId,
  }) {
    return Record(
      day: day ?? this.day,
      course: course ?? this.course,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      unitCode: unitCode ?? this.unitCode,
      unitName: unitName ?? this.unitName,
      lecturer: lecturer ?? this.lecturer,
      reminder: reminder ?? this.reminder,
      reminderSchedule: reminderSchedule ?? this.reminderSchedule,
      classLink: classLink ?? this.classLink,
      meetingPassCode: meetingPassCode ?? this.meetingPassCode,
      meetingId: meetingId ?? this.meetingId,
    );
  }

  String toJson() => json.encode(toMap());

  factory Record.fromJson(String source) => Record.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Record(day: $day, course: $course, time: $time, venue: $venue, unitCode: $unitCode, unitName: $unitName, lecturer: $lecturer, reminder: $reminder, reminderSchedule: $reminderSchedule, classLink: $classLink, meetingPassCode: $meetingPassCode, meetingId: $meetingId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Record &&
      other.day == day &&
      other.course == course &&
      other.time == time &&
      other.venue == venue &&
      other.unitCode == unitCode &&
      other.unitName == unitName &&
      other.lecturer == lecturer &&
      other.reminder == reminder &&
      other.reminderSchedule == reminderSchedule &&
      other.classLink == classLink &&
      other.meetingPassCode == meetingPassCode &&
      other.meetingId == meetingId;
  }

  @override
  int get hashCode {
    return day.hashCode ^
      course.hashCode ^
      time.hashCode ^
      venue.hashCode ^
      unitCode.hashCode ^
      unitName.hashCode ^
      lecturer.hashCode ^
      reminder.hashCode ^
      reminderSchedule.hashCode ^
      classLink.hashCode ^
      meetingPassCode.hashCode ^
      meetingId.hashCode;
  }
}
