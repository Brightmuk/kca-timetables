import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_class_details.dart';
import 'package:excel_reader/services/notification_service.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/shared/accent_color_selector.dart';
import 'package:excel_reader/shared/widgets/confirm_action.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EditClassPage extends StatefulWidget {
  final UnitClass unit;
  const EditClassPage({Key? key, required this.unit}) : super(key: key);

  @override
  _EditClassPageState createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {
  String? _day;
  String? _time;
  String? _venue;
  String? _lecturer;
  String? _link;
  String? _passCode;
  String? _meetingId;
  bool? _reminder;
  int? _accentColor;
  int? _reminderSchedule;

  void initState() {
    super.initState();
    _day = widget.unit.day;
    _time = widget.unit.time.originalStr;
    _venue = widget.unit.venue;
    _lecturer = widget.unit.lecturer;
    _link = widget.unit.classLink;
    _passCode = widget.unit.meetingPassCode;
    _meetingId = widget.unit.meetingId;
    _reminder = widget.unit.reminder;
    _reminderSchedule=widget.unit.reminderSchedule??5;
    _accentColor=widget.unit.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final AppState _appState = Provider.of<AppState>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [

              ],
              toolbarHeight: MediaQuery.of(context).size.height*0.1,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  color: Color(_accentColor!),
                ),
                height: MediaQuery.of(context).size.height*0.12,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[

                      IconButton(
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Text('Edit Class',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                IconButton(onPressed: ()async{
                var result = await showModalBottomSheet(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                context: context,
                builder: (context) => const ConfirmAction(text: 'Are you sure you want to delete this unit?'));
                  if(result){
                  if(!await TimeTableService(context: context).deleteUnit(widget.unit)){
                    toast('Sorry, an error occurred');
                  }else{
                    _appState.reload();
                    toast('Unit deleted');
                    Navigator.pop(context);
                    }
                  }

                }, icon: const Icon(Icons.delete,color: Colors.white,))

                    ],
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              systemOverlayStyle:const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              leading: Container()
            ),
            body: ListView(
              children: [

                SizedBox(
                  height: 50.sp,
                ),
                Center(
                  child: Text(
                    widget.unit.unitName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                  child: Text(
                    widget.unit.unitCode,
                    style: TextStyle(color: Colors.grey,fontSize: 14.sp),
                  ),
                ),
                Divider(
                  height: 50.sp,
                ),
                ListTile(
                  onTap: ()async{

                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context, builder: (context)=>EditDay(current: _day!),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _day=result;
                      });
                      save();
                      setReminder();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.calendar_today_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Day'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_day!),
                ),
                ListTile(
                  onTap: ()async{
                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context, builder: (context)=>EditTime(start: 0,end: 0,),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _time=result;
                      });
                      save();
                      setReminder();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.watch_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Time'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_time!),
                ),
                ListTile(
                  onTap: ()async{

                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context, builder: (context)=>EditVenue(venue: _venue!),
                      shape:

                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _venue=result;
                      });
                      save();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading:  Icon(Icons.room_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Venue'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_venue!),
                ),
                ListTile(
                  onTap: ()async{

                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context, builder: (context)=>EditLecturer(lecturer: _lecturer!),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _lecturer=result;
                      });
                      save();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.person_outline,
                      color: Color(_accentColor!)),
                  title: Text('Lecturer'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_lecturer!),
                ),
                ListTile(
                  onTap: ()async{

                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context, builder: (context)=>EditLink(meetingLink: _link??''),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _link=result;
                      });
                      save();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading:Icon(Icons.link_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Meeting link'),
                  subtitle: Text(_link ?? 'No link'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
                ListTile(
                  onTap: ()async{

                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context, builder: (context)=>EditCredentials(passCode:_passCode??'',meetingId:_meetingId??''),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _passCode=result['passCode'];
                        _meetingId=result['meetingId'];
                      });
                      save();
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.security_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Meeting credentials'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(
                      'Meeting Id: ${_meetingId ?? 'No meeting Id'} | Passcode: ${_passCode ?? 'No passcode'}'),
                ),
                Divider(),
                SwitchListTile(
                    activeColor: Color(_accentColor!),
                    title: Text('Reminder'),
                    subtitle: Text('Get reminded when class is about to start'),
                    value: _reminder!,
                    onChanged: (val)async {
                      setState(() {
                        _reminder=val;
                      });
                      save();
                      if(val){
                        setReminder();
                      }else{
                        await NotificationService().cancelReminder(widget.unit.sortIndex);
                      }
                    }),
                AnimatedOpacity(
                  opacity: _reminder!?1:0,

                  duration: Duration(milliseconds: 500),
                  child: ListTile(
                    onTap:_reminder!? ()async{

                      var result = await showModalBottomSheet(
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        context: context, builder: (context)=>EditReminderSchedule(minutes: _reminderSchedule!,),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                      if(result!=null){
                        setState(() {
                          _reminderSchedule=result;
                        });
                        save();
                        setReminder();
                      }
                    }:null,
                    style: ListTileStyle.drawer,
                    title: const Text('Reminder schedule'),
                    subtitle: Text(scheduleStr(_reminderSchedule!)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ),
                Divider(height: 10.sp,),
                Center(child: Text('Accent color',style: tileTitleTextStyle,)),

                SizedBox(
                  height: 20.sp,
                ),
                AccentColorSelector(currentColor: _accentColor!, onChange: (val){
                  setState(() {
                    _accentColor=val;
                  });
                  save();
                },),

                SizedBox(
                  height: 70.sp,
                ),


              ],
            )),
           Positioned(
            bottom: 10,
            child: AdmobBanner(
              adUnitId: 'ca-app-pub-1360540534588513/1644840657',
              adSize: AdmobBannerSize.FULL_BANNER,
              listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
                debugPrint(args.toString());
              },
              onBannerCreated: (AdmobBannerController controller) {},
            ),
          )
      ],
    );
  }


