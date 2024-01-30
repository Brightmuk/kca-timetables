
import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/edit_unit_details.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/screens/single_exam.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FinishExamSetupScreen extends StatefulWidget {
  final MyAppState appState;
  const FinishExamSetupScreen({Key? key, required this.appState}) : super(key: key);

  @override
  _FinishExamSetupScreenState createState() => _FinishExamSetupScreenState();
}

class _FinishExamSetupScreenState extends State<FinishExamSetupScreen> {


  @override
  void initState(){
    super.initState();

    Future.delayed(const Duration(seconds: 1),(){
      widget.appState.instantInterstitialShow();
    });
  }
  @override
  Widget build(BuildContext context) {
    MyAppState state = Provider.of<MyAppState>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color.fromARGB(255, 3, 4, 75),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const Text('Finish setup',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  padding: const EdgeInsets.all(20),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 3, 4, 75),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          leading: IconButton(
            padding: const EdgeInsets.all(20),
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color.fromRGBO(3, 4, 94, 1),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView(children: [
                SizedBox(
                  height: 50.sp,
                ),
                FutureBuilder<TimeTable>(
                    future: ExamService(context: context,state: state)
                        .getExamTimetable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        TimeTable? table = snapshot.data;
                        return Column(
                          children: [
                            Text(
                              table!.course,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              table.period,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                Divider(
                  height: 50.sp,
                ),
                StreamBuilder<List<ExamModel>>(
                    stream: ExamService(
                      state: state,
                            context: context)
                        .examsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => const AddExam(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            );
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: secondaryThemeColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Add unit',
                                  style: TextStyle(color: secondaryThemeColor),
                                )
                              ]),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('An error has occurred'),
                        );
                      }
                      List<ExamModel>? _records = snapshot.data;

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _records!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _records.length) {
                              return MaterialButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => const AddExam(),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  );
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add,
                                        color: secondaryThemeColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Add exam',
                                        style: TextStyle(
                                            color: secondaryThemeColor),
                                      )
                                    ]),
                              );
                            } else {
                              return ListTile(
                                style: ListTileStyle.drawer,
                                title: Text(_records[index].unitName),
                                subtitle:
                                    Text(_records[index].time.originalStr),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditExamPage(
                                            appState: state,
                                              exam: _records[index])));
                                },
                                leading:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(_records[index].date.day.toString(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                        Text(Time.monthName[_records[index].date.month]!,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              );
                            }
                          });
                    }),
                SizedBox(
                  height: 100.sp,
                )
              ]),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  child: MaterialButton(
                      disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(20),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      color: const Color.fromARGB(255, 201, 174, 20),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String convertDay(String day) {
    switch (day) {
      case 'MONDAY':
        return 'MON';
      case 'TUESDAY':
        return 'TUE';
      case 'WEDNESDAY':
        return 'WED';
      case 'THURSDAY':
        return 'THUR';
      case 'FRIDAY':
        return 'FRI';
      case 'SATURDAY':
        return 'SAT';
      default:
        return '';
    }
  }
}
