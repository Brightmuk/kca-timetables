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
  @override
  void initState() {
    super.initState();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 3, 4, 75),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        leading: IconButton(
          padding: EdgeInsets.all(20),
          onPressed: () {
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
                        itemCount: widget.records.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            style: ListTileStyle.drawer,
                            title: Text(widget.records[index].unitName),
                            subtitle: Text(widget.records[index].time),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SingleRecord(
                                          record: widget.records[index])));
                            },
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  convertDay(widget.records[index].day),
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
                    onPressed: () {}),
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
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context,true);
                  },
                  child: const Text('Yes'),
                  color: Colors.redAccent,
                ),
                MaterialButton(
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


