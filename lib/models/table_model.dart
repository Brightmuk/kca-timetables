import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:excel_reader/models/unit_class_model.dart';

class TimeTable {
  final String name;
  final String period;
  final String course;
  final DateTime date;
  TimeTable({
    required this.name,
    required this.period,
    required this.course,
    required this.date,
  });

  TimeTable copyWith({
    String? name,
    String? period,
    String? course,
    DateTime? date,
  }) {
    return TimeTable(
      name: name ?? this.name,
      period: period ?? this.period,
      course: course ?? this.course,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'period': period,
      'course': course,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory TimeTable.fromMap(Map<String, dynamic> map) {
    return TimeTable(
      name: map['name'] ?? '',
      period: map['period'] ?? '',
      course: map['course'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTable.fromJson(String source) => TimeTable.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TimeTable(name: $name, period: $period, course: $course, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TimeTable &&
      other.name == name &&
      other.period == period &&
      other.course == course &&
      other.date == date;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      period.hashCode ^
      course.hashCode ^
      date.hashCode;
  }
}
