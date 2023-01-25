import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/screens/exam_home.dart';
import 'package:excel_reader/screens/join_meeting_screen.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/screens/settings.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/widgets/app_drawer.dart';
import 'package:excel_reader/shared/widgets/app_loader.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/shared/unit_painter.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel_reader/models/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ClassHome extends StatefulWidget {
  const ClassHome({
    Key? key,
  }) : super(key: key);

  @override
  State<ClassHome> createState() => _ClassHomeState();
}

class _ClassHomeState extends State<ClassHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);

    return Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: FutureBuilder<TimeTable>(
              future: ClassTimeTableService(context: context, state: state)
                  .getClassTimetable(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.name,
                    style: titleTextStyle.copyWith(color: primaryThemeColor),
                  );
                } else {
                  return Text(
                    '',
                    style: titleTextStyle.copyWith(color: primaryThemeColor),
                  );
                }
              }),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: primaryThemeColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const SettingsPage()));
              },
            ),
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: primaryThemeColor,
            ),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        drawer: AppDrawer(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                  color: primaryThemeColor,
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: StreamBuilder<List<UnitClass>>(
                      stream:
                          ClassTimeTableService(context: context, state: state)
                              .unitsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error has occurred'),
                          );
                        }
                        List<UnitClass> units = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: ListView.separated(
                              itemCount: units.length,
                              separatorBuilder: ((context, index) {
                                if (units[index].day == units[index + 1].day) {
                                  return const Divider(
                                    color: primaryThemeColor,
                                    height: 0,
                                  );
                                } else {
                                  return const Divider(
                                    color: Color.fromARGB(255, 187, 187, 187),
                                    height: 1,
                                  );
                                }
                              }),
                              itemBuilder: (context, index) {
                                bool _withSameDay = index!=units.length-1&&units[index].day==units[index+1].day;
                                bool _sameDay = index != 0 &&
                                    units[index].day == units[index - 1].day;
                                return ClassUnitTile(
                                  unit: units[index],
                                  state: state,
                                  withSameDay: _withSameDay,
                                  sameDay: _sameDay,
                                );
                              }),
                        );
                      })),
            ),
            Positioned(
              bottom: 10,
              child: AdmobBanner(
                adUnitId: 'ca-app-pub-1360540534588513/5000702124',
                adSize: AdmobBannerSize.FULL_BANNER,
                listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
                  debugPrint(args.toString());
                },
                onBannerCreated: (AdmobBannerController controller) {},
              ),
            )
          ],
        ));
  }
}

class ClassUnitTile extends StatefulWidget {
  final UnitClass unit;
  final bool sameDay;
  final bool withSameDay;
  final AppState state;
  const ClassUnitTile({Key? key, required this.unit, required this.sameDay, required this.withSameDay, required this.state})
      : super(key: key);

  @override
  State<ClassUnitTile> createState() => _ClassUnitTileState();
}

class _ClassUnitTileState extends State<ClassUnitTile> {
  UnitClass? nowOrNextClass;
  @override
  void initState(){
    super.initState();
    ClassTimeTableService(state: widget.state,context: context).upcomingClass.listen((value) {
      if(mounted){
      setState(() {
        nowOrNextClass=value;
      });
      }
     });
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = Provider.of<AppState>(context);

    bool isNowOrNext = nowOrNextClass!=null&&nowOrNextClass!.unitCode==widget.unit.unitCode;
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditClassPage(unit: widget.unit,appState: state,)));
      },
      child: Container(
        margin: EdgeInsets.zero,
        height: 120.sp,
        color:  isNowOrNext?secondaryThemeColor.withOpacity(0.1): Colors.white,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 85.sp,
            color: Color(widget.unit.accentColor),
            child: Column(
                mainAxisAlignment:
                    widget.withSameDay ? MainAxisAlignment.end : MainAxisAlignment.center,
                children: [
                  Text(widget.sameDay ? '' : widget.unit.day,
                      style: TextStyle(color: Colors.white))
                ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RichText(text: TextSpan(children: [
                  TextSpan(text: widget.unit.time.originalStr,style: TextStyle(color: Color.fromARGB(255, 92, 92, 92),fontWeight: FontWeight.bold)),
                  TextSpan(text: " "+Time.timeLeft(widget.unit.time, widget.unit.day),style: TextStyle(color: Colors.grey,fontSize: 10.sp))
                ])),

                SizedBox(
                  height: 10.sp,
                ),
                Flexible(
                    child: Text(
                  widget.unit.unitName.capitalise(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                    
                      color: Color.fromARGB(255, 46, 46, 46)),
                )),
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outlined,
                          color: secondaryThemeColor,
                          size: 18.sp,
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Text(widget.unit.lecturer.capitalise(),
                            style: TextStyle(
                              
                            )),
                      ],
                    ),

                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.house_outlined,
                          color: secondaryThemeColor,
                          size: 18.sp,
                        ),
                        SizedBox(
                          width: 10.sp,
                        ),
                        Text(widget.unit.venue.capitalise(),
                            style: TextStyle(
                              
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.sp,
                )
              ],
            ),
          ),
          SizedBox(
            width: 0.sp,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 5.sp,),
              Icon(
                widget.unit.reminder?
                Icons.notifications_outlined:Icons.notifications_off_outlined,
                color: secondaryThemeColor,
                size: 18.sp,
              ),
               Opacity(
                 opacity:  widget.unit.canJoinMeeting?1:0,
                 child: MaterialButton(
                   minWidth: 40,
                  
                   color: secondaryThemeColor,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   onPressed: widget.unit.canJoinMeeting?(){
              if(widget.unit.classLink!=null){
                if(widget.unit.meetingPassCode!=null){
                    Clipboard.setData(ClipboardData(text: widget.unit.meetingPassCode));
                    toast('Meeting passscode copied!');
                }else{
                  toast('No meeting passcode');
                }
               Future.delayed(Duration(seconds: 1),()=> 
              launchExternalUrl(widget.unit.classLink!));
              
            }else{
              showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context, builder: (context)=>JoinClassMeeting(unitClass: widget.unit),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              );
            }
                 }:null,child: const Text('Join Meeting',style:TextStyle(color: Colors.white)),),
               )
            ],
           
          ),
          SizedBox(
            width: 10.sp,
          ),
        ]),
      ),
    );
  }
}
