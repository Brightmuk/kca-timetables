import 'package:excel_reader/screens/scan_screen.dart';
import 'package:flutter/material.dart';

class IsTimetableScreen extends StatefulWidget {
  
  const IsTimetableScreen({Key? key}) : super(key: key);

  @override
  _IsTimetableScreenState createState() => _IsTimetableScreenState();
}

class _IsTimetableScreenState extends State<IsTimetableScreen> {
  String? course;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      height: 300,
      child: Column(
        children: [
          ListTile(
            style: ListTileStyle.drawer,
            onTap: (){
               Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const ScanScreen(isClass: true,)));
            },
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: Color.fromRGBO(188, 175, 69, 0.3),
              size: 35,
            ),
            title: const Text('Class Timetable'),
            subtitle:
            Text('Scan class timetable'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ),
          ListTile(
            style: ListTileStyle.drawer,
            onTap: (){
               Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanScreen(isClass: false,)));
            },
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: Color.fromRGBO(188, 175, 69, 0.3),
              size: 35,
            ),
            title: const Text('Exam Timetable'),
            subtitle:
            Text('Scan exam timetable'),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ),
      ],)
    );
  }


}