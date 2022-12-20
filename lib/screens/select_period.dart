import 'package:flutter/material.dart';

enum CourseType { degree, diploma, certificate, masters, phd }

class ClassPeriodSelector extends StatefulWidget {
  final String courseType;
  const ClassPeriodSelector({Key? key, required this.courseType}) : super(key: key);

  @override
  State<ClassPeriodSelector> createState() => _ClassPeriodSelectorState();
}

class _ClassPeriodSelectorState extends State<ClassPeriodSelector> {
  String? period;
  CourseType? type;

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
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim two'),
                value: 'Year one Trim two',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim three'),
                value: 'Year one Trim three',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim one'),
                value: 'Year two Trim one',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim two'),
                value: 'Year two Trim two',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim three'),
                value: 'Year two Trim three',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim one'),
                value: 'Year three Trim one',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim two'),
                value: 'Year three Trim two',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim three'),
                value: 'Year three Trim three',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
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
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage two'),
                value: 'Stage two',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage three'),
                value: 'Stage three',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage four'),
                value: 'Stage four',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage five'),
                value: 'Stage five',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
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
              groupValue: period,
              onChanged: (String? val) {
                choosePeriod(val!);
              }),
          RadioListTile(
              activeColor: const Color.fromRGBO(188, 175, 69, 1),
              title: const Text('Stage two'),
              value: 'Stage two',
              groupValue: period,
              onChanged: (String? val) {
                choosePeriod(val!);
              }),
        ]);



      default:
        return Container();
    }
  }

  void choosePeriod(String val) {
    setState(() {
      period = val;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, period);
    });
  }
}

class ExamPeriodSelector extends StatefulWidget {
  final String courseType;
  const ExamPeriodSelector({Key? key, required this.courseType}) : super(key: key);

  @override
  State<ExamPeriodSelector> createState() => _ExamPeriodSelectorState();
}

class _ExamPeriodSelectorState extends State<ExamPeriodSelector> {
  String? period;
  CourseType? type;

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
                value: 'Year1Trim1',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim two'),
                value: 'Year1Trim2',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year one Trim three'),
                value: 'Year1Trim3',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim one'),
                value: 'Year2Trim1',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim two'),
                value: 'Year2Trim2',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year two Trim three'),
                value: 'Year2Trim3',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            Divider(),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim one'),
                value: 'Year3Trim1',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim two'),
                value: 'Year3Trim1',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Year three Trim three'),
                value: 'Year3Trim3',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
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
                value: 'Stage1',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage two'),
                value: 'Stage2',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage three'),
                value: 'Stage3',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage four'),
                value: 'Stage4',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
            RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: const Text('Stage five'),
                value: 'Stage5',
                groupValue: period,
                onChanged: (String? val) {
                  choosePeriod(val!);
                }),
          ],
        );
      case CourseType.certificate:
        return Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          RadioListTile(
              activeColor: const Color.fromRGBO(188, 175, 69, 1),
              title: const Text('Stage one'),
              value: 'Stage1',
              groupValue: period,
              onChanged: (String? val) {
                choosePeriod(val!);
              }),
          RadioListTile(
              activeColor: const Color.fromRGBO(188, 175, 69, 1),
              title: const Text('Stage two'),
              value: 'Stage2',
              groupValue: period,
              onChanged: (String? val) {
                choosePeriod(val!);
              }),
        ]);

      default:
        return Container();
    }
  }

  void choosePeriod(String val) {
    setState(() {
      period = val;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, period);
    });
  }
}