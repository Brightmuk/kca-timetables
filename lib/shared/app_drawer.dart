import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/confirm_action.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
                const Divider()
              ],
            );
            }else{
              return Text('',style: titleTextStyle.copyWith(color: primaryThemeColor),);
            }

          }
        ),
          ListTile(
            leading: Icon(
              Icons.pages_outlined,
              color: secondaryThemeColor,
            ),
            trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
          ),
            title: const Text('Scan class Timetable'),
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
            leading: Icon(
              Icons.pages_outlined,
              color: secondaryThemeColor,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 12,
            ),
            title: const Text('Exam Timetable'),
            onTap: () {
              toast('Coming soon');
              Navigator.pop(context);
            },
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
