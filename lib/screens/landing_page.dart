import 'package:excel_reader/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    Text('Welcome to \nKCA Timetables',
                        style: TextStyle(
                            color: Color.fromRGBO(3, 4, 94, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Its convenient, time saving and organised',
                        style: TextStyle(
                            color: Color.fromARGB(255, 201, 174, 20),
                            
                            )),
                    Divider(
                      height: 70,
                    ),
                    ListTile(
                        style: ListTileStyle.drawer,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 201, 174, 20),
                        size: 20,
                      ),
                      title:
                          Text('Have your timetable in a more organised way'),
                    ),
                    ListTile(
                        style: ListTileStyle.drawer,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 201, 174, 20),
                        size: 20,
                      ),
                      title: Text(
                          'Get reminded when your class is about to begin'),
                    ),
                    ListTile(
                        style: ListTileStyle.drawer,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check,
                        color: Color.fromARGB(255, 201, 174, 20),
                        size: 20,
                      ),
                      title:
                          Text('Join online classes directly with one click'),
                    )
                  ]),
            ),
            Positioned(
              bottom: 50,
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(20),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: const Color.fromARGB(255, 201, 174, 20),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanScreen()));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
