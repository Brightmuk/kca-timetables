import 'dart:convert';

class Time {
  final String originalStr;
  final int start;
  final int end;
  
  const Time({
    required this.originalStr,
    required this.start,
    required this.end,
  });
  
  factory Time.fromString(String time){
    
    try{
    int _start;
    int _end;
     
    if(time.trim().endsWith("HRS")){
     
      String f1 = time.substring(0, time.length-3).trim();
     
      List<String> startEnds = f1.split("-");
      _start = int.parse(startEnds[0]);
      _end = int.parse(startEnds[1]);
      
    }else{
     
       List<String> startEnds = time.split("-");
      
      bool startAM = startEnds[0].toUpperCase().contains("AM");
       _start = int.parse(startEnds[0].substring(0,startEnds[0].indexOf(".")));
      
      if(startAM){
        _start*=100;
      }else{
        _start = (_start+12)*100;
      }
       
      bool endAM = startEnds[1].toUpperCase().contains("AM");
      
       _end = int.parse(startEnds[1].substring(0,startEnds[1].indexOf(".")));
      if(endAM){
        _end*=100;
      }else{
        _end = (_end+12)*100;
      }
     
      
    }
    return Time(
      originalStr: time,
      start: _start,
      end: _end,
    );
    }catch(e){

      return const Time(originalStr:"No value",start:00,end:00);
    }

  }

  Time copyWith({
    String? originalStr,
    int? start,
    int? end,
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
      'start': start,
      'end': end,
    };
  }

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      originalStr: map['originalStr'] ?? '',
      start: map['start']?.toInt() ?? 0,
      end: map['end']?.toInt() ?? 0,
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
