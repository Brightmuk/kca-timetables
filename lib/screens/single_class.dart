import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_class_details.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/accent_color_selector.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

class EditClassPage extends StatefulWidget {
  final UnitClass record;
  const EditClassPage({Key? key, required this.record}) : super(key: key);

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
    _day = widget.record.day;
    _time = widget.record.time;
    _venue = widget.record.venue;
    _lecturer = widget.record.lecturer;
    _link = widget.record.classLink;
    _passCode = widget.record.meetingPassCode;
    _meetingId = widget.record.meetingId;
    _reminder = widget.record.reminder;
    _reminderSchedule=widget.record.reminderSchedule??5;
    _accentColor=widget.record.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
           appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height*0.1,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                color: Color.fromARGB(255, 3, 4, 75),
              ),
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width,
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
                                                                                  IconButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  save();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.transparent,
                ),
              ),
      
                ],
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 3, 4, 75),
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            leading: IconButton(
              padding: EdgeInsets.all(20),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color.fromRGBO(3, 4, 94, 1),
              ),
            ),
          ),
          body: ListView(
            children: [
    
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  widget.record.unitName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  widget.record.unitCode,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(
                height: 50,
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
                    context: context, builder: (context)=>EditTime(current: _time!),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _time=result;
                      });
                      save();
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
                  onChanged: (val) {
                    setState(() {
                      _reminder=val;
                    });
                    save();
                  }),
              AnimatedOpacity(
                opacity: _reminder!?1:0,
              
                duration: Duration(milliseconds: 500),
                child: ListTile(
                onTap: ()async{
    
                  var result = await showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context, builder: (context)=>EditReminderSchedule(minutes: _reminderSchedule!,),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _reminderSchedule=result;
                      });
                      save();
                    }
                },
                  style: ListTileStyle.drawer,
                  title: const Text('Reminder schedule'),
                  subtitle: Text(scheduleStr(_reminderSchedule!)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
              const Divider(height: 30,),
              Center(child: Text('Accent color',style: tileTitleTextStyle,)),
    
              const SizedBox(
                height: 20,
              ),
              AccentColorSelector(currentColor: _accentColor!, onChange: (val){
                setState(() {
                  _accentColor=val;
                });
                save();
              },),
    
              const SizedBox(
                height: 50,
              ),
    
              SizedBox(
                height: 30,
              ),
            ],
          )),
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
      unitCode: widget.record.unitCode,
      unitName: widget.record.unitName,
      day: _day!,
      time: _time!,
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
}



