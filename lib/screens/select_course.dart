import 'package:flutter/material.dart';

class CourseSelector extends StatefulWidget {
  final List<String> courses;
  const CourseSelector({Key? key, required this.courses}) : super(key: key);

  @override
  _CourseSelectorState createState() => _CourseSelectorState();
}

class _CourseSelectorState extends State<CourseSelector> {
  String? course;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: ListView.builder(
          itemCount: widget.courses.length,
          itemBuilder: (context, index) {
            return RadioListTile(
                activeColor: const Color.fromRGBO(188, 175, 69, 1),
                title: Text(widget.courses[index]),
                value: widget.courses[index],
                groupValue: course,
                onChanged: (String? val) {
                  chooseCourse(val!);
                });
          }),
    );
  }

  void chooseCourse(String val) {
    setState(() {
      course = val;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context, course);
    });
  }
}