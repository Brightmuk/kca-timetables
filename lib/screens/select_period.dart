import 'package:flutter/material.dart';

enum CourseType { degree, diploma, certificate, masters, phd }

class PeriodSelector extends StatefulWidget {
  final String courseType;
  const PeriodSelector({Key? key, required this.courseType}) : super(key: key);

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  String? period;
  CourseType? type;

  @override
  void initState() {
    super.initState();
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
                title: const Text('Year two trim three'),
                value: 'Year two trim three',
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
