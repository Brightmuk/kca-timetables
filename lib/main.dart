import 'package:excel_reader/screens/class_home.dart';
import 'package:excel_reader/screens/exam_home.dart';
import 'package:excel_reader/screens/landing_page.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;



void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>.value(
          value: MyAppState()
          )
    ],
    child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child:
      ScreenUtilInit(
      designSize: const Size(428,926),
      minTextAdapt: true,
      splitScreenMode: true,
        builder:(context,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Wrapper(),
        ),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyAppState state = Provider.of<MyAppState>(context);
    if(state.appMode==AppMode.classTimetable){
      return const ClassHome();
    }else if(state.appMode==AppMode.examTimetable){
      return const ExamsHome();
    }else{
      return const LandingPage();
    }
  }
}

///Configure timezones
// Future<void> configureLocalTimeZone() async {
//   tz.initializeTimeZones();
//   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
//   tz.setLocalLocation(tz.getLocation(timeZoneName!));
// }
