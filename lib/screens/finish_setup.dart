import 'package:excel_reader/record_model.dart';
import 'package:excel_reader/screens/single_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinishSetupScreen extends StatefulWidget {
  final String course;
  final String period;
  final List<Record> records;
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 3, 4, 75),
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              const Text('Finish setup',
                  style: TextStyle(
                      color: Color.fromRGBO(3, 4, 94, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              const Text('Edit the details of the listings'),
              const Divider(
                height: 50,
              ),
              Text(
                widget.course,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.period,
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(
                height: 50,
              ),
              Expanded(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.records.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.records[index].unitName),
                          subtitle: Text(widget.records[index].time),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingleRecord(
                                        record: widget.records[index])));
                          },
                          leading: Text(
                            convertDay(widget.records[index].day),
                            style: const TextStyle(fontSize: 12),
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
                  onPressed: () {}),
            )
          ],
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
