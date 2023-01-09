import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/notification.dart';
import 'package:excel_reader/screens/class_home.dart';
import 'package:excel_reader/screens/exam_home.dart';
import 'package:excel_reader/screens/landing_page.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/services/notification_service.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


NotificationPayload? payload;

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  payload = await NotificationService().init();
  await configureLocalTimeZone();
  Admob.initialize(testDeviceIds: ['0f4776ef-ce75-43fa-8b97-6a9a90fe35a6']);


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(
          value: AppState()
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
    AppState state = Provider.of<AppState>(context);

    if(state.mode==AppMode.classTimetable){
      return const ClassHome();
    }else if(state.mode==AppMode.examTimetable){
      return const ExamsHome();
    }else{
      return const LandingPage();
    }
  }
}

///Configure timezones
Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
