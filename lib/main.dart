import 'dart:io';

import 'package:excel_reader/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    ));
  }
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Sheet? excelSheet;
  String tableRows = '';
  bool loading = false;
  String error = '';

  String trim = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Excel reader'),
        backgroundColor: const Color.fromRGBO(3, 4, 94, 1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: loading,
                  child: const CircularProgressIndicator(
                    color: Colors.purpleAccent,
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(error),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: MaterialButton(
                    color: Colors.purpleAccent,
                    child: const Text(
                      'Read Pdf',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: readFile),
              ),
              excelSheet != null
                  ? ListTile(
                      leading: const Text('Max rows'),
                      trailing: Text(excelSheet!.maxRows.toString()),
                    )
                  : Container(),
              excelSheet != null
                  ? ListTile(
                      leading: const Text('Max columns'),
                      trailing: Text(excelSheet!.maxCols.toString()),
                    )
                  : Container(),
              excelSheet != null
                  ? ListTile(
                      leading: const Text('Rows length'),
                      trailing: Text(excelSheet!.rows.length.toString()),
                    )
                  : Container(),


              ListTile(
                leading: Text('Find year 3 trim 2'),
                trailing: Text('Found it at $trim'),
                onTap: () {
                  setState(() {
                    trim =
                        findTrim('YEAR THREE TRIM TWO').cellIndex.toString();
                  });
                },
              )
            ]),
      ),
    );
  }

  void readFile() async {
    setState(() {
      loading = true;
    });
    try {
      ByteData data = await rootBundle.load("assets/tt.xlsx");
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        setState(() {
          excelSheet = excel.sheets['BBIT_FT'];
          tableRows = excel.tables[table]!.maxRows.toString();
        });

        for (var row in excel.tables[table]!.rows) {
          print("$row");
        }
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }

    setState(() {
      loading = false;
    });
  }

  Data findTrim(String tri) {
    Data? data;
    for (var row in excelSheet!.rows) {
      for (var cell in row) {
        if (cell!=null&& cell.value == tri) {
          data = cell;
          break;
        }
      }
    }
    return data!;
  }
  void getTableheaders(){
       
    for (var row in excelSheet!.rows) {
      for (var cell in row) {
        if (cell!=null&& cell.value=='DAY') {
          
          break;
        }
      }
    }

  }
}
