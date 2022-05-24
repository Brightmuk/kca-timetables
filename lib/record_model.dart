import 'dart:convert';

import 'package:excel/excel.dart';

class Record {
  final String day;
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

  ///According to the timetables, the order of fields is day,time, room
  ///unit code,unit name,lecturer so  we assume it will always be the case
  ///therefore the index is relatively constant

  factory Record.fromSheet(List<Data?> row, int dayIndex) {
    return Record(
      day: row[dayIndex]!.value.toString().toUpperCase(),
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
      'time': time,
      'room': venue,
      'unitCode': unitCode,
      'unitName': unitName,
      'lecturer': lecturer,
      'reminder': reminder,
      'reminderSchedule':reminderSchedule,
      'classLink': classLink,
      'meetingPassCode': meetingPassCode,
      'mmetingId': meetingId,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      day:map['day'] ?? '',
      time:map['time'] ?? '',
      venue:map['room'] ?? '',
      unitCode:map['unitCode'] ?? '',
      unitName:map['unitName'] ?? '',
     lecturer: map['lecturer'] ?? '',
      reminder:map['reminder'] ?? false,
      reminderSchedule: map['reminderSchedule']??0,
      classLink:map['classLink'] ?? '',
      meetingPassCode:map['meetingPassCode'] ?? '',
      meetingId:map['meetingId'] ?? '',
    );
  }
}
