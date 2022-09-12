import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/notification.dart';
import 'package:excel_reader/screens/home_screen.dart';
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
  Admob.initialize();


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

///Configure timezones
Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}


class WrapperWidget extends StatefulWidget {
  const WrapperWidget({ Key? key }) : super(key: key);

  @override
  State<WrapperWidget> createState() => _WrapperWidgetState();
}

class _WrapperWidgetState extends State<WrapperWidget> {
  List<Widget> pages = const[Home(),Profile()];

  int currentPage=0;

  Widget currentView(){
    return pages[currentPage];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentView(),

      bottomNavigationBar: Container(
        child: Row(
          children: [
          IconButton(onPressed: (){
          setState(() {
            currentPage=0;
          });
        }, icon: Icon(Icons.home)),
        IconButton(onPressed: (){
          setState(() {
            currentPage=1;
          });
        }, icon: Icon(Icons.person))
        ]),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('home'),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Profile'),
    );
  }
}