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

  static Time noValue = Time(originalStr:"No value",start:TimeOfDay.now(),end:TimeOfDay.now());
  
  factory Time.fromString(String time){
    
    try{
    int _startHour;
    int _startMin;
    int _endHour;
    int _endMin;
     
    if(time.trim().endsWith("HRS")){
     
      String f1 = time.substring(0, time.length-3).trim();
     
      List<String> startEnds = f1.split("-");
      String start = startEnds[0].trim();
      String end = startEnds[1].trim();
      _startHour = int.parse(start.substring(0,2));
      _startMin = int.parse(start.substring(2));
      _endHour = int.parse(end.substring(0,2));
      _endMin = int.parse(end.substring(2));
      
    }else{
     
       List<String> startEnds = time.split("-");
      String start = startEnds[0].trim();
      String end = startEnds[1].trim();
      
      bool startAM = start.toUpperCase().contains("AM");
       _startHour = int.parse(start.substring(0,start.indexOf(".")));
      
      if(!startAM){
        _startHour = _startHour+12;
      }
       
      bool endAM = end.toUpperCase().contains("AM");
      
       _endHour = int.parse(end.substring(0,end.indexOf(".")));
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

      return noValue;
    }

  }

  static  String scheduleStr(TimeOfDay time) {
    if (time.hour>0) {
      return time.hour.toString() + ' hour(s)';
    } else {
      return time.minute.toString() + ' minutes';
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

 static int get timeIndex {
    
  int weekDay=DateTime.now().weekday;
  int hourOfDay = DateTime.now().hour;

  return (weekDay*100)+hourOfDay;

}



static String timeLeft(Time time, String day){
  TimeOfDay startTime=time.start;
  TimeOfDay endTime=time.end;

  DateTime now = DateTime.now();
  int recordDay = dayIndex(day);

if(recordDay-now.weekday==0&&now.hour>=startTime.hour&&now.hour<endTime.hour){
  
    return 'Ongoing';
  }
if(recordDay-now.weekday==0&&startTime.hour-now.hour==1){
    return 'in ${60-now.minute} minutes';
  }
if(recordDay-now.weekday==0&&startTime.hour-now.hour>1){
      return 'In ${(startTime.hour-now.hour).toStringAsFixed(0)} hours';
}
if(recordDay-now.weekday==1){
    return 'Tomorrow';
  }
if(recordDay-now.weekday==0&&endTime.hour<now.hour){
    return 'done';
  }

// return 'on $day';
return '';
}

static String relativeDay(DateTime date){
  DateTime today = DateTime.now();

  if(date.difference(today).inDays==0){
    return 'Today';
  }else if(date.difference(today).inDays==1){
    return 'Tomorrow';
  }else if(today.difference(date).inDays==1){
    return 'Yesterday';
  }else if(date.difference(today).inDays>1){
    return 'in ${date.day-today.day} days';
  }else if(today.difference(date).inDays>1){
    return 'days ago';
  }else{
    return dayFromWeekday(date.weekday);
  }
}


static int dayIndex(String day) {

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


static String convertDay(String day) {
  switch (day) {
    case 'MONDAY':
      return 'MON';
    case 'TUESDAY':
      return 'TUE';
    case 'WEDNESDAY':
      return 'WED';
    case 'THURSDAY':
      return 'THUR';
    case 'FRIDAY':
      return 'FRI';
    case 'SATURDAY':
      return 'SAT';
    default:
      return '';
  }
}
 static String dayFromWeekday(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'MONDAY';
      case 2:
        return 'TUESDAY';
      case 3:
        return 'WEDNESDAY';
      case 4:
        return 'THURSDAY';
      case 5:
        return 'FRIDAY';
      case 6:
        return 'SATURDAY';
      default:
        return '';
    }
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


  static String minuteFormat(int minute){
    if(minute>=10){
      return minute.toString();
    }else{
      return "0"+minute.toString();
    }
  }
  static String hourFormat(int hour){
    if(hour>=10){
      return hour.toString();
    }else{
      return "0"+hour.toString();
    }
  }
  static String timeStringFromTime(TimeOfDay start, TimeOfDay end){
    return '${hourFormat(start.hour)}${minuteFormat(start.minute)} - ${hourFormat(end.hour)}${minuteFormat(end.minute)} HRS';
  }

  static Map<int,String> monthName = {
       1:'Jan',2:'Feb',3:'March',4:'April',5:'May',6:'June',
       7:'July',8:'Aug',9:'Sept',10:'Oct',11:'Nov',12:'Dec'
  };



}

