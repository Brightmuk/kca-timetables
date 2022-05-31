import 'dart:io';

import 'package:excel_reader/screens/home_screen.dart';
import 'package:excel_reader/screens/landing_page.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Wrapper(),
    ));
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalData().isFirstTime(),
      builder: (context,sn){
        if(sn.hasData&&sn.data!){
          return const LandingPage();
        }else{
          return HomePage();
        }
      }
      );
  }
}
