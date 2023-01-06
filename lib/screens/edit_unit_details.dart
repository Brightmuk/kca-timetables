import 'package:excel_reader/models/exam_model.dart';
import 'package:excel_reader/models/table_model.dart';
import 'package:excel_reader/models/time_model.dart';
import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/screens/single_exam.dart';
import 'package:excel_reader/services/class_service.dart';
import 'package:excel_reader/services/exam_service.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:excel_reader/shared/decorations.dart';
import 'package:excel_reader/shared/text_styles.dart';
import 'package:excel_reader/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

enum EditDetailType { day, time, venue, lecturer, type, link, credentials }

class AddUnit extends StatefulWidget {
  const AddUnit({ Key? key }) : super(key: key);

  @override
  State<AddUnit> createState() => _AddUnitState();
}

class _AddUnitState extends State<AddUnit> {
    final TextEditingController _unitCodeC = TextEditingController();
  final TextEditingController _unitNameC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.sp,
                    ),
                    Text(
                      'New unit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                        ))
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 30.sp,
                ),
                ListTile(
                  title: Text(
                    'Unit Name',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _unitNameC,
                    validator: (val) => val!.isEmpty ? 'Enter unit name' : null,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Unit Code',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _unitCodeC,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a unit code' : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: MaterialButton(
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
                onPressed: () async {
                  TimeTable table = await ClassTimeTableService(
                          context: context, state: state)
                      .getClassTimetable();
                  UnitClass unit = UnitClass.defaultClass(
                      _unitNameC.value.text.toUpperCase(),
                      _unitCodeC.value.text.toUpperCase(),
                      table.course);
                  await ClassTimeTableService(context: context, state: state)
                      .saveUnit(unit);

                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditClassPage(unit: unit)));
                }),
          )
        ],
      ),
    );
  }
}


class AddExam extends StatefulWidget {
  const AddExam({Key? key}) : super(key: key);

  @override
  State<AddExam> createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final TextEditingController _unitCodeC = TextEditingController();
  final TextEditingController _unitNameC = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppState state = Provider.of<AppState>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.sp,
                    ),
                    const Text(
                      'New exam',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                        ))
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 30.sp,
                ),
                ListTile(
                  title: Text(
                    'Unit Name',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _unitNameC,
                    validator: (val) => val!.isEmpty ? 'Enter unit name' : null,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Unit Code',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _unitCodeC,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a unit code' : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: MaterialButton(
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
                onPressed: () async {
                  ExamModel exam = ExamModel.defaultModel(
                      _unitNameC.value.text.toUpperCase(),
                      _unitCodeC.value.text.toUpperCase());
                  await ExamService(context: context, state: state)
                      .saveExam(exam);

                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditExamPage(exam: exam)));
                }),
          )
        ],
      ),
    );
  }
}

class EditDay extends StatefulWidget {
  final String current;
  const EditDay({Key? key, required this.current}) : super(key: key);

  @override
  State<EditDay> createState() => _EditDayState();
}

class _EditDayState extends State<EditDay> {
  static const List<String> days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY'
  ];
  String? groupValue;

  @override
  void initState() {
    super.initState();
    groupValue = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.75,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.sp,
                  ),
                  Text(
                    'Day',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.sp,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                          title: Text(
                            days[index],
                            style: tileTitleTextStyle,
                          ),
                          activeColor: const Color.fromARGB(255, 201, 174, 20),
                          value: days[index],
                          groupValue: groupValue,
                          onChanged: (val) {
                            setState(() {
                              groupValue = days[index];
                            });
                          });
                    }),
              ),
              SizedBox(
                height: 30.sp,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  Navigator.pop(context, groupValue);
                }),
          )
        ],
      ),
    );
  }
}

class EditTime extends StatefulWidget {
  final Time time;
  const EditTime({Key? key, required this.time}) : super(key: key);

  @override
  State<EditTime> createState() => _EditTimeState();
}

class _EditTimeState extends State<EditTime> {
  @override
  void initState() {
    super.initState();
    start = widget.time.start;
    end = widget.time.end;
  }

