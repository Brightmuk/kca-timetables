import 'package:excel_reader/record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleRecord extends StatefulWidget {
  final Record record;
  const SingleRecord({Key? key, required this.record}) : super(key: key);

  @override
  _SingleRecordState createState() => _SingleRecordState();
}

class _SingleRecordState extends State<SingleRecord> {
  Record? _record;

  void initState() {
    super.initState();
    _record = widget.record;
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                const Text('Edit listing',
                    style: TextStyle(
                        color: Color.fromRGBO(3, 4, 94, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
                const Divider(
                  height: 50,
                ),
                Text(
                  widget.record.unitName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.record.unitCode,
                  style: TextStyle(color: Colors.grey),
                ),
                const Divider(
                  height: 50,
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today_outlined,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Day'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_record!.day),
                ),
                ListTile(
                  leading: Icon(Icons.watch_outlined,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Time'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_record!.time),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Lecturer'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_record!.lecturer),
                ),
                ListTile(
                  leading: Icon(Icons.move_down,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Type'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text(_record!.isVirtual ? 'Virtual' : 'In person'),
                ),
                ListTile(
                  leading: Icon(Icons.link_outlined,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Meeting link'),
                  subtitle: Text(_record!.classLink ?? 'No link'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.security_outlined,
                      color: const Color.fromARGB(255, 201, 174, 20)),
                  title: Text('Meeting credentials'),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                  subtitle: Text('Meeting Id: ${_record!.meetingId??'No meeting Id'} | Passcode: ${_record!.meetingPassCode??'No passcode'}'),
                ),
                Divider(),
                SwitchListTile(
                    activeColor: const Color.fromARGB(255, 201, 174, 20),
                    title: Text('Reminder'),
                    subtitle: Text('Get reminded when class is about to start'),
                    value: _record!.reminder,
                    onChanged: (val) {
                      setState(() {});
                    })
              ],
            ),
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
                    'Done',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            )
          ],
        ));
  }
}
