import 'package:flutter/material.dart';

class AccentColorSelector extends StatefulWidget {
  final int currentColor;
  final Function onChange;

  const AccentColorSelector({ Key? key, required this.onChange, required this.currentColor }) : super(key: key);

  @override
  _AccentColorSelectorState createState() => _AccentColorSelectorState();
}

class _AccentColorSelectorState extends State<AccentColorSelector> {
  int? _currentColor;

  void initState(){
    super.initState();
    _currentColor=widget.currentColor;
  }

  List<int> colors = [
    0xff050851,
    0xff240046,
    0xff1B4332,
    0xff650000,
    0xff6D3B47,
    0xff232323,
    0xff5D3C18
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: ListView.builder(
          itemCount: colors.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _currentColor=colors[index];
                });
                widget.onChange(colors[index]);
              },
              child: Container(
                margin: const EdgeInsets.only(right:30),
                width: 50,
                height: 50,
                child:  Visibility(
                  visible: _currentColor==colors[index],
                  child: Icon(Icons.check_outlined,size: 20,color: Colors.white,)
                  ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                color: Color(colors[index]),
                  
              ),),
            );
          }
        ),
      ),
    );
  }
}