  TimeOfDay start = TimeOfDay.now();
  TimeOfDay end = TimeOfDay.now();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.sp,
                  ),
                  Text(
                    'Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.sp,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start time',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.sp)),
                        SizedBox(
                          height: 14.sp,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryThemeColor.withOpacity(0.1)),
                              child: Text(
                                Time.hourFormat(start.hour),
                                style: TextStyle(
                                    color: primaryThemeColor,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10.sp,
                              child: Text(':',
                                  style: TextStyle(
                                      color: primaryThemeColor,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: secondaryThemeColor.withOpacity(0.1)),
                              child: Text(
                                Time.minuteFormat(start.minute),
                                style: TextStyle(
                                    color: secondaryThemeColor,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.55),
                            FloatingActionButton(
                                child: Icon(Icons.edit,color: primaryThemeColor,),
                                backgroundColor: Colors.white,
                                onPressed: () async{
                                    TimeOfDay? result = await showTimePicker(
                                      context: context,
                                      initialTime: widget.time.start,
                                      builder: ((context, child) {
                                     return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    // change the border color
                                    primary: primaryThemeColor,
                                    // change the text color
                                    onSurface: primaryThemeColor,
                                  ),
                                  // button colors 
                                  buttonTheme: const ButtonThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: secondaryThemeColor
                                    ),
                                  ),
                                ),
                                    child: child!,
                                  );
                                      })
                                      );
                                      if(result!=null){
                                        setState(() {
                                           start=result;
                                        });
                                       
                                      }
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End time',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.sp),
                        ),
                        SizedBox(
                          height: 14.sp,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryThemeColor.withOpacity(0.1)),
                              child: Text(
                                Time.hourFormat(end.hour),
                                style: TextStyle(
                                    color: primaryThemeColor,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 10.sp,
                              child: Text(':',
                                  style: TextStyle(
                                      color: primaryThemeColor,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: secondaryThemeColor.withOpacity(0.1)),
                              child: Text(
                                Time.minuteFormat(end.minute),
                                style: TextStyle(
                                    color: secondaryThemeColor,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.55),
                            FloatingActionButton(
                                child: Icon(Icons.edit,color: primaryThemeColor,),
                                backgroundColor: Colors.white,
                                onPressed: () async{
                                  TimeOfDay? result = await showTimePicker(
                                      context: context,
                                      initialTime: widget.time.end,
                                      builder: ((context, child) {
                                     return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    
                                    primary: primaryThemeColor,
                                   
                                    onSurface: primaryThemeColor,
                                  ),
                                  
                                  buttonTheme: const ButtonThemeData(
                                    colorScheme: ColorScheme.light(
                                      primary: secondaryThemeColor
                                    ),
                                  ),
                                ),
                                    child: child!,
                                  );
                                })
                                );
                                if(result!=null){
                                  setState(() {
                                    end=result;
                                  });
                                }
                                })
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50.sp,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  String result = Time.timeStringFromTime(start, end);
                  debugPrint(result);

                  Navigator.pop(context, Time.fromString(result));
                }),
          )
        ],
      ),
    );
  }
}

class EditVenue extends StatefulWidget {
  final String venue;
  const EditVenue({Key? key, required this.venue}) : super(key: key);

  @override
  State<EditVenue> createState() => _EditVenueState();
}

class _EditVenueState extends State<EditVenue> {
  final TextEditingController _venueC = TextEditingController();
  String? venueValue;

  @override
  void initState() {
    super.initState();

    if (widget.venue != 'VIRTUAL') {
      _venueC.text = widget.venue;
      venueValue = 'IN PERSON';
    } else {
      venueValue = widget.venue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.sp,
                  ),
                  Text(
                    'Venue',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.sp,
              ),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    'VIRTUAL',
                    style: tileTitleTextStyle,
                  ),
                  value: 'VIRTUAL',
                  groupValue: venueValue,
                  onChanged: (val) {
                    setState(() {
                      venueValue = val! as String?;
                    });
                  }),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    'IN PERSON',
                    style: tileTitleTextStyle,
                  ),
                  value: 'IN PERSON',
                  groupValue: venueValue,
                  onChanged: (val) {
                    setState(() {
                      venueValue = val! as String?;
                    });
                  }),
              Visibility(
                visible: venueValue != 'VIRTUAL',
                child: ListTile(
                  title: Text(
                    'Physical venue',
                    style: tileTitleTextStyle,
                  ),
                ),
              ),
              Visibility(
                visible: venueValue != 'VIRTUAL',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _venueC,
                    maxLength: 20,
                    validator: (val) =>
                        widget.venue != 'VIRTUAL' && val!.isEmpty
                            ? 'Enter a venue'
                            : null,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  Navigator.pop(context,
                      venueValue == 'VIRTUAL' ? 'VIRTUAL' : _venueC.value.text);
                }),
          )
        ],
      ),
    );
  }
}

class EditLecturer extends StatefulWidget {
  final String lecturer;
  const EditLecturer({Key? key, required this.lecturer}) : super(key: key);

  @override
  State<EditLecturer> createState() => _EditLecturerState();
}

class _EditLecturerState extends State<EditLecturer> {
  final TextEditingController _lecC = TextEditingController();

