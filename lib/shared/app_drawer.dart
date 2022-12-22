import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_class_details.dart';
import 'package:excel_reader/screens/finish_setup.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/confirm_action.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width*0.6,
      child: Stack(
        children: [
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                
                padding: EdgeInsets.all(60),
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: primaryThemeColor,
                ),
                child: Image.asset('assets/images/splash_center.png',)
              ),

            FutureBuilder<TimeTable>(
              future: TimeTableService(context: context).getClassTimetable(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  TimeTable? table = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(table!.name,style: titleTextStyle.copyWith(color: primaryThemeColor),),
                      trailing: Container(width: 10,height: 10, decoration: BoxDecoration(color: secondaryThemeColor, borderRadius: BorderRadius.circular(10))),
                    ),
                    
                    ListTile(
                      title: Text(table.course,style: tileTitleTextStyle,),
                      subtitle: Text(table.period,style: tileSubtitleTextStyle,),
                    ),
                    
                  ],
                );
                }else{
                  return Text('',style: titleTextStyle.copyWith(color: primaryThemeColor),);
                }

              }
            ),
            StreamBuilder<List<UnitClass>>(
              stream: TimeTableService(context: context).unitsStream,
              builder: (context, snapshot) {
                int count = snapshot.hasData?snapshot.data!.length:0;
                return ListTile(
                  leading: Text('$count unit(s)',style: tileTitleTextStyle,),
                  
                  trailing: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: ()async{
                      Navigator.pop(context);
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        context: context, builder: (context)=>const AddUnit(),
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );


                  },
                  color: secondaryThemeColor,
                  child: Text('ADD UNIT',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13)),
                  ),
                );
              }
            ),
            const Divider(),
              ListTile(
                    leading: Icon(
                      Icons.pages_outlined,
                      color: secondaryThemeColor,
                    ),
                    trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                  ),
                    title: const Text('Scan Class Timetable'),
                    onTap: ()async  {

                      var result = await showModalBottomSheet(
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      context: context,
                      builder: (context) => const ConfirmAction(text: 'This will overwrite the current class timetable data. Are you sure you want to rescan the timetable?'));
                        if (result) {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanScreen()));
                        }
              
                    },
                  ),

              ListTile(
                leading: const Icon(
                  Icons.pages_outlined,
                  color: secondaryThemeColor,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
                title: const Text('Scan Exam Timetable'),
                onTap: () async{
                  
                    var result = await showModalBottomSheet(
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) => const ConfirmAction(text: 'This will overwrite the current exam timetable data. Are you sure you want to rescan the timetable?'));
                      if (result) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanScreen(isClass: false,)));
                      }
                  
                },
              ),

            ],
            
          ),
           Positioned(
             bottom: 20,
             child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LiteRollingSwitch(
                  value: false,
                  width: MediaQuery.of(context).size.width*0.4,
                  animationDuration: const Duration(milliseconds: 400),
                  textOff: 'Class Timetable Mode ',
                  textOn: 'Exam Timetable Mode ',
                  textOnColor: Colors.white,
                  colorOff: primaryThemeColor,
                  colorOn: secondaryThemeColor,
                  iconOn: Icons.school_outlined, 
                  iconOff: Icons.receipt,
                  onChanged: (bool state) {
                   
                  },
                  onDoubleTap: () {},
                  onSwipe: () {},
                  onTap: () {},
                ),
          ),
           ),
        ],
      ),
    );
  }
}



class DrawerPainter extends CustomPainter{
  final Color color;

  DrawerPainter({required this.color,});

  @override
  void paint(Canvas canvas, Size size) {
   final paint = Paint()
   ..style=PaintingStyle.fill
   ..strokeWidth=1
   ..color=color;

    Offset p1 = Offset(0, size.height*0.3);
   final path = Path();
   path.lineTo(size.width, 0);
   path.lineTo(size.width, size.height*0.5);
  path.arcToPoint( p1,radius: Radius.circular(size.height*size.width/100),clockwise: false);
 
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

  
}
