import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:excel_reader/models/unit_class_model.dart';

class TimeTable {
  final String name;
  final List<UnitClass> records;

  const TimeTable({
    required this.name,
    required this.records,
  });



  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'records': records.map((x) => x.toMap()).toList(),
    };
  }

  factory TimeTable.fromMap(Map<String, dynamic> map) {
    return TimeTable(
      name: map['name'] ?? '',
      records: List<UnitClass>.from(map['records']?.map((x) => UnitClass.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeTable.fromJson(String source) => TimeTable.fromMap(json.decode(source));

  @override
  String toString() => 'TimeTable(name: $name, records: $records)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TimeTable &&
      other.name == name &&
      listEquals(other.records, records);
  }

  @override
  int get hashCode => name.hashCode ^ records.hashCode;
}