  void initState() {
    super.initState();
    _lecC.text = widget.lecturer;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.sp,
                  ),
                  Text(
                    'Lecturer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 30.sp,
              ),
              ListTile(
                title: Text(
                  'Lecturer\'s Name',
                  style: tileTitleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration:
                      AppStyles().textFieldDecoration(label: '', hintText: ''),
                  cursorColor: secondaryThemeColor,
                  controller: _lecC,
                  validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  Navigator.pop(context, _lecC.value.text);
                }),
          )
        ],
      ),
    );
  }
}

class EditLink extends StatefulWidget {
  final String meetingLink;
  const EditLink({Key? key, required this.meetingLink}) : super(key: key);

  @override
  State<EditLink> createState() => _EditLinkState();
}

class _EditLinkState extends State<EditLink> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linkC.text = widget.meetingLink;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.9,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.sp,
                    ),
                    Text(
                      'Meeting link',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                        ))
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 30.sp,
                ),
                ListTile(
                  title: Text(
                    'Meeting link',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _linkC,
                    validator: (val) => val!.isEmpty ? 'Enter a link' : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, _linkC.value.text);
                  }
                }),
          )
        ],
      ),
    );
  }
}

class EditCredentials extends StatefulWidget {
  final String passCode;
  final String meetingId;
  const EditCredentials(
      {Key? key, required this.passCode, required this.meetingId})
      : super(key: key);

  @override
  State<EditCredentials> createState() => _EditCredentialsState();
}

class _EditCredentialsState extends State<EditCredentials> {
  final TextEditingController _meetingIdC = TextEditingController();
  final TextEditingController _passCodeC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _meetingIdC.text = widget.meetingId;
    _passCodeC.text = widget.passCode;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30.sp,
                    ),
                    Text(
                      'Meeting credentials',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.clear,
                          size: 20,
                        ))
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 30.sp,
                ),
                ListTile(
                  title: Text(
                    'Meeting Id',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _meetingIdC,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a meetingId' : null,
                  ),
                ),
                ListTile(
                  title: Text(
                    'Meeting passcode',
                    style: tileTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: AppStyles()
                        .textFieldDecoration(label: '', hintText: ''),
                    cursorColor: secondaryThemeColor,
                    controller: _passCodeC,
                    validator: (val) =>
                        val!.isEmpty ? 'Enter a passcode' : null,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'meetingId': _meetingIdC.value.text,
                      'passCode': _passCodeC.value.text
                    });
                  }
                }),
          )
        ],
      ),
    );
  }
}

class EditReminderSchedule extends StatefulWidget {
  final TimeOfDay initial;
  const EditReminderSchedule({Key? key, required this.initial})
      : super(key: key);

  @override
  State<EditReminderSchedule> createState() => _EditReminderScheduleState();
}

class _EditReminderScheduleState extends State<EditReminderSchedule> {
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    time = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.7,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30.sp,
                  ),
                  Text(
                    'Reminder schedule',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                      ))
                ],
              ),
              Divider(),
              SizedBox(
                height: 20.sp,
              ),
              ListTile(
                subtitle: Text(
                    'Get a reminder ${Time.scheduleStr(time)} before the class starts'),
              ),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    '5 minutes ',
                    style: tileTitleTextStyle,
                  ),
                  value: const TimeOfDay(hour: 0,minute: 5),
                  groupValue: time,
                  onChanged: (TimeOfDay? val) {
                    setState(() {
                      time = val!;
                    });
                  }),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    '30 minutes ',
                    style: tileTitleTextStyle,
                  ),
                  value: TimeOfDay(hour: 0,minute:30),
                  groupValue: time,
                  onChanged: (TimeOfDay? val) {
                    setState(() {
                      time = val!;
                    });
                  }),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    '1 hour ',
                    style: tileTitleTextStyle,
                  ),
                  value: TimeOfDay(hour: 1,minute:0),
                  groupValue: time,
                  onChanged: (TimeOfDay? val) {
                    setState(() {
                      time = val!;
                    });
                  }),
              RadioListTile(
                  activeColor: const Color.fromARGB(255, 201, 174, 20),
                  title: Text(
                    '2 hours ',
                    style: tileTitleTextStyle,
                  ),
                  value: TimeOfDay(hour: 2,minute:0),
                  groupValue: time,
                  onChanged: (TimeOfDay? val) {
                    setState(() {
                      time = val!;
                    });
                  }),
            ],
          ),
          Positioned(
            bottom: 0,
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
                onPressed: () {
                  Navigator.pop(context, time);
                }),
          )
        ],
      ),
    );
  }


}
