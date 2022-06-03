import 'package:excel_reader/models/unit_class_model.dart';
import 'package:excel_reader/screens/home_screen.dart';
import 'package:excel_reader/screens/single_class.dart';
import 'package:excel_reader/services/timetable_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

class FinishSetupScreen extends StatefulWidget {
  final String course;
  final String period;
  final List<UnitClass> records;
  const FinishSetupScreen(
      {Key? key,
      required this.records,
      required this.period,
      required this.course})
      : super(key: key);

  @override
  _FinishSetupScreenState createState() => _FinishSetupScreenState();
}

class _FinishSetupScreenState extends State<FinishSetupScreen> {
  List<UnitClass> _records=[];

  @override
  void initState() {
    super.initState();
    _records=widget.records;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var result = await showModalBottomSheet(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (context) => const ConfirmPop());
        if (result) {
          return true;
        } else {
          return false;
        }
      },
      child: SafeArea(
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
              const Text('Finish setup',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                                                  IconButton(
              padding: const EdgeInsets.all(20),
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
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          leading: IconButton(
            padding: EdgeInsets.all(20),
            onPressed: ()async {
                     var result = await showModalBottomSheet(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              context: context,
              builder: (context) => const ConfirmPop());
          if (result) {
           Navigator.pop(context);
          }
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
                Column(children: [

                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    widget.course,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.period,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(
                    height: 50,
                  ),
                  Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _records.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              style: ListTileStyle.drawer,
                              title: Text(_records[index].unitName),
                              subtitle: Text(_records[index].time),
                              onTap: () async{
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditClassPage(
                                          editMode: false,
                                            record: _records[index])));
                                if(result!=null){
                                
                                  setState(() {
                                   int i=_records.indexWhere((record) => record.unitCode==result.unitCode);
                            
                                  _records.removeAt(i);
                                  _records.insert(i, result);
                                  });
                                }
      
                              },
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    convertDay(_records[index].day),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            );
                          }))
                ]),
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
                      onPressed: save),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save()async{
    var result = await TimeTableService(context: context).saveTimeTable(records: _records,course:widget.course);
    if(result){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>const HomePage()), (Route<dynamic> route) => false);
    }
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

class ConfirmPop extends StatelessWidget {
  const ConfirmPop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 150,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Unsaved data will be lost. Are you sure you want to go back? ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                MaterialButton(
                                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context,true);
                  },
                  child: const Text('Yes'),
                  color: Colors.redAccent,
                ),
                MaterialButton(
                                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context,false);
                  },
                  child: const Text('No'),
                  color: const Color.fromARGB(255, 201, 174, 20),
                ),
                const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


