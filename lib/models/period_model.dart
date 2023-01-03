


import 'package:excel_reader/screens/select_period.dart';

class Period{
  final String str;
  final RegExp reg;
  final CourseType type;

  const Period({required this.str, required this.type, required this.reg});

  bool isMatch(String value){
    return reg.stringMatch(value)!=null;
  }
  @override
  String toString(){
    return "Str: $str, Reg: $reg, Type: $type";
  }

}