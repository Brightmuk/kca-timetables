import 'dart:convert';

import 'package:excel/excel.dart';

class Record {
  final String day;
  final String time;
  final String room;
  final String unitCode;
  final String unitName;
  final String lecturer;
  final bool isVirtual;
  final bool reminder;
  final String? classLink;
  final String? meetingPassCode;
  final String? meetingId;

  Record({
    required this.day,
    required this.time,
    required this.room,
    required this.unitCode,
    required this.unitName,
    required this.lecturer,
    required this.isVirtual,
    required this.reminder,
    this.classLink,
    this.meetingPassCode,
    this.meetingId,
  });

  ///According to the timetables, the order of fields is day,time, room
  ///unit code,unit name,lecturer so  we assume it will always be the case
  ///therefore the index is relatively constant

  factory Record.fromSheet(List<Data?> row, int dayIndex) {
    return Record(
      day: row[dayIndex]!.value,
      time: row[dayIndex + 1]!.value,
      room: row[dayIndex + 2]!.value,
      unitCode: row[dayIndex + 3]!.value,
      unitName: row[dayIndex + 4]!.value,
      lecturer: row[dayIndex + 5]!.value,
      reminder: false,
      isVirtual: false
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
      'room': room,
      'unitCode': unitCode,
      'unitName': unitName,
      'lecturer': lecturer,
      'isVirtual': isVirtual,
      'reminder': reminder,
      'classLink': classLink,
      'meetingPassCode': meetingPassCode,
      'mmetingId': meetingId,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      day:map['day'] ?? '',
      time:map['time'] ?? '',
      room:map['room'] ?? '',
      unitCode:map['unitCode'] ?? '',
      unitName:map['unitName'] ?? '',
     lecturer: map['lecturer'] ?? '',
      isVirtual:map['isVirtual'] ?? false,
      reminder:map['reminder'] ?? false,
      classLink:map['classLink'] ?? '',
      meetingPassCode:map['meetingPassCode'] ?? '',
      meetingId:map['meetingId'] ?? '',
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Record &&
      other.day == day &&
      other.time == time &&
      other.room == room &&
      other.unitCode == unitCode &&
      other.unitName == unitName &&
      other.lecturer == lecturer &&
      other.isVirtual == isVirtual &&
      other.reminder == reminder &&
      other.classLink == classLink &&
      other.meetingPassCode == meetingPassCode &&
      other.meetingId == meetingId;
  }

  @override
  int get hashCode {
    return day.hashCode ^
      time.hashCode ^
      room.hashCode ^
      unitCode.hashCode ^
      unitName.hashCode ^
      lecturer.hashCode ^
      isVirtual.hashCode ^
      reminder.hashCode ^
      classLink.hashCode ^
      meetingPassCode.hashCode ^
      meetingId.hashCode;
  }
}
