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
              future: ClassTimeTableService(context: context,state: state).getClassTimetable(),
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
            icon: Icon(
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
                child: Consumer<AppState>(builder: (context, state, child) {
                  return ListView(children: [
                    SizedBox(
                      height: 20.sp,
                    ),
                    StreamBuilder<UnitClass>(
                        stream:
                            ClassTimeTableService(context: context,state: state).upcomingClass,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: circularLoader);
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'An error has occurred',
                                style: normalTextStyle,
                              ),
                            );
                          }
                          UnitClass _record = snapshot.data!;
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Text(
                                  'UPCOMING',
                                  style: titleTextStyle,
                                ),
                                trailing: Text(
                                  Time.timeLeft(
                                      _record.time, _record.day),
                                  style: minorTextStyle,
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  _record.unitCode,
                                  style: majorTextStyle,
                                ),
                                subtitle: Text(
                                  _record.unitName.capitalise(),
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.grey[600]),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                subtitle: Text(_record.time.originalStr,
                                    style: TextStyle(fontSize: 13.sp)),
                                title: Text(
                                  _record.venue,
                                  style: tileTitleTextStyle,
                                ),
                                trailing: MaterialButton(
                                  disabledColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: _record.canJoinMeeting
                                      ? () {
                                          if (_record.classLink != null) {
                                            launchExternalUrl(
                                                _record.classLink!);
                                          } else {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (context) =>
                                                  JoinClassMeeting(
                                                      unitClass: _record),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                            );
                                          }
                                        }
                                      : null,
                                  color: Color(_record.accentColor),
                                  child: Text(
                                    'JOIN MEETING',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    Divider(
                      height: 20.sp,
                    ),
                    TodayUnitTile(
                      color: Colors.pinkAccent,
                      size: Size(MediaQuery.of(context).size.width * 0.8, 200),
                    ),
                    WeeklyUnitTile(
                        size: Size(185.sp, 185.sp), color: Colors.pinkAccent),
                    SizedBox(
                      height: 40.sp,
                    ),
                  ]);
                }),
              ),
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

class TodayUnitTile extends StatelessWidget {
  final Size size;
  final Color color;
  const TodayUnitTile({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return SizedBox(
        height: size.height + 80.sp,
        child: StreamBuilder<List<UnitClass>>(
            stream:
                ClassTimeTableService(context: context, day: weekDay,state: state).unitsStream,
            builder: (context, snapshot) {
              // if(snapshot.connectionState==ConnectionState.waiting){
              //   return const Center(child: circularLoader);
              // }
              if (!snapshot.hasData) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        'TODAY',
                        style: titleTextStyle,
                      ),
                      trailing: Text(
                        'no classe(s)',
                        style: minorTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 50.sp,
                    ),
                    Icon(
                      Icons.celebration_outlined,
                      color: secondaryThemeColor,
                      size: 40,
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Text('You have no class today', style: titleTextStyle),
                  ],
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An error has occurred',
                    style: normalTextStyle,
                  ),
                );
              }

              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'TODAY',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 3, 4, 75)),
                    ),
                    trailing: Text(
                      '${snapshot.data!.length} classe(s)',
                      style: minorTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: size.height,
                    child: ListView.separated(
                        itemCount: snapshot.data!.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 20,
                          );
                        },
                        itemBuilder: (context, index) {
                          UnitClass record = snapshot.data![index];
                          return Opacity(
                            opacity: record.isFulfiled ? 0.5 : 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditClassPage(unit: record)));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: Color(record.accentColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  width: size.width,
                                  child: CustomPaint(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.pinkAccent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Text(
                                                    record.unitCode,
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Icon(
                                                record.reminder
                                                    ? Icons.notifications_active
                                                    : Icons.notifications_off,
                                                size: 20.sp,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 60.sp,
                                          ),
                                          Text(
                                            record.unitName.capitalise(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            record.venue,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 204, 204),
                                                fontSize: 13.sp),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                record.time.originalStr,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 196, 196, 196),
                                                    fontSize: 12.sp),
                                              ),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              Text(
                                                  Time.timeLeft(
                                                      record.time,
                                                      record.day),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 139, 142, 161),
                                                      fontSize: 10.sp))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    painter: UnitPainter(
                                        color: Colors.white.withOpacity(0.1)),
                                  )),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
      );
    });
  }

  String get weekDay {
    int weekDay = DateTime.now().weekday;
    switch (weekDay) {
      case 1:
        return 'MONDAY';
      case 2:
        return 'TUESDAY';
      case 3:
        return 'WEDNESDAY';
      case 4:
        return 'THURSDAY';
      case 5:
        return 'FRIDAY';
      case 6:
        return 'SATURDAY';
      default:
        return 'None';
    }
  }
}

class WeeklyUnitTile extends StatelessWidget {
  final Size size;
  final Color color;

  const WeeklyUnitTile({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return SizedBox(
        height: size.height + 150.sp,
        child: StreamBuilder<List<UnitClass>>(
            stream: ClassTimeTableService(context: context,state: state).unitsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred'),
                );
              }
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      'WEEKLY',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 3, 4, 75)),
                    ),
                    trailing: Text(
                      '${snapshot.data!.length} classe(s)',
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(
                    height: size.height + 50.sp,
                    child: ListView.separated(
                        itemCount: snapshot.data!.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 20.sp,
                          );
                        },
                        itemBuilder: (context, index) {
                          UnitClass record = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditClassPage(unit: record)));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.day,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Color(record.accentColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: size.width,
                                    height: size.height,
                                    child: CustomPaint(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0.sp),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.all(5.sp),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.pinkAccent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Text(
                                                      record.unitCode,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              250,
                                                              250,
                                                              250),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Icon(
                                                  record.reminder
                                                      ? Icons
                                                          .notifications_active
                                                      : Icons.notifications_off,
                                                  size: 20,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 40.sp,
                                            ),
                                            Text(
                                              record.unitName.capitalise(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              record.venue,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 173, 173, 173),
                                                  fontSize: 12.sp),
                                            ),
                                            Text(
                                              record.time.originalStr,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 197, 197, 197),
                                                  fontSize: 12.sp),
                                            )
                                          ],
                                        ),
                                      ),
                                      painter: UnitPainter(
                                          color: Colors.white.withOpacity(0.1)),
                                    )),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
      );
    });
  }
}
