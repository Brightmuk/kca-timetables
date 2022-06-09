import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


enum EditDetailType { day, time, venue, lecturer, type, link, credentials }


class EditDay extends StatefulWidget {
  final String current;
  const EditDay({ Key? key,required this.current }) : super(key: key);


  @override
  State<EditDay> createState() => _EditDayState();
}

class _EditDayState extends State<EditDay> {
    static const List<String> days = [
    'MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY'
  ];
  String? groupValue;

  @override
  void initState(){
    super.initState();
    groupValue=widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: MediaQuery.of(context).size.height*0.7,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
          children: [
           
            Column(
              children: [
                  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Day',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),
                Expanded(
                  child: ListView.builder(
                    itemCount: days.length,
                      itemBuilder: (context,index){
                        return RadioListTile(
                          title: Text(days[index],style: tileTitleTextStyle,),
                          activeColor: const Color.fromARGB(255, 201, 174, 20),
                          value: days[index], 
                          groupValue: groupValue,
                           onChanged: (val){
                   setState(() {
                     groupValue=days[index];
                   });
                
                           }
                           );
                      }
                      ),
                ),
                SizedBox(height: 30.sp,),
              ],
            ),
           
       Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                      Navigator.pop(context,groupValue);
                    }
                        ),
              )
          ],
        ),
    );
  
  }
}
class EditTime extends StatefulWidget {
  final String current;
  const EditTime({ Key? key,required this.current }) : super(key: key);

  @override
  State<EditTime> createState() => _EditTimeState();
}

class _EditTimeState extends State<EditTime> {

  @override
  void initState(){
    super.initState();
    try{
    List<String> range = widget.current.substring(0,widget.current.length-3).split('-');
    start = double.parse(range[0]);
    end = double.parse(range[1]) ;
    }catch(e){
      print(e.toString());
    }

  }
  double start=0;
  double end=0;

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(vertical: 20),
            
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Time',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                Column(
                  children: [
                    Text('Start time',style:TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.sp,),
                    Text(timeString(start)+' hrs',),
                  ],
                ),
                Column(
                  children: [
                    Text('End time',style:TextStyle(fontWeight: FontWeight.bold) ,),
                      SizedBox(height: 10.sp,),
                    Text(timeString(end)+' hrs'),
                  ],
                )
              ],),
               SizedBox(height: 50.sp,),
              RangeSlider(
                max: 2100,
                min: 0700,
                divisions: 14,
                activeColor: const Color.fromARGB(255, 201, 174, 20),
                values: RangeValues(start,end),
                labels: RangeLabels(timeString(start)+' hrs',timeString(end)+' hrs'), 
                onChanged: (values){
                  setState(() {
                    start=values.start;
                    end = values.end;
                  });
                }
                ),
                SizedBox(height: 30.sp,),
            ],
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      String result = [timeString(start),timeString(end)].join('-')+' HRS';
                      Navigator.pop(context,result);
                    }
                        ),
              )
        ],
      ),
    );
  }
  String timeString(double time){
    if(time<1000){
      return  '0'+time.toStringAsFixed(0);
    }else{
      return  time.toStringAsFixed(0);
    }
   
  }
}
class EditVenue extends StatefulWidget {
  final String venue;
  const EditVenue({ Key? key,required this.venue }) : super(key: key);

  @override
  State<EditVenue> createState() => _EditVenueState();
}

class _EditVenueState extends State<EditVenue> {
  final TextEditingController _venueC = TextEditingController();
  String? venueValue;

@override
void initState(){
  super.initState();
  
  if(widget.venue!='VIRTUAL'){
    _venueC.text=widget.venue;
    venueValue='IN PERSON';
  }else{
  venueValue=widget.venue;
  }

}

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(vertical: 20),
    height: MediaQuery.of(context).size.height*0.9,   

      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
            Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Venue',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),
             RadioListTile(
               activeColor: const Color.fromARGB(255, 201, 174, 20),
               title: Text('VIRTUAL',style: tileTitleTextStyle,),
               value: 'VIRTUAL', 
               groupValue: venueValue, 
               onChanged: (val){
                 setState(() {
                   venueValue=val! as String?;
                 });
               }
               ),
               RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                 title: Text('IN PERSON',style: tileTitleTextStyle,),
               value: 'IN PERSON', 
               groupValue: venueValue, 
               onChanged: (val){

                 setState(() {
                   venueValue=val! as String?;
                 });
               }
               ),
              Visibility(
                visible: venueValue!='VIRTUAL',
                child: const ListTile(
                  title: Text('Physical venue',style: tileTitleTextStyle,),
                ),
              ),
              Visibility(
                visible: venueValue!='VIRTUAL',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      
                      controller: _venueC,
                      maxLength: 20,
                      validator: (val) =>
                          widget.venue!='VIRTUAL'&&val!.isEmpty ? 'Enter a venue' : null,
                    ),
                ),
              ),
            ],
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      
                      Navigator.pop(context,venueValue=='VIRTUAL'?'VIRTUAL':_venueC.value.text);
                    }
                        ),
              )
        ],
      ),
    );
  }
}
class EditLecturer extends StatefulWidget {
  final String lecturer;
  const EditLecturer({ Key? key, required this.lecturer}) : super(key: key);

  @override
  State<EditLecturer> createState() => _EditLecturerState();
}

class _EditLecturerState extends State<EditLecturer> {
    final TextEditingController _lecC = TextEditingController();

