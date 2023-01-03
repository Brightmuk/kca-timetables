import 'dart:convert';

import 'package:flutter/material.dart';

extension TimeOfD on TimeOfDay{
  static Map<String, int> toMap(TimeOfDay t){
    return {
      'hour':t.hour,
      'minute':t.minute
    };
  }
  static TimeOfDay fromMap(Map<String, dynamic> map) {
    return TimeOfDay(
      hour: map['hour'] ?? 0,
      minute: map['minute']??0
    );
  }
  static String toJson(TimeOfDay t) => json.encode(toMap(t));

  static TimeOfDay fromJson(String t)=> fromMap(json.decode(t));
}

class Time {
  final String originalStr;
  final TimeOfDay start;
  final TimeOfDay end;
  
  const Time({
    required this.originalStr,
    required this.start,
    required this.end,
  });
  
  factory Time.fromString(String time){
    
    try{
    int _startHour;
    int _startMin;
    int _endHour;
    int _endMin;
     
    if(time.trim().endsWith("HRS")){
     
      String f1 = time.substring(0, time.length-3).trim();
     
      List<String> startEnds = f1.split("-");
      _startHour = int.parse(startEnds[0].substring(0,2));
      _startMin = int.parse(startEnds[0].substring(2));
      _endHour = int.parse(startEnds[1].substring(0,2));
      _endMin = int.parse(startEnds[1].substring(2));
      
    }else{
     
       List<String> startEnds = time.split("-");
      
      bool startAM = startEnds[0].toUpperCase().contains("AM");
       _startHour = int.parse(startEnds[0].substring(0,startEnds[0].indexOf(".")));
      
      if(!startAM){
        _startHour = _startHour+12;
      }
       
      bool endAM = startEnds[1].toUpperCase().contains("AM");
      
       _endHour = int.parse(startEnds[1].substring(0,startEnds[1].indexOf(".")));
      if(!endAM){
        _endHour = _endHour+12;
      }
      _startMin = 0;
      _endMin = 0;
     
      
    }
    return Time(
      originalStr: time,
      start: TimeOfDay(hour: _startHour,minute: _startMin),
      end: TimeOfDay(hour: _endHour,minute: _endMin),
    );
    }catch(e){

      return Time(originalStr:"No value",start:TimeOfDay.now(),end:TimeOfDay.now());
    }

  }


DateTime getDate(dynamic dayOfWeek, int reminderHrs,int reminderMins){
  DateTime now = DateTime.now();
  int unitDay = getWeekday(dayOfWeek);
  int dayDifference;
  if(unitDay<now.weekday){
    unitDay+=7;
    dayDifference=unitDay-now.weekday;
  }else{
    dayDifference=unitDay-now.weekday;
  }

  return DateTime(now.year,now.month,now.day+dayDifference, start.hour,start.minute).subtract(Duration(hours: reminderHrs,minutes: reminderMins));
}

static int getWeekday(day){
  if(day.runtimeType==int){
    return day;
  }else{
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

}




  Time copyWith({
    String? originalStr,
    TimeOfDay? start,
    TimeOfDay? end,
  }) {
    return Time(
      originalStr: originalStr ?? this.originalStr,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalStr': originalStr,
      'start': TimeOfD.toMap(start),
      'end': TimeOfD.toMap(end),
    };
  }

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      originalStr: map['originalStr'] ?? '',
      start: TimeOfD.fromMap(map['start']),
      end: TimeOfD.fromMap(map['end']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Time.fromJson(String source) => Time.fromMap(json.decode(source));

  @override
  String toString() => 'Time(originalStr: $originalStr, start: $start, end: $end)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Time &&
      other.originalStr == originalStr &&
      other.start == start &&
      other.end == end;
  }

  @override
  int get hashCode => originalStr.hashCode ^ start.hashCode ^ end.hashCode;
}

