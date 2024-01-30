
import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/models/string_extension.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/screens/settings.dart';
import 'package:excel_reader/screens/single_exam.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/widgets/app_drawer.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class ExamsHome extends StatefulWidget {
  const ExamsHome({ Key? key }) : super(key: key);

  @override
  _ExamsHomeState createState() => _ExamsHomeState();
}

class _ExamsHomeState extends State<ExamsHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    MyAppState state = Provider.of<MyAppState>(context);

    return Scaffold(
      key: _scaffoldKey,
              extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: FutureBuilder<TimeTable>(
              future: ExamService(context: context,state: state).getExamTimetable(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Text(snapshot.data!.name,style: titleTextStyle.copyWith(color: primaryThemeColor),);
                }else{
                  return Text('',style: titleTextStyle.copyWith(color: primaryThemeColor),);
                }

              }
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined,color: primaryThemeColor,),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const SettingsPage()));
                
              },
            ),
          ],
          leading: IconButton(icon: const Icon(Icons.menu,color: primaryThemeColor,)
            ,onPressed: (){
              _scaffoldKey.currentState!.openDrawer();
            },),
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        drawer: const AppDrawer(),

      body: Stack(
        alignment: Alignment.center,
        children: [
          
          RefreshIndicator(
              color: primaryThemeColor,
              onRefresh: ()async{
                setState(() {

                });

              },
            child: Consumer<MyAppState>(
              
              builder: (context, state, child) {
                return StreamBuilder<List<ExamModel>>(
                  stream: ExamService(context: context,state: state).examsStream,
                  builder: (context, snapshot) {
                  if(!snapshot.hasData){
                      return const Center(child: CircularProgressIndicator());
                    }
                    if(snapshot.hasError){
                      return const Center(child: Text('An error has occurred'),);
                    }
                    List<ExamModel> exams = snapshot.data!;
                  
                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 50),
                      
                      itemCount: exams.length,
                      itemBuilder: (context, index){
                      
                        return Column(
                          children: [
                            index==0?DayHeader(date: exams[index].date):Container(),
                            ExamTile(exam: exams[index])
                          ],
                        );
                      },
                     separatorBuilder: ((context, index) {

                       if(isSameDate(exams[index].date, exams[index+1].date)){
                         
                         return const Divider(color: Colors.grey,);
                       }else{
                         return DayHeader(date: exams[index+1].date);
                       }
                     }), );
                  }
                );
              }
            ),
          ),
          //   Positioned(
          //   bottom: 10,
          //   child: AdmobBanner(
          //     adUnitId: 'ca-app-pub-1360540534588513/5000702124',
          //     adSize: AdmobBannerSize.FULL_BANNER,
          //     listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
          //       debugPrint(args.toString());
          //     },
          //     onBannerCreated: (AdmobBannerController controller) {},
          //   ),
          // )
        ],
      ),
    );
  }
  bool isSameDate(DateTime first, DateTime second){
    return first.day==second.day&&first.month==second.month;
  }
}

class DayHeader extends StatelessWidget {
  final DateTime date;
  
  const DayHeader({ Key? key,required this.date }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Time.relativeDay(date)=='days ago'?Colors.grey: primaryThemeColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(date.day.toString(),style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
              Text(Time.monthName[date.month]!,style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
            ],
          ),
          Text(Time.relativeDay(date),style:TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),)
      ]),
    );
  }
}


class ExamTile extends StatelessWidget {
  final ExamModel exam;
  const ExamTile({ Key? key,required this.exam }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyAppState state = Provider.of<MyAppState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditExamPage(exam: exam,appState: state,)));
        },
        child: Container(
         decoration: const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(exam.time.originalStr),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     
                    Text(exam.unitName.capitalise(),style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 25,),
                    Row(
                      children: [
                      const Icon(Icons.house_outlined,color: secondaryThemeColor,),
                      const SizedBox(width: 10,),
                      Text(exam.venue,style: const TextStyle(fontWeight: FontWeight.w600),)
                    ],),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                      const Icon(Icons.person_outline,color: secondaryThemeColor,),
                      const SizedBox(width: 10,),
                      Text(exam.invigilator.capitalise(),style: const TextStyle(fontWeight: FontWeight.w600),)
                    ],),
                     const SizedBox(height: 20,),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

