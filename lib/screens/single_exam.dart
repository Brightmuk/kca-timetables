import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_unit_details.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/services/notification_service.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/shared/accent_color_selector.dart';
import 'package:excel_reader/shared/widgets/confirm_action.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


class EditExamPage extends StatefulWidget {
  final ExamModel exam;
  final AppState appState;
  const EditExamPage({Key? key, required this.exam, required this.appState}) : super(key: key);

  @override
  _EditExamPageState createState() => _EditExamPageState();
}

class _EditExamPageState extends State<EditExamPage> {
  DateTime? _date;
  Time? _time;
  String? _venue;
  String? _invigilator;
  bool? _reminder;
  int? _accentColor;
  TimeOfDay? _reminderSchedule;

  void initState() {
    super.initState();
    _date = widget.exam.date;
    _time = widget.exam.time;
    _venue = widget.exam.venue;
    _invigilator = widget.exam.invigilator;
    _reminder = widget.exam.reminder;
    _reminderSchedule=widget.exam.reminderSchedule;
    _accentColor=widget.exam.accentColor;


    Future.delayed(const Duration(seconds: 2),(){
      widget.appState.loadInterstitialAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = Provider.of<AppState>(context);

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
                      Text('Edit Exam',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                IconButton(onPressed: ()async{
                var result = await showModalBottomSheet(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                context: context,
                builder: (context) => const ConfirmAction(text: 'Are you sure you want to delete this exam?'));
                  if(result){
                  if(!await ExamService(context: context,state: state).deleteExam(widget.exam)){
                    toast('Sorry, an error occurred');
                  }else{
                    state.reload();
                    toast('Exam deleted');
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
                    widget.exam.unitName,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Center(
                  child: Text(
                    widget.exam.unitCode,
                    style: TextStyle(color: Colors.grey,fontSize: 14.sp),
                  ),
                ),
                Divider(
                  height: 50.sp,
                ),
                ListTile(
                  onTap: ()async{

                    // var result = await showModalBottomSheet(
                    //   backgroundColor: Colors.white,
                    //   isScrollControlled: true,
                    //   context: context, builder: (context)=>EditDay(current: _date!),
                    //   shape:
                    //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    // );
                    // if(result!=null){
                    //   setState(() {
                    //     _date=result;
                    //   });
                    //   save();
                    //   setReminder();
                    // }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.calendar_today_outlined,
                      color: Color(_accentColor!)),
                  title: Text('Date'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(DateFormat.MMMEd().format(_date!)),
                ),
                ListTile(
                  onTap: ()async{
                    var result = await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context, builder: (context)=>EditTime(time: _time!,),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _time=result;
                      });
                      save(state);
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
                  subtitle: Text(_time!.originalStr),
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
                      save(state);
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
                      context: context, builder: (context)=>EditLecturer(lecturer: _invigilator!),
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _invigilator=result;
                      });
                      save(state);
                    }
                  },
                  style: ListTileStyle.drawer,
                  leading: Icon(Icons.person_outline,
                      color: Color(_accentColor!)),
                  title: Text('Invigilator'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_invigilator!),
                ),

                Divider(),
                SwitchListTile(
                    activeColor: Color(_accentColor!),
                    title: Text('Reminder'),
                    subtitle: Text('Get reminded when exam is about to start'),
                    value: _reminder!,
                    onChanged: (val)async {
                      setState(() {
                        _reminder=val;
                      });
                      save(state);
                      if(val){
                        setReminder();
                      }else{
                        await NotificationService().cancelReminder(widget.exam.sortIndex);
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
                        context: context, builder: (context)=>EditReminderSchedule(initial: _reminderSchedule!,),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                      if(result!=null){
                        setState(() {
                          _reminderSchedule=result;
                        });
                        save(state);
                        setReminder();
                      }
                    }:null,
                    style: ListTileStyle.drawer,
                    title: const Text('Reminder schedule'),
                    subtitle: Text(Time.scheduleStr(_reminderSchedule!)),
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
                  save(state);
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


Future<void> setReminder()async{

    await NotificationService().zonedScheduleNotification(
      id: widget.exam.sortIndex, 
      title: 'Yoh! Exam is about to start', 
      description: 'Your ${widget.exam.unitName} class is starting in ${Time.scheduleStr(_reminderSchedule!)}', 
      payload: "{'unitCode':${widget.exam.unitCode}}", 
      date: _time!.getDate(widget.exam.date.weekday, _reminderSchedule!.hour, _reminderSchedule!.minute));
}

  void save(AppState state)async{
    ExamModel _exam = ExamModel(
        accentColor: _accentColor!,
        unitCode: widget.exam.unitCode,
        unitName: widget.exam.unitName,
        date: _date!,
        time: _time!,
        venue: _venue!,
        invigilator: _invigilator!,
        reminder: _reminder!,
        reminderSchedule: _reminderSchedule!
    );

    await ExamService(context: context,state: state).editExam(exam: _exam);

  }
}



