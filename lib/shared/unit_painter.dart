import 'package:flutter/material.dart';

class UnitPainter extends CustomPainter{
  final Color color;

  UnitPainter({required this.color,});

  @override
  void paint(Canvas canvas, Size size) {
   final paint = Paint()
   ..style=PaintingStyle.fill
   ..strokeWidth=1
   ..color=color;

    Offset p1 = Offset(0, size.height*0.3);
   final path = Path()

  
   ..moveTo(0, size.height*0.3);

    //two
   path.lineTo(0,size.height);
   path.lineTo(size.width,size.height);
   path.lineTo(size.width,size.height*0.5);
  path.arcToPoint( p1,radius: Radius.circular(size.height*size.width/100));
 
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;

  
}