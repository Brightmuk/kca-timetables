import 'package:carousel_slider/carousel_slider.dart';
import 'package:excel_reader/screens/scan_screen.dart';
import 'package:excel_reader/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> pages = [
    'assets/images/organised.png',
    'assets/images/reminder.png',
    'assets/images/link.png',

  ];
  final List<String> texts = [
    'All your classes\norganised\nin one place',
    'Get reminded\nwhen class\nstarts',
    'Join\nonline classes\nwith one click'

  ];
  int viewIndex=0;
    Widget indicator(currentIndex) {
    return SizedBox(
        height: 10.sp,
        width: pages.length * 30,
        child: ListView.separated(
            itemCount: pages.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 10,
              );
            },
            itemBuilder: (context, index) {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? secondaryThemeColor
                      : Colors.grey[200],
                  border: Border.all(
                      color: Colors.grey[200]!, width: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.3,
        flexibleSpace: SizedBox(
          height: MediaQuery.of(context).size.height*0.3,
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
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(texts[viewIndex],style: TextStyle(color: primaryThemeColor,fontSize: 30,fontWeight: FontWeight.bold),),
  ),
  SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            viewIndex = index;
                          });
                        },
                        height: 300,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemCount: pages.length,
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) =>
            Image.asset(
              pages[index],
            )),
        ),
        SizedBox(height: 70.sp,),
        Center(child: indicator(viewIndex))
        ],
            ),
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

    final Offset point1 = Offset(size.width*0.5, size.height);
    final Offset point2 = Offset(size.width,size.height);


    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..arcToPoint(point1,radius: const Radius.circular(200))
      ..arcToPoint(point2,radius: const Radius.circular(200),clockwise: false)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

}