    void initState(){
      super.initState();
      _lecC.text=widget.lecturer;
    }

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(vertical: 20),
             height: MediaQuery.of(context).size.height*0.9,   
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Lecturer',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),

              const ListTile(
                title: Text('Lecturer\'s Name',style: tileTitleTextStyle,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    
                    controller: _lecC,
                   
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a name' : null,
                  ),
              ),
            ],
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      
                      Navigator.pop(context,_lecC.value.text);
                    }
                        ),
              )
        ],
      ),
    );
  }
}

class EditLink extends StatefulWidget {
  final String meetingLink;
  const EditLink({ Key? key,required this.meetingLink }) : super(key: key);

  @override
  State<EditLink> createState() => _EditLinkState();
}

class _EditLinkState extends State<EditLink> {
        final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkC = TextEditingController();

  @override
  void initState(){
    super.initState();
    _linkC.text=widget.meetingLink;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(vertical: 20),
          height: MediaQuery.of(context).size.height*0.9,  
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              
              children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Meeting link',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),
          
                const ListTile(
                  title: Text('Meeting link',style: tileTitleTextStyle,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      
                      controller: _linkC,
                      
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a link' : null,
                    ),
                ),
              ],
            ),
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      
                      if(_formKey.currentState!.validate()){
                      Navigator.pop(context,_linkC.value.text);
                      }
                    }
                        ),
              )
        ],
      ),
    );
  }
}
class EditCredentials extends StatefulWidget {
  final String passCode;
  final String meetingId;
  const EditCredentials({ Key? key,required this.passCode,required this.meetingId }) : super(key: key);

  @override
  State<EditCredentials> createState() => _EditCredentialsState();
}

class _EditCredentialsState extends State<EditCredentials> {
    final TextEditingController _meetingIdC = TextEditingController();
    final TextEditingController _passCodeC = TextEditingController();

    @override
    void initState(){
      super.initState();
      _meetingIdC.text=widget.meetingId;
      _passCodeC.text=widget.passCode;
    }
      final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
       height: MediaQuery.of(context).size.height*0.9,  
     margin: const EdgeInsets.symmetric(vertical: 20),  
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Meeting credentials',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 30.sp,),
          
                const ListTile(
                  title: Text('Meeting Id',style: tileTitleTextStyle,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      
                      controller: _meetingIdC,
                      
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a meetingId' : null,
                    ),
                ),
                const ListTile(
                  title: Text('Meeting passcode',style: tileTitleTextStyle,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                      
                      controller: _passCodeC,
                     
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a passcode' : null,
                    ),
                ),
              ],
            ),
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      if(_formKey.currentState!.validate()){
                      Navigator.pop(context,{'meetingId':_meetingIdC.value.text,'passCode':_passCodeC.value.text});
                      }

                    }
                        ),
              )
        ],
      ),
    );
  }
}

class EditReminderSchedule extends StatefulWidget {
  final int minutes;
  const EditReminderSchedule({ Key? key,required this.minutes }) : super(key: key);

  @override
  State<EditReminderSchedule> createState() => _EditReminderScheduleState();
}

class _EditReminderScheduleState extends State<EditReminderSchedule> {

  int minutes=0;

  @override
  void initState(){
    super.initState();
    minutes=widget.minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(vertical: 20),
         height: MediaQuery.of(context).size.height*0.7,    
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
                                Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     SizedBox(width: 30.sp,),
                     Text('Reminder schedule',style: TextStyle(fontWeight: FontWeight.bold),),
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,size: 20,))
                   ],
                 ),
                 Divider(),
                SizedBox(height: 20.sp,),
              
              ListTile(
                subtitle: Text('Get a reminder ${scheduleStr(minutes)} before the class starts'),
              ),
             RadioListTile(
               activeColor: const Color.fromARGB(255, 201, 174, 20),
               title: Text('5 minutes ',style: tileTitleTextStyle,),
               value: 5, 
               groupValue: minutes, 
               onChanged: (int? val){
                 setState(() {
                   minutes=val!;
                 });
               }
               ),
              RadioListTile(
                activeColor: const Color.fromARGB(255, 201, 174, 20),
                title: Text('30 minutes ',style: tileTitleTextStyle,),
               value: 30, 
               groupValue: minutes, 
               onChanged: (int? val){
                 setState(() {
                   minutes=val!;
                 });
               }
               ),
               RadioListTile(
                 activeColor: const Color.fromARGB(255, 201, 174, 20),
                 title: Text('1 hour ',style: tileTitleTextStyle,),
               value: 60, 
               groupValue: minutes, 
               onChanged: (int? val){
                 setState(() {
                   minutes=val!;
                 });
               }
               ),
              RadioListTile(
                activeColor: const Color.fromARGB(255, 201, 174, 20),
                title: Text('2 hours ',style: tileTitleTextStyle,),
               value: 120, 
               groupValue: minutes, 
               onChanged: (int? val){
                 setState(() {
                   minutes=val!;
                 });
               }
               ),

            ],
          ),

            Positioned(
                bottom: 0,
                child: MaterialButton(
                    disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(20),
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    color: const Color.fromARGB(255, 201, 174, 20),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed:(){
                     
                      
                      Navigator.pop(context,minutes);
                    }
                        ),
              )
        ],
      ),
    );

  }
  String scheduleStr(int minutes){
    if(minutes>59){
      return (minutes/60).toStringAsFixed(0)+' hour(s)';
    }else {
      return minutes.toString()+' minutes';
    }
  }
}