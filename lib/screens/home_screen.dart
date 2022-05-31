import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:excel_reader/shared/unit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel_reader/models/string_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
          icon: Icon(Icons.settings_outlined,color: Color.fromARGB(255, 3, 4, 75),),
          onPressed: (){
            
          },
        ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu_outlined,color: Color.fromARGB(255, 3, 4, 75),),
          onPressed: (){
            
          },
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 3, 4, 75),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Stack(
            alignment: Alignment.center,
            children: [


              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        StreamBuilder<UnitClass>(
                          stream: TimeTableService(context: context).upcomingClass,
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return Center(child: CircularProgressIndicator());
                            }
                            if(snapshot.hasError){
                              return Center(child: Text('An error has occurred'),);
                            }
                            UnitClass _record = snapshot.data!;
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Text('UPCOMING',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Color.fromARGB(255, 3, 4, 75)),),
                                  trailing: Text(timeLeft(_record.time, _record.day),style: TextStyle(color: Colors.grey,fontSize: 13),),
                                ),

                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(_record.unitCode,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300),),
                              subtitle: Text(_record.unitName.capitalise()),
                            ),
                            ListTile(
                              
                              contentPadding: EdgeInsets.zero,
                              subtitle: Text(_record.time,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600)),
                              title: Text(_record.venue,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
                              trailing: MaterialButton(
                                disabledColor: Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                onPressed: _record.canJoinMeeting?(){}:null,
                                color: const Color.fromARGB(255, 201, 174, 20),
                                child: Text('JOIN MEETING',style: TextStyle(color: Colors.white,fontSize: 13),),
                                ),
                            ),
                              ],
                            );
                          }
                        ),


                        Divider(height: 20,),
                                

                        TodayUnitTile(color: Colors.pinkAccent, size: Size(MediaQuery.of(context).size.width*0.8,200),),
                        
                        SizedBox(height: 40,),


                        // Row(children: [
                        //   SizedBox(width: MediaQuery.of(context).size.width*0.3, child: RadioListTile(title: Text('All'), activeColor: const Color.fromARGB(255, 201, 174, 20), value: '', groupValue: '', onChanged: (val){})),
                        //   SizedBox(width: MediaQuery.of(context).size.width*0.32, child: RadioListTile(title: Text('In person'), activeColor: const Color.fromARGB(255, 201, 174, 20), value: '', groupValue: '', onChanged: (val){})),                          
                        //   SizedBox(width: MediaQuery.of(context).size.width*0.3, child: RadioListTile(title: Text('Virtual'), activeColor: const Color.fromARGB(255, 201, 174, 20), value: '', groupValue: '', onChanged: (val){}))
                        // ],),
                         WeeklyUnitTile(size: Size(200,200),color: Colors.pinkAccent,),
                        SizedBox(height: 40,),
                        // ListTile(
                        //   contentPadding: EdgeInsets.zero,
                        //   leading: Text('IN PERSON CLASSES',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 3, 4, 75)),),
                        //   trailing: Text('4 classes',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        // ),
                        //  UnitTile(size: Size(150,150),color: Color.fromARGB(255, 3, 4, 75),),
                        // SizedBox(height: 40,),
                        // ListTile(
                        //   contentPadding: EdgeInsets.zero,
                        //   leading: Text('VIRTUAL CLASSES',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 3, 4, 75)),),
                        //   trailing: Text('3 classes',style: TextStyle(color: Colors.grey,fontSize: 13),),
                        // ),
                        //  UnitTile(size: Size(150,150),color: Color.fromARGB(255, 3, 4, 75),),
                        // SizedBox(height: 50,)
                      
                      ]),
                ),
              ),
      
            ],
          )
    );
  }
}
class TodayUnitTile extends StatelessWidget {
  final Size size;
  final Color color;
  const TodayUnitTile({ Key? key, required this.size,required this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height+70,

      child: StreamBuilder<List<UnitClass>>(
        stream: TimeTableService(context: context,day:weekDay).recordsStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text('An error has occurred'),);
          }
          return Column(
            children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text('TODAY',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 3, 4, 75)),),
              trailing: Text('${snapshot.data!.length} classe(s)',style: TextStyle(color: Colors.grey,fontSize: 13),),
            ),
              SizedBox(
                height: size.height,
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context,index){
                    return SizedBox(width: 20,);
                  },
                  itemBuilder: (context,index){
                    UnitClass record= snapshot.data![index];
                      return Opacity(
                        opacity: record.isFulfiled?0.5:1,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditClassPage(
                                      editMode: true,
                                        record: record)));
                      
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                
                              color: Color.fromARGB(255, 3, 4, 75),
                              borderRadius: BorderRadius.circular(20),
                             
                            ),
                            width:size.width,
                            
                            child: CustomPaint(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: Colors.pinkAccent,borderRadius: BorderRadius.circular(20)),
                                          child: Text(record.unitCode,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 15,fontWeight: FontWeight.bold),)),
                                        Icon(record.reminder? Icons.notifications_active:Icons.notifications_off,size: 20,color: Color.fromARGB(255, 255, 255, 255),)
                                      ],
                                    ),
                                               SizedBox(height: 60,),            
                                   Text(record.unitName.capitalise(),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                                         
                                    Text(record.venue,style: TextStyle(color: Color.fromARGB(255, 204, 204, 204),fontSize: 13),),
                                    Row(
                                      children: [
                                        Text(record.time,style: TextStyle(color: Color.fromARGB(255, 196, 196, 196),fontSize: 12),),
                                        SizedBox(width: 10,),
                                        Text(timeLeft(record.time, record.day),style: TextStyle(color: Color.fromARGB(255, 139, 142, 161),fontSize: 10))
                                      ],
                                    )
                                    
                                  ],
                                ),
                              ),
                              painter: UnitPainter(color: Colors.white.withOpacity(0.1)),
                            )
                            ),
                        ),
                      );
                    }
                  ),
              ),
            ],
          );
        }
      ),
    );
  }
  String get weekDay{
  int weekDay=DateTime.now().weekday;
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
  const WeeklyUnitTile({ Key? key, required this.size,required this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height+100,
      child: StreamBuilder<List<UnitClass>>(
        stream: TimeTableService(context: context).recordsStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text('An error has occurred'),);
          }
          return Column(
            children: [
              ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text('WEEKLY',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 3, 4, 75)),),
              trailing: Text('${snapshot.data!.length} classe(s)',style: TextStyle(color: Colors.grey,fontSize: 13),),
            ),
              SizedBox(
                height: size.height+20,
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context,index){
                    return SizedBox(width: 20,);
                  },
                  itemBuilder: (context,index){
                    UnitClass record= snapshot.data![index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditClassPage(
                                    editMode: true,
                                      record: record)));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      
                            Text(record.day,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Container(
                              decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  
                                color: Color.fromARGB(255, 3, 4, 75),
                                borderRadius: BorderRadius.circular(10),
                               
                              ),
                              width:size.width,
                              height: size.height,
                              child: CustomPaint(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: Colors.pinkAccent,borderRadius: BorderRadius.circular(20)),
                                        child: Text(record.unitCode,style: TextStyle(color: Color.fromARGB(255, 250, 250, 250),fontSize: 15,fontWeight: FontWeight.bold),)),
                                      Icon(record.reminder? Icons.notifications_active:Icons.notifications_off,size: 20,color: Color.fromARGB(255, 255, 255, 255),)
                                    ],
                                  ),
                                                            SizedBox(height: 60,),
                                     Text(record.unitName.capitalise(),style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.bold),),
                                      Text(record.venue,style: TextStyle(color: Color.fromARGB(255, 173, 173, 173),fontSize: 12),),
                                
                                      Text(record.time,style: TextStyle(color: Color.fromARGB(255, 197, 197, 197),fontSize: 12),)
                                    ],
                                  ),
                                ),
                                painter: UnitPainter(color: Colors.white.withOpacity(0.1)),
                              )
                              ),
                          ],
                        ),
                      );
                    }
                  ),
              ),
            ],
          );
        }
      ),
    );
  }
}





