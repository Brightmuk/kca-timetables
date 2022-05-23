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
            ListView.builder(
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
class EditVenue extends StatelessWidget {
  const EditVenue({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class EditLecturer extends StatelessWidget {
  const EditLecturer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class EditType extends StatelessWidget {
  const EditType({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class EditLink extends StatelessWidget {
  const EditLink({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class EditCredentials extends StatelessWidget {
  const EditCredentials({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
class EditReminderSchedule extends StatelessWidget {
  const EditReminderSchedule({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}