String get timeFormatStr{
  if(_reminderSchedule!>60){
    return '${_reminderSchedule!~/60} hour(s)';
  }else{
    return '$_reminderSchedule minutes';
  }
}

int get reminderHrs{
  int hrs=0;
  if(_reminderSchedule!%60>0){
    hrs = _reminderSchedule!~/60;
  }
  return hrs;
}
int get reminderMins{
  int mins=0;
  if(_reminderSchedule!<60){
    mins = _reminderSchedule!.toInt();
  }
  return mins;
}


Future<void> setReminder()async{
  debugPrint(getDate().toString());
  
    await NotificationService().zonedScheduleNotification(
      id: widget.unit.sortIndex, 
      title: 'Class is about to start', 
      description: 'Your ${widget.unit.unitName} class is starting in $timeFormatStr', 
      payload: "{'unitCode':${widget.unit.unitCode}}", 
      date: getDate());
}

DateTime getDate(){
  
  int startHour=int.parse(_time!.substring(0,2));
  int startMinute = int.parse(_time!.substring(2,4));
  DateTime now = DateTime.now();

  int unitDay = getWeekday(_day);

  int dayDifference;
  if(unitDay<now.weekday){
    unitDay+=7;
    dayDifference=unitDay-now.weekday;
  }else{
    dayDifference=unitDay-now.weekday;
  }

  return DateTime(
    now.year,now.month,now.day+dayDifference, startHour-reminderHrs,startMinute-reminderMins
    );
}

  String scheduleStr(int minutes){
    if(minutes>59){
      return (minutes/60).toString()+' hours';
    }else {
      return minutes.toString()+' minutes';
    }
  }
  void save()async{
    UnitClass _record = UnitClass(
        accentColor: _accentColor!,
        unitCode: widget.unit.unitCode,
        unitName: widget.unit.unitName,
        day: _day!,
        time: Time.fromString(_time!),
        venue: _venue!,
        lecturer: _lecturer!,
        meetingId: _meetingId,
        meetingPassCode: _passCode,
        classLink: _link,
        reminder: _reminder!,
        reminderSchedule: _reminderSchedule
    );

    await TimeTableService(context: context).editRecord(record: _record);

  }

  int getWeekday(day){
      switch (day) {
      case 'MONDAY':
        return 1;
      case 'TUESDAY':
        return 2;
      case 'WEDNESDAY':
        return 3;
      case 'THURSDAY':
        return 4;
      case 'FRIDAY':
        return 5;
      case 'SATURDAY':
        return 6;
      default:
        return 0;
    }
}
}



