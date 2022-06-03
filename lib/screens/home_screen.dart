// import 'package:admob_flutter/admob_flutter.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/screens/join_meeting_screen.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/screens/settings.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/app_widgets.dart';
import 'package:excel_reader/shared/functions.dart';
import 'package:excel_reader/shared/text_styles.dart';
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
          icon: const Icon(Icons.settings_outlined,color: primaryThemeColor,),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const SettingsPage()));
          },
        ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset('assets/images/logo_alternate.png'),
        ),
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: primaryThemeColor,
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
                              return const Center(child: circularLoader);
                            }
                            if(snapshot.hasError){
                              return Center(child: Text('An error has occurred',style: normalTextStyle,),);
                            }
                            UnitClass _record = snapshot.data!;
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Text('UPCOMING',style: titleTextStyle,),
                                  trailing: Text(timeLeft(_record.time, _record.day),style: minorTextStyle,),
                                ),

                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(_record.unitCode,style: majorTextStyle,),
                              subtitle: Text(_record.unitName.capitalise(),style: TextStyle(fontSize: 14,color: Colors.grey[600]),),
                            ),
                            ListTile(
                              
                              contentPadding: EdgeInsets.zero,
                              subtitle: Text(_record.time,style: tileTitleTextStyle),
                              title: Text(_record.venue,style: tileTitleTextStyle,),
                              trailing: MaterialButton(
                                disabledColor: Colors.grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                onPressed: _record.canJoinMeeting?(){
                                  if(_record.classLink!=null){
                                    launchExternalUrl(_record.classLink!);
                                  }else{
                                  showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context, builder: (context)=>JoinClassMeeting(unitClass: _record),
                                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                                  }

                                }:null,
                                color: secondaryThemeColor,
                                child: const Text('JOIN MEETING',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13),),
                                ),
                            ),
                              ],
                            );
                          }
                        ),


                        const Divider(height: 20,),
                                

                        TodayUnitTile(color: Colors.pinkAccent, size: Size(MediaQuery.of(context).size.width*0.8,200),),
                        
                        const SizedBox(height: 40,),

                         const WeeklyUnitTile(size: Size(200,200),color: Colors.pinkAccent,),
                        const SizedBox(height: 40,),

                      
                      ]),
                ),
              ),
            // Positioned(
            //   bottom: 20,
            //   child: AdmobBanner(
            //         adUnitId: 'ca-app-pub-1360540534588513/5000702124',
            //         adSize: AdmobBannerSize.FULL_BANNER,
            //         listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
            //           debugPrint(args.toString());
            //         },
            //         onBannerCreated: (AdmobBannerController controller) {},
            //       ),
            // )
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
            return const Center(child: circularLoader);
          }
          if(snapshot.hasError){
            return Center(child: Text('An error has occurred',style: normalTextStyle,),);
          }
          return Column(
            children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Text('TODAY',style: titleTextStyle,),
              trailing: Text('${snapshot.data!.length} classe(s)',style: minorTextStyle,),
            ),
              SizedBox(
                height: size.height,
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context,index){
                    return const SizedBox(width: 20,);
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
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                
                              color: primaryThemeColor,
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
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: Colors.pinkAccent,borderRadius: BorderRadius.circular(20)),
                                          child: Text(record.unitCode,style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontSize: 15,fontWeight: FontWeight.bold),)),
                                        Icon(record.reminder? Icons.notifications_active:Icons.notifications_off,size: 20,color: Color.fromARGB(255, 255, 255, 255),)
                                      ],
                                    ),
                                  const SizedBox(height: 60,),            
                                   Text(record.unitName.capitalise(),style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                                                         
                                    Text(record.venue,style: const TextStyle(color: Color.fromARGB(255, 204, 204, 204),fontSize: 13),),
                                    Row(
                                      children: [
                                        Text(record.time,style: const TextStyle(color: Color.fromARGB(255, 196, 196, 196),fontSize: 12),),
                                        const SizedBox(width: 10,),
                                        Text(timeLeft(record.time, record.day),style: const TextStyle(color: Color.fromARGB(255, 139, 142, 161),fontSize: 10))
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





