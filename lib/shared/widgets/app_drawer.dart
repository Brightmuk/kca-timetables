import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_class_details.dart';
import 'package:excel_reader/screens/finish_class_setup.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/widgets/confirm_action.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);

    return Drawer(
      width: MediaQuery.of(context).size.width*0.6,
      child: Stack(
        children: [
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                
                padding: const EdgeInsets.all(60),
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: primaryThemeColor,
                ),
                child: Image.asset('assets/images/splash_center.png',)
              ),

            FutureBuilder<TimeTable>(
              future: state.isClassMode? ClassTimeTableService(context: context,state: state).getClassTimetable():
              ExamService(context: context,state: state).getExamTimetable(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  TimeTable? table = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: secondaryThemeColor,
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(state.modeStr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
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
             StreamBuilder<int>(
              stream:  state.isClassMode? ClassTimeTableService(context: context,state: state).unitsCount:
              ExamService(context: context,state: state).examsCount,
              builder: (context, snapshot) {
                int? count = snapshot.hasData?snapshot.data:0;
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
                    leading: const Icon(
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
                      builder: (context) => const ConfirmAction(text: 'This will overwrite the current class timetable data. Are you sure you want to scan the timetable?'));
                        if (result) {
                          await ClassTimeTableService(context: context,state: state).reScanClassTt(state);
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
                    builder: (context) => const ConfirmAction(text: 'This will overwrite the current exam timetable data. Are you sure you want to scan the timetable?'));
                      if (result) {
                        Navigator.pop(context);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Slide to change mode',style: TextStyle(color: Colors.grey,fontSize: 11),),
                  const Divider(),
                  AnimatedToggleSwitch<bool>.dual(
                            current: !state.isClassMode,
                            first: true,
                            second: false,
                            textMargin: const EdgeInsets.symmetric(horizontal: 15),
                            minTouchTargetSize: MediaQuery.of(context).size.width*0.4,
                            indicatorSize: Size(100,45),
                            innerColor: primaryThemeColor,
                            indicatorColor: secondaryThemeColor,
                            
                            borderColor:primaryThemeColor,
                            
                            textBuilder: (value) {
                              return Text(state.modeStr, style: TextStyle(color: Colors.white),);
                            },
                            onChanged: (val)async{
                              AppMode mode = val?AppMode.examTimetable:AppMode.classTimetable;
                              bool exists;
                              if(!val){
                                exists = await ClassTimeTableService(context: context,state: state).tableExists();
                              }else{
                                exists = await ExamService(context: context,state: state).tableExists();
                              }
                              if(exists){
                                state.changeMode(mode);

                              }else{
                                var result = await showModalBottomSheet(
                                  shape:
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  context: context,
                                  builder: (context) => ConfirmAction(text: 'You have no ${val?'exam':'class'} timetable yet. Do you want to scan now?'));
                                    if (result) {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScanScreen(isClass: !val,)));
                                    }
                              }  
                            },
                            iconBuilder: (val){
                              if(!val){
                                  return Icon(Icons.school_outlined,color: Colors.white,);
                              }else{
                                return Icon(Icons.receipt,color: Colors.white,);
                              }
                              
                            },
                            
                          )
                ],
              ),
          ),
           ),
        ],
      ),
    );
  }
}


