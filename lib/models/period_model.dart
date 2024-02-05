


import 'package:excel_reader/screens/select_period.dart';
import 'package:flutter/foundation.dart';

class Period{
  final String str;
  final RegExp reg;
  final CourseType type;

  const Period({required this.str, required this.type, required this.reg});

  bool isMatch(String value){

    if(isTrimType){
    return reg.stringMatch(value)!=null;
    // &&value.toLowerCase().contains('trim');
    }else{
    return reg.stringMatch(value)!=null;
    }

  }
  bool get isTrimType{
    return type==CourseType.degree||type==CourseType.masters||type==CourseType.phd;
  }
  @override
  String toString(){
    return "Str: $str, Reg: $reg, Type: $type";
  }

}