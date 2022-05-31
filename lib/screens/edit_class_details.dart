import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



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
            
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
          children: [
           
            Column(
              children: [
                Text('Day',style: TextStyle(fontWeight: FontWeight.bold),),
                Expanded(
                  child: ListView.builder(
                    itemCount: days.length,
                      itemBuilder: (context,index){
                        return RadioListTile(
                          title: Text(days[index]),
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
              ],
            ),
       Positioned(
                bottom: 50,
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
               Text('Time',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                Column(
                  children: [
                    Text('Start time',style:TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Text(timeString(start)+' hrs',),
                  ],
                ),
                Column(
                  children: [
                    Text('End time',style:TextStyle(fontWeight: FontWeight.bold) ,),
                      SizedBox(height: 10,),
                    Text(timeString(end)+' hrs'),
                  ],
                )
              ],),
               SizedBox(height: 50,),
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
            ],
          ),

            Positioned(
                bottom: 50,
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
  }
  venueValue=widget.venue;
}

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
               Text('Venue',style: TextStyle(fontWeight: FontWeight.bold),),

             RadioListTile(
               title: Text('VIRTUAL'),
               value: 'VIRTUAL', 
               groupValue: venueValue, 
               onChanged: (val){
                 setState(() {
                   venueValue=val! as String?;
                 });
               }
               ),
               RadioListTile(
                 title: Text('IN PERSON'),
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
                  title: Text('Physical venue'),
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
                bottom: 50,
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
            
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
               Text('Lecturer',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),

              const ListTile(
                title: Text('Lecturer\'s Name'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    
                    controller: _lecC,
                    maxLength: 20,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a name' : null,
                  ),
              ),
            ],
          ),

            Positioned(
                bottom: 50,
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
            
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
               Text('Meeting link',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),

              const ListTile(
                title: Text('Meeting link'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    
                    controller: _linkC,
                    maxLength: 20,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a link' : null,
                  ),
              ),
            ],
          ),

            Positioned(
                bottom: 50,
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
                     
                      
                      Navigator.pop(context,_linkC.value.text);
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
               Text('Meeting Credentials',style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),

              const ListTile(
                title: Text('Meeting Id'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    
                    controller: _meetingIdC,
                    maxLength: 20,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a meetingId' : null,
                  ),
              ),
              const ListTile(
                title: Text('Meeting passcode'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                    
                    controller: _passCodeC,
                    maxLength: 20,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a passcode' : null,
                  ),
              ),
            ],
          ),

            Positioned(
                bottom: 50,
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
                     
                      
                      Navigator.pop(context,{'meetingId':_meetingIdC.value.text,'passCode':_passCodeC.value.text});
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
            
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
               Text('Reminder Schedule',style: TextStyle(fontWeight: FontWeight.bold),),
              
              ListTile(
                subtitle: Text('Get a reminder ${scheduleStr(minutes)} before the class starts'),
              ),
             RadioListTile(
               activeColor: const Color.fromARGB(255, 201, 174, 20),
               title: Text('5 minutes '),
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
                title: Text('30 minutes '),
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
                 title: Text('1 hour '),
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
                title: Text('2 hours '),
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
                bottom: 50,
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