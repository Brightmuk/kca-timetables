import 'package:excel_reader/models/period_model.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum CourseType { degree, diploma, certificate, masters, phd }

class ClassPeriodSelector extends StatefulWidget {
  final String courseType;
  const ClassPeriodSelector({Key? key, required this.courseType}) : super(key: key);

  @override
  State<ClassPeriodSelector> createState() => _ClassPeriodSelectorState();
}

class _ClassPeriodSelectorState extends State<ClassPeriodSelector> {
  String? periodStr;
  CourseType? type;
  Period? _period;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.courseType);
    if (widget.courseType.startsWith('B')) {
      type = CourseType.degree;
    } else if (widget.courseType.startsWith('C')) {
      type = CourseType.certificate;
    } else if (widget.courseType.startsWith('D')) {
      type = CourseType.diploma;
    } else if (widget.courseType.startsWith('P')) {
      type = CourseType.phd;
    } else if (widget.courseType.startsWith('M')) {
      type = CourseType.masters;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(child: periodTypes()),
      ),
    );
  }

  Widget periodTypes() {
    switch (type) {
      case CourseType.degree:
      case CourseType.masters:
      case CourseType.phd:
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim one'),
                value: 'Year one Trim one',
                groupValue: periodStr,
                onChanged: (String? val) {
                  Period period = Period(str: val!, type: type!, reg: RegExp(r'(one+\s\w+\s+one|\D+1+\D+1|1.1)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim two'),
                value: 'Year one Trim two',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(one+\s\w+\s+two|\D+1+\D+2|1.2)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim three'),
                value: 'Year one Trim three',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(one+\s\w+\s+three|\D+1+\D+3|1.3)',caseSensitive:false));
                  choosePeriod(period);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim one'),
                value: 'Year two Trim one',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(two+\s\w+\s+one|\D+2+\D+1|2.1)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim two'),
                value: 'Year two Trim two',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(two+\s\w+\s+two|\D+2+\D+2|2.2)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim three'),
                value: 'Year two Trim three',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(two+\s\w+\s+three|\D+2+\D+3|2.3)',caseSensitive:false));
                  choosePeriod(period);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim one'),
                value: 'Year three Trim one',
                groupValue: periodStr,
                onChanged: (String? val) {
                Period period = Period(str: val!, type: type!, reg: RegExp(r'(three+\s\w+\s+one|\D+3+\D+1|3.1)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim two'),
                value: 'Year three Trim two',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(three+\s\w+\s+two|\D+3+\D+2|3.2)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim three'),
                value: 'Year three Trim three',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(three+\s\w+\s+three|\D+3+\D+3|3.3)',caseSensitive:false));
                  choosePeriod(period);
                }),
          ],
        );

      case CourseType.diploma:
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage one'),
                value: 'Stage one',
                groupValue: periodStr,
                onChanged: (String? val) {
                 Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+one|one|stage\s\1|stage1|\D+I)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage two'),
                value: 'Stage two',
                groupValue: periodStr,
                onChanged: (String? val) {
                  Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+two|two|stage\s\2|stage2|\D+II)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage three'),
                value: 'Stage three',
                groupValue: periodStr,
                onChanged: (String? val) {
                Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+three|three|stage\s\3|stage3|\D+III)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage four'),
                value: 'Stage four',
                groupValue: periodStr,
                onChanged: (String? val) {
                  Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+four|four|stage\s\4|stage4|\D+IV)',caseSensitive:false));
                  choosePeriod(period);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage five'),
                value: 'Stage five',
                groupValue: periodStr,
                onChanged: (String? val) {
                  Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+five|five|stage\s\5|stage5|\D+V)',caseSensitive:false));
                  choosePeriod(period);
                }),
          ],
        );
      case CourseType.certificate:
        return Column(children: [
          const SizedBox(
            height: 20,
          ),
          Divider(),
          RadioListTile(
              activeColor: const Color.fromRGBO(188, 175, 69, 1),
              title: const Text('Stage one'),
              value: 'Stage one',
              groupValue: periodStr,
              onChanged: (String? val) {
                Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+one|one|stage\s\1|stage1|\D+I)',caseSensitive:false));
                  choosePeriod(period);
              }),
          RadioListTile(
              activeColor: const Color.fromRGBO(188, 175, 69, 1),
              title: const Text('Stage two'),
              value: 'Stage two',
              groupValue: periodStr,
              onChanged: (String? val) {
                Period period = Period(str: val!, type: type!, reg: RegExp(r'(\D+two|two|stage\s\2|stage2|\D+I)',caseSensitive:false));
                  choosePeriod(period);
              }),
        ]);



      default:
        return Container();
    }
  }

  void choosePeriod(Period val) {
    setState(() {
      periodStr = val.str;
    });
   
    Future.delayed(const Duration(milliseconds: 500), () {
      
      Navigator.pop(context, val);
    });
  }
}

