import 'package:excel_reader/record_model.dart';
import 'package:excel_reader/screens/edit_listing_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleRecord extends StatefulWidget {
  final Record record;
  const SingleRecord({Key? key, required this.record}) : super(key: key);

  @override
  _SingleRecordState createState() => _SingleRecordState();
}

class _SingleRecordState extends State<SingleRecord> {
  String? _day;
  String? _time;
  String? _venue;
  String? _lecturer;
  String? _link;
  String? _passCode;
  String? _meetingId;
  bool? _reminder;
  int _reminderSchedule=5;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Edit listing',
                  style: TextStyle(
                      color: Color.fromRGBO(3, 4, 94, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const Divider(
                height: 50,
              ),
              Text(
                widget.record.unitName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.record.unitCode,
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(
                height: 50,
              ),
              ListTile(
                onTap: ()async{

                  var result = await showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context, builder: (context)=>EditDay(current: _day!),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _day=result;
                      });
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.calendar_today_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
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
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.watch_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
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
                    context: context, builder: (context)=>EditVenue(venue: _venue!),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _venue=result;
                      });
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.room_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
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
                    context: context, builder: (context)=>EditLecturer(lecturer: _lecturer!),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _lecturer=result;
                      });
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.person_outline,
                    color: const Color.fromARGB(255, 201, 174, 20)),
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
                    context: context, builder: (context)=>EditLink(meetingLink: _link??''),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _link=result;
                      });
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.link_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
                title: Text('Meeting link'),
                subtitle: Text(_link ?? 'No link'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ),
              ListTile(
                onTap: ()async{

                  var result = await showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context, builder: (context)=>EditCredentials(passCode:_passCode??'',meetingId:_meetingId??''),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _passCode=result['passCode'];
                        _meetingId=result['meetingId'];
                      });
                    }
                },
                style: ListTileStyle.drawer,
                leading: Icon(Icons.security_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
                title: Text('Meeting credentials'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                subtitle: Text(
                    'Meeting Id: ${_meetingId ?? 'No meeting Id'} | Passcode: ${_passCode ?? 'No passcode'}'),
              ),
              Divider(),
              SwitchListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text('Reminder'),
                  subtitle: Text('Get reminded when class is about to start'),
                  value: _reminder!,
                  onChanged: (val) {
                    setState(() {
                      _reminder=val;
                    });
                  }),
              AnimatedOpacity(
                opacity: _reminder!?1:0,
              
                duration: Duration(milliseconds: 300),
                child: ListTile(
                onTap: ()async{

                  var result = await showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context, builder: (context)=>EditReminderSchedule(minutes: _reminderSchedule,),
                              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                    if(result!=null){
                      setState(() {
                        _reminderSchedule=result;
                      });
                    }
                },
                  style: ListTileStyle.drawer,
                  title: Text('Reminder schedule'),
                  subtitle: Text(scheduleStr(_reminderSchedule)),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              MaterialButton(
                  disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(20),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: const Color.fromARGB(255, 201, 174, 20),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Record _record = Record(
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
                    Navigator.pop(context,_record);
                  }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
    String scheduleStr(int minutes){
    if(minutes>59){
      return (minutes/60).toString()+' hours';
    }else {
      return minutes.toString()+' minutes';
    }
  }
}



