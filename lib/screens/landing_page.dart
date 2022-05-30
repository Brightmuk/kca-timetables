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
        toolbarHeight: MediaQuery.of(context).size.height*0.4,
        flexibleSpace: SizedBox(
                    height: MediaQuery.of(context).size.height*0.4,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                    SizedBox(
                    height: MediaQuery.of(context).size.height*0.1,
                  ),
                    const Text('Welcome to \nKCA Timetables',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Its convenient, time saving and organised',
                      style: TextStyle(
                          color: Color.fromARGB(255, 201, 174, 20),
                          
                          )),
                      ]),
                      painter: TrapeziumPainter(),
                    ),
                  ),
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [

                  ListTile(
                    
                    leading: Icon(
                      Icons.check,
                      color: Color.fromARGB(255, 201, 174, 20),
                      size: 20,
                    ),
                    title:
                        Text('Have your timetable in a more organised way'),
                  ),
                  ListTile(
                    
                    leading: Icon(
                      Icons.check,
                      color: Color.fromARGB(255, 201, 174, 20),
                      size: 20,
                    ),
                    title: Text(
                        'Get reminded when your class is about to begin'),
                  ),
                  ListTile(
                   
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
    );
  }
}

class TrapeziumPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()
    ..strokeCap=StrokeCap.round
    ..color=const Color.fromARGB(255, 3, 4, 75)
    ..style =PaintingStyle.fill
    ..strokeWidth=10;
    
    final path = Path()
    ..moveTo(0, 0)
    ..lineTo(0, size.height)
    ..lineTo(size.width, size.height/1.5)
    ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

}
