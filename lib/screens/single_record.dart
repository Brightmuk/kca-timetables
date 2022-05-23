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
  String? venue;
  String? _lecturer;
  String? _type;
  String? _link;
  String? _passCode;
  String? _meetingId;
  bool? _reminder;

  void initState() {
    super.initState();
    _day = widget.record.day;
    _time = widget.record.time;
    venue = widget.record.venue;
    _lecturer = widget.record.lecturer;
    _link = widget.record.classLink;
    _type = widget.record.type;
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
                style: ListTileStyle.drawer,
                leading: Icon(Icons.room_outlined,
                    color: const Color.fromARGB(255, 201, 174, 20)),
                title: Text('Venue'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                subtitle: Text(venue!),
              ),
              ListTile(
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
                style: ListTileStyle.drawer,
                leading: Icon(Icons.move_down,
                    color: const Color.fromARGB(255, 201, 174, 20)),
                title: Text('Type'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                subtitle: Text(_type!),
              ),
              ListTile(
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
                onTap: (){
                  
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
                  style: ListTileStyle.drawer,
                  title: Text('Reminder schedule'),
                  subtitle: Text('3 min'),
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
                    Navigator.pop(context);
                  }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}



