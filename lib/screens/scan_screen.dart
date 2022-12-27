import 'dart:io';
import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/screens/exam_home.dart';
import 'package:excel_reader/screens/finish_setup.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/select_course.dart';
import 'package:excel_reader/screens/select_period.dart';
import 'package:excel/excel.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/services/local_data.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/decorations.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  final bool isClass;
  const ScanScreen({Key? key, this.isClass=true}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? excelFile;
  Excel? excelDoc;
  List<String>? courses = [];
  String? course;
  String? period;
  String? period2;
  bool scanningDoc = false;
  bool isAuto = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courseNameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height*0.1,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color.fromARGB(255, 3, 4, 75),
            ),
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

                IconButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              Text('Create ${widget.isClass?'class':'exam'} timetable',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                IconButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {

                  },
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
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          leading: Container(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            
            child: Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                
                      SizedBox(
                        height: 50.sp,
                      ),
                                        
                      widget.isClass? SwitchListTile(
                        activeColor: secondaryThemeColor,
                        activeTrackColor: secondaryThemeColor.withOpacity(0.5),
                        title: const Text('Auto setup'),
                        subtitle:
                        Text(isAuto?'Scan from excel (KCA university timetable formats only)':'Setup the timetable manually'),
                        value: isAuto, onChanged: (val){
                          setState(() {
                            isAuto=val;
                          });
                        }
                        ):Container(),
                        Divider(
                        height: 50.sp,
                      ),
                        isAuto?Column(
                          children: [
                
                      ListTile(
                        style: ListTileStyle.drawer,
                        onTap: pickFile,
                        leading: const Icon(
                          Icons.document_scanner_outlined,
                          color: Color.fromRGBO(188, 175, 69, 0.3),
                          size: 35,
                        ),
                        title: const Text('Select the spreadsheet document(.xlsx)'),
                        subtitle: Text(excelFile != null
                            ? getDocName(excelFile!.path)
                            : 'No document selected'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      Visibility(
                        visible: excelFile != null && scanningDoc,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator(
                            backgroundColor: Color.fromRGBO(188, 175, 69, 0.3),
                            color: Color.fromRGBO(3, 4, 94, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Visibility(
                          visible: excelFile != null && scanningDoc,
                          child: Center(
                              child: Text(
                                excelFile != null
                                    ? 'Scanning ${getDocName(excelFile!.path)}'
                                    : '',
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ))),
                     Divider(
                        height: 50.sp,
                      ),ListTile(
                        style: ListTileStyle.drawer,
                        onTap: scanningDoc ? null : selectCourse,
                        leading: const Icon(
                          Icons.school_outlined,
                          color: Color.fromRGBO(188, 175, 69, 0.3),
                          size: 35,
                        ),
                        title: const Text('Select course'),
                        subtitle:
                        Text(course != null ? course! : 'No course selected'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      Divider(
                        height: 50.sp,
                      ),
                      ListTile(
                        style: ListTileStyle.drawer,
                        onTap: scanningDoc ? null : selectPeriod,
                        leading: const Icon(
                          Icons.calendar_month_outlined,
                          color: Color.fromRGBO(188, 175, 69, 0.3),
                          size: 35,
                        ),
                        title: const Text('Select period'),
                        subtitle:
                        Text(period != null ? period! : 'No period selected'),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      Divider(
                        height: 50.sp,
                      ),
                
                    
                        ],):
                        Form(
                          
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              // height: MediaQuery.of(context).size.height*0.9,
                              child: Column(
                                children: [
                                  SizedBox(height: 10.sp,),
                                TextFormField(
                                 
                                  controller: _courseNameC,
                                  cursorColor: primaryThemeColor,
                                  decoration: AppStyles().textFieldDecoration(
                                      label: 'Course Name', hintText: 'Bachelors'),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Course name is required';
                                    }
                                  },
                                ),
                                SizedBox(height: 20.sp,),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  style: ListTileStyle.drawer,
                                  onTap:  selectManualPeriod,
                                  leading: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Color.fromRGBO(188, 175, 69, 0.3),
                                    size: 35,
                                  ),
                                  title: const Text('Select period'),
                                  subtitle:
                                  Text(period != null ? period! : 'No period selected'),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ),
                                
                                
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.sp,)
                    ]),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  child: Consumer<AppState>(
                    
                    builder: (context, state,child) {
                      return MaterialButton(
                          disabledColor: const Color.fromRGBO(188, 175, 69, 0.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.all(20),
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          color: const Color.fromARGB(255, 201, 174, 20),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          onPressed:
                          (excelDoc != null && period != null && course != null)||!isAuto
                              ? (){
                                  if(widget.isClass){
                                    classTimetableScan(state);
                                   
                                  } else{
                                    examTimetableScan(state);
                                    
                                  }  
                              }
                              : null);
                    }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();


    if (result != null&&result.files.single.path!.endsWith('.xlsx')) {
      File file = File(result.files.single.path!);
      setState(() {
        excelFile = file;
        scanningDoc = true;
      });
      Future.delayed(const Duration(microseconds: 2000), () {
        readXlsx(file);
      });
    } else if(result != null&&!result.files.single.path!.endsWith('.xlsx')){
      toast('Please select a valid spreadsheet document(.xlsx)');
    }
  }

  void readXlsx(File file) {
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    setState(() {
      excelDoc = excel;
      courses = excel.sheets.keys.toList();
      course = null;
      scanningDoc = false;
    });
  }

  String getDocName(String path) {
    try {
      List arr = path.split('/');
      return arr[arr.length - 1];
    } catch (e) {
      return path;
    }
  }

  void selectCourse() async {
    if (excelFile != null) {
      var result = await showModalBottomSheet(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => CourseSelector(
            courses: courses!,
          ));
      if (result != null) {
        setState(() {
          course = result;
          period = null;
        });
      }
    } else {
      toast('Please select the timetable document first');
    }
  }

  void selectManualPeriod()async{
          var result = await showModalBottomSheet(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          builder: (context) => const ClassPeriodSelector(
            courseType: 'Bachelors',
          ));
      if (result != null) {
        setState(() {
          period = result;
        });
      }
  }

  void selectPeriod() async {
    if (excelFile == null) {
      toast('Please select the timetable document first');
    } else if (course == null) {
      toast('Please select the course first');
    } else {
      var result = await showModalBottomSheet(
          backgroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          context: context,
          builder: (context) => widget.isClass? ClassPeriodSelector(
            courseType: course!,
          ):ExamPeriodSelector(courseType: course!));
      if (result != null) {
        setState(() {
          period = result;
          period2 = result.replaceAll("Trim","Trimester");
        });
      }
    }
  }

  void classTimetableScan(AppState state) async{
   
    if(!isAuto){
      await LocalData().setNotFirst();
      if(_formKey.currentState!.validate()){
      await TimeTableService(context: context).saveTableDetails(name: 'Custom timetable', period: period??'', course: _courseNameC.value.text);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const FinishSetupScreen())
        );
      }
      return;
    }
    Sheet? sheet;
    CellIndex? periodIndex;
    CellIndex? dayIndex;

    //Step 1: Find the selected sheet/course
    try {
      sheet = excelDoc!.sheets[course];
    } catch (e) {
      toast('There was an error reading from that course');
      return;
    }
    //Step 2: Find the period
    //Step 3: Find the 'Day' field

    try {
      rowsLoop:
      for (var row in sheet!.rows) {
        cellsLoop:
        for (var cell in row) {
        
          if (cell != null && (cell.value == period!.toUpperCase() || cell.value == period2!.toUpperCase()) ) {
            periodIndex = cell.cellIndex;
            break cellsLoop;
          }
          if (cell != null && periodIndex != null && cell.value == 'DAY') {
            dayIndex = cell.cellIndex;
            break rowsLoop;
          }
        }
      }
    } catch (e) {
      toast('The period was not found');
      return;
    }
    //Step 4: loop through records to get the values
    // toast(dayIndex!.rowIndex.toString());
    try {
      List<UnitClass> _records = [];
      int startIndex = dayIndex!.rowIndex + 1;
      int lastRecordIndex=startIndex+6; 

      debugPrint(startIndex.toString());
      debugPrint(lastRecordIndex.toString());
      
      for (var i = startIndex; sheet.rows[i][dayIndex.columnIndex] != null; i++) {
        if (sheet.rows[i][dayIndex.columnIndex] != null) {

          _records.add(UnitClass.fromSheet(sheet.rows[i], dayIndex.columnIndex,course!));
        }
      }
      
      _records.sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

      var result = await TimeTableService(context: context).saveClassTimeTable(period:period!, tableName: getDocName(excelFile!.path), units: _records,course:course!);

      if(result){
         state.changeMode(AppMode.classTimetable);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const FinishSetupScreen()));

      }

    } catch (e) {
      
      toast('The period was not found or has an invalid format');
    }
  }

void examTimetableScan(AppState state)async{ 
    Sheet? sheet;
    CellIndex? periodIndex;
    

    //Step 1: Find the selected sheet/course
    try {
      sheet = excelDoc!.sheets[course];
    } catch (e) {
      toast('There was an error reading from that course');
      return;
    }
    //Step 2: Find the periods
    List<ExamModel> _exams = [];
 
    try {
      rowsloop:
      for (var row in sheet!.rows) {
       
        cellsLoop:
        for (var cell in row) {
          
          if (cell != null && (cell.value.toString().toUpperCase() == 'TRIMESTER') ) {
            periodIndex = cell.cellIndex;
             
            break rowsloop;
            
          }
        }
      }
    } catch (e) {
      toast('The period was not found');
      return;
    }
    //Step 4: loop through records to get the values
    // toast(dayIndex!.rowIndex.toString());
 
    try {
      
        for (int i =periodIndex!.rowIndex+1; i<sheet.rows.length-1;i++) {
          
          if(sheet.rows[i][periodIndex.columnIndex]!.value.toString().toUpperCase()==period!.toUpperCase()){
             
            debugPrint(sheet.rows[i][1].toString());
            
            _exams.add(ExamModel.fromSheet(sheet.rows[i]));
          
          }
        }
       
      var result = await ExamService(context: context).saveExamTimeTable(period:period!, tableName: getDocName(excelFile!.path), exams: _exams,course:course!);

      if(result){
         state.changeMode(AppMode.examTimetable);
         Navigator.pop(context);


      }

    } catch (e) {
      debugPrint(e.toString());
      toast('The period was not found or has an invalid format');
    }
}

}
