import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_class_details.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';


class JoinClassMeeting extends StatefulWidget {
  final UnitClass unitClass;
  const JoinClassMeeting({ Key? key, required this.unitClass }) : super(key: key);

  @override
  State<JoinClassMeeting> createState() => _JoinClassMeetingState();
}

class _JoinClassMeetingState extends State<JoinClassMeeting> {
  String? link;
  String? passCode;
  String? meetingId;

  @override
  void initState(){
    super.initState();
    link=widget.unitClass.classLink;
    passCode=widget.unitClass.meetingPassCode;
    meetingId=widget.unitClass.meetingId;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child:
      Column(
          children: [
            Text('Join meeting',style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 50,),
            ListTile(
              onTap: ()async{

                var result = await showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  context: context, builder: (context)=>EditLink(meetingLink: link??''),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
                if(result!=null){
                  setState(() {
                    link=result;
                  });
                  save();
                }
              },
              style: ListTileStyle.drawer,
              leading: const Icon(Icons.link_outlined,
                  color: Color.fromARGB(255, 201, 174, 20)),
              title: Text('Meeting link'),
              subtitle: Text(link ?? 'Add a meeting link to join class with one tap next time'),
              trailing: link!=null?MaterialButton(
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed:(){
                  launchExternalUrl(link!);
                },
                color: const Color.fromARGB(255, 201, 174, 20),
                child: Text('JOIN',style: TextStyle(color: Colors.white,fontSize: 13),),
              ): const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
            Divider(height: 30,),
            ListTile(
              onTap: ()async{

                var result = await showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  context: context, builder: (context)=>EditCredentials(passCode:passCode??'',meetingId:meetingId??''),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
                if(result!=null){
                  setState(() {
                    passCode=result['passCode'];
                    meetingId=result['meetingId'];
                  });
                  save();
                }
              },
              style: ListTileStyle.drawer,
              leading: Icon(Icons.security_outlined,
                  color: const Color.fromARGB(255, 201, 174, 20)),
              title: Text('Meeting Id'),
              trailing: meetingId!=null?IconButton(onPressed: (){
                Clipboard.setData(ClipboardData(text: meetingId));
                toast('Meeting Id copied!');
              }, icon: Icon(Icons.copy)): const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              subtitle: Text(
                  meetingId ?? 'No meeting Id'),
            ),
            ListTile(
              onTap: ()async{

                var result = await showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context, builder: (context)=>EditCredentials(passCode:passCode??'',meetingId:meetingId??''),
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
                if(result!=null){
                  setState(() {
                    passCode=result['passCode'];
                    meetingId=result['meetingId'];
                  });
                  save();
                }
              },
              style: ListTileStyle.drawer,
              leading: Icon(Icons.security_outlined,
                  color: const Color.fromARGB(255, 201, 174, 20)),
              title: Text('Meeting passcode'),
              trailing: meetingId!=null?IconButton(onPressed: (){
                Clipboard.setData(ClipboardData(text: passCode));
                toast('Meeting passcode copied!');
              }, icon: Icon(Icons.copy)): const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              subtitle: Text(
                  ' ${passCode ?? 'No passcode'}'),
            )

          ]),


    );
  }
  void save()async{
    UnitClass _record = UnitClass(
        accentColor:  widget.unitClass.accentColor ,
        unitCode: widget.unitClass.unitCode,
        unitName: widget.unitClass.unitName,
        day: widget.unitClass.day,
        time: widget.unitClass.time,
        venue: widget.unitClass.venue,
        lecturer: widget.unitClass.lecturer,
        meetingId: meetingId,
        meetingPassCode: passCode,
        classLink: link,
        reminder: widget.unitClass.reminder,
        reminderSchedule: widget.unitClass.reminderSchedule
    );
    await TimeTableService(context: context).editRecord(record: _record);

  }
}