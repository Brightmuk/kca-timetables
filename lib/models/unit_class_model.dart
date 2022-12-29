import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/shared/functions.dart';

class UnitClass {
  final String day;
  final String? course;
  final Time time;
  final String venue;
  final String unitCode;
  final String unitName;
  final String lecturer;
  final bool reminder;
  final int? reminderSchedule;
  final String? classLink;
  final String? meetingPassCode;
  final String? meetingId;
  final int accentColor;

  UnitClass({
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
    required this.accentColor
  });


  ///According to the timetables, the order of fields is day,time, room
  ///unit code,unit name,lecturer so  we assume it will always be the case
  ///therefore the index is relatively constant

  factory UnitClass.fromSheet(List<Data?> row, int dayIndex,String courseName) {
    return UnitClass(
      accentColor: 0xff050851,
      day: row[dayIndex]!.value.toString().toUpperCase(),
      course:courseName,
      time: Time.fromString(row[dayIndex + 1]!.value.toString().toUpperCase()) ,
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

  factory UnitClass.defaultClass(String defaultUnitName, String defaultUnitCode, String defaultCourseName){
    return UnitClass(
      accentColor: 0xff050851,
      day: dayFromWeekday(DateTime.now().weekday),
      course:defaultCourseName,
      time: Time.fromString('0800-1100 HRS'),
      venue: 'VIRTUAL',
      unitCode: defaultUnitCode,
      unitName: defaultUnitName,
      lecturer: 'LECTURER\'S NAME',
      meetingId: null,
      reminderSchedule: null,
      meetingPassCode: null,
      classLink: null,
      reminder: false,
    );
  }




  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'accentColor':accentColor,
      'course': course,
      'time': time.toJson(),
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

  factory UnitClass.fromMap(Map<String, dynamic> map) {
    return UnitClass(
      accentColor: map['accentColor']??0xff050851,
      day: map['day'] ?? '',
      course: map['course'],
      time: Time.fromJson(map['time'] ?? '') ,
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



  String toJson() => json.encode(toMap());

  factory UnitClass.fromJson(String source) => UnitClass.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Record(day: $day, course: $course, time: $time, venue: $venue, unitCode: $unitCode, unitName: $unitName, lecturer: $lecturer, reminder: $reminder, reminderSchedule: $reminderSchedule, classLink: $classLink, meetingPassCode: $meetingPassCode, meetingId: $meetingId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UnitClass &&
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

  bool get isFulfiled{
      int hourOfDay = DateTime.now().hour;
    return (hourOfDay*100)>time.end;
      
}

bool get canJoinMeeting{
  int today = DateTime.now().weekday;
  

  return timeIndex>=time.start&&venue=='VIRTUAL'&&dayIndex(day)== today;
}

int get weekday{
      switch (day) {
      case 'MONDAY':
        return 1;
      case 'TUESDAY':
        return 2;
      case 'WEDNESDAY':
        return 3;
      case 'THURSDAY':
        return 4;
      case 'FRIDAY':
        return 5;
      case 'SATURDAY':
        return 6;
      default:
        return 0;
    }
}

  int get sortIndex {
    int timeValue=time.start;


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

}
